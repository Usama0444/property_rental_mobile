import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_switch_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/profile/edit_profile/controller/edit_profile_controller.dart';
import 'package:property_rental_app/pages/profile/settings/settings.dart'
    as setting;
import 'package:property_rental_app/universal_models/user_model.dart';
import 'package:property_rental_app/utils/validator.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final controller = Get.put(EditProfileController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: 'Edit Profile',
            isBackButton: true,
            isSuffixIcon: true,
            suffixWidget: GestureDetector(
              onTap: () {
                Get.to(() => const setting.Settings());
              },
              child: const Icon(
                Icons.settings,
                weight: 24,
                color: blackColor3B,
              ),
            ),
          ),
       Expanded(
  child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .get(),
    builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        print(snapshot.error);
        return const Center(
          child: Text('Error loading user data'),
        );
      }

      UserModel userModel;

      if (snapshot.hasData && snapshot.data!.exists) {
        userModel = UserModel.fromDocumentSnapshot(snapshot.data!);
      } else {
        userModel = UserModel.initialize();
      }

    
  
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              const Text(
                                'Name',
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
                                controller: userModel.userName,
                                validator: (value) {
                                  return isUsernameValid(value!);
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Email',
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
                                controller: userModel.userEmail,
                                validator: (value) {
                                  return isEmailValid(value!);
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Phone',
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
                                controller: userModel.phoneNo,
                                isPrefixIcon: true,
                                prefixIcon: SizedBox(
                                  child: CountryCodePicker(
                                    onChanged: (c) {
                                      print(c.code);
                                      userModel.countryCode = c.code.toString();
                                    },
                                    initialSelection: userModel.countryCode,
                                    textStyle: const TextStyle(
                                        fontSize: 12, color: blackColor),
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    padding: EdgeInsets.zero,
                                    flagDecoration:
                                        ShapeDecoration.fromBoxDecoration(
                                      const BoxDecoration(
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  return isPhoneValid(value!);
                                },
                              ),
                              const SizedBox(height: 20),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     const Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             'Notifications',
                              //             style: TextStyle(
                              //               fontSize: 16,
                              //               fontWeight: FontWeight.w600,
                              //               color: blackColor3B,
                              //               fontFamily: 'Avenir',
                              //             ),
                              //           ),
                              //           SizedBox(height: 4),
                              //           Text(
                              //             'Receive notifications for property recommendation and more from HSL Homes',
                              //             style: TextStyle(
                              //               fontSize: 12,
                              //               fontWeight: FontWeight.w600,
                              //               color: blackColor3B,
                              //               fontFamily: 'Avenir',
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     const SizedBox(width: 40),
                              //     Obx(
                              //       () => CustomSwitchButtonWidget(
                              //         status: userModel.isNotifications.value,
                              //         onToggle: (value) {
                              //           userModel.isNotifications.value =
                              //               !userModel.isNotifications.value;
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 34,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const Expanded(child: SizedBox()),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                        text: 'Update',
                        height: 44,
                        width: Get.width,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.editProfile(userModel);
                          } else {
                            return;
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 32,
                  )
                ],
              );
            },
          ))
        ],
      ),
    );
  }
}
