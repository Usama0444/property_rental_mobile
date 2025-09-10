import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/profile_listtile.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/create_new_advert/create_new_advert.dart';

class CreatingNewAds extends StatelessWidget {
  const CreatingNewAds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomAppBar(
            title: '',
            isSuffixIcon: true,
            isBottomBorder: false,
            suffixWidget: CustomButton(
                text: 'Exit',
                width: 85,
                isBorder: true,
                backgroundColor: whiteColor,
                textColor: textColor66,
                borderRadius: 45,
                onPressed: () {
                  Get.offAll(BottomNavBar());

                }),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                   Text(
                    'Welcome, ${currentUserDataModel!.value.userName.text}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 20,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Image.asset(
                        'assets/images/new_ads.png',
                        height: 250,
                        width: 260,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Start creating a new Ad',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 18,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileListTile(
                    icon: 'assets/images/create_new_ad.png',
                    title: 'Create new Advert',
                    trailing: 'assets/icons/right_angle.png',
                    iconColor: iconColor,
                    onTap: () {
                      Get.to(() => const CreateNewAdvert());
                    },
                  ),
                  // const SizedBox(height: 24),
                  // ProfileListTile(
                  //   icon: 'assets/images/continue_editing.png',
                  //   title: 'Continue editing your previous Ad',
                  //   trailing: 'assets/icons/right_angle.png',
                  //   iconColor: iconColor,
                  //   onTap: () {
                  //     // deleteBottomSheet();
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
