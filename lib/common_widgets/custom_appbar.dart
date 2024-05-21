import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.isBackButton,
    required this.title,
    this.isBottomBorder = true,
    this.isSuffixIcon,
    this.leftTap,
    this.suffixWidget,
  });

  final bool? isBackButton;
  final void Function()? leftTap;
  final bool? isSuffixIcon;
  final bool? isBottomBorder;
  final String title;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isBottomBorder == true
            ? const Border(
                bottom: BorderSide(width: 1, color: greyBorderColor),
              )
            : const Border(),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 50, left: 20, bottom: 16, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isBackButton == true
                ? GestureDetector(
                    onTap:leftTap?? () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/icons/left_arrow.png",
                      height: 24,
                      width: 24,
                    ),
                  )
                : Container(
                    height: 24,
                    width: 24,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontSize: 20,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w600,
                    // letterSpacing: -0.32,
                  ),
                )
              ],
            ),
            isSuffixIcon == true
                ? suffixWidget!
                : Container(
                    height: 24,
                    width: 24,
                  ),
          ],
        ),
      ),
    );
  }
}
