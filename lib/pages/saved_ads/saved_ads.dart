import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/saved_ads/controller/saved_ads_controller.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/favourites_model.dart';

import '../search_screen/model/search_model.dart';
import '../search_screen/widget/search_property_widget.dart';

class SavedAds extends StatelessWidget {
  SavedAds({super.key});

  final controller = Get.put(SavedAdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: 'Saved Ads'),
          const SizedBox(
            height: 20,
          ),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection('favourites')
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const SizedBox();
          //       }
          //       if (snapshot.hasError) {
          //         print(snapshot.error.toString());
          //       }
          //       if (!snapshot.data!.docs.isNotEmpty) {
          //         return const Center(
          //             child: SizedBox(
          //                 child: Text(
          //           'No saved Ads yet.',
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             color: textColor7171,
          //             fontSize: 14,
          //             fontFamily: 'Avenir',
          //           ),
          //         )));
          //       }
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: ListView.builder(
          //             shrinkWrap: true,
          //             padding: EdgeInsets.zero,
          //             itemCount: snapshot.data!.docs.length,
          //             itemBuilder: (context, index) {
          //               FavouriteModel favModel =
          //                   FavouriteModel.fromDocumentSnapshot(
          //                       snapshot.data!.docs[index]
          //                           as DocumentSnapshot<Map<String, dynamic>>);
          //               print(favModel.likes);
          //               if (favModel.likes.contains(auth.currentUser!.uid)) {
          //                 SearchModel newModel =
          //                     controller.propertiesList[index];
          //
          //                 return StreamBuilder(
          //                   stream: FirebaseFirestore.instance
          //                       .collection('listings')
          //                       .doc(snapshot.data!.docs[index].id)
          //                       .snapshots(),
          //                   builder: (context, snapshot) {
          //                     if (snapshot.connectionState ==
          //                         ConnectionState.waiting) {
          //                       return const SizedBox();
          //                     }
          //                     if (snapshot.hasError) {
          //                       print(snapshot.error.toString());
          //                     }
          //                     if (!snapshot.data!.exists) {
          //                       return Center(
          //                           child: SizedBox(
          //                               child: const Text(
          //                         'No saved Ads yet.',
          //                         style: TextStyle(
          //                           fontWeight: FontWeight.w700,
          //                           color: blackColor3B,
          //                           fontSize: 20,
          //                           fontFamily: 'Avenir',
          //                         ),
          //                       )));
          //                     }
          //                     AddListingModel listingModel =
          //                         AddListingModel.fromDocumentSnapshot(
          //                             snapshot.data as DocumentSnapshot<
          //                                 Map<String, dynamic>>);
          //                     return Padding(
          //                       padding: const EdgeInsets.only(bottom: 16),
          //                       child: SearchPropertyWidget(
          //                         searchModel: listingModel,
          //                         listingId: snapshot.data!.id,
          //                         searchModelUI: newModel,
          //                       ),
          //                     );
          //                   },
          //                 );
          //               }
          //               return SizedBox();
          //             }),
          //       );
          //     },
          //   ),
          // )
   Expanded(
  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('favourites')
        .where('likes', arrayContains: auth.currentUser!.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .get(),
    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        print('Waiting for favourites data...');
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        print('Error fetching favourites: ${snapshot.error}');
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        print('No favourites data or empty collection');
        return const Center(
          child: Text(
            'No saved Ads yet.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
              fontSize: 14,
              fontFamily: 'Avenir',
            ),
          ),
        );
      }

      // Pre-fetch listings to check if any valid ones exist
      return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: Future.wait(
          snapshot.data!.docs.map((doc) => FirebaseFirestore.instance
              .collection('listings')
              .doc(doc.id)
              .withConverter<Map<String, dynamic>>(
                fromFirestore: (snapshot, _) => snapshot.data()!,
                toFirestore: (data, _) => data,
              )
              .get()),
        ),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>> listingsSnapshot) {
          if (listingsSnapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for listings data...');
            return const Center(child: CircularProgressIndicator());
          }
          if (listingsSnapshot.hasError) {
            print('Error fetching listings: ${listingsSnapshot.error}');
            return Center(child: Text('Error: ${listingsSnapshot.error}'));
          }

          // Check for valid listings
          List<Widget> validListingWidgets = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            var doc = snapshot.data!.docs[i];
            var listingDoc = listingsSnapshot.data![i];
            String docId = doc.id;
            print('Processing doc $docId');

            if (listingDoc.exists) {
              try {
                AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(listingDoc);
                print('Valid listing found for $docId: ${listingDoc.data()}');
                validListingWidgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SearchPropertyWidget(
                      searchModel: listingModel,
                      listingId: docId,
                    ),
                  ),
                );
              } catch (e) {
                print('Error creating AddListingModel for $docId: $e');
              }
            } else {
              print('Listing does not exist for: $docId');
            }
          }

          // If no valid listings, show "No saved Ads yet."
          if (validListingWidgets.isEmpty) {
            print('No valid listings found');
            return const Center(
              child: Text(
                'No saved Ads yet.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Avenir',
                ),
              ),
            );
          }

          // Render valid listings
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: validListingWidgets,
            ),
          );
        },
      );
    },
  ),
), ] ),
    );
  }
}
