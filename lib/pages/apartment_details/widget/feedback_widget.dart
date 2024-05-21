import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/apartment_details_controller.dart';

class FeedBackWidget extends StatelessWidget {
  FeedBackWidget({
    super.key,
    required this.propertyID,
    required this.sellerID,
  });

  final controller = Get.put(ApartmentDetailsController());
  final String propertyID;
  final String sellerID;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 10,
        )
      ], color: whiteColor, borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Form(
        key: formKey,
        child: Column(
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
              hintText: 'Enter you feedback',
              maxLines: 5,
              borderRadius: 8,
              controller: controller.feedbackModel.feedback,
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
                    controller.addFeedback(sellerID, propertyID);
                  }
                })
          ],
        ),
      ),
    );
  }
}
