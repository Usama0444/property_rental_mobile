import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';

import '../../universal_models/add_listing_model.dart';
import '../add_listing/select_facilities_publish/select_facilities_publish.dart';

class SelectFacilities extends StatelessWidget {
   SelectFacilities({super.key, this.listingId, this.listingModel});
   final String? listingId;
   final AddListingModel? listingModel;


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
                width: 116,
                isBorder: true,
                backgroundColor: whiteColor,
                textColor: blackColor3B,
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
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Image.asset(
                        'assets/images/facilities.png',
                        height: 250,
                        width: 260,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Step 3',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: blackColor3B,
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Select facilities in your property',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 20,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'In this step, We will ask you select all facilities available in your property like security camera, wardrobe etc',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: blackColor3B,
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Container(
            height: 76,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CustomButton(
              text: 'Next',
              height: 44,
              width: Get.width,
              onPressed: () {
                Get.to(() => SelectFacilitiesPublish(listingId:listingId,listingModel:listingModel));
              },
            ),
          )
        ],
      ),
    );
  }
}
