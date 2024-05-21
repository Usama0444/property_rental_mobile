import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/select_facilities/select_facilities.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:video_player/video_player.dart';

import '../../../common_widgets/loading_dialog.dart';
import '../../../common_widgets/video_widget.dart';
import 'controller/uplaod_property_image_controller.dart';

class UploadPropertyImages extends StatelessWidget {
  UploadPropertyImages({super.key, this.listingId, this.listingModel});
  final String? listingId;
  final AddListingModel? listingModel;

  final controller = Get.put(UploadPropertyImagesController());
  final RxBool data = true.obs;
  @override
  Widget build(BuildContext context) {
    // print(listingModel!.listingImages.length);
    // print(listingModel!.listingImages[0]);
    // print(listingModel!.listingImageMemories.length);
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
                textColor: blackColor3B,
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
                  const Text(
                    'Upload Images for your property',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 20,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: DottedBorder(
                      dashPattern: [4, 4],
                      strokeWidth: 0.5,
                      color: primaryColor,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(5),
                      strokeCap: StrokeCap.round,
                      padding: const EdgeInsets.all(5),
                      borderPadding: const EdgeInsets.all(4),
                      child: CustomButton(
                        backgroundColor: const Color(0xFFEFE6E6),
                        width: Get.width,
                        textColor: blackColor3B,
                        text: 'Upload photos form Gallery',
                        isPrefixIcon: true,
                        fontWeight: FontWeight.w500,
                        isBorder: false,
                        prefixIcon: Image.asset('assets/icons/gallery.png'),
                        onPressed: () async {
                          List<Uint8List>? selectedImages =
                              await getMultipleImage();
                          if (selectedImages != null &&
                              selectedImages.isNotEmpty) {
                            for (var image in selectedImages) {
                              listingModel!.listingImageMemories.add(image.obs);
                              print(
                                  '${listingModel!.listingImageMemories.length}++++++++++++++++++ gallery');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: DottedBorder(
                      dashPattern: [4, 4],
                      strokeWidth: 0.5,
                      color: primaryColor,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(5),
                      strokeCap: StrokeCap.round,
                      padding: const EdgeInsets.all(5),
                      borderPadding: const EdgeInsets.all(4),
                      child: CustomButton(
                        backgroundColor: const Color(0xFFEFE6E6),
                        width: Get.width,
                        textColor: blackColor3B,
                        fontWeight: FontWeight.w500,
                        isBorder: false,
                        text: 'Upload video from Gallery',
                        isPrefixIcon: true,
                        prefixIcon: Image.asset('assets/icons/video.png'),
                        onPressed: () async {
                          Uint8List? selectedImages =
                              await getVideo(ImageSource.gallery);
                          if (selectedImages != null &&
                              selectedImages.isNotEmpty) {
                            // for (var image in selectedImages) {
                            listingModel!.listingImageMemories
                                .add(selectedImages.obs);
                            /*           print(
                                  '${listingModel!.listingImageMemories.length}++++++++++++++++++ gallery');*/
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: DottedBorder(
                      dashPattern: [4, 4],
                      strokeWidth: 0.5,
                      color: primaryColor,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(5),
                      strokeCap: StrokeCap.round,
                      padding: const EdgeInsets.all(5),
                      borderPadding: const EdgeInsets.all(4),
                      child: CustomButton(
                          backgroundColor: const Color(0xFFEFE6E6),
                          width: Get.width,
                          fontWeight: FontWeight.w500,
                          textColor: blackColor3B,
                          text: 'Take photos from camera',
                          isPrefixIcon: true,
                          isBorder: false,
                          prefixIcon: Image.asset('assets/icons/camera.png'),
                          onPressed: () async {
                            Uint8List? selectedImages =
                                await getImage(ImageSource.camera);
                            if (selectedImages != null &&
                                selectedImages.isNotEmpty) {
                              // for (var image in selectedImages) {
                              listingModel!.listingImageMemories
                                  .add(selectedImages.obs);

                              debugPrint(
                                  '${listingModel!.listingImageMemories.value.length} length pf list=========');
                            }
                          }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                      () => /*listingModel!.listingImageMemories.value.isNotEmpty
                        ?*/
                          listingModel!.listingImages.isNotEmpty ||
                                  listingModel!
                                      .listingImageMemories.value.isNotEmpty
                              ? Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF4F4F4),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 10)
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /* listingModel!.listingImages.isNotEmpty
                                    ? */
                                      Obx(() {
                                        // data.value=true;
                                        return data.value
                                            ? Wrap(
                                                children: List.generate(
                                                    listingModel!.listingImages
                                                        .length, (index) {
                                                  print('my data');
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, bottom: 8),
                                                    child: SizedBox(
                                                        width: Get.width * 0.37,
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: /*listingModel!
                                                                    .listingImages[
                                                                        index]
                                                                    .value
                                                                    .contains(
                                                                        'https://firebasestorage.googleapis.com/')
                                                                ?*/
                                                                  Image.network(
                                                                listingModel!
                                                                    .listingImages[
                                                                        index]
                                                                    .value,
                                                                height: 115,
                                                                width:
                                                                    Get.width,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  ///for video url
                                                                  return PlayVideo(
                                                                    path: listingModel!
                                                                        .listingImages[
                                                                            index]
                                                                        .value,
                                                                    // videoBytes:
                                                                  );
                                                                },
                                                              )
                                                              /* : Image.memory(
                                                                    listingModel!
                                                                        .listingImageMemories[
                                                                            index]
                                                                        .value,
                                                                    height: 115,
                                                                    width: Get
                                                                        .width,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return _VideoPlay(
                                                                        videoBytes: listingModel!
                                                                            .listingImageMemories[index]
                                                                            .value,
                                                                      );
                                                                    },
                                                                  )*/
                                                              ,
                                                            ),
                                                            Positioned(
                                                              right: 8,
                                                              top: 8,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  data.value =
                                                                      true;
                                                                  listingModel!
                                                                      .listingImages
                                                                      .removeAt(
                                                                          index);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          whiteColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2)),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/delete_3.png',
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  );
                                                }),
                                              )
                                            : SizedBox();
                                      }),
                                      // : SizedBox(),
                                      listingModel!
                                              .listingImageMemories.isNotEmpty
                                          ? Wrap(
                                              children: List.generate(
                                                  listingModel!
                                                      .listingImageMemories
                                                      .value
                                                      .length,
                                                  (index) => Obx(() => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 5.0,
                                                                bottom: 8),
                                                        child: SizedBox(
                                                            width: Get.width *
                                                                0.37,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .memory(
                                                                    listingModel!
                                                                        .listingImageMemories[
                                                                            index]
                                                                        .value,
                                                                    height: 115,
                                                                    width: Get
                                                                        .width,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      print(listingModel!
                                                                          .listingImageMemories
                                                                          .length);
                                                                      print(listingModel!
                                                                          .listingImageMemories[
                                                                              index]
                                                                          .value);
                                                                      print(
                                                                          'inside else');
                                                                      return _VideoPlay(
                                                                        videoBytes: listingModel!
                                                                            .listingImageMemories[index]
                                                                            .value,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 8,
                                                                  top: 8,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      listingModel!
                                                                          .listingImageMemories
                                                                          .removeAt(
                                                                              index);
                                                                      // listingModel!
                                                                      //     .listingImages
                                                                      //     .removeAt(
                                                                      //         index);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          24,
                                                                      width: 24,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              whiteColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(2)),
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              4),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/icons/delete_3.png',
                                                                        height:
                                                                            16,
                                                                        width:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ))),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                )
                              : SizedBox()
                      // : SizedBox(),
                      ),

                  // Obx(
                  //   () => listingModel!.listingImageMemories.isNotEmpty
                  //       ? Container(
                  //           width: Get.width,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(12),
                  //             color: const Color(0xFFF4F4F4),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                   color: Colors.black.withOpacity(0.1),
                  //                   spreadRadius: 1,
                  //                   blurRadius: 10)
                  //             ],
                  //           ),
                  //           padding: const EdgeInsets.all(16),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Center(
                  //                 child: Wrap(
                  //                   alignment: WrapAlignment.center,
                  //                   children: listingModel!.listingImageMemories
                  //                       .map((imageMemory) {
                  //                     return Obx(() => Padding(
                  //                       padding: const EdgeInsets.only(
                  //                           left: 5, right: 5.0, bottom: 8),
                  //                       child: SizedBox(
                  //                         width: Get.width * 0.37,
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                           BorderRadius.circular(10),
                  //                           child: Image.memory(
                  //                             imageMemory.value,
                  //                             height: 115,
                  //                             width: Get.width,
                  //                             fit: BoxFit.cover,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ));
                  //                   }).toList(),
                  //                 ),
                  //
                  //                 // Wrap(
                  //                 //     alignment: WrapAlignment.center,
                  //                 //     children: List.generate(
                  //                 //     listingModel!.listingImageMemories.length,
                  //                 //       (index) => Padding(
                  //                 //         padding: const EdgeInsets.only(left: 5,
                  //                 //             right: 5.0, bottom: 8),
                  //                 //         child: Container(
                  //                 //           width: Get.width * 0.37,
                  //                 //           child: Stack(
                  //                 //             children: [
                  //                 //               Obx(() {
                  //                 //                 return ClipRRect(
                  //                 //                   borderRadius:
                  //                 //                       BorderRadius.circular(10),
                  //                 //                   child:
                  //                 //
                  //                 //                       // controller.imagePath1.value != ''
                  //                 //                       //     ? controller.imagePath1.value
                  //                 //                       //             .contains(".mp4")
                  //                 //                       //         ? _VideoPlay(
                  //                 //                       //             path: controller
                  //                 //                       //                 .imagePath1.value)
                  //                 //                       //         : Image.file(
                  //                 //                       //             File(
                  //                 //                       //               controller
                  //                 //                       //                   .imagePath1
                  //                 //                       //                   .value
                  //                 //                       //                   .toString(),
                  //                 //                       //             ),
                  //                 //                       //             height: 115,
                  //                 //                       //             width: Get.width,
                  //                 //                       //             fit: BoxFit.cover,
                  //                 //                       //           )
                  //                 //
                  //                 //                     listingModel!.listingImageMemories.isNotEmpty?
                  //                 //                         Image.memory(listingModel!.listingImageMemories)
                  //                 //                           : Image.asset(
                  //                 //                               'assets/images/apartment_3.png',
                  //                 //                               height: 115,
                  //                 //                               width: Get.width,
                  //                 //                               fit: BoxFit.cover,
                  //                 //                             ),
                  //                 //                 );
                  //                 //               }),
                  //                 //               Positioned(
                  //                 //                 right: 8,
                  //                 //                 top: 8,
                  //                 //                 child: GestureDetector(
                  //                 //                   onTap: () {
                  //                 //                     controller.imagePath1.value = '';
                  //                 //                   },
                  //                 //                   child: Container(
                  //                 //                     height: 24,
                  //                 //                     width: 24,
                  //                 //                     decoration: BoxDecoration(
                  //                 //                         color: whiteColor,
                  //                 //                         borderRadius:
                  //                 //                             BorderRadius.circular(2)),
                  //                 //                     padding: const EdgeInsets.all(4),
                  //                 //                     child: Image.asset(
                  //                 //                       'assets/icons/delete_3.png',
                  //                 //                       height: 16,
                  //                 //                       width: 16,
                  //                 //                     ),
                  //                 //                   ),
                  //                 //                 ),
                  //                 //               )
                  //                 //             ],
                  //                 //           ),
                  //                 //         ),
                  //                 //       ),
                  //                 //     )
                  //                 //     //     const SizedBox(width: 16),
                  //                 //     //     Expanded(
                  //                 //     //       child: Stack(
                  //                 //     //         children: [
                  //                 //     //           Obx(
                  //                 //     //             () => ClipRRect(
                  //                 //     //               borderRadius: BorderRadius.circular(10),
                  //                 //     //               child: controller.imagePath2.value != ''
                  //                 //     //                   ? controller.imagePath2.value
                  //                 //     //                           .contains(".mp4")
                  //                 //     //                       ? _VideoPlay(
                  //                 //     //                           path: controller
                  //                 //     //                               .imagePath2.value)
                  //                 //     //                       : Image.file(
                  //                 //     //                           File(
                  //                 //     //                             controller.imagePath2.value
                  //                 //     //                                 .toString(),
                  //                 //     //                           ),
                  //                 //     //                           height: 115,
                  //                 //     //                           width: Get.width,
                  //                 //     //                           fit: BoxFit.cover,
                  //                 //     //                         )
                  //                 //     //                   : Image.asset(
                  //                 //     //                       'assets/images/apartment_3.png',
                  //                 //     //                       height: 115,
                  //                 //     //                       width: Get.width,
                  //                 //     //                       fit: BoxFit.cover,
                  //                 //     //                     ),
                  //                 //     //             ),
                  //                 //     //           ),
                  //                 //     //           Positioned(
                  //                 //     //             right: 8,
                  //                 //     //             top: 8,
                  //                 //     //             child: GestureDetector(
                  //                 //     //               onTap: () {
                  //                 //     //                 controller.imagePath2.value = '';
                  //                 //     //               },
                  //                 //     //               child: Container(
                  //                 //     //                 height: 24,
                  //                 //     //                 width: 24,
                  //                 //     //                 decoration: BoxDecoration(
                  //                 //     //                     color: whiteColor,
                  //                 //     //                     borderRadius:
                  //                 //     //                         BorderRadius.circular(2)),
                  //                 //     //                 padding: const EdgeInsets.all(4),
                  //                 //     //                 child: Image.asset(
                  //                 //     //                   'assets/icons/delete_3.png',
                  //                 //     //                   height: 16,
                  //                 //     //                   width: 16,
                  //                 //     //                 ),
                  //                 //     //               ),
                  //                 //     //             ),
                  //                 //     //           )
                  //                 //     //         ],
                  //                 //     //       ),
                  //                 //     //     ),
                  //                 //     //   ],
                  //                 //     // ),
                  //                 //     // const SizedBox(height: 16),
                  //                 //     // Row(
                  //                 //     //   children: [
                  //                 //     //     Expanded(
                  //                 //     //       child: Stack(
                  //                 //     //         children: [
                  //                 //     //           Obx(
                  //                 //     //             () => ClipRRect(
                  //                 //     //               borderRadius: BorderRadius.circular(10),
                  //                 //     //               child: controller.imagePath3.value != ''
                  //                 //     //                   ? controller.imagePath3.value
                  //                 //     //                           .contains(".mp4")
                  //                 //     //                       ? _VideoPlay(
                  //                 //     //                           path: controller
                  //                 //     //                               .imagePath3.value)
                  //                 //     //                       : Image.file(
                  //                 //     //                           File(
                  //                 //     //                             controller.imagePath3.value
                  //                 //     //                                 .toString(),
                  //                 //     //                           ),
                  //                 //     //                           height: 115,
                  //                 //     //                           width: Get.width,
                  //                 //     //                           fit: BoxFit.cover,
                  //                 //     //                         )
                  //                 //     //                   : Image.asset(
                  //                 //     //                       'assets/images/apartment_3.png',
                  //                 //     //                       height: 115,
                  //                 //     //                       width: Get.width,
                  //                 //     //                       fit: BoxFit.cover,
                  //                 //     //                     ),
                  //                 //     //             ),
                  //                 //     //           ),
                  //                 //     //           Positioned(
                  //                 //     //             right: 8,
                  //                 //     //             top: 8,
                  //                 //     //             child: GestureDetector(
                  //                 //     //               onTap: () {
                  //                 //     //                 controller.imagePath3.value = '';
                  //                 //     //               },
                  //                 //     //               child: Container(
                  //                 //     //                 height: 24,
                  //                 //     //                 width: 24,
                  //                 //     //                 decoration: BoxDecoration(
                  //                 //     //                     color: whiteColor,
                  //                 //     //                     borderRadius:
                  //                 //     //                         BorderRadius.circular(2)),
                  //                 //     //                 padding: const EdgeInsets.all(4),
                  //                 //     //                 child: Image.asset(
                  //                 //     //                   'assets/icons/delete_3.png',
                  //                 //     //                   height: 16,
                  //                 //     //                   width: 16,
                  //                 //     //                 ),
                  //                 //     //               ),
                  //                 //     //             ),
                  //                 //     //           )
                  //                 //     //         ],
                  //                 //     //       ),
                  //                 //     //     ),
                  //                 //     //     const SizedBox(width: 16),
                  //                 //     //     Expanded(
                  //                 //     //       child: Stack(
                  //                 //     //         children: [
                  //                 //     //           Obx(
                  //                 //     //             () => ClipRRect(
                  //                 //     //               borderRadius: BorderRadius.circular(10),
                  //                 //     //               child: controller.imagePath4.value != ''
                  //                 //     //                   ? controller.imagePath4.value
                  //                 //     //                           .contains(".mp4")
                  //                 //     //                       ? _VideoPlay(
                  //                 //     //                           path: controller
                  //                 //     //                               .imagePath4.value)
                  //                 //     //                       : Image.file(
                  //                 //     //                           File(
                  //                 //     //                             controller.imagePath4.value
                  //                 //     //                                 .toString(),
                  //                 //     //                           ),
                  //                 //     //                           height: 115,
                  //                 //     //                           width: Get.width,
                  //                 //     //                           fit: BoxFit.cover,
                  //                 //     //                         )
                  //                 //     //                   : Image.asset(
                  //                 //     //                       'assets/images/apartment_3.png',
                  //                 //     //                       height: 115,
                  //                 //     //                       width: Get.width,
                  //                 //     //                       fit: BoxFit.cover,
                  //                 //     //                     ),
                  //                 //     //             ),
                  //                 //     //           ),
                  //                 //     //           Positioned(
                  //                 //     //             right: 8,
                  //                 //     //             top: 8,
                  //                 //     //             child: GestureDetector(
                  //                 //     //               onTap: () {
                  //                 //     //                 controller.imagePath4.value = '';
                  //                 //     //               },
                  //                 //     //               child: Container(
                  //                 //     //                 height: 24,
                  //                 //     //                 width: 24,
                  //                 //     //                 decoration: BoxDecoration(
                  //                 //     //                     color: whiteColor,
                  //                 //     //                     borderRadius:
                  //                 //     //                         BorderRadius.circular(2)),
                  //                 //     //                 padding: const EdgeInsets.all(4),
                  //                 //     //                 child: Image.asset(
                  //                 //     //                   'assets/icons/delete_3.png',
                  //                 //     //                   height: 16,
                  //                 //     //                   width: 16,
                  //                 //     //                 ),
                  //                 //     //               ),
                  //                 //     //             ),
                  //                 //     //           )
                  //                 //     //         ],
                  //                 //     //       ),
                  //                 //     //     ),
                  //                 //
                  //                 //     ),
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //       : SizedBox(),
                  // ),
                  const SizedBox(height: 34),
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
              text: 'Next',
              height: 44,
              width: Get.width,
              onPressed: () {
                if (listingModel!.listingImages.isEmpty &&
                    listingModel!.listingImageMemories.isEmpty) {
                  loadingDialog(
                      message: 'Please select atleast one image.',
                      button: true);
                } else {
                  Get.to(() => SelectFacilities(
                      listingId: listingId, listingModel: listingModel));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

/// video player widget for Uint8List video
class _VideoPlay extends StatefulWidget {
  final Uint8List videoBytes;

  const _VideoPlay({
    required this.videoBytes,
  });

  @override
  State<_VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<_VideoPlay> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final file = File('${Directory.systemTemp.path}/video_temp.mp4');
    await file.writeAsBytes(widget.videoBytes);
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    setState(() {}); // rebuild widget once video is initialized
    _videoController!.play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_videoController != null) {
          if (_videoController!.value.isPlaying) {
            _videoController!.pause();
          } else {
            _videoController!.play();
          }
        }
      },
      child: Container(
        height: 115,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: _videoController != null
                ? _videoController!.value.aspectRatio
                : 16 / 9,
            child: _videoController != null
                ? VideoPlayer(_videoController!)
                : Container(),
          ),
        ),
      ),
    );
  }
}

/// video player widget
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
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     videoController = VideoPlayerController.file((File(widget.path)))
//       ..initialize().then((value) {
//         videoController.setLooping(true);
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
//         height: 115,
//         width: Get.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: VideoPlayer(videoController),
//           ),
//         ),
//       ),
//     );
//   }
// }
