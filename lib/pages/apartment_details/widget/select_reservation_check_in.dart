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
  final controller = Get.put(BookingsController());
  EventList<Event> markedDatesMap = EventList<Event>(events: {});

  // Query Firestore to get all bookings for the given listingID
  QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('propertyID', isEqualTo: listingID)
      .get();

  // Get current date to filter out past bookings
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  // Iterate through bookings and mark all dates between check-in and check-out
  for (var doc in bookingsSnapshot.docs) {
    int checkInMillis = doc['checkIn'];
    int checkOutMillis = doc['checkOut'];

    DateTime checkInDate = DateTime.fromMillisecondsSinceEpoch(checkInMillis);
    DateTime checkOutDate = DateTime.fromMillisecondsSinceEpoch(checkOutMillis);

    if (checkOutDate.isBefore(today)) {
      continue;
    }

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
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  // Sample checkBookingAvailability function
  Future<bool> checkBookingAvailability(
      int checkInMillis, int checkOutMillis) async {
    DateTime checkInDate = DateTime.fromMillisecondsSinceEpoch(checkInMillis);
    DateTime checkOutDate = DateTime.fromMillisecondsSinceEpoch(checkOutMillis);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (checkInDate.isBefore(today) || checkOutDate.isBefore(today)) {
      return false;
    }

    QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('propertyID', isEqualTo: listingID)
        .get();

    for (var doc in bookingsSnapshot.docs) {
      int bookedCheckInMillis = doc['checkIn'];
      int bookedCheckOutMillis = doc['checkOut'];

      DateTime bookedCheckIn =
          DateTime.fromMillisecondsSinceEpoch(bookedCheckInMillis);
      DateTime bookedCheckOut =
          DateTime.fromMillisecondsSinceEpoch(bookedCheckOutMillis);

      if (bookedCheckOut.isBefore(today)) {
        continue;
      }

      if (!(checkOutDate.isBefore(bookedCheckIn) ||
          checkInDate.isAfter(bookedCheckOut))) {
        return false;
      }
    }
    return true;
  }

  // Reactive variables
  final RxBool isMonthlyBooking = false.obs;
  final RxInt selectedMonths = 1.obs;
  // Add reactive variable for check-out calendar month
  final Rx<DateTime> checkOutCalendarMonth = DateTime.now().obs;

  // Function to calculate check-out date based on months
  DateTime calculateCheckOutDate(DateTime checkInDate, int months) {
    int targetYear = checkInDate.year;
    int targetMonth = checkInDate.month + months;
    int targetDay = checkInDate.day;

    while (targetMonth > 12) {
      targetMonth -= 12;
      targetYear += 1;
    }

    DateTime lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0);
    if (targetDay > lastDayOfMonth.day) {
      targetDay = lastDayOfMonth.day;
    }

    return DateTime(targetYear, targetMonth, targetDay);
  }

  // Update check-out calendar month when check-in date or months change
  void updateCheckOutCalendarMonth() {
    if (controller.checkInDate.value != null && isMonthlyBooking.value) {
      DateTime checkOutDate = calculateCheckOutDate(
        controller.checkInDate.value!,
        selectedMonths.value,
      );
      checkOutCalendarMonth.value = DateTime(checkOutDate.year, checkOutDate.month, 1);
    } else {
      checkOutCalendarMonth.value = DateTime.now();
    }
  }

  // Update check-out date and calendar month when check-in date changes
  ever(controller.checkInDate, (_) => updateCheckOutCalendarMonth());
  ever(selectedMonths, (_) => updateCheckOutCalendarMonth());

  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: whiteColor,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (context) {
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            color: greyBorderColor,
                            height: 1,
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  text: 'Daily Booking',
                                  height: 44,
                                  width: Get.width / 2 - 30,
                                  onPressed: () {
                                    isMonthlyBooking.value = false;
                                    selectedMonths.value = 1;
                                    if (controller.checkInDate.value != null) {
                                      controller.checkOutDate.value = controller.checkInDate.value;
                                    }
                                  },
                                  backgroundColor: isMonthlyBooking.value
                                      ? greyBorderColor
                                      : primaryColor,
                                  textColor: isMonthlyBooking.value
                                      ? blackColor3B
                                      : whiteColor,
                                ),
                                CustomButton(
                                  text: 'Monthly Booking',
                                  height: 44,
                                  width: Get.width / 2 - 30,
                                  onPressed: () {
                                    isMonthlyBooking.value = true;
                                    if (controller.checkInDate.value != null) {
                                      controller.checkOutDate.value = calculateCheckOutDate(
                                        controller.checkInDate.value!,
                                        selectedMonths.value,
                                      );
                                      updateCheckOutCalendarMonth();
                                    } else {
                                      loadingDialog(
                                        message: 'Please select a check-in date first.',
                                        button: true,
                                      );
                                    }
                                  },
                                  backgroundColor: isMonthlyBooking.value
                                      ? primaryColor
                                      : greyBorderColor,
                                  textColor: isMonthlyBooking.value
                                      ? whiteColor
                                      : blackColor3B,
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => isMonthlyBooking.value
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Select Months',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: blackColor3B,
                                            fontSize: 18,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: blackColor3B, width: 1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          child: DropdownButton<int>(
                                            underline: SizedBox.shrink(),
                                            value: selectedMonths.value,
                                            items: [1, 3, 6, 9, 12].map((int months) {
                                              return DropdownMenuItem<int>(
                                                value: months,
                                                child: Text('$months Month${months > 1 ? 's' : ''}'),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue) async {
                                              if (newValue != null) {
                                                selectedMonths.value = newValue;
                                                if (controller.checkInDate.value != null) {
                                                  DateTime newCheckOutDate = calculateCheckOutDate(
                                                    controller.checkInDate.value!,
                                                    newValue,
                                                  );
                                                  bool isBookable = await checkBookingAvailability(
                                                    controller.checkInDate.value!.millisecondsSinceEpoch,
                                                    newCheckOutDate.millisecondsSinceEpoch,
                                                  );
                                                  if (isBookable) {
                                                    controller.checkOutDate.value = newCheckOutDate;
                                                    updateCheckOutCalendarMonth();
                                                  } else {
                                                    loadingDialog(
                                                      message:
                                                          'The selected period is already booked.',
                                                      button: true,
                                                    );
                                                  }
                                                } else {
                                                  loadingDialog(
                                                    message: 'Please select a check-in date first.',
                                                    button: true,
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 20),
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
                                  blurRadius: 10,
                                ),
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
                                  color: Colors.white,
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
                                markedDatesMap: markedDatesMap,
                                markedDateShowIcon: false,
                                markedDateIconBuilder: (event) => event.dot,
                                onDayPressed: (date, events) async {
                                  DateTime now = DateTime.now();
                                  DateTime today = DateTime(now.year, now.month, now.day);
                                  if (date.isBefore(today)) {
                                    loadingDialog(
                                        message:
                                            'Cannot select a past date for check-in.',
                                        button: true);
                                    return;
                                  }
                                  if (markedDatesMap.getEvents(date).isNotEmpty) {
                                    loadingDialog(
                                        message:
                                            'The selected check-in date is already booked.',
                                        button: true);
                                    return;
                                  }
                                  controller.checkInDate.value = date;
                                  if (isMonthlyBooking.value) {
                                    DateTime newCheckOutDate = calculateCheckOutDate(
                                      date,
                                      selectedMonths.value,
                                    );
                                    bool isBookable = await checkBookingAvailability(
                                      date.millisecondsSinceEpoch,
                                      newCheckOutDate.millisecondsSinceEpoch,
                                    );
                                    if (isBookable) {
                                      controller.checkOutDate.value = newCheckOutDate;
                                      updateCheckOutCalendarMonth();
                                    } else {
                                      loadingDialog(
                                          message:
                                              'The selected period is already booked.',
                                          button: true);
                                    }
                                  } else {
                                    controller.checkOutDate.value = date;
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
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isMonthlyBooking.value
                                    ? greyBorderColor.withOpacity(0.5)
                                    : whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: CalendarCarousel(
                                pageScrollPhysics: isMonthlyBooking.value
                                    ? const NeverScrollableScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                customGridViewPhysics: isMonthlyBooking.value
                                    ? const NeverScrollableScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
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
                                  color: Color(0xFFB08968),
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
                                // Set the initial month for the check-out calendar
                                targetDateTime: checkOutCalendarMonth.value,
                                markedDatesMap: markedDatesMap,
                                markedDateShowIcon: false,
                                markedDateIconBuilder: (event) => event.dot,
                                onDayPressed: isMonthlyBooking.value
                                    ? null
                                    : (date, events) async {
                                        DateTime now = DateTime.now();
                                        DateTime today = DateTime(now.year, now.month, now.day);
                                        if (date.isBefore(today)) {
                                          loadingDialog(
                                              message:
                                                  'Cannot select a past date for check-out.',
                                              button: true);
                                          return;
                                        }
                                        if (markedDatesMap
                                            .getEvents(date)
                                            .isNotEmpty) {
                                          loadingDialog(
                                              message:
                                                  'The selected check-out date is already booked.',
                                              button: true);
                                          return;
                                        }
                                        if (controller.checkInDate.value == null ||
                                            date.isBefore(
                                                controller.checkInDate.value!) ||
                                            isSameDay(
                                                date, controller.checkInDate.value!)) {
                                          loadingDialog(
                                              message:
                                                  'Check-out date must be after check-in date.',
                                              button: true);
                                          return;
                                        }
                                        int selectedDateMillis =
                                            date.millisecondsSinceEpoch;
                                        bool isBookable =
                                            await checkBookingAvailability(
                                                controller.checkInDate.value!.millisecondsSinceEpoch,
                                                selectedDateMillis);
                                        if (isBookable) {
                                          controller.checkOutDate.value = date;
                                        } else {
                                          loadingDialog(
                                              message:
                                                  'The selected check-out date is already booked.',
                                              button: true);
                                        }
                                      },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Divider(
                    color: greyBorderColor,
                    height: 1,
                  ),
               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
  child: CustomButton(
    text: 'Done',
    height: 44,
    width: Get.width,
    onPressed: () async {
      if (controller.checkInDate.value == null ||
          controller.checkOutDate.value == null) {
        loadingDialog(
            message: 'Please select both check-in and check-out dates.',
            button: true);
        return;
      }
      final totalAmount;
      final subTotal;
      int extraPayTotal = 0;

      if (controller.checkOutDate.value!.isAfter(controller.checkInDate.value!) ||
          isSameDay(controller.checkOutDate.value!, controller.checkInDate.value!)) {
        final daysDifference = controller.checkOutDate.value!
                .difference(controller.checkInDate.value!)
                .inDays +
            1;

        // Calculate rentTotalAmount based on booking type
        final rentTotalAmount = isMonthlyBooking.value
            ? selectedMonths.value *
                (listingModel.monthlyCost.text.isNotEmpty
                    ? int.parse(listingModel.monthlyCost.text)
                    : int.parse(listingModel.payment.text)) // Fallback to daily rate if monthlyPayment is empty
            : daysDifference * int.parse(listingModel.payment.text);

        // Fetch commission rate
        final double commissionRate = await FirebaseFirestore.instance
            .collection(listingModel.listingRole.value == 'Rent'
                ? 'rentcommission'
                : 'salescommission')
            .where('property_type', isEqualTo: listingModel.propertyType.value)
            .get()
            .then((val) {
          if (val.size == 0) {
            return 0.0;
          } else {
            return double.parse(val.docs.first['commission_rate']);
          }
        });

        // Calculate extraPayTotal based on booking type
        if (listingModel.extraPay.text.isNotEmpty) {
          extraPayTotal = isMonthlyBooking.value
              ? selectedMonths.value * int.parse(listingModel.extraPay.text)
              : daysDifference * int.parse(listingModel.extraPay.text);

          totalAmount = rentTotalAmount + commissionRate + extraPayTotal;
          subTotal = rentTotalAmount + extraPayTotal;
        } else {
          totalAmount = rentTotalAmount + commissionRate;
          subTotal = rentTotalAmount;
        }

        int checkInDateMillis =
            controller.checkInDate.value!.millisecondsSinceEpoch;
        int checkOutDateMillis =
            controller.checkOutDate.value!.millisecondsSinceEpoch;

        bool isBookable = await checkBookingAvailability(
            checkInDateMillis, checkOutDateMillis);

        if (isBookable) {
          Get.to(() => PaymentScreen(
                listingModel: listingModel,
                listingID: listingID,
                days: daysDifference,
                extraAmount: extraPayTotal.toString(),
                rentAmount: rentTotalAmount.toString(),
                totalAmount: totalAmount.toString(),
                commission: commissionRate.toString(),
                subTotal: subTotal.toString(),
                bookingMode: isMonthlyBooking.value ? 'Monthly' : 'Daily',
              ));
        } else {
          loadingDialog(
              message: 'The property is already booked for these days.',
              button: true);
        }
      } else {
        loadingDialog(
            message: 'Please select a check-out date after the check-in date.',
            button: true);
      }
    },
  ),
) ],
              ),
            )
          ],
        ),
      );
    },
  );
}
TextStyle activeStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Avenir',
    color: blackColor3B,
  );
}

TextStyle inActiveStyle() {
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