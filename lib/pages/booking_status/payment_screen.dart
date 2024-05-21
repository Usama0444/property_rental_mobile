import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/booking_status/booking_status.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

import '../../common_widgets/custom_text_field.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen(
      {super.key,
      required this.listingModel,
      required this.totalAmount,
      required this.listingID});
  final controller = Get.put(BookingsController());
  final AddListingModel listingModel;
  final String totalAmount;
  final String listingID;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

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
              child:StreamBuilder(

                stream: FirebaseFirestore.instance.collection('listings').doc(listingID).snapshots(),builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                }
                if (!snapshot.data!.exists) {
                  return const Text('Data does\'nt exist');
                }
                AddListingModel listingModel =
                AddListingModel.fromDocumentSnapshot(
                    snapshot.data as DocumentSnapshot<
                        Map<String, dynamic>>);
                return  Column(
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
                              // Text(
                              //   "Total",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 14,
                              //     color: textColor8080,
                              //     fontFamily: 'Avenir',
                              //   ),
                              // ),    SizedBox(height: 24),
                              Text(
                                "Indicate Payment Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              SizedBox(height: 24),Text(
                                "Rent Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),    SizedBox(height: 24),
                              Text(
                                "Total",
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
                                "Ksh ${listingModel.extraPay.text}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              const SizedBox(height: 24),

                              Text(
                                "Ksh ${listingModel.payment.text}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),     const SizedBox(height: 24),

                              Text(
                                "Ksh ${totalAmount.toString()}",
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
                    Form(
                      key: key,
                      child: Padding(
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
                              controller: controller.bookingMdl.mPesa,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your mpesa no.";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 66),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                          text: 'Next',
                          height: 44,
                          width: Get.width,
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              controller.bookingMdl.totalPayment = totalAmount;
                              controller.rentBooking(listingModel,
                                  listingModel.sellerID, listingID, totalAmount);
                              // Get.to(() =>  BookingStatus(listingModel:listingModel));
                              // Get.find<BottomNavController>().tabIndex.value = 0;
                            }
                          }),
                    ),
                  ],
                );
              },)
            ),
          )
        ],
      ),
    );
  }
}
