import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/profile/controller.dart';

rateUsBottomSheet() {
  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: whiteColor,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (context) {
      final controller = Get.put(ProfileController());
      return Container(
        decoration: const ShapeDecoration(
          color: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/rate_us.png',
                  height: 153,
                  width: 136,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Rate your experience with MSL Homes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: blackColor3B,
                    fontSize: 18,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(height: 13),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 55,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Column(
                    children: [
                      Image.asset(
                        'assets/icons/ratings_selected.png',
                        scale: 1,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        controller.ratingsList[_],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: blackColor3B,
                          fontSize: 50,
                          fontFamily: 'Avenir',
                        ),
                      )
                    ],
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Rate',
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  width: Get.width,
                  height: 46,
                  onPressed: () {
                    loadingDialog(
                        message: 'Thank you for rating the application.',
                        button: true,
                        tap: () {
                          Get.back();
                          Get.back();
                        });
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text(
                    'I’ll do it later',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9A9A9A),
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
