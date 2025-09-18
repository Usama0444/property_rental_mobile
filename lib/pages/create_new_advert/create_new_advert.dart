import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_button.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/tell_us_about/tell_us_about.dart';
import 'widget/new_advert_widget.dart';

class CreateNewAdvert extends StatelessWidget {
  const CreateNewAdvert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Begin Your Journey with HSL Homes in Just a Few Simple Steps!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: blackColor3B,
                  fontSize: 20,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
            const SizedBox(height: 25),
            const NewAdvertWidget(
              noCount: 1,
              title: 'Tell us about your place',
              description:
                  'Share some basic info about your property like where it is, how many guests can stay & description',
            ),  const Divider(
              color: greyBorderColor,
              height: 1,
            ),
            const SizedBox(height: 25),
            const NewAdvertWidget(
              noCount: 2,
              title: 'Make it stand out',
              description:
                  'Upload eye catching 6 or more images to make your property to stand out of others.',
            ),  const Divider(
              color: greyBorderColor,
              height: 1,
            ),
            const SizedBox(height: 25),
            const NewAdvertWidget(
              noCount: 3,
              title: 'Select facilities in your property',
              description:
                  'With one tap, Select all facilities available in your property like security camera, wardrobe etc',
            ),  const Divider(
              color: greyBorderColor,
              height: 1,
            ),
            const SizedBox(height: 25),
            const NewAdvertWidget(
              noCount: 4,
              title: 'Finish and publish',
              description:
                  'Hit publish to showcase your property to eager buyers on our app',
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 24),
              child: CustomButton(
                  text: 'Continue',
                  height: 44,
                  width: Get.width,
                  onPressed: () {
                    Get.to(() => const TellUsAbout());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
