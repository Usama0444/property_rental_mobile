import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/pages/splash/carousel.dart';

import '../../common_widgets/custom_button.dart';
import '../../constants/app_colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after 5 seconds
    // Future.delayed(const Duration(seconds: 5), () {
    //   // Replace 'NextPage' with the actual route or widget you want to navigate to
    //   Get.to(() => CaroselSlider());
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'assets/images/image for dtart.png',
              height: Get.height * 0.7 ,
              fit: BoxFit.contain,
            ),
          ),
          const Text(
            'Welcome to',
            style: TextStyle(
              fontSize: 24     ,
              fontWeight: FontWeight.w600,
              // color:  primaryColor,
              fontFamily: 'Avenir',
            ),
          ),
          const Text(
            'Realtime Estates Ltd',
            style: TextStyle(
              fontSize: 25 ,
              fontWeight: FontWeight.w900,
              color: primaryColor,
              // fontWeight: FontWeight.bold,
              fontFamily: 'Avenir',
            ),
          ),

          SizedBox(height: 8,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal:24),
            child: Text(
              'The best real estate application in Kenya to complete your life and family',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Avenir',
              ),
            ),
          ),
          SizedBox(height: 18,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButton(
                text: 'Next',
                height: 44,
                width: Get.width,
                onPressed: () async {
                  Get.to(() => CaroselSlider());
                }),
          ),
        ],
      ),
    );
  }
}
