import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/profile/controller.dart';
import 'package:property_rental_app/pages/search_screen/widget/mpesa_number.dart';
import 'package:property_rental_app/utils/validator.dart';

import '../../../common_widgets/global_functions.dart';
import '../../../common_widgets/loading_dialog.dart';

reservationBottomSheet(sellerID, listingModel, listingID) {
  final controller = Get.put(BookingsController());
  final formKey = GlobalKey<FormState>();
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
        height: Get.height - 120,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 8, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 5,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: lightGreyD9,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            RichText(
                              text: const TextSpan(
                                text: 'Full Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hintText: 'Type your name',
                              fillColor: whiteColor,
                              hintColor: textColor66,
                              controller: controller.bookingMdl.buyerName,
                              validator: (value) {
                                return isUsernameValid(value!);
                              },
                            ),
                            const SizedBox(height: 20),
                            RichText(
                              text: const TextSpan(
                                text: 'Phone number',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              hintText: 'Enter phone number',
                              fillColor: whiteColor,
                              hintColor: textColor66,
                              controller: controller.bookingMdl.buyerPhoneNo,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                return isPhoneValid(value!);
                              },
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: const TextSpan(
                                text: 'Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: blackColor3B,
                                  fontSize: 16,
                                  fontFamily: 'Avenir',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
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
                                  headerMargin:
                                      const EdgeInsets.only(bottom: 24),
                                  scrollDirection: Axis.horizontal,
                                  // daysHaveCircularBorder: false,
                                  daysTextStyle: activeStyle(),
                                  weekendTextStyle: activeStyle(),
                                  inactiveDaysTextStyle: inActiveStyle(),
                                  inactiveWeekendTextStyle: inActiveStyle(),
                                  markedDateCustomTextStyle: const TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: whiteColor,
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
                                  markedDateCustomShapeBorder:
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  weekDayMargin: EdgeInsets.zero,
                                  childAspectRatio: 1,
                                  todayBorderColor: primaryColor,
                                  todayButtonColor:
                                      primaryColor.withOpacity(0.8),
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
                                  selectedDateTime:
                                      controller.selectedDate.value,

                                  onDayPressed: (date, events) {
                                    DateTime now = DateTime.now();

                                    if (date.isAfter(DateTime(
                                            now.year, now.month, now.day)) ||
                                        date ==
                                            DateTime(
                                                now.year, now.month, now.day)) {
                                      print('enter');
                                      controller.selectedDate.value = date;
                                    }
                                    // controller.selectedDate.value = date;
                                    // print(controller.selectedDate.value);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      child: CustomButton(
                        text: 'Done',
                        height: 44,
                        width: Get.width,
                        onPressed: () async {
                          print(controller.selectedDate.value);
                          int date = controller
                              .selectedDate.value.millisecondsSinceEpoch;

                          controller.bookingMdl.checkIn = date;
                          print('=========');
                          if (formKey.currentState!.validate()) {
                            // Convert selected dates to milliseconds
                            int checkInDateMillis = controller
                                .selectedDate.value.millisecondsSinceEpoch;

                            // Check for overlapping bookings
                            bool isBookable =
                                await checkBookingAvailabilitySold(
                              checkInDateMillis,
                            );

                            // controller.fullNameController.clear();
                            // controller.phoneController.clear();
                            if (isBookable) {
                              print('shdvfkhvfk___________________');
                              Get.back();
                              mpesaNumberBottomSheet(
                                  sellerID, listingModel, listingID);
                            } else {
                              print('sbvdfhsedvbfkef-------------------');
                              loadingDialog(
                                  message:
                                      'The property is already booked for this date.',
                                  button: true);
                            }
                          }
                          // Get.to(() => EnterPropertyDetails());
                        },
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
