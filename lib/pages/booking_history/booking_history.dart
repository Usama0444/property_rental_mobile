import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/widget/feedback_widget.dart';
import 'package:property_rental_app/pages/booking_history/controller/booking_history_controller.dart';
import 'package:property_rental_app/pages/booking_history/widget/booking_history_completed.dart';
import 'package:property_rental_app/pages/booking_history/widget/booking_history_ongoing.dart';
import 'package:property_rental_app/pages/booking_history/widget/ongoing_listing.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import '../../main.dart';
import 'widget/ongoing_completed.dart';

class BookingHistory extends StatelessWidget {
  BookingHistory({super.key});

  final controller = Get.put(BookingHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'Booking History',
            isBackButton: true,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 22.0),
                  child: Divider(
                    color: Color(0xFFDFDFDF),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.mySelection.value = 0;
                        },
                        child: Obx(
                          () => Column(
                            children: [
                              Text(
                                'My bookings',
                                style: TextStyle(
                                  color: controller.mySelection.value == 0
                                      ? primaryColor
                                      : blackColor3B,
                                  fontSize: 14,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 109,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: controller.mySelection.value == 0
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.mySelection.value = 1;
                        },
                        child: Obx(
                          () => Column(
                            children: [
                              Text(
                                'My listings',
                                style: TextStyle(
                                  color: controller.mySelection.value == 1
                                      ? primaryColor
                                      : blackColor3B,
                                  fontSize: 14,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 109,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: controller.mySelection.value == 1
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OngoingCompleted(),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() => controller.mySelection.value == 0 &&
                    controller.selectedButton.value == 0

                ///ongoing my bookings
                ? 
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('bookings')
      .where(Filter.and(
          Filter('buyerID', isEqualTo: auth.currentUser!.uid),
          Filter('orderStatus', isEqualTo: 'Pending')))
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
        width: Get.width,
        height: 246,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      print('error');
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      print('no data exit');
      return const Center(
        child: SizedBox(
          child: Text(
            'No ongoing bookings yet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        BookingModel bookingModel =
            BookingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
        if (bookingModel.pendingPayment == '0') {
          print('000000000000');
          print(snapshot.data!.docs[index].id.toString());
          // checkTimeExpire(
          //     bookingModel.checkOut.toString(),
          //     snapshot.data!.docs[index].id.toString(),
          //     bookingModel.orderStatus);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BookingHistoryOngoing(
            docID: snapshot.data!.docs[index].id,
            bookingModel: bookingModel,
          ),
        );
      },
    );
  },
)
                ///my completed bookings
                : controller.mySelection.value == 0 &&
                        controller.selectedButton.value == 1
                    ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('bookings')
      .where(Filter.and(
          Filter('buyerID', isEqualTo: auth.currentUser!.uid),
          Filter('orderStatus', isEqualTo: 'Completed')))
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
        width: Get.width,
        height: 246,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      print('error');
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      print('no data exit');
      return const Center(
        child: SizedBox(
          child: Text(
            'No completed bookings yet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        BookingModel bookingModel =
            BookingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BookingHistoryCompleted(
            bookingModel: bookingModel,
          ),
        );
      },
    );
  },
)

                    ///my listings ongoing
                    : controller.mySelection.value == 1 &&
                            controller.selectedButton.value == 0
                        ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('bookings')
      .where(Filter.and(
          Filter('sellerID', isEqualTo: auth.currentUser!.uid),
          Filter('orderStatus', isEqualTo: 'Pending')))
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
        width: Get.width,
        height: 246,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      print('error');
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: SizedBox(
          child: Text(
            'No ongoing bookings yet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        BookingModel bookingModel =
            BookingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OngoingListing(
            bookingModel: bookingModel,
          ),
        );
      },
    );
  },
)
                        : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('bookings')
      .where(Filter.and(
          Filter('sellerID', isEqualTo: auth.currentUser!.uid),
          Filter('orderStatus', isEqualTo: 'Completed')))
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return SizedBox(
        width: Get.width,
        height: 246,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      print('error');
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: SizedBox(
          child: Text(
            'No completed bookings yet',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: greyColor,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        BookingModel bookingModel =
            BookingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
        return GestureDetector(
          onTap: () {
            // customDialog(bookingModel: bookingModel, listingModel:);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: OngoingListing(
              bookingModel: bookingModel,
            ),
          ),
        );
      },
    );
  },
)
                          ),
          ),
        ],
      ),
    );
  }
}
