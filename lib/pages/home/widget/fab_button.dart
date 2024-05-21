import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/start_new_ads/start_new_ads.dart';

class FabButton extends StatelessWidget {
  const FabButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () {
        Get.to(
          () => const CreatingNewAds(),
        );
      },
      backgroundColor: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/add_icon.png',
              height: 24,
              width: 24,
              color: whiteColor,
            ),
            const SizedBox(width: 6,),
            const Text(
              'Add Listing',
              style: TextStyle(
                fontSize: 16,
                color: whiteColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ), // Change the color as needed
    );
  }
}
