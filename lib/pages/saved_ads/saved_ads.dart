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

      bool currentUserLikedAnyProperty = false;

      for (var doc in snapshot.data!.docs) {
        FavouriteModel favModel = FavouriteModel.fromDocumentSnapshot(doc);
        if (favModel.likes.contains(auth.currentUser!.uid)) {
          print('yes');
          currentUserLikedAnyProperty = true;
          break;
        }
      }
      print(currentUserLikedAnyProperty);

      if (currentUserLikedAnyProperty == true) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              FavouriteModel favModel = FavouriteModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
              print(favModel.likes);
              if (favModel.likes.contains(auth.currentUser!.uid)) {
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('listings')
                      .doc(snapshot.data!.docs[index].id)
                      .withConverter<Map<String, dynamic>>(
                        fromFirestore: (snapshot, _) => snapshot.data()!,
                        toFirestore: (data, _) => data,
                      )
                      .get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> listingSnapshot) {
                    if (listingSnapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (listingSnapshot.hasError) {
                      print(listingSnapshot.error.toString());
                      return Text('Error: ${listingSnapshot.error}');
                    }
                    if (!listingSnapshot.hasData || !listingSnapshot.data!.exists) {
                      return const SizedBox();
                    }
                    AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(listingSnapshot.data!);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SearchPropertyWidget(
                        searchModel: listingModel,
                        listingId: listingSnapshot.data!.id,
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        );
      } else {
        print('mine');
        print(currentUserLikedAnyProperty);
        return const Center(
          child: SizedBox(
            child: Text(
              'No saved Ads yet.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
                fontSize: 14,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        );
      }
    },
  ),
)  ],
      ),
    );
  }
}
