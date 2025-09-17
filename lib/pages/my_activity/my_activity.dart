import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/my_activity/controller/my_activity_controller.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/recent_searches_model.dart';
import 'package:property_rental_app/universal_models/viewed_property_model.dart';
import 'widget/recent_search.dart';
import 'widget/viewed_activity.dart';

class MyActivity extends StatelessWidget {
  MyActivity({super.key});

  final controller = Get.put(MyActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'My Activity',
            isBackButton: true,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Row(
                children: [
                  CustomButton(
                      text: 'Recent searches',
                      height: 36,
                      width: 145,
                      backgroundColor: controller.isRecentSearches.value == 0
                          ? const Color(0xFFEFE6E6)
                          : whiteColor,
                      textColor: blackColor3B,
                      isBorder: true,
                      borderColor: controller.isRecentSearches.value == 0
                          ? primaryColor
                          : greyBorderColor,
                      borderRadius: 6,
                      onPressed: () {
                        controller.isRecentSearches.value = 0;
                      }),
                  const SizedBox(width: 12),
                  CustomButton(
                      text: 'Viewed',
                      height: 36,
                      width: 81,
                      backgroundColor: controller.isRecentSearches.value == 1
                          ? const Color(0xFFEFE6E6)
                          : whiteColor,
                      textColor: blackColor,
                      isBorder: true,
                      borderColor: controller.isRecentSearches.value == 1
                          ? primaryColor
                          : greyBorderColor,
                      borderRadius: 6,
                      onPressed: () {
                        controller.isRecentSearches.value = 1;
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => controller.isRecentSearches.value == 0
                ? Expanded(
  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('recentSearches')
        .where('userID', isEqualTo: auth.currentUser!.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .get(),
    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
      }
      if (snapshot.hasError) {
        print(snapshot.error.toString());
        return Text('Error: ${snapshot.error}');
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            'Data doesn\'t exist',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          RecentSearchesModel rcModel = RecentSearchesModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RecentSearch(rcModel: rcModel),
          );
        },
      );
    },
  ),
)
                : Expanded(
  child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('viewedProperty')
        .doc(auth.currentUser!.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .get(),
    builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
      }
      if (snapshot.hasError) {
        print(snapshot.error.toString());
        return Text('Error: ${snapshot.error}');
      }
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Center(
          child: Text(
            'No viewed property yet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        );
      }
      ViewedPropertyModel vpModel = ViewedPropertyModel.fromDocumentSnapshot(snapshot.data!);
      return ListView.builder(
        itemCount: vpModel.propertyIds.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('listings')
                .doc(vpModel.propertyIds[index])
                .withConverter<Map<String, dynamic>>(
                  fromFirestore: (snapshot, _) => snapshot.data()!,
                  toFirestore: (data, _) => data,
                )
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot2) {
              print('${vpModel.propertyIds[index]} ==================123');
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapshot2.hasError) {
                print(snapshot2.error.toString());
                return Text('Error: ${snapshot2.error}');
              }
              if (!snapshot2.hasData || !snapshot2.data!.exists) {
                return const SizedBox();
              }
              AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(snapshot2.data!);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ViewedActivity(
                  listingModel: listingModel,
                  listingId: vpModel.propertyIds[index]!,
                ),
              );
            },
          );
        },
      );
    },
  ),
)
          ),
        ],
      ),
    );
  }
}
