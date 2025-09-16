import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/apartment_details/controller/apartment_details_controller.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/apartment_details/widget/feedback_widget.dart';
import 'package:property_rental_app/pages/booking_history/widget/pending_payment.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import 'package:property_rental_app/utils/custom_dialog.dart';

import '../../../common_widgets/loading_dialog.dart';

class BookingHistoryOngoing extends StatelessWidget {
  BookingHistoryOngoing({
    super.key,
    required this.bookingModel,
    required this.docID,
  });
  final BookingModel bookingModel;
  final String docID;
  final controller = Get.put(BookingsController());
  
void _checkAndCompleteBooking(BuildContext context) {
final endDate = DateTime.fromMillisecondsSinceEpoch(int.parse(bookingModel.checkOut.toString()));   
 final currentDate = DateTime.now();
    if (currentDate.isAfter(endDate.add(Duration(days: 1)))) {
      FirebaseFirestore.instance
          .collection('bookings')
          .doc(docID)
          .update({
            'orderStatus': 'Completed',
          }).then((_) {
           _showFeedbackDialog(context);
          });
    }
  }
  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = Get.put(ApartmentDetailsController());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: whiteColor,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Post a feedback for this property',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: blackColor3B,
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Enter your feedback',
                    maxLines: 5,
                    borderRadius: 8,
                    controller: feedbackController.feedbackModel.feedback,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter feedback.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Post',
                    height: 44,
                    width: Get.width,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        feedbackController.addFeedback(bookingModel.sellerID, bookingModel.propertyID);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: 'Cancel',
                    height: 44,
                    width: Get.width,
                    backgroundColor: greyBorderColor,
                    textColor: blackColor3B,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
 
 @override
  Widget build(BuildContext context) {
  _checkAndCompleteBooking(context);
    print(bookingModel.propertyID);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .doc(bookingModel.propertyID)
          // .where('propertyID', isEqualTo: bookingModel.propertyID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          print('error');
        }
        if (!snapshot.data!.exists) {
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
            ))),
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
                 if (bookingModel.pendingPayment != '0') ...[
                    // CustomButton(
                    //     text: 'Complete',
                    //     height: 38,
                    //     backgroundColor: primaryColor,
                    //     textColor: whiteColor,
                    //     width: Get.width * 0.4,
                    //     onPressed: () {
                    //       // FirebaseFirestore.instance
                    //       //     .collection('bookings')
                    //       //     .doc(docID)
                    //       //     .update({
                    //       //   'orderStatus': 'Completed',
                    //       // }).then((_) {
                    //       //   // _showFeedbackDialog(context);
                    //       // });
                    //     },
                    //   )
                    //     : 
                              CustomButton(
                                  text: 'Pay',
                                  height: 38,
                                  backgroundColor: primaryColor,
                                  textColor: whiteColor,
                                  width: Get.width * 0.4,
                                  onPressed: () {
                                    // await FirebaseFirestore.instance.collection('bookings').doc(docID).update({

                                    Get.to(() => PendingPaymentScreen(
                                        listingModel: listingsModel,
                                        bookingID: docID,
                                        bookingModel: bookingModel));
                                  }),
                             
                                      
                            
                          
                    const SizedBox(height: 16),
                  ],
            ])
              ),
              GestureDetector(
                onTap: () {
                  customDialog(
                      bookingModel: bookingModel, listingModel: listingsModel);
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
                          : SizedBox(),
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
