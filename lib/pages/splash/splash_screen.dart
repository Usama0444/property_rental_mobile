import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/pages/auth/login/login_screen.dart';

import '../../main.dart';
import '../bottom_nav_bar/user_bottom_nav_bar.dart';
import 'landing_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate based on the user authentication status
      if (currentUser != null) {
        Get.off(() => BottomNavBar());
      } else {
        Get.off(() => LandingPage());
      }

      // currentUser != null ? BottomNavBar() : LandingPage()
    });

    return Scaffold(
      body: Container(
        width: Get.width,
        child: Image.asset(
          'assets/images/splash_image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
