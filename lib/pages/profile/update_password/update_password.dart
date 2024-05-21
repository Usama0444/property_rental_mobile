import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/utils/validator.dart';

import 'controller/update_password_controller.dart';

class UpdatePassword extends StatelessWidget {
  UpdatePassword({super.key});

  final controller = Get.put(UpdatePasswordController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'Update Password',
            isBackButton: true,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: '***********',
                      borderRadius: 8,
                      hintColor: greyColor,
                      controller: controller.oldPasswordController,
                      validator: (value) {
                        return isPasswordValid(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: '***********',
                      borderRadius: 8,
                      hintColor: greyColor,
                      controller: controller.newPasswordController,
                      validator: (value) {
                        return isPasswordValid(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Re type Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: '***********',
                      borderRadius: 8,
                      hintColor: greyColor,
                      controller: controller.reTypeController,
                      validator: (value) {
                        return isConfirmPasswordValid(
                            value!, controller.newPasswordController.text);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Expanded(child: SizedBox()),
                    CustomButton(
                        text: 'Update password',
                        height: 44,
                        width: Get.width,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.changePassword(
                              email:currentUserDataModel!.value.userEmail.text /*snapshot.data!['userEmail']*/,
                            );
                            // Get.offAll(BottomNavBar());
                          }
                        }),
                    const SizedBox(
                      height: 32,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
