import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/profile_listtile.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/profile/update_password/update_password.dart';
import 'widget/delete_bottomsheet.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          const CustomAppBar(
            title: 'Settings',
            isBackButton: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ProfileListTile(
                  icon: 'assets/icons/password.png',
                  title: 'Update Password',
                  trailing: 'assets/icons/right_angle.png',
                  onTap: () {
                    Get.to(() => UpdatePassword());
                  },
                ),
                const SizedBox(height: 24),
                const Divider(color: greyBorderColor, height: 1),
                const SizedBox(height: 24),
                ProfileListTile(
                  icon: 'assets/icons/delete.png',
                  title: 'Delete Account',
                  trailing: 'assets/icons/right_angle.png',
                  onTap: () {
                    deleteBottomSheet();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }
}
