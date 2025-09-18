import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import 'package:property_rental_app/universal_models/feedback_model.dart';

void customDialog(
    {bool showReview = false,
    required BookingModel bookingModel,
    required AddListingModel listingModel}) {
  showDialog(
    barrierDismissible: true,
    context: Get.context!,
    builder: (BuildContext context) {
      print(auth.currentUser!.uid);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          backgroundColor: whiteColor,
          alignment: AlignmentDirectional.center,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            'assets/images/cross_icon.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, right: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            bookingModel.bookingType,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ),
                      ),
                      Text(
                        listingModel.propertyName.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: blackColor3B,
                          fontSize: 20,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'KSH ${bookingModel.totalPayment}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontSize: 24,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 27,
                                backgroundImage: AssetImage(
                                    'assets/images/dummy_profile.png'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                bookingModel.sellerName.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                ),
                              )
                            ],
                          ),
                          bookingModel.sellerPhoneNo != ''?    Row(
                            children: [
                              Image.asset(
                                'assets/images/mobile.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                bookingModel.sellerPhoneNo,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: blackColor3B,
                                  fontSize: 12,
                                  fontFamily: 'Avenir',
                                ),
                              )
                            ],
                          ):SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      bookingModel.bookingType == 'Tour'
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Tour date',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: blackColor3B,
                                  fontSize: 12,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Check in date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: blackColor3B,
                                    fontSize: 12,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Check out date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: blackColor3B,
                                    fontSize: 12,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      bookingModel.bookingType == 'Tour'
                          ? Row(
                              children: [
                                Image.asset(
                                  'assets/images/calender.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          bookingModel.checkIn)),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: blackColor3B,
                                    fontSize: 12,
                                    fontFamily: 'Avenir',
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/calender.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              bookingModel.checkIn)),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: blackColor3B,
                                        fontSize: 12,
                                        fontFamily: 'Avenir',
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/calender.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              bookingModel.checkOut)),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: blackColor3B,
                                        fontSize: 12,
                                        fontFamily: 'Avenir',
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                             
       
                     // : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Align(
                              alignment: AlignmentGeometry.topLeft,
                               child: TextButton(
                                                           
                                onPressed: () {
                                 
                               },
                                 style: TextButton.styleFrom(
                                   minimumSize: const Size(200, 45), // Matches width: 200, height: 45
                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(8), // Adjust radius to match CustomButton
                                   ),
                                   textStyle: const TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.w600,
                                     fontFamily: 'Avenir', // Match your app's font
                                   ),
                                   
                                 ),
                                 child: const Text(
                                   'Mark as Completed',
                                   style: TextStyle(
                                     color: primaryColor, // Matches textColor: Colors.white
                                   ),
                                 ),
                                 ),
                             ),
                Container(
                  height: 37,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      // Text(
                      //   '#272',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //     color: blackColor3B,
                      //     fontSize: 12,
                      //     fontFamily: 'Avenir',
                      //   ),
                      // ),
                      Text(
                        bookingModel.orderDate,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontSize: 12,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
