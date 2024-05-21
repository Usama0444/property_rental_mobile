import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/favourites_model.dart';
import '../../../common_widgets/global_functions.dart';
import '../../apartment_details/apartment_details.dart';
import '../controller/search_screen_controller.dart';

class SearchPropertyWidget extends StatelessWidget {
  SearchPropertyWidget({
    super.key,
    this.searchModel,
    this.listingId,
  });
  String? listingId;
  AddListingModel? searchModel;

  final controller = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    final CarouselController carouselController = CarouselController();

    RxInt currentCarouselPage = 0.obs;
    return GestureDetector(
      onTap: () {
        controller.addViewProperty(propertyID: listingId);
        ////
        if (searchModel!.listingRole.value == 'Rent') {
          Get.to(() => ApartmentDetails(
                comingFromMyAdd: false,
                listingId: listingId,
              ));
        } else {
          Get.to(() => ApartmentDetails(
                listingId: listingId,
                isForSale: true,
                comingFromMyAdd: false,
              ));
        }
      },
      child: Stack(
        children: [
          Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: lightGrey),
            ),
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              bottom: 16,
              right: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: searchModel!.listingImages.length != 0
                        ? SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                Obx(
                                  () => CarouselSlider(
                                      /*disableGesture: false,*/
                                      carouselController: carouselController,
                                      items: searchModel!.listingImages
                                          .map((imagePath) {
                                        // print(imagePath.value);
                                        return Image.network(
                                          imagePath.value,
                                          // searchModel!.listingImages.first.value,
                                          height: 200,
                                          width: Get.width,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return FutureBuilder(
                                              future: videoThumbnail(
                                                  urlForThumbnail:
                                                      imagePath.value),
                                              builder: (context, snapshot) {
                                                print(snapshot.data.toString());
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(
                                                      height: 200,
                                                      width: Get.width,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: primaryColor,
                                                      )));
                                                }
                                                if (snapshot.hasError) {
                                                  print(snapshot.error
                                                      .toString());
                                                  print('error');
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return SizedBox(
                                                      height: 200,
                                                      width: Get.width,
                                                      child: Image.file(
                                                        File(snapshot.data
                                                            .toString()),
                                                        height: 200,
                                                        width: Get.width,
                                                        fit: BoxFit.cover,
                                                      ));
                                                } else {
                                                  return SizedBox(
                                                      height: 200,
                                                      width: Get.width,
                                                      child: const Center(
                                                          child: SizedBox()));
                                                }
                                              },
                                            );
                                          },
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        height: 390,
                                        clipBehavior: Clip.antiAlias,

                                        aspectRatio: 16 / 5,
                                        viewportFraction: 1.0,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: false,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        // enlargeCenterPage: true,
                                        // enlargeFactor: 0.3,
                                        onPageChanged: (index, reason) {
                                          /*  controller.*/ currentCarouselPage
                                              .value = index;
                                        },
                                        scrollDirection: Axis.horizontal,
                                      )),
                                ),
                                Positioned(
                                    left: 5,
                                    top: Get.width * 0.26,
                                    child: GestureDetector(
                                        onTap: () {
                                          carouselController.previousPage();
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_back_ios_new,
                                              size: 12,
                                            ),
                                          ),
                                        ))),
                                Positioned(
                                    right: 5,
                                    top: Get.width * 0.26,
                                    child: GestureDetector(
                                        onTap: () {
                                          carouselController.nextPage();
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 12,
                                            ),
                                          ),
                                        ))),
                                Positioned(
                                    left: 0.0,
                                    right: 0.0,
                                    // left: Get.width * 0.4,
                                    bottom: 4,
                                    child: Obx(
                                      () => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: searchModel!.listingImages
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => carouselController
                                                .jumpToPage(entry.key),
                                            child: Container(
                                                width: 10.0,
                                                height: 10.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0,
                                                        horizontal: 3.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: entry.key !=
                                                            /* controller
                                                                .*/
                                                            currentCarouselPage
                                                                .value
                                                        ? Colors.white
                                                            .withOpacity(0.40)
                                                        : Colors.white)),
                                          );
                                        }).toList(),
                                      ),
                                    )),
                               // View more photos button
                                    if (searchModel!.listingImages.length > 5) // Add condition to show button
                                Positioned(
                                  bottom: 10, // Adjust position as needed
                                  left: 0,
                                  right: 0,
                                  child: Visibility(
                                    visible: currentCarouselPage.value > 4,
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Action when button is pressed
                                        },
                                        child: Text('View More Photos'),
                                      ),
                                    ),
                                  ),),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            width: Get.width,
                          )),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  searchModel!.propertyName.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: blackColor3B,
                    fontSize: 20,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "KSH ${searchModel!.cost.text.toString()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    fontSize: 20,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(
                  height: 8,
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
                        searchModel!.street.text +
                            ", " +
                            searchModel!.town.text +
                            ", " +
                            searchModel!.countryName.value,
                        maxLines: 2,
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
                  height: 8,
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
                        text:
                            'Bedrooms : ${searchModel!.selectedBedroom.last} ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: blackColor,
                          fontFamily: 'Avenir',
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '(${searchModel!.selectedBedroom.last} Available)',
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
                ),
                const SizedBox(
                  height: 12,
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                          // width: Get.width,
                          text: /*searchModelUI.buttonText*/ 'Call',
                          isPrefixIcon: true,
                          suffixTextIconWidth: 2,
                          fontSize: 12,
                          buttonIconWidth: 8,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Image.asset(
                              'assets/icons/call_2.png',
                              height: 16,
                              width: 14,
                              color: whiteColor,
                            ),
                          ),
                          onPressed: () {
                            print('55555555555');
                            print(searchModel!.phoneNo.text);

                            makePhoneCall(searchModel!.phoneNo.text);
                          }),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      CustomButton(
                          // width: Get.width,
                          text: /*searchModelUI.buttonText*/ 'Whatsapp',
                          isPrefixIcon: true,
                          buttonIconWidth: 8,
                          fontSize: 12,
                          backgroundColor: green,
                          suffixTextIconWidth: 2,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Image.asset(
                              'assets/icons/whatsapp (1).png',
                              height: 16,
                              width: 14,
                              color: whiteColor,
                            ),
                          ),
                          onPressed: () {
                            openWhatsAppChat(searchModel!.phoneNo.text);
                          }),
                    ],
                  ),
                )

                //               CustomButton(
                //                   width: Get.width,
                //                   text: /*searchModelUI.buttonText*/ 'See details',
                //                   isSuffixIcon: true,
                //                   suffixTextIconWidth: 2,
                //                   suffixIcon: Image.asset(
                //                     'assets/icons/arrow_right.png',
                //                     height: 20,
                //                     width: 20,
                //                     color: whiteColor,
                //                   ),
                //                   onPressed: () {
                //                     controller.addViewProperty(propertyID: listingId);
                // ////
                //                     if (searchModel!.listingRole.value == 'Rent') {
                //                       Get.to(() => ApartmentDetails(
                //                             comingFromMyAdd: false,
                //                             listingId: listingId,
                //                           ));
                //                     } else {
                //                       Get.to(() => ApartmentDetails(
                //                             listingId: listingId,
                //                             isForSale: true,
                //                             comingFromMyAdd: false,
                //                           ));
                //                     }
                //                     // homeController.propertyType.value == 0
                //                     //     ? Get.to(() => ApartmentDetails())
                //                     //     : Get.to(() => ApartmentDetails(isForSale: true));
                //                   })
              ],
            ),
          ),

          ///verified
          // Positioned(
          //   top: 24,
          //   left: 24,
          //   child: searchModelUI.verified == true
          //       ? Container(
          //           decoration: BoxDecoration(
          //               color: skyColor, borderRadius: BorderRadius.circular(26)),
          //           padding: const EdgeInsets.only(
          //               left: 8, right: 12, top: 4, bottom: 4),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image.asset(
          //                 'assets/icons/verified_icon.png',
          //                 height: 16,
          //                 width: 16,
          //               ),
          //               const Text(
          //                 'Verified',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.w600,
          //                   color: blueLightColor,
          //                   fontSize: 12,
          //                   fontFamily: 'Avenir',
          //                 ),
          //               ),
          //             ],
          //           ),
          //         )
          //       : SizedBox.shrink(),
          // ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('favourites')
                .doc(listingId)
                .snapshots(),
            builder: (context, snapshot) {
              print("$listingId +'/////'");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              FavouriteModel? model;

              if (!snapshot.data!.exists) {
                print('data doesnts');

                model = FavouriteModel.initialize();
              }
              if (snapshot.data!.exists) {
                print('data exists');
                model = FavouriteModel.fromDocumentSnapshot(
                    snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
              }

              return Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    if (!snapshot.data!.exists) {
                      FirebaseFirestore.instance
                          .collection('favourites')
                          .doc(listingId)
                          .set({
                        'likes': [auth.currentUser!.uid]
                      }).then((value) {
                        print('done like');
                      }).onError((error, stackTrace) {
                        print(error.toString());
                      });
                    } else {
                      if (model!.likes.contains(auth.currentUser!.uid)) {
                        model.likes.remove(auth.currentUser!.uid);
                        // listOfLikes.remove(index);
                      } else {
                        model.likes.add(auth.currentUser!.uid);

                        // listOfLikes.add(index);
                      }

                      FirebaseFirestore.instance
                          .collection('favourites')
                          .doc(listingId)
                          .update({'likes': model.likes});
                    }
                    // searchModelUI.isFavourite.value = !searchModelUI.isFavourite.value;
                  },
                  child: Obx(
                    () => CircleAvatar(
                      radius: 19,
                      backgroundColor: const Color(0xFFF2F2F2),
                      child: Image.asset(
                        model!.likes.contains(auth.currentUser!.uid)
                            ? 'assets/icons/favourite_fill.png'
                            : 'assets/icons/favourite_unfill.png',
                        height: 17,
                        width: 19,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

//
// class _VideoPlay extends StatefulWidget {
//   final String path;
//
//   const _VideoPlay({
//     required this.path,
//   });
//
//   @override
//   State<_VideoPlay> createState() => _VideoPlayState();
// }
//
// class _VideoPlayState extends State<_VideoPlay> {
//   late VideoPlayerController videoController;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     videoController = VideoPlayerController.network(widget.path)
//       ..initialize().then((value) {
//         setState(() {
//           isLoading = false;
//         });
//         // videoController.setLooping(true);
//         videoController.play();
//       });
//     // videoController.initialize().then((_) {
//     //   videoController.setLooping(true);
//     // });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     videoController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (videoController.value.isPlaying) {
//           videoController.pause();
//         } else {
//           // If the video is paused, play it.
//           videoController.play();
//         }
//       },
//       child: Container(
//         height: 200,
//         width: Get.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: videoController != null && !isLoading
//               ? AspectRatio(
//                   aspectRatio: 16 / 5,
//                   child: VideoPlayer(videoController!),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(
//                   color: primaryColor,
//                 )),
//           // child: AspectRatio(
//           //   aspectRatio: 16 / 5,
//           //   child: VideoPlayer(
//           //     videoController,
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }
