import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/main.dart';

class UpdatePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final reTypeController = TextEditingController();
  final oldPasswordController = TextEditingController();

  changePassword({required email}) async {
    loadingDialog(message: 'Please wait....', loading: true);
    print(oldPasswordController.text);
    print(email);
    var cred = EmailAuthProvider.credential(
        email: email, password: oldPasswordController.text);
    await auth.currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) async {
      print('======');
      await auth.currentUser!
          .updatePassword(reTypeController.text)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({'password': reTypeController.text}).then((value) {
          print('password updated');
        });

        Get.back();
        loadingDialog(
            message: 'Password Changed Successfully.',
            button: true,
            isFromForgotPassword: true);

        // resetTextField();
      });
    }).onError((error, stackTrace) {
      if (error.toString() ==
          "[firebase_auth/INVALID_LOGIN_CREDENTIALS] An internal error has occurred. [ INVALID_LOGIN_CREDENTIALS ]") {
        loadingDialog(
          message: 'Your current password is incorrect. Please, try again.',
        );
      } else if (error.toString() ==
          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
        loadingDialog(
          message: 'The credential is incorrect. Please, try again.',
        );
      } else {
        print(error.toString());
        loadingDialog(
          message: 'Something Went Wrong, Please, try again.',
        );
      }
      print('222222222222');
      print(error.toString());
    });
  }
}
