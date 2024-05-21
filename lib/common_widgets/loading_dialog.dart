import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import 'custom_button.dart';

loadingDialog(
    {String? message,
    String? endBtnText,
    double? padding,
    Color? clr,
    bool loading = false,
    bool button = false,
    button1 = false,
    VoidCallback? tap,
    bool? isFromForgotPassword = false,
    Widget? startWidget}) {
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Center(
            child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    loading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        message.toString(),
                        style:const TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontSize: 13,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w600,
                          // letterSpacing: -0.32,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    button
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                button1 ? startWidget! : const SizedBox(),
                                button
                                    ? CustomButton(
                                        text: endBtnText ?? "Okay",
                                        height: 40,
                                        width: Get.width * 0.26,
                                        onPressed: tap ??
                                            () {
                                              if (isFromForgotPassword ==
                                                  true) {
                                                Get.back();
                                                Get.back();
                                              } else {
                                                Get.back();
                                              }
                                            },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                )),
          )
        ],
      );
    },
  );
}
//
// CustomButton(
// onPressed: () {
// if (controller.formKey.currentState!.validate()) {
// controller.onClick.value = !controller.onClick.value;
// if (controller.optController.length != 6 ||
// controller.optController.text == "") {
// controller.onClick.value = true;
// }
// if (controller.optController.length == 6) {
// Get.to(() => HomeScreen());
// }
// }
// },
// title: "Verify Code",
// btnWidth: Get.width * 0.4,
// btnHeight: 43,
// ),
