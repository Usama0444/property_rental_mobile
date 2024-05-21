import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/main_controller.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/booking_status/booking_status.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import 'package:property_rental_app/universal_models/user_model.dart';

import '../../../common_widgets/custom_text_field.dart';
import '../../../common_widgets/loading_dialog.dart';

class PendingPaymentScreen extends StatelessWidget {
  PendingPaymentScreen(
      {super.key,
      required this.listingModel,
      required this.bookingID,
      required this.bookingModel});
  final controller = Get.put(BookingsController());
  final AddListingModel listingModel;
  final BookingModel bookingModel;

  final String bookingID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Payment',
            isBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 34),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColor8080,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              "Pending Payment",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColor8080,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Mpesa",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColor8080,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Ksh ${bookingModel.pendingPayment}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColor8080,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Text(
                          'Kindly input your Mpesa number to pay for booking.',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: blackColor3B,
                            fontSize: 16,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: '+91 637 765 786',
                          fillColor: whiteColor,
                          borderRadius: 8,
                          hintColor: textColor66,
                          keyboardType: TextInputType.phone,
                          controller: bookingModel.mPesa,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your mpesa no.";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 66),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                        text: 'Next',
                        height: 44,
                        width: Get.width,
                        onPressed: () async {
                          loadingDialog(
                              message: 'Please wait !!', loading: true);

                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(bookingID)
                              .update({
                            'isPaymentDone': true,
                            'pendingPayment': '0'
                          }).then((value) async {
                            print('booking other payment done');
                            // DocumentSnapshot userdata = await FirebaseFirestore
                            //     .instance
                            //     .collection('users')
                            //     .doc(bookingModel.sellerID)
                            //     .get();


                            // UserModel uModel = UserModel.fromDocumentSnapshot(
                            //     userdata
                            //         as DocumentSnapshot<Map<String, dynamic>>);
                            //
                            //
                            // Get.put(MainController()).sendPushNotification(
                            //   token: uModel.token.toString(),
                            //   // image: userModel.userImage.toString(),
                            //   title: currentUserDataModel!.value.userName.text,
                            //   body:
                            //       'has payed the pending amount for tour to ${listingModel.propertyName.text}.',
                            // );
                            controller.sendNotificationOnBooking(listingModel.sellerID, bookingID, listingModel,bookingID);
                            //////////
                            Get.back();
                            Get.back();
                            print('done');
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                          // controller.bookingMdl.totalPayment = totalAmount;
                          // controller.rentBooking(listingModel,listingModel.sellerID,bookingID,totalAmount);
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
