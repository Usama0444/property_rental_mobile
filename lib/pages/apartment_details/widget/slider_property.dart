import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/apartment_details_controller.dart';
import 'package:property_rental_app/pages/search_screen/search_screen.dart';
import 'package:property_rental_app/universal_models/favourites_model.dart';

import '../../../common_widgets/global_functions.dart';
import '../../../main.dart';
import '../../../universal_models/add_listing_model.dart';
import '../../home/widget/bedsitter_widget.dart';
import '../apartment_details.dart';

class SliderProperty extends StatelessWidget {
  SliderProperty({
    super.key,
  });

  final controller = Get.put(ApartmentDetailsController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
          .where('propertyType', isEqualTo: 'Bedsitters')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or any other loading indicator
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
              'No data available'); // Or any other empty state widget
        }
        return SizedBox(
          height: 120,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              AddListingModel listingModel =
                  AddListingModel.fromDocumentSnapshot(
                      snapshot.data!.docs[index]);
              return BedsittersWidget(
                listingID: snapshot.data!.docs[index].id,
                // homeModel: controller.bedsittersList[index],
                listingModel: listingModel,
              );
            },
          ),
        );
      },
    );
  }
}

class RecommendedProperties extends StatelessWidget {
  RecommendedProperties({
    super.key,
  });

  final controller = Get.put(ApartmentDetailsController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
          // .where('propertyType', isEqualTo: 'Bedsitters')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or any other loading indicator
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
              'No data available'); // Or any other empty state widget
        }
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(snapshot.data!.docs.length, (index) {
              AddListingModel listingModel =
                  AddListingModel.fromDocumentSnapshot(
                      snapshot.data!.docs[index]);

              return Stack(
                children: [
                  Container(
                    width: Get.width * 0.44,
                    margin: const EdgeInsets.only(
                        // right: 10, bottom: 8, left: 10, top: 8),
                        right: 8,
                        bottom: 8,
                        left: 8,
                        top: 8),
                    // padding: const EdgeInsets.only(
                    //     left: 8, right: 12, top: 8, bottom: 8),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(12),
                    //   color: whiteColor,
                    //   boxShadow: [
                    //     BoxShadow(
                    //         color: textColor.withOpacity(0.1),
                    //         spreadRadius: 0.5,
                    //         blurRadius: 5,
                    //         offset: const Offset(1, 3)),
                    //   ],
                    // ),
                    child: GestureDetector(
                      onTap: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApartmentDetails(
                                        comingFromMyAdd: false,
                                        listingId:
                                            snapshot.data!.docs[index].id,
                                      )),
                            );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: listingModel!.listingImages.length != 0
                                  ? Image.network(
                                      listingModel!.listingImages.first.value,
                                      height: 120,
                                      width: Get.width,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return FutureBuilder(
                                          future: videoThumbnail(
                                              urlForThumbnail: listingModel
                                                  .listingImages[0].value),
                                          builder: (context, snapshot) {
                                            print(snapshot.data.toString());
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return SizedBox(
                                                  height: 120,
                                                  width: Get.width,
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: primaryColor,
                                                  )));
                                            }
                                            if (snapshot.hasError) {
                                              print(snapshot.error.toString());
                                              print('error');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return SizedBox(
                                                  height: 120,
                                                  width: Get.width,
                                                  child: Image.file(
                                                    File(
                                                        snapshot.data.toString()),
                                                    height: 120,
                                                    width: 126,
                                                    fit: BoxFit.cover,
                                                  ));
                                            } else {
                                              return SizedBox(
                                                  width: Get.width,
                                                  height: 120,
                                                  child: const Center(
                                                      child: SizedBox()));
                                            }
                                          },
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 200,
                                      width: Get.width,
                                    )),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              print('shvd====');
                              // Get.to(()=>SearchScreen(role: 'hvsfd', isComingFromActivity: true));
                             
                              // Get.back();
                              // Get.to(() => ApartmentDetails(
                              //       comingFromMyAdd: false,
                              //       listingId: snapshot.data!.docs[index].id,
                              //     ));
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3, bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      listingModel.propertyName.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'KSH ${listingModel.payment.text}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/bedroom_2.png',
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Bedrooms : ${listingModel.selectedBedroom.last}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: blackColor,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // ),
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance
                    //       .collection('favourites')
                    //       .doc(snapshot.data!.docs[index].id)
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.waiting) {
                    //       return const SizedBox();
                    //     }
                    //     if (snapshot.hasError) {
                    //       print(snapshot.error.toString());
                    //     }
                    //     FavouriteModel? model;
                    //
                    //     if (!snapshot.data!.exists) {
                    //       print('data doesnts');
                    //
                    //       model = FavouriteModel.initialize();
                    //     }
                    //     if (snapshot.data!.exists) {
                    //       print('data exists');
                    //       model = FavouriteModel.fromDocumentSnapshot(snapshot
                    //           .data as DocumentSnapshot<Map<String, dynamic>>);
                    //     }
                    //
                    //     var listingId = snapshot.data!.id;
                    //     // print("$listingId +'/////'");
                    //     return Positioned(
                    //       top: 20,
                    //       right: 20,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           if (!snapshot.data!.exists) {
                    //             FirebaseFirestore.instance
                    //                 .collection('favourites')
                    //                 .doc(listingId)
                    //                 .set({
                    //               'likes': [auth.currentUser!.uid]
                    //             }).then((value) {
                    //               print('done like');
                    //             }).onError((error, stackTrace) {
                    //               print(error.toString());
                    //             });
                    //           } else {
                    //             if (model!.likes
                    //                 .contains(auth.currentUser!.uid)) {
                    //               model.likes.remove(auth.currentUser!.uid);
                    //               // listOfLikes.remove(index);
                    //             } else {
                    //               model.likes.add(auth.currentUser!.uid);
                    //
                    //               // listOfLikes.add(index);
                    //             }
                    //
                    //             FirebaseFirestore.instance
                    //                 .collection('favourites')
                    //                 .doc(listingId)
                    //                 .update({'likes': model.likes});
                    //           }
                    //           // searchModelUI.isFavourite.value = !searchModelUI.isFavourite.value;
                    //         },
                    //         child: Obx(
                    //           () => CircleAvatar(
                    //             radius: 14,
                    //             backgroundColor: const Color(0xFFF2F2F2),
                    //             child: Image.asset(
                    //               model!.likes.contains(auth.currentUser!.uid)
                    //                   ? 'assets/icons/favourite_fill.png'
                    //                   : 'assets/icons/favourite_unfill.png',
                    //               height: 14,
                    //               width: 13,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                  )
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
