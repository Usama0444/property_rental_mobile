
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';


void customCompleteBookingDialog(
    {bool showReview = true,
    required BookingModel bookingModel,
    required AddListingModel listingModel,
    required String docId}) {
  
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
                              const SizedBox(height: 20),
                               Row(
                                 children: [
                                   feedbackWidget(listingModel),
                                 ],
                               ),
       
                     // : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                    ],
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
Widget feedbackWidget(AddListingModel listingModel) {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('feedbacks')
        .where('propertyID', isEqualTo: listingModel.docId)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
      }
      if (snapshot.hasError) {
        print(snapshot.error.toString());
        return const Text('Error');
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text(
          '0 Reviews',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: blackColor3B, // Ensure this color is defined
            fontSize: 12,
            fontFamily: 'Avenir',
          ),
        );
      }

      final reviews = snapshot.data!.docs;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${reviews.length} Reviews',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: blackColor3B, // Ensure this color is defined
              fontSize: 12,
              fontFamily: 'Avenir',
            ),
          ),
          const SizedBox(height: 5),
          // Display each review text
          ...reviews.map((doc) {
            final reviewData = doc.data() as Map<String, dynamic>;
            final reviewText = reviewData['feedback'] ?? 'No review text';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                reviewText,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Avenir',
                  color: Colors.black54,
                ),
              ),
            );
          }).toList(),
        ],
      );
    },
  );
}