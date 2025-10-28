import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/apartment_details.dart';
import 'package:property_rental_app/pages/home/model/home_model.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

import '../../../common_widgets/global_functions.dart';

class BedsittersWidget extends StatelessWidget {
  const BedsittersWidget({
    super.key,
    // required this.homeModel,
    required this.listingModel, required this.listingID,
  });
  final AddListingModel listingModel;
  final String listingID;
  // final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(ApartmentDetails(comingFromMyAdd: false,listingId: listingID,));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4, bottom: 8, left: 4, top: 8),
        padding: const EdgeInsets.only(left: 8, right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                color: textColor.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: const Offset(1, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: listingModel!.listingImages.length != 0
                        ? Image.network(
                            listingModel!.listingImages.first.value,
                            height: 80,
                            width: 126,
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
                                        height: 80,
                                        width: 126,
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
                                        height: 80,
                                        width: 126,
                                        child: Image.file(
                                          File(snapshot.data.toString()),
                                          height: 80,
                                          width: 126,
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
                          )
                        : Container(
                            height: 200,
                            width: Get.width,
                          )),
                // Verified badge
                if (listingModel.isVerified)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/verified_icon.png',
                            height: 10,
                            width: 10,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listingModel.propertyName.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    listingModel.listingRole == 'Rent'
                        ? 'KSH ${listingModel.payment.text}'
                        : 'KSH ${formatLargeNumber(listingModel.totalSaleCost.text)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/bedroom_2.png',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Bedrooms : ${listingModel.selectedBedroom.last} (${listingModel.selectedBedroom.last} Available)',
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
            )
          ],
        ),
      ),
    );
  }
}
