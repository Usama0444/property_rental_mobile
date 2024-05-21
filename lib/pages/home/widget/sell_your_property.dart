import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/start_new_ads/start_new_ads.dart';

class SellYourProperty extends StatelessWidget {
  const SellYourProperty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.only(top: 12, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sell your property faster with Qwarqo ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Avenir',
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sell your property faster. Effective marketing, wider reach, and expert guidance at your service.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: 'Add Listing',
                      backgroundColor: whiteColor,
                      isBorder: true,
                      textColor: blackColor,
                      borderRadius: 6,
                      verticalPadding: 6,
                      height: 30,
                      width: 93,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      onPressed: () {
                        Get.to(() => const CreatingNewAds());
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/property_image_3.png',
                  height: 112,
                  width: 176,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
