import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/booking_controller.dart';
import 'package:property_rental_app/pages/profile/controller.dart';
import 'package:property_rental_app/pages/search_screen/widget/pay_ksh_to_book.dart';
import 'package:property_rental_app/utils/validator.dart';

mpesaNumberBottomSheet(sellerID, listingModel,listingID) {
  final controller = Get.put(BookingsController());
  final formKey = GlobalKey<FormState>();
  return showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: false,
    backgroundColor: whiteColor,
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kindly input your Mpesa number to pay for booking.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: blackColor3B,
                    fontSize: 20,
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
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Submit',
                        height: 48,
                        borderRadius: 8,
                        width: Get.width,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            // controller.bookingMdl.mPesa.clear();
                            payKshtoBookBottomSheet(sellerID,listingModel,listingID);
                          }
                          // Get.to(() => EnterPropertyDetails());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
