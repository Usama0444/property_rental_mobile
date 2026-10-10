import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  var privacyDetails = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  // Fetch privacy policy data from Firestore
  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('privacypolicy')
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        privacyDetails.value = data['details'] ?? '';
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

