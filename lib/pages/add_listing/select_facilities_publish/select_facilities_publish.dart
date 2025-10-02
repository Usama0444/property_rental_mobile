import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/add_listing/controller/listing_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

class SelectFacilitiesPublish extends StatelessWidget {
  SelectFacilitiesPublish({super.key, this.listingId, this.listingModel});
  final String? listingId;
  final AddListingModel? listingModel;

  final controller = Get.put(EnterPropertyDetailsController());
  RxList<dynamic> selectFacilities = [].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: '',
            isSuffixIcon: true,
            isBottomBorder: false,
            suffixWidget: CustomButton(
                text: 'Exit',
                width: 116,
                isBorder: true,
                backgroundColor: whiteColor,
                textColor: textColor66,
                borderRadius: 45,
                onPressed: () {
                  Get.offAll(BottomNavBar());
                }),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Listing your property as',
                  //   textAlign: TextAlign.start,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w700,
                  //     color: blackColor3B,
                  //     fontSize: 18,
                  //     fontFamily: 'Avenir',
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: List.generate(
                  //     controller.propertyList.length,
                  //     (index) => GestureDetector(
                  //       onTap: () {
                  //         listingModel!.listingRole.value =
                  //             controller.propertyList[index]['title'];
                  //       },
                  //       child: Obx(
                  //         () => Container(
                  //           height: 98,
                  //           width: 100,
                  //           margin: const EdgeInsets.only(right: 20),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(
                  //                   color: controller.isListingAs.value != index
                  //                       ? greyBorderColor
                  //                       : Colors.transparent,
                  //                   width: 1),
                  //               color: listingModel!.listingRole.value ==
                  //                       controller.propertyList[index]['title']
                  //                   // color: controller.isListingAs.value == index
                  //                   ? primaryColor.withOpacity(0.2)
                  //                   : whiteColor,
                  //               borderRadius: BorderRadius.circular(6)),
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 12, vertical: 12),
                  //           child: Column(
                  //             children: [
                  //               Image.asset(
                  //                 controller.propertyList[index]['icon'],
                  //                 height: 44,
                  //                 width: 44,
                  //               ),
                  //               const SizedBox(height: 6),
                  //               Text(
                  //                 controller.propertyList[index]['title'],
                  //                 textAlign: TextAlign.start,
                  //                 style: const TextStyle(
                  //                   fontWeight: FontWeight.w700,
                  //                   color: blackColor3B,
                  //                   fontSize: 12,
                  //                   fontFamily: 'Avenir',
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                  // const SizedBox(height: 42),
                 
                  const Text(
                    'Select facilities in your property',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 18,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                      itemCount: controller.facilitiesList.length,
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        mainAxisExtent: 98,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(() => GestureDetector(
                              onTap: () {
                                if (listingModel!.facilities.contains(controller
                                    .facilitiesList[index]['title'])) {
                                  listingModel!.facilities.remove(controller
                                      .facilitiesList[index]['title']);
                                } else {
                                  listingModel!.facilities.add(controller
                                      .facilitiesList[index]['title']);
                                }
                                // if (selectFacilities.contains(controller
                                //     .facilitiesList[index]['title'])) {
                                //   selectFacilities.remove(controller
                                //       .facilitiesList[index]['title']);
                                // } else {
                                //   selectFacilities.add(controller
                                //       .facilitiesList[index]['title']);
                                // }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: listingModel!.facilities
                                                .contains(controller
                                                        .facilitiesList[index]
                                                    ['title'])
                                            ? Colors.transparent
                                            : greyBorderColor,
                                        width: 1),
                                    color: listingModel!.facilities.contains(
                                            controller.facilitiesList[index]
                                                ['title'])
                                        ? primaryColor.withOpacity(0.2)
                                        : whiteColor,
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      controller.facilitiesList[index]['icon'],
                                      height: 44,
                                      width: 44,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      controller.facilitiesList[index]['title'],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: blackColor3B,
                                        fontSize: 12,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Container(
            height: 76,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CustomButton(
              text: 'Finish And Publish',
              height: 44,
              width: Get.width,
             onPressed: () async {
                print(listingId);
                try {
                  if (listingId == '' || listingId == null) {
                    await controller.publishListing(listingModel!);
                  } else {
                    print('Updating existing listing');
                    await controller.updateListing(listingModel, listingId);
                  }
                } catch (e) {
                  print('Error updating isListingUser or publishing listing: $e');
                  Get.snackbar('Error', 'Failed to publish listing: $e',
                      snackPosition: SnackPosition.BOTTOM);
                }
              
              },
            ),
          )
        ],
      ),
    );
  }
}
