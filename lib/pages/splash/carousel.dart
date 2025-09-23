
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/auth/login/login_screen.dart';
import 'package:property_rental_app/pages/splash/splash_controller.dart';

class CaroselSlider extends StatelessWidget {
  CaroselSlider({
    super.key,
  });

  final controller = Get.put(SplashController());
  final CarouselSliderController caroselController = CarouselSliderController();
  // final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              CarouselSlider(
                carouselController: caroselController,
                options: CarouselOptions(
                  animateToClosest: true,
                  pageSnapping: true,
                  clipBehavior: Clip.hardEdge,
                  padEnds: true,
                  reverse: false,
                  aspectRatio: 16 / 9,
                  height: Get.height * 0.8,
                  autoPlayCurve: Curves.easeIn,
                  enlargeFactor: 0.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  disableCenter: false,
                  enableInfiniteScroll: false,
                  initialPage: controller.buySaleRentIndex.value,
                  onPageChanged: (index, dynamic) {
                    controller.buySaleRentIndex.value = index;
                  },
                  scrollDirection: Axis.horizontal,
                ),
                items: controller.buySaleRentList.map(
                  (buySaleRentMap) {
                    return controller.buySaleRentIndex.value == 0
                        ? Container(
                            width: Get.width,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Image.asset(
                                    'assets/images/image for dtart.png',
                                    height: Get.height * 0.6,
                                    width: Get.width,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'Welcome to',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    // color:  primaryColor,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                const Text(
                                  'Realtime Estates Ltd',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: primaryColor,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: 'Avenir',
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    'The best real estate application in Kenya to complete your life and family',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                //   child: CustomButton(
                                //       text: 'Next',
                                //       height: 44,
                                //       width: Get.width,
                                //       onPressed: () async {
                                //         Get.to(() => CaroselSlider());
                                //       }),
                                // ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  // height: 322,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      //   color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      SizedBox(
                                          height: Get.height * 0.5,
                                          // width: 140,
                                          child: Image.asset(
                                              buySaleRentMap['image'])),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Text(
                                          buySaleRentMap['title'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w800,
                                            color: primaryColor,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ).toList(),
              ),
              Center(
                child: PageViewDotIndicator(
                  currentItem: controller.buySaleRentIndex.value,
                  count: controller.buySaleRentList.length,
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
                  //defaults to circle
                  borderRadius: BorderRadius.circular(50),

                  //only for rectangle shape
                  onItemClicked: (index) {
                    controller.buySaleRentIndex.value = index;
                    caroselController.animateToPage(index);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: 'Next ',
                  height: 44,
                  width: Get.width,
                  onPressed: () async {
                    // Step 4: Navigate to the next carousel item or go to LoginScreen
                    int nextIndex = controller.buySaleRentIndex.value + 1;
                    if (nextIndex < controller.buySaleRentList.length) {
                      caroselController.animateToPage(nextIndex);
                      controller.buySaleRentIndex.value = nextIndex;
                    } else {
                      Get.offAll(() => LoginScreen());
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
