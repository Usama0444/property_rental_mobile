import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';

import '../../common_widgets/loading_dialog.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();



  final selectedIndex = 0.obs;
  final selectedDateIndex = 0.obs;
  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  // Rx<DateTime> selectedListViewDate = Rx<DateTime>(DateTime.now());

  final List<String> ratingsList = [
    'Terrible',
    'Bad',
    'Okay',
    'Good',
    'Great',
  ];
}
