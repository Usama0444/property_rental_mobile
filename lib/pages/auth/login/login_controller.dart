import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/common_widgets/no_internet_dialog.dart';
import 'package:property_rental_app/main.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';

import '../../bottom_nav_bar/controller/bottom_bar_controller.dart';

class LoginController extends GetxController {
  RxBool isChecked = false.obs;
  var isHidePassword = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  ///login function
  Future<void> login() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetDialog();
    } else {
      loadingDialog(message: 'Please wait !!', loading: true);
      try {
        await auth
            .signInWithEmailAndPassword(
          email: emailController.value.text,
          password: passwordController.value.text,
        )
            .then((value) async {
          // Wait for the user to be fully signed in.
          currentUser = await checkUserData();

          print('signing in .................');
          print(currentUser?.get('userEmail'));
          if (currentUser != null) {
            print('current user ======$currentUser');
            await getCurrentUserData();
            Get.back();

            if (currentUserDataModel != null) {
              Get.offAll(() => BottomNavBar());
              Get.find<BottomNavController>().tabIndex.value = 0;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .update({'password': passwordController.value.text}).then(
                      (value) {
                print('password updated');
              });
            }

            emailController.clear();
            passwordController.clear();
            await auth.currentUser!.reload();
          } else {
            Get.back();
            loadingDialog(
                message:
                    "Your account was deleted, contact the provider or create new account");
          }
        });
      } on FirebaseAuthException catch (error) {
        Get.back();
        print(error.toString());
        switch (error.code) {
          case "invalid-credential":
            loadingDialog(
                message:
                    "The username or password you entered is incorrect. Please check your login information and try again.",
                button: true);
            break;
          case "too-many-requests":
            loadingDialog(
              message:
                  "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.",
            );
            break;
          case "network-request-failed":
            loadingDialog(
                message: "Please check internet connection and try again.",
                button: true);
            break;
          default:
        }
      }
    }
  }
}
