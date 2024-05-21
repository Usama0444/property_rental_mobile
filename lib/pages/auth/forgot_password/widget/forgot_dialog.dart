import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/auth/login/login_screen.dart';

void forgotDialog() {
  showDialog(
    barrierDismissible: true,
    context: Get.context!,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Dialog(
          backgroundColor: whiteColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: whiteColor,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 36, right: 36, top: 26, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/mail_icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'A reset link has been emailed to you.\nPlease also check your spam',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: blackColor3B,
                      fontSize: 14,
                      fontFamily: 'sfPro',
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    onPressed: () {
                      Get.off(() => LoginScreen());

                    },
                    text: 'Okay',
                    width: Get.width,
                    height: 44,
                    borderRadius: 5,
                    // borderRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
