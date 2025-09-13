import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/apartment_details/apartment_details.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

class BrowsProperty extends StatelessWidget {
  BrowsProperty({
    super.key,
    required this.propertyType,
  });
  final String propertyType;
  final controller = Get.put(HomeController());
  Query<Map<String, dynamic>>? query;
  RxBool filterValue = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedName.value == 'Apartment') {
        print('123');
        query = FirebaseFirestore.instance
                .collection('listings')
                .where('propertyType', isEqualTo: 'Apartment')
                .where('listingRole', isEqualTo: controller.propertyType2.value)
                .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
            as Query<Map<String, dynamic>>;
      }
      if (controller.selectedName.value == 'Bedsitters') {
        print('bedsitters');

        query = FirebaseFirestore.instance
                .collection('listings')
                .where('listingRole', isEqualTo: controller.propertyType2.value)
                .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
                .where('propertyType', isEqualTo: 'Bedsitters')
            as Query<Map<String, dynamic>>;
      }
      if (controller.selectedName.value == 'Single room') {
        print('sungle');

        query = FirebaseFirestore.instance
                .collection('listings')
                .where('selectedBedroom', arrayContains: '1')
                .where('listingRole', isEqualTo: controller.propertyType2.value)
                .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
            as Query<Map<String, dynamic>>;
      }
      if (controller.selectedName.value == '1,2,3+ Bedrooms') {
        print('bedems');

        query = FirebaseFirestore.instance
                .collection('listings')
                .where('listingRole', isEqualTo: controller.propertyType2.value)
                .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
            as Query<Map<String, dynamic>>;
      }
      if (controller.selectedName.value == 'For Sale') {
        print('fsf');
        query = FirebaseFirestore.instance
                .collection('listings')
                .where('listingRole', isEqualTo: 'For Sale')
                .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
            as Query<Map<String, dynamic>>;
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: whiteColor,
          // color: redColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10)
          ],
        ),
        padding: const EdgeInsets.only(top: 12, left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Browse properties by Categories ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: blackColor,
                fontFamily: 'Avenir',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 34,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.propertiesCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.isSelectedIndex.value = index;
                        controller.selectedName.value =
                            controller.propertiesCategories[index]['title'];
                        print(controller.selectedName.value);
                        filterValue.value = true;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: controller.isSelectedIndex.value == index
                                  ? primaryColor
                                  : greyBorderColor),
                          color: controller.isSelectedIndex.value == index
                              ? primaryColor.withOpacity(0.2)
                              : whiteColor,
                          borderRadius: BorderRadius.circular(46),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              controller.propertiesCategories[index]['icon'],
                              height: 18,
                              width: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              controller.propertiesCategories[index]['title'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
          Obx(() {
  return StreamBuilder(
    stream: filterValue.value == true ? query?.snapshots() : query?.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
      }
      if (snapshot.hasError) {
        print(snapshot.error.toString());
        return const Center(child: Text('Error loading properties'));
      }
      if (snapshot.data!.docs.isEmpty) {
        controller.initialPage.value = 0; // Reset initialPage when empty
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No Property for this category.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: blackColor,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        );
      }

      List<AddListingModel> myProperties = [];
      for (var data in snapshot.data!.docs) {
        AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(data);
        myProperties.add(listingModel);
      }

      // Reset initialPage if it's out of bounds
      if (controller.initialPage.value >= myProperties.length) {
        controller.initialPage.value = 0;
      }

      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              clipBehavior: Clip.hardEdge,
              padEnds: false,
              aspectRatio: 16 / 9,
              height: 265,
              autoPlayCurve: Curves.easeIn,
              enlargeFactor: 0.0,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              initialPage: controller.initialPage.value,
              onPageChanged: (index, reason) {
                controller.initialPage.value = index;
              },
              scrollDirection: Axis.horizontal,
            ),
            items: List.generate(myProperties.length, (index) {
              return PropertyData(
                imageMap: myProperties[index],
                selectedName: controller.selectedName.value,
                role: 'Rent',
                listingId: snapshot.data!.docs[index].id,
              );
            }),
          ),
          Obx(
            () => Center(
              child: PageViewDotIndicator(
                currentItem: controller.initialPage.value,
                count: myProperties.length,
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
                  controller.initialPage.value = index;
                },
              ),
            ),
          ),
        ],
      );
    },
  );}),
  const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    });
  }
}

