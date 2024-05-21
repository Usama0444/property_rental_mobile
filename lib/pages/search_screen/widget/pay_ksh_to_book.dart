import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/profile/controller.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

payKshtoBookBottomSheet(sellerID, AddListingModel listingModel, listingID) {
  final controller = Get.put(BookingsController());
  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: whiteColor,

    // enableDrag: true,

    // showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    // onClosing: () {},
    builder: (context) {
      return Container(
        decoration: const ShapeDecoration(
          color: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Pay Ksh. 1000 to book',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: blackColor3B,
                  fontSize: 24,
                  fontFamily: 'Avenir',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Note that the above amount shall be used to reserve this room for you and can be used to reserve another room',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: blackColor3B,
                  fontSize: 14,
                  fontFamily: 'Avenir',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      height: 48,
                      isBorder: true,
                      borderRadius: 8,
                      textColor: textColor8080,
                      backgroundColor: whiteColor,
                      width: Get.width,
                      onPressed: () {
                        // Get.to(() => EnterPropertyDetails());
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Confirm',
                      height: 48,
                      borderRadius: 8,
                      width: Get.width,
                      onPressed: () {
                        int pendingAmount =
                            int.parse(listingModel.cost.text.toString()) - 1000;
                        controller.bookingMdl.pendingPayment =
                            pendingAmount.toString();
                        controller.bookingMdl.propertyID = listingID;
                        print(controller.bookingMdl.pendingPayment);
                        controller.addBooking(
                            listingModel.sellerID, listingID, listingModel);

                        ////////////////
                        // Get.offAll(BottomNavBar());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
