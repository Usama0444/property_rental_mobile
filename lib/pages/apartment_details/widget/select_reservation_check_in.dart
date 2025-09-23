import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/booking_status/booking_status.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

import '../../booking_status/payment_screen.dart';

Future<void> reservationCheckInBottomSheet({
  required AddListingModel listingModel,
  required String listingID,
}) async {
  // print(listingModel./)
  final controller = Get.put(BookingsController());
  EventList<Event> markedDatesMap = EventList<Event>(events: {});

  // Query Firestore to get all bookings for the given listingID
  QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('propertyID', isEqualTo: listingID)
      .get();

  // Iterate through bookings and mark all dates between check-in and check-out
  for (var doc in bookingsSnapshot.docs) {
    int checkInMillis = doc['checkIn'];
    int checkOutMillis = doc['checkOut'];

    DateTime checkInDate = DateTime.fromMillisecondsSinceEpoch(checkInMillis);
    DateTime checkOutDate = DateTime.fromMillisecondsSinceEpoch(checkOutMillis);

    // Mark all dates in the range from check-in to check-out
    DateTime currentDate = checkInDate;
    while (!currentDate.isAfter(checkOutDate)) {
      markedDatesMap.add(
        currentDate,
        Event(
          date: currentDate,
          title: 'Booked',
          dot: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.brown, // Light brown color for booked dates
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }
  // final controller1 = Get.put(HomeController());
  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: whiteColor,
    enableDrag: true,

    // showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    // onClosing: () {},
    builder: (context) {
      // final controller = Get.put(SettingController());
      return Container(
        decoration: const ShapeDecoration(
          color: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
        ),
        height: Get.height - 40,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select your reservation details',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: blackColor3B,
                                  fontSize: 18,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Image.asset(
                                  'assets/icons/cross_icon.png',
                                  height: 24,
                                  width: 24,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            color: greyBorderColor,
                            height: 1,
                          ),
                          const SizedBox(height: 20),
                          // const Text(
                          //   'Bedrooms',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w700,
                          //     color: blackColor3B,
                          //     fontSize: 16,
                          //     fontFamily: 'Avenir',
                          //   ),
                          // ),
                          // const SizedBox(height: 12),
                          // Obx(
                          //       () =>
                          //           Wrap(
                          //             children: List.generate(
                          //               listingModel.selectedBedroom.length,
                          //               (index) => GestureDetector(
                          //                 onTap: () {
                          //                   controller.bookingMdl.selectedBedroom.clear();
                          //                   for (int i = 0; i <= index; i++) {
                          //                     controller.bookingMdl.selectedBedroom
                          //                         .add(  listingModel.selectedBedroom[index]);
                          //                   }
                          //                 },
                          //                 child: Container(
                          //                   margin: const EdgeInsets.only(
                          //                       right: 12, bottom: 12),
                          //                   padding: const EdgeInsets.symmetric(
                          //                       vertical: 6, horizontal: 13),
                          //                   decoration: BoxDecoration(
                          //                       border: Border.all(
                          //                         color: controller.bookingMdl
                          //                                 .selectedBedroom.isNotEmpty
                          //                             ? controller.bookingMdl
                          //                                         .selectedBedroom.last ==
                          //                                     controller
                          //                                         .bedroomsList[index]
                          //                                 ? primaryColor
                          //                                 : greyBorderColor
                          //                             : greyBorderColor,
                          //                       ),
                          //                       borderRadius: BorderRadius.circular(6)),
                          //                   child: Text(
                          //                     listingModel.selectedBedroom[index],
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           ),
                          //           const SizedBox(height: 12),
                          
                          const Text(
                            'Check-In',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blackColor3B,
                              fontSize: 18,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Obx(
                              () => CalendarCarousel(
                                pageScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                customGridViewPhysics:
                                    const NeverScrollableScrollPhysics(),
                                height: 360,
                                width: double.infinity,
                                firstDayOfWeek: 1,
                                showHeaderButton: true,

                                leftButtonIcon: Container(
                                  height: 34,
                                  width: 34,
                                  child: const Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: blackColor,
                                  ),
                                ),
                                rightButtonIcon: Container(
                                  height: 34,
                                  width: 34,
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: blackColor3B,
                                  ),
                                ),
                                dayButtonColor: Colors.transparent,
                                headerMargin: const EdgeInsets.only(bottom: 24),
                                scrollDirection: Axis.horizontal,
                                // daysHaveCircularBorder: false,
                                daysTextStyle: activeStyle(),
                                weekendTextStyle: activeStyle(),
                                inactiveDaysTextStyle: inActiveStyle(),
                                inactiveWeekendTextStyle: inActiveStyle(),
                                           markedDateCustomShapeBorder: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
  side: const BorderSide(
    color: Color(0xFFB08968),
    width: 2,
  ),
),
markedDateCustomTextStyle: const TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w400,
  fontSize: 15,
  color: Colors.white, // Match text color to light brown
),
                                dayPadding: 2,
                                nextDaysTextStyle: inActiveStyle(),
                                prevDaysTextStyle: inActiveStyle(),
                                weekdayTextStyle: const TextStyle(
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Avenir',
                                ),
                                headerTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: blackColor3B,
                                ),
                              
                                weekDayMargin: EdgeInsets.zero,
                                childAspectRatio: 1,
                                todayBorderColor: Colors.grey,
                                todayButtonColor: Colors.grey,
                                todayTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: whiteColor,
                                ),
                                selectedDayTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: whiteColor,
                                ),
                                
                                selectedDayBorderColor: primaryColor,
                                selectedDayButtonColor: primaryColor,
                                selectedDateTime: controller.checkInDate.value,
                                markedDatesMap: markedDatesMap, // Add marked dates
                                markedDateShowIcon: false,
                                markedDateIconBuilder: (event) => event.dot,
                               onDayPressed: (date, events) async {
                                  DateTime now = DateTime.now();
                                  if (date.isBefore(DateTime(
                                      now.year, now.month, now.day))) {
                                    loadingDialog(
                                        message:
                                            'Cannot select a past date for check-in.',
                                        button: true);
                                    return;
                                  }
                                  // Check if the date is marked as booked
  if (markedDatesMap.getEvents(date).isNotEmpty) {
    loadingDialog(
        message: 'The selected check-in date is already booked.',
        button: true);
    return;
  }
                                  int selectedDateMillis =
                                      date.millisecondsSinceEpoch;
                                  bool isBookable = await checkBookingAvailability(
                                      selectedDateMillis, selectedDateMillis);
                                  if (isBookable) {
                                    controller.checkInDate.value = date;
                                  } else {
                                    loadingDialog(
                                        message:
                                            'The selected check-in date is already booked.',
                                        button: true);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Check-out',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: blackColor3B,
                              fontSize: 18,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10)
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Obx(
                              () => CalendarCarousel(
                                pageScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                customGridViewPhysics:
                                    const NeverScrollableScrollPhysics(),
                                height: 360,
                                width: double.infinity,
                                firstDayOfWeek: 1,
                                showHeaderButton: true,

                                leftButtonIcon: Container(
                                  height: 34,
                                  width: 34,
                                  child: const Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: blackColor,
                                  ),
                                ),
                                rightButtonIcon: Container(
                                  height: 34,
                                  width: 34,
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: blackColor3B,
                                  ),
                                ),
                                dayButtonColor: Colors.transparent,
                                headerMargin: const EdgeInsets.only(bottom: 24),
                                scrollDirection: Axis.horizontal,
                                // daysHaveCircularBorder: false,
                                daysTextStyle: activeStyle(),
                                weekendTextStyle: activeStyle(),
                                inactiveDaysTextStyle: inActiveStyle(),
                                inactiveWeekendTextStyle: inActiveStyle(),
                               markedDateCustomShapeBorder: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
  side: const BorderSide(
    color: Color(0xFFB08968),
    width: 2,
  ),
),
markedDateCustomTextStyle: const TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w400,
  fontSize: 15,
  color: Color(0xFFB08968), // Match text color to light brown
),
                                dayPadding: 2,
                                nextDaysTextStyle: inActiveStyle(),
                                prevDaysTextStyle: inActiveStyle(),
                                weekdayTextStyle: const TextStyle(
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Avenir',
                                ),
                                headerTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: blackColor3B,
                                ),
                              
                                weekDayMargin: EdgeInsets.zero,
                                childAspectRatio: 1,
                               todayBorderColor: Colors.grey,
                                todayButtonColor: Colors.grey,
                                todayTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: whiteColor,
                                ),
                                selectedDayTextStyle: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: whiteColor,
                                ),
                                selectedDayBorderColor: primaryColor,
                                selectedDayButtonColor: primaryColor,
                                selectedDateTime: controller.checkOutDate.value,
