import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/apartment_details_controller.dart';

class ExpansionWidget extends StatelessWidget {
  ExpansionWidget({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final controller = Get.put(ApartmentDetailsController());
  var isExpandTile = false.obs;

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        tilePadding: const EdgeInsets.only(left: 16, right: 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: whiteColor,
        collapsedShape: RoundedRectangleBorder(
          side: const BorderSide(color: greyBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: greyBorderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        onExpansionChanged: (isExpand) {
          isExpandTile.value = isExpand;
        },
        trailing: isExpandTile.value != true
            ? const Icon(
                Icons.add,
                color: primaryColor,
              )
            : const Icon(
                Icons.remove,
                color: primaryColor,
              ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor3B,
            fontFamily: 'Avenir',
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: blackColor3B,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
