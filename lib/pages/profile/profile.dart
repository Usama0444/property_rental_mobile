import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/auth/login/login_screen.dart';
import 'package:property_rental_app/pages/booking_history/booking_history.dart';
import 'package:property_rental_app/pages/contact_us/contact_us.dart';
import 'package:property_rental_app/pages/my_activity/my_activity.dart';
import 'package:property_rental_app/pages/my_property_ads/my_property_ads.dart';
import 'package:property_rental_app/pages/profile/about_us/about_us.dart';
import 'package:property_rental_app/pages/profile/edit_profile/edit_profile.dart';
import 'package:property_rental_app/common_widgets/profile_listtile.dart';
import 'package:property_rental_app/pages/profile/widget/rate_us.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/loading_dialog.dart';
import 'manage_alerts/manage_alerts.dart';
import 'privacy_policy/privacy_policy.dart';
import 'terms_of_service/terms_of_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 266,
            child: Stack(
              // clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 240,
                  width: Get.width,
                  child: Image.asset(
                    'assets/images/profile_bak_2.png',
                    height: 240,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0.8,
                  right: 0.8,
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10)
                      ],
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${currentUserDataModel!.value.userName.text}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blackColor3B,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Get.to(() => EditProfile());
                              },
                              child: AbsorbPointer(
                                absorbing: false,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Edit profile',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      'assets/icons/arrow_right.png',
                                      height: 12,
                                      width: 12,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomButton(
                            width: 85,
                            height: 34,
                            text: 'Logout',
                            fontSize: 13,
                            onPressed: () async {
                              loadingDialog(
                                  button: true,
                                  button1: true,
                                  endBtnText: 'Yes',
                                  message:
                                      'Are you sure you want to logout?',
                                  tap: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(auth.currentUser!.uid.toString())
                                        .get()
                                        .then((value) async {
                                      if (value.data()!.isNotEmpty) {
                                        await value.reference.update({
                                          'token': '',
                                        });
                                      }
                                    });
                                    auth.signOut().then((value) {
                                      Get.off(() => LoginScreen());
                                    }).onError((error, stackTrace) {
                                      print(error.toString());
                                    });
                                    // });
                                  },
                                  startWidget: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomButton(
                                      text: "Cancel",
                                      height: 40,
                                      width: Get.width * 0.26,
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ));
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MyActivity());
                      },
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 10,
                            )
                          ],
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, bottom: 16, right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/activity.png',
                                  height: 44,
                                  width: 75,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'My Activity',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor3B,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        'View your recent property search and activity',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Avenir',
                                          color: textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/icons/right_angle.png',
                              height: 24,
                              width: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'More on MSL Homes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir',
                        color: blackColor3B,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // ProfileListTile(
                    //   icon: 'assets/icons/notificationbing.png',
                    //   title: 'Manage Alerts',
                    //   trailing: 'assets/icons/right_angle.png',
                    //   onTap: () {
                    //     Get.to(() => ManageAlert());
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 32,
                    // ),
                    Obx(() => currentUserDataModel?.value.isListingUser.value ?? false
                        ? ProfileListTile(
                            icon: 'assets/icons/ads.png',
                            title: 'My Property Ads',
                            trailing: 'assets/icons/right_angle.png',
                            onTap: () {
                              Get.to(() => MyPropertyAds());
                            },
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(
                      height: 32,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/history.png',
                      title: 'Booking history',
                      trailing: 'assets/icons/right_angle.png',
                      onTap: () {
                        Get.to(() => BookingHistory());
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      color: greyBorderColor,
                      height: 0.5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/call.png',
                      title: 'Contact Us',
                      trailing: 'assets/icons/right_angle.png',
                      onTap: () {
                        Get.to(() => ContactUs());
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/about_us.png',
                      title: 'About Us',
                      trailing: 'assets/icons/right_angle.png',
                      onTap: () {
                        Get.to(() => const AboutUs());
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/terms_of_service.png',
                      title: 'Terms of Service',
                      trailing: 'assets/icons/about_right.png',
                      onTap: () {
                        Get.to(() => const TermsOfService());
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/shieldsecurity.png',
                      title: 'Privacy Policy',
                      trailing: 'assets/icons/about_right.png',
                      onTap: () {
                        Get.to(() => const PrivacyPolicy());
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ProfileListTile(
                      icon: 'assets/icons/heart.png',
                      title: 'Rate the App',
                      trailing: 'assets/icons/about_right.png',
                      onTap: () {
                        rateUsBottomSheet();
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
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