markedDatesMap: markedDatesMap, // Add marked dates
                                markedDateShowIcon: false,
                                markedDateIconBuilder: (event) => event.dot,
                                onDayPressed: (date, events) async {
  print('Check-out calendar pressed: $date');
  DateTime now = DateTime.now();
  if (date.isBefore(DateTime(now.year, now.month, now.day))) {
    loadingDialog(
        message: 'Cannot select a past date for check-out.',
        button: true);
    return;
  }
  // Check if the date is marked as booked
  if (markedDatesMap.getEvents(date).isNotEmpty) {
    loadingDialog(
        message: 'The selected check-in date is already booked.',
        button: true);
    return;
  }
  if (date.isBefore(controller.checkInDate.value) ||
      isSameDay(date, controller.checkInDate.value)) {
    loadingDialog(
        message: 'Check-out date must be after check-in date.',
        button: true);
    return;
  }
  int selectedDateMillis = date.millisecondsSinceEpoch;
  bool isBookable = await checkBookingAvailability(
      selectedDateMillis, selectedDateMillis);
  if (isBookable) {
    print('Setting checkOutDate to: $date');
    controller.checkOutDate.value = date;
    print('checkInDate after update: ${controller.checkInDate.value}');
  } else {
    loadingDialog(
        message: 'The selected check-out date is already booked.',
        button: true);
  }
},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(12),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  const Divider(
                    color: greyBorderColor,
                    height: 1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    child: CustomButton(
                      text: 'Done',
                      height: 44,
                      width: Get.width,
                      // onPressed: () async {
                      //
                      //   if (controller.checkOutDate.value
                      //           .isAfter(controller.checkInDate.value) ||
                      //       controller.checkOutDate.value ==
                      //           controller.checkInDate.value) {
                      //     final daysDifference = controller.checkOutDate.value
                      //             .difference(controller.checkInDate.value)
                      //             .inDays +
                      //         1;
                      //
                      //     final rentDays = daysDifference *
                      //         int.parse(listingModel.cost.text);
                      //
                      //     final totalAmount =
                      //         rentDays + int.parse(listingModel.extraPay.text);
                      //     print(totalAmount.toString() + ' totalAmount');
                      //     print(daysDifference.toString() + ' daysDifference');
                      //
                      //     // Convert selected dates to milliseconds
                      //     int checkInDateMillis = controller
                      //         .checkInDate.value.millisecondsSinceEpoch;
                      //     int checkOutDateMillis = controller
                      //         .checkOutDate.value.millisecondsSinceEpoch;
                      //
                      //     // Check for overlapping bookings
                      //     bool isBookable = await checkBookingAvailability(
                      //         checkInDateMillis, checkOutDateMillis);
                      //
                      //     // Get.to(() => const BookingStatus());
                      //     if (isBookable) {
                      //       Get.to(() => PaymentScreen(
                      //           listingModel: listingModel,
                      //           listingID: listingID,
                      //           totalAmount: totalAmount.toString()));
                      //     } else {
                      //       loadingDialog(
                      //           message:
                      //               'The property is already booked for these days.',
                      //           button: true);
                      //     }
                      //   } else {
                      //     loadingDialog(
                      //         message:
                      //             'Please select a date after the check-in date.',
                      //         button: true);
                      //   }
                      // },
                      onPressed: () async {
                        final totalAmount;
                        final subTotal;
                        int extraPayTotal=0;
                        if (controller.checkOutDate.value
                            .isAfter(controller.checkInDate.value) ||
                            controller.checkOutDate.value ==
                                controller.checkInDate.value) {
                          final daysDifference = controller.checkOutDate.value
                              .difference(controller.checkInDate.value)
                              .inDays +
                              1;

                          final rentTotalAmount = daysDifference *
                              int.parse(listingModel.payment.text);

                          final double commissionRate = await FirebaseFirestore.instance.collection(listingModel.listingRole.value == 'Rent' ? 'rentcommission' : 'salescommission').where('property_type', isEqualTo: listingModel.propertyType.value).get().then((val){

                            if(val.size == 0){
                              return 0;
                            }else{
                              return double.parse(val.docs.first['commission_rate']);
                            }

                          });

                          if (listingModel.extraPay.text != '') {
                            extraPayTotal = daysDifference *
                                int.parse(listingModel.extraPay.text);


                            totalAmount = rentTotalAmount + commissionRate + extraPayTotal;
                            subTotal = rentTotalAmount + extraPayTotal;
                          } else {
                            totalAmount = rentTotalAmount + commissionRate;
                            subTotal = rentTotalAmount;
                          }


                          print(daysDifference.toString() + ' daysDifference');

                          // Convert selected dates to milliseconds
                          int checkInDateMillis = controller
                              .checkInDate.value.millisecondsSinceEpoch;
                          int checkOutDateMillis = controller
                              .checkOutDate.value.millisecondsSinceEpoch;

                          // Check for overlapping bookings
                          bool isBookable = await checkBookingAvailability(
                              checkInDateMillis, checkOutDateMillis);

                          // Get.to(() => const BookingStatus());
                          if (isBookable) {
                            Get.to(() => PaymentScreen(
                                listingModel: listingModel,
                                listingID: listingID,
                                days:daysDifference,
                                extraAmount: extraPayTotal.toString(),
                                rentAmount: rentTotalAmount.toString(),
                                totalAmount: totalAmount.toString(),
                                commission: commissionRate.toString(),
                              subTotal: subTotal.toString(),
                            ));
                          } else {
                            loadingDialog(
                                message:
                                'The property is already booked for these days.',
                                button: true);
                          }
                        } else {
                          loadingDialog(
                              message:
                              'Please select a date after the check-in date.',
                              button: true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

activeStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Avenir',
    color: blackColor3B,
  );
}

inActiveStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Avenir',
    color: blackColor3B,
  );
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

//
// Future<bool> checkBookingAvailability(
//     int checkInDateMillis, int checkOutDateMillis) async {
//   // Query Firestore to check for overlapping bookings
//   // Assuming you have a collection named "bookings" containing documents representing bookings
//   QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
//       .collection('bookings')
//       .where('checkIn', isGreaterThanOrEqualTo: checkInDateMillis)
//       .where('checkOut', isLessThanOrEqualTo: checkOutDateMillis)
//       .get();
//
//   // If there are overlapping bookings, return false
//   return bookingsSnapshot.docs.isEmpty;
// }
