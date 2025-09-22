import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

class PropertyActions extends StatelessWidget {
final AddListingModel listing;
  final String? listingId;
  final VoidCallback? onActionComplete;

  const PropertyActions({
    Key? key,
required this.listing,
    required this.listingId,
    this.onActionComplete,
  }) : super(key: key);
  Future<void> _deleteListing() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'No authenticated user found',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Delete the listing
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId)
          .delete();
      print('Listing deleted: $listingId');

      // Check if the user has other listings
      final remainingListings = await FirebaseFirestore.instance
          .collection('listings')
          .where('sellerID', isEqualTo: userId)
          .get();

      // If no other listings remain, update isListingUser to false
      if (remainingListings.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'isListingUser': false});
        print('isListingUser updated to false for user: $userId');
      } else {
        print('User still has ${remainingListings.docs.length} listings, isListingUser not updated');
      }

      // Trigger UI refresh
      onActionComplete?.call();
    } catch (e) {
      print('Error deleting listing or updating isListingUser: $e');
      Get.snackbar('Error', 'Failed to delete listing: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: 
          CustomButton(
            width: Get.width,
            text: listing.isActive ? 'Active' : 'Paused',
            suffixTextIconWidth: 2,
            backgroundColor: listing.isActive ? Colors.green : Colors.orange,
            textColor: Colors.white,
            onPressed: () {
              // Show confirmation dialog before toggling status
              loadingDialog(
                button: true,
                button1: true,
                endBtnText: 'Yes',
                message: listing.isActive
                    ? 'Are you sure you want to pause this listing?'
                    : 'Are you sure you want to activate this listing?',
                tap: () async {
                  try {
                    // Show loading indicator
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    // Update isActive status in Firestore
                    await FirebaseFirestore.instance
                        .collection('listings')
                        .doc(listing.docId)
                        .update({'isActive': !listing.isActive});

                    // Close loading and confirmation dialogs
                    Get.back(); // Close loading dialog
                    Get.back();
                    onActionComplete?.call(); // Close confirmation dialog
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.snackbar(
                      'Error',
                      'Failed to update listing status: $e',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                startWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomButton(
                    text: 'Cancel',
                    height: 40,
                    width: Get.width * 0.26,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: CustomButton(
            width: Get.width,
            text: 'Delete Ad',
            suffixTextIconWidth: 2,
            onPressed: () {
              loadingDialog(
                button: true,
                button1: true,
                endBtnText: 'Yes',
                message: 'Are you sure you want to delete the Ad?',
                tap: () async {
                  try {
                    // Show loading indicator
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    // Delete listing from Firestore
  await _deleteListing();
                    // Close loading and confirmation dialogs
                    Get.back(); // Close loading dialog
                    Get.back();
                    onActionComplete?.call();
                    // Close confirmation dialog
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.snackbar(
                      'Error',
                      'Failed to delete listing: $e',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                startWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomButton(
                    text: 'Cancel',
                    height: 40,
                    width: Get.width * 0.26,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}