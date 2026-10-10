import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TermsOfServiceController extends GetxController {
  var termsDetail = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  // Fetch terms and conditions data from Firestore
  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading.value = true;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('termsconditions')
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        termsDetail.value = data['detail'] ?? '';
      }
    } catch (e) {
      print('Error fetching terms and conditions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

