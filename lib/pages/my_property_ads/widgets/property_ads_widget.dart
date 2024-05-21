import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

import '../../../common_widgets/global_functions.dart';
import '../../../universal_models/add_listing_model.dart';
import '../../add_listing/enter_property_details/enter_property_details.dart';

class PropertyAdsWidget extends StatelessWidget {
  PropertyAdsWidget({
    super.key,
    this.searchModel,
    this.listingId,
  });
  String? listingId;
  AddListingModel? searchModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ////////////////////////////////
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: searchModel!.listingImages.length != 0
                  ? Image.network(
                      searchModel!.listingImages.first.value,
                      height: 200,
                      width: Get.width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return FutureBuilder(
                          future: videoThumbnail(
                              urlForThumbnail:
                                  searchModel!.listingImages[0].value),
                          builder: (context, snapshot) {
                            print(snapshot.data.toString());
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height: 200,
                                  width: Get.width,
                                  child: const Center(
                                      child: CircularProgressIndicator(
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
                                  height: 200,
                                  width: Get.width,
                                  child: Image.file(
                                    File(snapshot.data.toString()),
                                    height: 200,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                  ));
                            } else {
                              return SizedBox(
                                  height: 200,
                                  width: Get.width,
                                  child: Center(child: SizedBox()));
                            }
                          },
                        );
                      },
                    )
                  : Container(
                      height: 200,
                      width: Get.width,
                    )),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                searchModel!.propertyName.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: blackColor3B,
                  fontSize: 16,
                  fontFamily: 'Avenir',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => EnterPropertyDetails(
                        listingId: listingId,
                      ));
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: primaryColor,
                    decorationThickness: 3,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    fontSize: 16,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'KSH ${searchModel!.cost.text}',
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ),
                  ],
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
                  text: 'Bedrooms : ${searchModel!.selectedBedroom.last}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                    fontFamily: 'Avenir',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' (${searchModel!.selectedBedroom.last} Available)',
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
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flexible(
              //   child: CustomButton(
              //     width: Get.width,
              //     text: 'Post your ad',
              //     suffixTextIconWidth: 2,
              //     onPressed: () {},
              //   ),
              // ),
              // const SizedBox(
              //   width: 12,
              // ),
              Flexible(
                child: CustomButton(
                  width: Get.width,
                  // backgroundColor: whiteColor,
                  // isBorder: true,
                  // textColor: primaryColor,
                  text: 'Delete Ad',
                  suffixTextIconWidth: 2,
                  onPressed: () {
                    loadingDialog(
                        button: true,
                        button1: true,
                        endBtnText: 'Yes',
                        message: 'Are you sure you want to delete the Ad?',
                        tap: () {
                          FirebaseFirestore.instance
                              .collection('listings')
                              .doc(listingId)
                              .delete()
                              .then((value) {
                            Get.back();
                          });
                        },
                        startWidget: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomButton(
                            text: "Cancel",
                            height: 40,
                            width: Get.width * 0.26,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _VideoPlay extends StatefulWidget {
  final String path;

  const _VideoPlay({
    required this.path,
  });

  @override
  State<_VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<_VideoPlay> {
  late VideoPlayerController videoController;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = VideoPlayerController.network(widget.path)
      ..initialize().then((value) {
        setState(() {
          isLoading = false;
        });
        // videoController.setLooping(true);
        videoController.play();
      });
    // videoController.initialize().then((_) {
    //   videoController.setLooping(true);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (videoController.value.isPlaying) {
          videoController.pause();
        } else {
          // If the video is paused, play it.
          videoController.play();
        }
      },
      child: Container(
        height: 200,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: videoController != null && !isLoading
              ? AspectRatio(
                  aspectRatio: 16 / 5,
                  child: VideoPlayer(videoController!),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                )),
          // child: AspectRatio(
          //   aspectRatio: 16 / 5,
          //   child: VideoPlayer(
          //     videoController,
          //   ),
          // ),
        ),
      ),
    );
  }
}
