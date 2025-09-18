import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import 'package:property_rental_app/utils/custom_dialog.dart';

class BookingHistoryCompleted extends StatelessWidget {
  const BookingHistoryCompleted({
    super.key,
    required this.bookingModel,
  });
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
      // Optionally, return a widget to display the error to the user
      return const Center(child: Text('An error occurred. Please try again.'));
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
        return GestureDetector(
          onTap: () {
            customDialog(
                bookingModel: bookingModel, listingModel: listingsModel);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: greyBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              children: [
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
                      CustomButton(
                          text: 'Review It',
                          height: 38,
                          isBorder: true,
                          textColor: primaryColor,
                          borderColor: primaryColor,
                          backgroundColor: whiteColor,
                          width: 176,
                          onPressed: () {
                            customDialog(
                                bookingModel: bookingModel,
                                listingModel: listingsModel);
                          }),
                      const SizedBox(height: 16),
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
                      // const Text(
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontSize: 12,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
