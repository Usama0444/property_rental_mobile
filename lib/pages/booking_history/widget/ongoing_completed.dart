import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/booking_history/controller/booking_history_controller.dart';

class OngoingCompleted extends StatelessWidget {
  OngoingCompleted({
    super.key,
  });

  final controller = Get.put(BookingHistoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 37,
      margin: const EdgeInsets.symmetric(horizontal: 44),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23.50),
            side: const BorderSide(color: greyBorderColor, width: 1)),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectedButton.value = 0;
                },
                child: Container(
                  width: 162,
                  height: 39,
                  decoration: ShapeDecoration(
                    color: controller.selectedButton.value == 0
                        ? primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Ongoing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.selectedButton.value == 0
                            ? whiteColor
                            : blackColor3B,
                        fontSize: 16,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectedButton.value = 1;
                },
                child: Container(
                  width: 162,
                  height: 39,
                  decoration: ShapeDecoration(
                    color: controller.selectedButton.value == 1
                        ? primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Completed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.selectedButton.value == 1
                            ? whiteColor
                            : blackColor3B,
                        fontSize: 14,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
