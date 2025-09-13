import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/profile/controller.dart';

rateUsBottomSheet() {
    final controller = Get.put(ProfileController());
  final TextEditingController reviewController = TextEditingController();
  double selectedRating = 3.0; // Default rating
  Future<String?> getUserName() async {
    try {
      // Option 1: Check Firebase Auth displayName
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName;
      }

      // Option 2: Fetch from Firestore users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['userName'] ?? 'Anonymous';
      }
      return 'Anonymous'; // Fallback if no name is found
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }
  // Function to upload rating and review to Firestore
  Future<void> uploadRatingToFirestore({
    required String userId,
    required String reviewText,
    required double starRating,
    required String userName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'userId': userId,
        'reviewText': reviewText,
        'starRating': starRating,
        'timestamp': FieldValue.serverTimestamp(),
        'userName': userName,
      });
    } catch (e) {
      print('Error uploading rating: $e');
      Get.snackbar('Error', 'Failed to submit review. Please try again.');
    }
  }
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
      final controller = Get.put(ProfileController());
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/rate_us.png',
                  height: 153,
                  width: 136,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Rate your experience with MSL Homes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: blackColor3B,
                    fontSize: 18,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(height: 13),
                 RatingBar.builder(
                  initialRating: selectedRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 55,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Image.asset(
                        'assets/icons/ratings_selected.png',
                        scale: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.ratingsList[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: blackColor3B,
                          fontSize: 50,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                    print('Selected rating: $rating');
                  },
                ),
                  const SizedBox(height: 30),
                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    hintText: 'Enter your review',
                    hintStyle: const TextStyle(
                      color: Color(0xFF808080),
                      fontFamily: 'Avenir',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: greyBorderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                  ),
                  maxLines: 4,
                  maxLength: 500,
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 16,
                    color: blackColor3B,
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Rate',
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  width: Get.width,
                  height: 46,
                  onPressed: () {
                    loadingDialog(
                        message: 'Submitting your review...',
                      button: true,
                      tap: () async {
                        final userName = await getUserName();
                        if (userName == null) {
                     
                          Get.snackbar('Error', 'Failed to fetch user name.');
                          return;
                        }
                        await uploadRatingToFirestore(
                          userId: auth.currentUser!.uid,
                          reviewText: reviewController.text.trim(),
                          starRating: selectedRating,
                          userName: userName,
                        );
                        Get.back(); // Close loading dialog
                        Get.back(); // Close bottom sheet
                        Get.snackbar('Success', 'Thank you for your review!');
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text(
                    'I’ll do it later',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9A9A9A),
                      fontSize: 16,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
