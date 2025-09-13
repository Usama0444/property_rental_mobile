import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/common_widgets/social_custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/auth/forgot_password/forgot_password.dart';
import 'package:property_rental_app/pages/auth/login/login_controller.dart';
import 'package:property_rental_app/pages/auth/sign_up/sign_up_controller.dart';
import 'package:property_rental_app/pages/auth/sign_up/sign_up_screen.dart';
import 'package:property_rental_app/pages/profile/terms_of_service/terms_of_service.dart';
import 'package:property_rental_app/utils/validator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();
  var isUserNameOrPasswordIncorrect = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // const CustomAppBar(
              //   title: 'Sign In to post an ad',
              //   isBottomBorder: false,
              // ),
              const SizedBox(height: 45),
              Image.asset(
                'assets/images/logo.png', fit: BoxFit.fill,
                // 'assets/images/forgot_password.png',
                // width: 135,
                height: 114,
              ),

              const SizedBox(
                height: 24,
              ),
              const Text(
                'Login to Your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontWeight: FontWeight.w600,
                  color: blackColor,
                  fontSize: 12,
                  fontFamily: 'Avenir',
                ),
              ),

              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // const SizedBox(height: 10),
                      // Container(
                      //   height: 40,
                      //   width: Get.width,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: redColor,
                      //     ),
                      //     borderRadius: BorderRadius.circular(4),
                      //   ),
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Image.asset(
                      //             'assets/icons/alert_icon.png',
                      //             height: 18,
                      //             width: 18,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           const Text(
                      //             'The username or password is incorrect.',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //               fontSize: 12,
                      //               color: redColor,
                      //               fontFamily: 'Avenir',
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Image.asset(
                      //         'assets/icons/x.png',
                      //         height: 20,
                      //         width: 20,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Email',
                        controller: controller.emailController,
                        validator: (value) {
                          return isEmailValid(value!);
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CustomTextField(
                          labelText: 'Password',
                          obscureText: controller.isHidePassword.value,
                          controller: controller.passwordController,
                          isSuffixIcon: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isHidePassword.value =
                                  !controller.isHidePassword.value;
                            },
                            child: controller.isHidePassword.value == true
                                ? Image.asset(
                                    'assets/icons/hide_pass.png',
                                    scale: 4,
                                    height: 20,
                                    width: 20,
                                    color: iconColor,
                                  )
                                : Image.asset(
                                    'assets/icons/show_pass.png',
                                    scale: 4,
                                    height: 20,
                                    width: 20,
                                    color: iconColor,
                                  ),
                          ),
                          validator: (value) {
                            return isPasswordValid(value!);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Login',
                        height: 44,
                        width: Get.width,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.login();
                            // Get.to(() => BottomNavBar());
                            // controller.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    controller.isChecked.toggle();
                                  },
                                  child: Checkbox(
                                    hoverColor: Colors.transparent,
                                    splashRadius: 0,
                                    visualDensity: const VisualDensity(
                                      horizontal: -2.0, // Adjust the width
                                      vertical: -2.0,
                                    ),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    fillColor: MaterialStateProperty.all(
                                        const Color(0xFFD9D9D9)),
                                    activeColor: primaryColor,
                                    checkColor: primaryColor,
                                    value: controller.isChecked.value,
                                    onChanged: (value) {
                                      controller.isChecked.value = value!;
                                    },
                                  ),
                                ),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: blackColor,
                                  fontFamily: 'Avenir',
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ForgotPassword());
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 4,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(
                              child: Divider(
                            endIndent: 10,
                          )),
                          Text(
                            "OR",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: blackColor,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            indent: 10,
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SocialCustomButton(
                        text: 'Continue with google',
                        isPrefixIcon: true,
                        prefixIcon: Image.asset(
                          'assets/icons/google_icon.png',
                          height: 22,
                          width: 22,
                        ),
                        isSuffixIcon: true,
                        suffixIcon: Image.asset(
                          'assets/icons/apple_icon.png',
                          height: 22,
                          width: 22,
                          color: Colors.transparent,
                        ),
                        height: 38,
                        backgroundColor: whiteColor,
                        textColor: blackColor,
                        isBorder: true,
                        width: Get.width,
                        onPressed: () {
                          Get.put(SignUpController()).signInWithGoogle();
                          ///////////////////
                        },
                      ),
                      // const SizedBox(height: 20),
                      // SocialCustomButton(
                      //   text: 'Continue with facebook',
                      //   isPrefixIcon: true,
                      //   prefixIcon: Image.asset(
                      //     'assets/icons/facebook_icon.png',
                      //     height: 22,
                      //     width: 22,
                      //   ),
                      //   isSuffixIcon: true,
                      //   suffixIcon: Image.asset(
                      //     'assets/icons/apple_icon.png',
                      //     height: 22,
                      //     width: 22,
                      //     color: Colors.transparent,
                      //   ),
                      //   height: 38,
                      //   backgroundColor: whiteColor,
                      //   textColor: blackColor,
                      //   isBorder: true,
                      //   width: Get.width,
                      //   onPressed: () {},
                      // ),
                      // const SizedBox(height: 20),
                      // SocialCustomButton(
                      //   text: 'Continue with apple',
                      //   isPrefixIcon: true,
                      //   prefixIcon: Image.asset(
                      //     'assets/icons/apple_icon.png',
                      //     height: 22,
                      //     width: 22,
                      //   ),
                      //   isSuffixIcon: true,
                      //   suffixIcon: Image.asset(
                      //     'assets/icons/apple_icon.png',
                      //     height: 22,
                      //     width: 22,
                      //     color: Colors.transparent,
                      //   ),
                      //   height: 38,
                      //   backgroundColor: whiteColor,
                      //   textColor: blackColor,
                      //   isBorder: true,
                      //   width: Get.width,
                      //   onPressed: () {},
                      // ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                            fontSize: 14,
                            fontFamily: 'Avenir',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(SignUp()),
                              text: 'Register',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                                fontSize: 16,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By continuing you agree to our ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: greyColor,
                            fontSize: 14,
                            fontFamily: 'Avenir',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(const TermsOfService()),
                              text: 'terms and conditions',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 3,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: greyColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
