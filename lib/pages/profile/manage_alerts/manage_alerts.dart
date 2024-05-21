import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_switch_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';

import 'controller/manage_alert_controller.dart';

class ManageAlert extends StatelessWidget {
   ManageAlert({super.key});

  final controller = Get.put(ManageAlertController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'Manage Alerts',
            isBackButton: true,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Text(
                  'Get new updates based on your searches or recent searches',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor3B,
                    fontSize: 14,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Email recommendation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                          () => CustomSwitchButtonWidget(
                        status: controller.isEmailRecommendation.value,
                        onToggle: (value) {
                          controller.isEmailRecommendation.value =
                          !controller.isEmailRecommendation.value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(
                  color: greyBorderColor,
                  height: 1,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Recent viewed properties',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                          () => CustomSwitchButtonWidget(
                        status: controller.isRecentViewed.value,
                        onToggle: (value) {
                          controller.isRecentViewed.value =
                          !controller.isRecentViewed.value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
