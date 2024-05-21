import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';

class RentBuyButton extends StatelessWidget {
  RentBuyButton({
    super.key,
  });

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: ShapeDecoration(
        color: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.50),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.propertyTypeButton.value = 0;
                  controller.propertyType2.value='Rent';
                },
                child: Container(
                  width: 127,
                  height: 39,
                  decoration: ShapeDecoration(
                    color: controller.propertyTypeButton.value == 0
                        ? primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Rent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.propertyTypeButton.value == 0
                            ? whiteColor
                            : blackColor,
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
                  controller.propertyTypeButton.value = 1;
                  controller.propertyType2.value='Sold';

                },
                child: Container(
                  width: 127,
                  height: 39,
                  decoration: ShapeDecoration(
                    color: controller.propertyTypeButton.value == 1
                        ? primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: controller.propertyTypeButton.value == 1
                            ? whiteColor
                            : blackColor,
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