class PropertyData extends StatelessWidget {
  PropertyData({
    super.key,
    required this.imageMap,
    required this.selectedName,
    required this.role,
    required this.listingId,
  });
  final AddListingModel imageMap;
  final String selectedName;
  final String listingId;
  final String role;
  Query<Map<String, dynamic>>? query;

  @override
  Widget build(BuildContext context) {
    // if (selectedName == 'Apartment') {
    //   print('Apartments');
    //
    //       query = FirebaseFirestore.instance
    //       .collection('listings')
    //       .where('propertyType', isEqualTo: 'Apartment')
    //       .where('listingRole', isEqualTo: role) as Query<Map<String, dynamic>>;
    // }
    // if (selectedName == 'Bedsitters') {
    //   print('bedsitters');
    //
    //       query = FirebaseFirestore.instance
    //       .collection('listings')
    //       .where('listingRole', isEqualTo: role) as Query<Map<String, dynamic>>;
    // }
    // if (selectedName == 'Single room') {
    //   print('sungle');
    //
    //       query = FirebaseFirestore.instance
    //       .collection('listings')
    //       .where('propertyType', isEqualTo: 'Apartment')
    //       .where('listingRole', isEqualTo: role) as Query<Map<String, dynamic>>;
    // }
    // if (selectedName == '1,2,3+ Bedrooms') {
    //   print('bedems');
    //
    //       query = FirebaseFirestore.instance
    //       .collection('listings')
    //       .where('propertyType', isEqualTo: 'Apartment')
    //       .where('listingRole', isEqualTo: role)
    //      as Query<Map<String, dynamic>>;
    // }
    // if (selectedName == 'For Sale') {
    //   print('fsf');
    //   query = FirebaseFirestore.instance
    //           .collection('listings')
    //           .where('listingRole', isEqualTo: 'Sold')
    //       as Query<Map<String, dynamic>>;
    // }
    return GestureDetector(
      onTap: () {
        Get.to(ApartmentDetails(
          comingFromMyAdd: false,
          listingId: listingId,
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageMap.listingImages[0].value,
            height: 139,
            width: 241,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return FutureBuilder(
                future: videoThumbnail(
                    urlForThumbnail: imageMap.listingImages[0].value),
                builder: (context, snapshot) {
                  print(snapshot.data.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: 139,
                        width: 241,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        )));
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    print('error');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                        height: 139,
                        width: 241,
                        child: Image.file(
                          File(snapshot.data.toString()),
                          width: Get.width,
                          height: 246,
                          fit: BoxFit.cover,
                        ));
                  } else {
                    return const SizedBox(
                        width: 80,
                        height: 55,
                        child: Center(child: SizedBox()));
                  }
                },
              );
            },
          ),
          // SizedBox(
          //   height: 139,
          //   width: 241,
          //   child: Image.asset(
          //     imageMap['image'],
          //   ),
          // ),
          const SizedBox(
            height: 8,
          ),
          Text(
            imageMap.propertyName.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: blackColor,
              fontFamily: 'Avenir',
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'KSH  ${imageMap.payment.text}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontFamily: 'Avenir',
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Image.asset(
                'assets/icons/location_icon.png',
                height: 16,
                width: 16,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  imageMap.street.text +
                      ", " +
                      imageMap.town.text +
                      ", " +
                      imageMap.countryName.value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Image.asset(
                'assets/icons/bedroom_2.png',
                height: 16,
                width: 16,
              ),
              const SizedBox(
                width: 4,
              ),
              RichText(
                text: TextSpan(
                  text: 'Bedrooms : ${imageMap.selectedBedroom.last} ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                    fontFamily: 'Avenir',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '( ${imageMap.selectedBedroom.last} Available)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: blackColor,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
