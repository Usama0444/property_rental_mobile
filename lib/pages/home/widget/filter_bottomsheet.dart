import 'dart:ffi';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';

import '../../search_screen/controller/search_screen_controller.dart';

filterBottomSheet() {
  final controller = Get.put(HomeController());
  // final controller1 = Get.put(SearchScreenController());
  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: whiteColor,

    enableDrag: true,

    // showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    // onClosing: () {},
    builder: (context) {
      // final controller = Get.put(SettingController());
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
        height: Get.height - 60,
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Search for property',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: blackColor3B,
                            fontSize: 20,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Image.asset(
                            'assets/icons/cross_icon.png',
                            height: 24,
                            width: 24,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      color: greyBorderColor,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'City, Community or Building',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 16,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Search by typing',
                      fillColor: whiteColor,
                      hintColor: textColor66,
                      controller: controller.filterSearchCtrl,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Bedrooms',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 16,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          CustomButton(
                              text: 'Rent',
                              height: 36,
                              width: 60,
                              backgroundColor: controller.isBuyRent.value == 0
                                  ? const Color(0xFFEFE6E6)
                                  : whiteColor,
                              textColor: blackColor3B,
                              fontWeight: FontWeight.w500,
                              isBorder: true,
                              borderColor: controller.isBuyRent.value == 0
                                  ? primaryColor
                                  : greyBorderColor,
                              borderRadius: 6,
                              onPressed: () {
                                controller.isBuyRent.value = 0;
                                controller.buyRentValue.value = 'Rent';
                              }),
                          const SizedBox(width: 12),
                          CustomButton(
                              text: 'Buy',
                              height: 36,
                              width: 60,
                              fontWeight: FontWeight.w500,
                              backgroundColor: controller.isBuyRent.value == 1
                                  ? const Color(0xFFEFE6E6)
                                  : whiteColor,
                              textColor: blackColor3B,
                              isBorder: true,
                              borderColor: controller.isBuyRent.value == 1
                                  ? primaryColor
                                  : greyBorderColor,
                              borderRadius: 6,
                              onPressed: () {
                                controller.buyRentValue.value = 'Sold';

                                controller.isBuyRent.value = 1;
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Property Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 16,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Wrap(
                        children: List.generate(
                          controller.propertyTypeList.length,
                          (index) => GestureDetector(
                            onTap: () {
                              controller.propertyType.value = index;
                              controller.propertyTypeValue.value =
                                  controller.propertyTypeList[index];
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 12, bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 13),
                              decoration: BoxDecoration(
                                  color: controller.propertyType.value == index
                                      ? const Color(0xFFEFE6E6)
                                      : whiteColor,
                                  border: Border.all(
                                    color:
                                        controller.propertyType.value == index
                                            ? primaryColor
                                            : greyBorderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                controller.propertyTypeList[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Bedrooms',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 20,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Wrap(
                        children: List.generate(
                          controller.bedroomsList.length,
                          (index) => GestureDetector(
                            onTap: () {
                              controller.bedroomCount.value =
                                  controller.bedroomsList[index];
                              controller.selectedBedroom.value = index;
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 12, bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 13),
                              decoration: BoxDecoration(
                                  color:
                                      controller.selectedBedroom.value == index
                                          ? const Color(0xFFEFE6E6)
                                          : whiteColor,
                                  border: Border.all(
                                    color: controller.selectedBedroom.value ==
                                            index
                                        ? primaryColor
                                        : greyBorderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6)),
                              child: SizedBox(
                                child: Text(
                                  controller.bedroomsList[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: blackColor3B,
                                    fontSize: 16,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 20,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Min: KSH ${controller.minValue.toDouble()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: blackColor3B,
                              fontSize: 12,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          Text(
                            'Min: KSH ${controller.maxValue.toDouble()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: blackColor3B,
                              fontSize: 12,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlutterSlider(
                      values: [
                        controller.minValue.value,
                        controller.maxValue.value
                      ],
                      max: controller.maxValue.value,
                      min: controller.minValue.value,
                      rangeSlider: true,
                      jump: true,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      trackBar: FlutterSliderTrackBar(
                        activeTrackBarHeight: 4,
                        activeDisabledTrackBarColor: blackColor,
                        inactiveTrackBar: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12)),
                        activeTrackBar: const BoxDecoration(
                          color: primaryColor,
                        ),
                      ),
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: false,
                        disabled: true,
                      ),
                      handler: FlutterSliderHandler(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: SvgPicture.asset(
                          'assets/icons/handler_2.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: SvgPicture.asset(
                          'assets/icons/handler_2.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        controller.minValue.value = lowerValue;
                        controller.maxValue.value = upperValue;
                      },
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: greyBorderColor,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Reset filter',
                        backgroundColor: whiteColor,
                        isBorder: true,
                        textColor: const Color(0xFF666666),
                        width: Get.width,
                        height: 44,
                        onPressed: () {
                          controller.isBuyRent.value = 10;
                          controller.propertyType.value = 10;
                          controller.selectedBedroom.value = 10;
                          controller.isFilter.value = false;
                          controller.minValue.value = 1000.0;
                          controller.maxValue.value = 104000.0;
                          controller.filterSearchCtrl.clear();
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'Show Result',
                        backgroundColor: primaryColor,
                        textColor: whiteColor,
                        width: Get.width,
                        height: 44,
                        onPressed: () {
                          controller.addSearches();

                          print('hjsvfdhk');
                          controller.isFilter.value = true;
                          Get.back();
                          Get.find<BottomNavController>().tabIndex.value = 1;
                          Get.to(() => BottomNavBar());
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
