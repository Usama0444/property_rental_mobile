import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';
import 'package:property_rental_app/pages/home/home.dart';
import 'package:property_rental_app/pages/profile/profile.dart';
import 'package:property_rental_app/pages/saved_ads/saved_ads.dart';
import 'package:property_rental_app/pages/search_screen/search_screen.dart';

import '../../search_screen/controller/search_screen_controller.dart';

class BottomNavController extends GetxController {
  RxInt tabIndex = 0.obs;
  static List<Widget> widgetsOption = <Widget>[
    Home(),
    SearchScreen(
      role: Get.put(HomeController()).propertyStatus.value,
      isComingFromActivity: false,
    ),
    SavedAds(),
    const Profile(),
  ];
}
