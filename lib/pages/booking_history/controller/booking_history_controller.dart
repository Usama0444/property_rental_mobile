import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
  var selectedButton = 0.obs;
  var mySelection = 0.obs;
  Future<void> checkTimeExpire(String checkOut, String docID, String currentStatus) async {
  try {
    // Parse checkout date
    DateTime checkoutDate = DateTime.parse(checkOut);
    DateTime currentDate = DateTime.now();

    // Check if checkout date is in the past
    if (currentDate.isAfter(checkoutDate) && currentStatus == 'Pending') {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docID)
          .update({'orderStatus': 'Completed'});
      
      // Optionally trigger feedback popup (handled in UI)
    }
  } catch (e) {
    print('Error in checkTimeExpire: $e');
  }
}
}
