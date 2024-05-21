import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/apartment_details.dart';
import 'package:video_player/video_player.dart';

import '../../../common_widgets/global_functions.dart';
import '../../../universal_models/add_listing_model.dart';

class ViewedActivity extends StatelessWidget {
  ViewedActivity({super.key,  this.listingId, required this.listingModel, });
  final AddListingModel listingModel;
 final String? listingId;

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
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: listingModel!.listingImages.length != 0
                  ? Image.network(
                listingModel!.listingImages.first.value,
                height: 200,
                width: Get.width,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return FutureBuilder(
                    future: videoThumbnail(
                        urlForThumbnail:
                        listingModel
                            .listingImages[0].value
                    ),
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
                        return  SizedBox(
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
          Text(
            listingModel.propertyName.text,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
              color: blackColor3B,
              fontSize: 16,
              fontFamily: 'Avenir',
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'KSH ${listingModel!.cost.text}',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              fontSize: 20,
              fontFamily: 'Avenir',
            ),
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
                  listingModel!.street.text +
                      ", " +
                      listingModel!.town.text +
                      ", " +
                      listingModel!.countryName.value,
                  // maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
                  text: 'Bedrooms : ${listingModel!.selectedBedroom.last} ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                    fontFamily: 'Avenir',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '(${listingModel!.selectedBedroom.last} Available)',
                      style: TextStyle(
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
          CustomButton(
              width: Get.width,
              text: 'See details',
              isSuffixIcon: true,
              suffixTextIconWidth: 2,
              suffixIcon: Image.asset(
                'assets/icons/arrow_right.png',
                height: 20,
                width: 20,
                color: whiteColor,
              ),
              onPressed: () {
                print('${listingId}  ============hysdfj');
                if (listingModel.listingRole == 'Rent') {
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
                //
              })
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
              : Center(child: CircularProgressIndicator(color: primaryColor,)),
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
