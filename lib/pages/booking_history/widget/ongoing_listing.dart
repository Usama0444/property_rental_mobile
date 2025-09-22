import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';

import '../../../universal_models/add_listing_model.dart';
import '../../../utils/custom_dialog.dart';

class OngoingListing extends StatelessWidget {
  const OngoingListing({super.key, required this.bookingModel});
  final BookingModel bookingModel;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
  future: FirebaseFirestore.instance
      .collection('listings')
      .doc(bookingModel.propertyID)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox();
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      print('error');
    }
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return Padding(
        padding: EdgeInsets.only(top: Get.height / 3.5),
        child: const Center(
          child: SizedBox(
            child: Text(
              'No ongoing bookings yet.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
                fontSize: 14,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        ),
      );
    }

    AddListingModel listingsModel = AddListingModel.fromDocumentSnapshot(
        snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
    final payedAmount = int.parse(listingsModel.cost.text) -
        int.parse(bookingModel.pendingPayment);
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: greyBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 5, right: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
                child: Column(
                  children: [
                    Text(
                      listingsModel.propertyName.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontSize: 20,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 8),
                    bookingModel.pendingPayment == '0'
                        ? Text(
                            'KSH ${bookingModel.totalPayment}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontSize: 24,
                              fontFamily: 'Avenir',
                            ),
                          )
                        : Text(
                            'KSH ${payedAmount}',
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
                              backgroundImage:
                                  AssetImage('assets/images/dummy_profile.png'),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              bookingModel.buyerName.text,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: blackColor3B,
                                fontSize: 16,
                                fontFamily: 'Avenir',
                              ),
                            )
                          ],
                        ),
                        bookingModel.buyerPhoneNo.text != ''
                            ? Row(
                                children: [
                                  Image.asset(
                                    'assets/images/mobile.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    bookingModel.buyerPhoneNo.text,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: blackColor3B,
                                      fontSize: 12,
                                      fontFamily: 'Avenir',
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                  customDialog(
                      bookingModel: bookingModel, listingModel: listingsModel,docId: '');
                },
                child: Container(
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
                      bookingModel.orderStatus == 'Pending' &&
                              bookingModel.bookingType == 'Tour' &&
                              bookingModel.pendingPayment != '0'
                          ? Text(
                              '${bookingModel.orderStatus} payment is ${bookingModel.pendingPayment}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: blackColor3B,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        bookingModel.orderDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: blackColor3B,
                          fontSize: 12,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
