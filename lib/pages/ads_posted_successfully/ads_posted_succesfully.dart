import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/apartment_details.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';

class AdsPostedSuccessfully extends StatelessWidget {
   AdsPostedSuccessfully({super.key, this.listingId});
String? listingId;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          Get.offAll(BottomNavBar());
          return;
        }
        // Get.close(3);
        Get.offAll(BottomNavBar());
      },
      child: Scaffold(
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
                    Get.offAll(() => BottomNavBar());
                  }),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 68),
                    Container(
                      // color: Colors.red,
                      child: Center(
                        child: Image.asset(
                          'assets/images/ads_posted.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Woohoo!',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: blackColor3B,
                        fontSize: 22,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: Get.width,
                        child: const Text(
                          'You have successfully posted your property Ad',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: blackColor3B,
                            fontSize: 20,
                            fontFamily: 'Avenir',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Congratulations! Your property ad is now live and ready to attract potential buyers. Sit back and let our platform work its magic as interested individuals discover your listing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: blackColor3B,
                        fontSize: 15,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'View your Ad',
                      height: 44,
                      width: Get.width,
                      onPressed: () {
                        // Get.to(() => MyPropertyAds());
                        Get.to(() => ApartmentDetails(listingId: listingId, comingFromMyAdd: true,));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
