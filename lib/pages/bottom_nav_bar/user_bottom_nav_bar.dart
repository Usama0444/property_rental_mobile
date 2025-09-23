import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';

import '../search_screen/controller/search_screen_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
    
      body: Obx(
        () => BottomNavController.widgetsOption
            .elementAt(controller.tabIndex.value),
      ),
    
      /// NavBar Custom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10)
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.put(HomeController()).propertyStatus.value =
                      'all';
                  controller.tabIndex.value = 0;
                },
                child: controller.tabIndex.value == 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage('assets/icons/home_2.png'),
                              size: 24,
                              color: primaryColor,
                            ),
                            const Spacer( ),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              height: 10,
                              width: 10,
                              color: primaryColor,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage(
                                'assets/icons/home_1.png',
                              ),
                              size: 24,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.tabIndex.value = 1;
                },
                child: controller.tabIndex.value == 1
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage('assets/icons/search_2.png'),
                              size: 24,
                              color: primaryColor,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              color: primaryColor,
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage(
                                'assets/icons/search_1.png',
                              ),
                              size: 24,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.tabIndex.value = 2;
                },
                child: controller.tabIndex.value == 2
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage('assets/icons/saved_2.png'),
                              color: primaryColor,
                              size: 24,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              color: primaryColor,
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage(
                                'assets/icons/saved_1.png',
                              ),
                              size: 24,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.tabIndex.value = 3;
                },
                child: controller.tabIndex.value == 3
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage('assets/icons/profile_icon_2.png'),
                              size: 24,
                              color: primaryColor,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              color: primaryColor,
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const ImageIcon(
                              AssetImage(
                                'assets/icons/profile_icon_1.png',
                              ),
                              size: 24,
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/icons/half_circle.png',
                              height: 10,
                              width: 10,
                              alignment: Alignment.bottomCenter,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
