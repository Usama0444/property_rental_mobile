import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  // Observable variables for contact data
  var address = ''.obs;
  var availability = ''.obs;
  var contactNumber = ''.obs;
  var supportEmail = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContactUsData();
  }

  // Fetch contact us data from Firestore
  Future<void> fetchContactUsData() async {
    try {
      isLoading.value = true;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('contactus')
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        address.value = data['address'] ?? '';
        availability.value = data['availability'] ?? '';
        contactNumber.value = data['contact_number'] ?? '';
        supportEmail.value = data['support_email'] ?? '';
      }
    } catch (e) {
      print('Error fetching contact us data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
