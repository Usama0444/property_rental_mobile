import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/constants/app_colors.dart';

deleteBottomSheet() {
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        // height: Get.height - 60,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Image.asset(
                    'assets/icons/delete_2.png',
                    height: 78,
                    width: 78,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Are you sure you want to delete this account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: blackColor3B,
                    fontSize: 20,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Delete my account',
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  width: Get.width,
                  height: 46,
                  onPressed: () async {
                    deleteUserAccount();
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9A9A9A),
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    },
  );
}
