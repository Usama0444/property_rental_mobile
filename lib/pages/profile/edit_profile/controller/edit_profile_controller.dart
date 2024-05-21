import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/no_internet_dialog.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/user_model.dart';

import '../../../../common_widgets/loading_dialog.dart';

class EditProfileController extends GetxController {
  RxBool isReceiveNotifications = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  ///edit profile
  editProfile(UserModel userModel) async {
    loadingDialog(message: 'Please wait !!', loading: true);
    final connecitivityResult = await (Connectivity().checkConnectivity());

    if (connecitivityResult == ConnectivityResult.none) {
      Get.back();
      showNoInternetDialog();
    } else {
    var data = await userModel.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .update(data)
        .then((value) {
      currentUserDataModel = userModel.obs;
      Get.close(2);
    }).onError((error, stackTrace) {
      print(error.toString());
      Get.back();
      loadingDialog(message: "There was problem! please try again later.");
      // loadingDialog(message: error.toString());
    });
    }
  }
}
