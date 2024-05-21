import 'package:flutter/material.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    required this.trailing,
    this.iconColor,
  });

  final String icon;
  final String trailing;
  final String title;
  final Color? iconColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  icon,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: blackColor3B,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Avenir',
                  ),
                ),
              ],
            ),
            Image.asset(
              trailing,
              height: 24,
              width: 24,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
