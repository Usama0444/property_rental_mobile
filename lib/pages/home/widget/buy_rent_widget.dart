import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/create_new_advert/create_new_advert.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';
import 'package:property_rental_app/pages/start_new_ads/start_new_ads.dart';

class BuyRentWidget extends StatelessWidget {
  BuyRentWidget({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 397,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          alignment: Alignment.center,
          image: AssetImage('assets/images/new_shad.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Obx(
        () {
          // Filter buySaleRentList to exclude 'Add Details' if isListingUser is false or null
          final filteredList = controller.buySaleRentList.where((buySaleRentMap) {
            if (buySaleRentMap['buttonTitle'] == 'Add Details') {
              return currentUserDataModel?.value.isListingUser.value ?? false;
            }
            return true;
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: Get.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    clipBehavior: Clip.hardEdge,
                    padEnds: true,
                    aspectRatio: 16 / 9,
                    height: 305,
                    autoPlayCurve: Curves.easeIn,
                    enlargeFactor: 0.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: filteredList.length > 1, // Disable infinite scroll if only one item
                    initialPage: controller.buySaleRentIndex.value.clamp(0, filteredList.length - 1),
                    onPageChanged: (index, dynamic) {
                      controller.buySaleRentIndex.value = index;
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  items: filteredList.map(
                    (buySaleRentMap) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 100,
                                    width: 140,
                                    child: Image.asset(buySaleRentMap['image']),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    buySaleRentMap['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: blackColor,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 164,
                                    child: Text(
                                      buySaleRentMap['subTitle'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF3B3B3B),
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    text: buySaleRentMap['buttonTitle'],
                                    textColor: blackColor,
                                    borderRadius: 6,
                                    width: 165,
                                    isBorder: true,
                                    backgroundColor: whiteColor,
                                    onPressed: () {
                                      controller.isFromBottom.value = false;
                                      print(buySaleRentMap.toString() + '1111');
                                      if (buySaleRentMap['buttonTitle'] == 'Browse Properties') {
                                        controller.propertyStatus.value = 'For Sale';
                                        Get.to(() => BottomNavBar());
                                        Get.find<BottomNavController>().tabIndex.value = 1;
                                      } else if (buySaleRentMap['buttonTitle'] == 'Add Details') {
                                        Get.to(() => const CreateNewAdvert());
                                      } else {
                                        controller.propertyStatus.value = 'Rent';
                                        Get.to(() => BottomNavBar());
                                        Get.find<BottomNavController>().tabIndex.value = 1;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              Center(
                child: PageViewDotIndicator(
                  currentItem: controller.buySaleRentIndex.value.clamp(0, filteredList.length - 1),
                  count: filteredList.length,
                  unselectedColor: lightGreyD9,
                  selectedColor: primaryColor,
                  size: const Size(40, 6),
                  unselectedSize: const Size(22, 6),
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  fadeEdges: false,
                  boxShape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                  onItemClicked: (index) {
                    controller.buySaleRentIndex.value = index;
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}