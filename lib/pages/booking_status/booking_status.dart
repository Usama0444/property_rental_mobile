import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';

import '../../universal_models/add_listing_model.dart';
import '../apartment_details/controller/booking_controller.dart';

class BookingStatus extends StatelessWidget {
  BookingStatus({super.key, required this.listingModel, required this.subTotal, required this.commission, required this.total});
  final AddListingModel listingModel;
  final String subTotal;
  final String commission;
  final String total;
  final controller = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          Get.offAll(() => BottomNavBar());
          return;
        }
        // Get.close(3);
        Get.offAll(() => BottomNavBar());
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            CustomAppBar(
              title: 'Booking Status',
              isBackButton: true,
              leftTap: () {
                Get.offAll(() => BottomNavBar());
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 34),
                    Image.asset(
                      'assets/images/booking.png',
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Booking Confirmed",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: primaryColor,
                        fontFamily: 'Avenir',
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: greyBorderColor, height: 1),
                    const SizedBox(height: 24),
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
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                "Transaction ID",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                                                            SizedBox(height: 24),

                               Text(
                                "Sales/Rent Comission",
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
                                DateFormat('dd MMM yyyy')
                                    .format(DateTime.now()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                "FT4Q121S",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Ksh $subTotal",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: textColor8080,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                                const SizedBox(height: 24),
                               Text(
                                commission,
                                style: TextStyle(
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
                    const SizedBox(height: 24),
                    const Divider(color: greyBorderColor, height: 1),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 28, right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: primaryColor,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          Text(
                            "Ksh $total",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: primaryColor,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 66),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                          text: 'Back to Home',
                          height: 44,
                          width: Get.width,
                          onPressed: () {
                            Get.find<BottomNavController>().tabIndex.value = 0;
                            Get.to(BottomNavBar());
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
