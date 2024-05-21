import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/main.dart';

import '../../../common_widgets/global_functions.dart';
import '../../../universal_models/user_model.dart';
import '../../bottom_nav_bar/controller/bottom_bar_controller.dart';
import '../../bottom_nav_bar/user_bottom_nav_bar.dart';

class SignUpController extends GetxController {
  RxBool isChecked = false.obs;
  var isHidePassword = true.obs;
  var isConfirmHidePassword = true.obs;

  final confirmController = TextEditingController();
  final passwordController = TextEditingController();

  ///userModel
  UserModel userModel = UserModel.initialize();

  createAccount() async {
    loadingDialog(message: "loading...", loading: true);
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: userModel.userEmail.text,
        password: userModel.password.text,
      )
          .then((value) async {
        debugPrint('Sign up successfully ====================');

        await insertData();
        Get.back();
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        if (error ==
            '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
          loadingDialog(
              message:
                  "The email you provided is already in use try with new email!");
        } else {
          loadingDialog(message: "Something went wrong !!!");
        }
        debugPrint('+++++');
        debugPrint(error.toString());
      });
    } on FirebaseAuthException catch (error) {
      // userModel.userEmail.clear();
      // verifyController.clear();
      // Get.close(2);
      debugPrint("signUp ${error.code}");
      switch (error.code) {
        case "email-already-in-use":
          loadingDialog(
              message:
                  "The email you provided is already in use try with new email!");
          break;
      }
    }
  }

  ///google sign in
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<bool> checkIfEmailExists({String? email}) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .where('userEmail', isEqualTo: email /*??emailController.text*/)
        .get();
    print(doc.docs.isEmpty);
    return doc.docs.isEmpty;
  }

  Future signInWithGoogle() async {
    loadingDialog(message: 'Please wait !!',loading: true);
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await auth.signInWithCredential(credential).then((value) async {
      var isEmailNotExit = await checkIfEmailExists(email: value.user!.email);
      print(value.user!.email);

      if (isEmailNotExit == true) {
        print('in if');
        FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .set({
          "userName": value.user!.displayName,
          "userEmail": value.user!.email,
          'phoneNo': '',
          'userID': '',
          'token': userModel.token,
          'countryCode': 'KE',
          'isEmailRecommendation': false,
          'isNotifications': true,
          'isRecentViewed': true,
          'password': '',
        }).then((value) async {
          currentUser = await checkUserData();
          await getCurrentUserData();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid.toString())
              .update({'userID': auth.currentUser!.uid}).then((value) {
            userModel.userID = auth.currentUser!.uid;
            print(auth.currentUser!.uid);
            Get.back();
            Get.put(BottomNavController()).tabIndex.value = 0;
            Get.offAll(() => BottomNavBar());

            userModel = UserModel.initialize();
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      } else {
        print('else000');
        currentUser = await checkUserData();
        await getCurrentUserData();
        Get.put(BottomNavController()).tabIndex.value = 0;
        Get.offAll(() => BottomNavBar());
      }
    });
  }

  ///insert user
  insertData() async {
    var data = await userModel.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .set(data)
        .then((value) async {
      print('inserting data ===========');
      currentUser = await checkUserData();
      await getCurrentUserData();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid.toString())
          .update({'userID': auth.currentUser!.uid}).then((value) {
        userModel.userID = auth.currentUser!.uid;
        debugPrint('0000000000000000000000 checking auth ID below');
        debugPrint(auth.currentUser!.uid);
        Get.offAll(() => BottomNavBar());
        userModel = UserModel.initialize();
      });
    }).onError((error, stackTrace) async {
      debugPrint('delete user ==== in else (if user doesn\'t exist)"');
      await auth.currentUser!.delete();
      Get.back();
      loadingDialog(message: "There was problem!\nPlease try again later");
    });
  }
}
