
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class TipsforSafety extends StatelessWidget {
  const TipsforSafety({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tips for your safety',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: blackColor3B,
                fontSize: 16,
                fontFamily: 'Avenir',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  'assets/icons/tickcircle.png',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  'Always Visit the Place Before You Rent',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor3B,
                    fontSize: 12,
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Image.asset(
                  'assets/icons/tickcircle.png',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  'Don’t Rush to Get a House',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor3B,
                    fontSize: 12,
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}