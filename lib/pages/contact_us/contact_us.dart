import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/contact_us/controller/contact_us_controller.dart';
import 'package:property_rental_app/utils/validator.dart';

class ContactUs extends StatelessWidget {
  ContactUs({super.key});

  final controller = Get.put(ContactUsController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 44,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    'assets/icons/left_arrow.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                const Center(
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Image.asset(
                  'assets/icons/left_arrow.png',
                  height: 24,
                  width: 24,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Center(
            child: Text(
              'Any question or remarks? Just write us a message!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor7171,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: 'Enter full name',
                        borderRadius: 8,
                        controller: controller.fullNameController,
                        validator: (value) {
                          return isUsernameValid(value!);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: 'Enter email address',
                        borderRadius: 8,
                        controller: controller.emailController,
                        validator: (value) {
                          return isEmailValid(value!);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Phone number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: '654 765432',
                        borderRadius: 8,
                        keyboardType: TextInputType.phone,
                        controller: controller.phoneController,
                        isPrefixIcon: true,
                        prefixIcon: CountryCodePicker(
                          initialSelection: 'KE',
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          padding: EdgeInsets.zero,
                          flagDecoration: ShapeDecoration.fromBoxDecoration(
                            const BoxDecoration(shape: BoxShape.circle),
                          ),
                        ),
                        validator: (value) {
                          return isPhoneValid(value!);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        hintText: 'Enter your message',
                        borderRadius: 8,
                        maxLines: 5,
                        controller: controller.messageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your message.";
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Send',
                        height: 38,
                        width: Get.width,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            loadingDialog(
                                button: true,
                                endBtnText: 'Okay',
                                message: 'Your message has been delivered.',
                                tap: () async {
                                  Get.back();
                                  Get.back();
                                  controller.fullNameController.clear();
                                  controller.phoneController.clear();
                                  controller.messageController.clear();
                                  controller.emailController.clear();

                                });
                          }},
                      ),
                      const SizedBox(height: 32),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 32, horizontal: 20),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            ),
                          );
                        }
                        
                        return Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Let's Talk About Everything!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Hello there! If you'd like to ask us something, you can get in touch with us here! We'd love to address any and all concerns you may have.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              if (controller.availability.value.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                const Text(
                                  "Availability",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.availability.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ],
                              if (controller.contactNumber.value.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Image.asset(
                                  'assets/icons/call_2.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.contactNumber.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ],
                              if (controller.supportEmail.value.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Image.asset(
                                  'assets/icons/mail.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.supportEmail.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ],
                              if (controller.address.value.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Image.asset(
                                  'assets/icons/pin.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.address.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 34),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
