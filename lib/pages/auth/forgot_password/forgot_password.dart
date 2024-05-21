import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/auth/forgot_password/controller/forgot_password.dart';
import 'package:property_rental_app/utils/validator.dart';
import 'widget/forgot_dialog.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final controller = Get.put(ForgotPasswordController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Forgot Password',
            isBottomBorder: false,
            isBackButton: true,
          ),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/forgot_password.png',
                        width: 227,
                        height: 214,
                      ),
                      const SizedBox(height: 30),

                      Align(alignment: Alignment.topLeft,

                        child: const Text(
                          'Please enter your email address',
                          style: TextStyle(
                            color: Color(0xFF2B2B2B),
                            fontSize: 16,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w600,
                            // letterSpacing: -0.32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Email',
                        hintText: 'rhammad636@gmail.com',
                        controller: controller.emailController,
                        validator: (value) {
                          return isEmailValid(value!);
                        },

                      ),
                      // Spacer(),
                      // Expanded(child: SizedBox(height: Get.height * 0.1)),


                      SizedBox(
                        height: Get.height * 0.28,
                      ),
                      // const Expanded(child: SizedBox()),
                      // SizedBox(
                      //   height: 70,
                      //   width: 280,
                      //   child: Column(
                      //     children: [
                      //       const SizedBox(
                      //         height: 24,
                      //       ),
                      //       RichText(
                      //         textAlign: TextAlign.center,
                      //         text: const TextSpan(
                      //           text: "Haven't received the link yet?",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w600,
                      //             color: blackColor3B,
                      //             fontSize: 16, 
                      //             fontFamily: 'Avenir',
                      //           ),
                      //           children: <TextSpan>[],
                      //         ),
                      //       ),
                      //       const SizedBox(height: 5),
                      //       GestureDetector(
                      //         onTap: () {
                      //           if (formKey.currentState!.validate()) {
                      //             FirebaseAuth.instance
                      //                 .sendPasswordResetEmail(
                      //                     email: controller.emailController.text)
                      //                 .then((value) {
                      //               forgotDialog();
                      //               controller.emailController.clear();
                      //               print('sent successfully');
                      //             }).onError((error, stackTrace) {
                      //               print(error.toString());
                      //             });
                      //           }
                      //         },
                      //         child: const Text(
                      //           'Resend !',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w600,
                      //             color: primaryColor,
                      //             fontFamily: 'sfPro',
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButton(
                text: 'Send link',
                height: 44,
                width: Get.width,
                onPressed: () async {
                  ///if (_forgetFormKey.currentState!.validate()) {
                  //   loadingDialog(
                  //       message: 'Please wait!!', loading: true);
                  //   await FirebaseFirestore.instance
                  //       .collection("users")
                  //       .where('userEmail',
                  //           isEqualTo: controller
                  //               .emailAddressController.text)
                  //       .get()
                  //       .then((value) async {
                  //     if (value.docs.isEmpty) {
                  //       Get.back();
                  //       print(value);
                  //       loadingDialog(
                  //           message: "The Email doesn't Exists.",
                  //           button: true);
                  //     } else {
                  //       await FirebaseAuth.instance
                  //           .sendPasswordResetEmail(
                  //               email: controller
                  //                   .emailAddressController.text)
                  //           .then((value) {
                  //         Get.back();
                  //         controller.emailAddressController
                  //             .clear();
                  //         resetDialog();
                  //         print('sent successfully');
                  //       }).onError((error, stackTrace) {
                  //         print(error.toString());
                  //         Get.back();
                  //         loadingDialog(
                  //           message:
                  //               'Something went wrong, try again later',
                  //           button: true,
                  //         );
                  //       });
                  //     }
                  //   }).onError((error, stackTrace) {
                  //     Get.back();
                  //     loadingDialog(
                  //       message:
                  //           'Something went wrong, try again later',
                  //       button: true,
                  //     );
                  //   });
                  // }
                  if (formKey.currentState!.validate()) {
                    loadingDialog(
                        message: 'Please wait!!', loading: true);
                    await FirebaseFirestore.instance
                        .collection("users")
                        .where('userEmail',
                        isEqualTo:
                        controller.emailController.text)
                        .get()
                        .then(
                          (value) async {
                        if (value.docs.isEmpty) {
                          Get.back();
                          print(value);
                          loadingDialog(
                              message: "The Email doesn't Exists.",
                              button: true);
                        } else {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                              email:
                              controller.emailController.text)
                              .then((value) {
                            forgotDialog();
                            controller.emailController.clear();
                            print('sent successfully');
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                        }
                      },
                    );
                  }
                }),
          ),
          const SizedBox(height: 24 ),
        ],
      ),
    );
  }
}
