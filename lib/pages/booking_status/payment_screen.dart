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
        required this.extraAmount,
        required this.days,
        required this.rentAmount,
        required this.listingID});
  final controller = Get.put(BookingsController());
  final AddListingModel listingModel;
  final String totalAmount;
  final String extraAmount;
  final String rentAmount;
  final String listingID;
  final int days;

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
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('listings')
                      .doc(listingID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                    }
                    if (!snapshot.data!.exists) {
                      return const Text('Data does\'nt exist');
                    }
                    AddListingModel listingModel =
                    AddListingModel.fromDocumentSnapshot(snapshot.data
                    as DocumentSnapshot<Map<String, dynamic>>);
                    return Padding(
                      padding: const EdgeInsets.only(left: 28, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 34),
                          PaymentRow(
                            text: 'Mpesa',
                            title: 'Payment Method',
                          ),
                          Divider(thickness: 0.2),
                          const SizedBox(height: 12),

                          PaymentRow(
                            text: 'Ksh ${rentAmount.toString()}',
                            title: 'Rent Amount',
                          ),
                            Divider(thickness: 0.2),
                          const SizedBox(height: 12),
                          PaymentRow(
                            text: '2000',
                            title: "Sale/Rent Comission",
                          ),
                          Divider(thickness: 0.2),
                          const SizedBox(height: 12),
                          Text(
                            'Extra Payments',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              // color: textColor8080,
                              fontFamily: 'Avenir',
                            ),
                          ),

                          listingModel.indicatePayList.length != 0
                              ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: List.generate(
                                listingModel.indicatePayList.length,
                                    (index) => Container(
                                  color:
                                  // index.isEven ?
                                  whiteColor,
                                  // : const Color(0xFFF3F3F3),
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 12,
                                    vertical: 0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        listingModel.indicatePayList[index]
                                            .extraName.text,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textColor8080,
                                          fontSize: 14,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                      Text(
                                        '$days * ${listingModel.indicatePayList[index].extraCost.text}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textColor.withOpacity(0.7),
                                          fontSize: 14,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          PaymentRow(
                            text: 'Ksh ${extraAmount.toString()}',
                            title: '',
                          ),

                          Divider(thickness: 0.2),
                          const SizedBox(height: 12),
                          PaymentRow(
                            text: 'Ksh ${totalAmount.toString()}',
                            title: "Total",
                          ),
                          Divider(thickness: 0.2),
                          const SizedBox(height: 18),


                          Form(
                            key: key,
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
                          const SizedBox(height: 66),
                          CustomButton(
                              text: 'Next',
                              height: 44,
                              width: Get.width,
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  controller.bookingMdl.totalPayment = totalAmount;
                                  controller.rentBooking(
                                      listingModel,
                                      listingModel.sellerID,
                                      listingID,
                                      totalAmount);
                                  // Get.to(() =>  BookingStatus(listingModel:listingModel));
                                  // Get.find<BottomNavController>().tabIndex.value = 0;
                                }
                              }),
                        ],
                      ),
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}

class PaymentRow extends StatelessWidget {
  const PaymentRow({super.key, required this.title, required this.text});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            // color: textColor8080,
            fontFamily: 'Avenir',
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor8080,
            fontFamily: 'Avenir',
          ),
        ),
      ],
    );
  }
}