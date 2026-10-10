import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AboutUsController extends GetxController {
  var aboutDetail = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  // Fetch about us data from Firestore
  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('aboutus')
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        aboutDetail.value = data['detail'] ?? '';
      }
    } catch (e) {
      print('Error fetching about us data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

