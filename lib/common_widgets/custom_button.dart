import 'package:flutter/material.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? buttonIconWidth;
  final String text;
  final double fontSize;
  final double? height;
  final double horizontalPadding;
  final double suffixTextIconWidth;
  final double verticalPadding;
  final double borderRadius;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final bool isBorder;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final bool isPrefixIcon;
  final Color? iconColor;
  final String? fontFamily;
  final Color borderColor;
  final double? borderWidth;
  final double? suffixIconSize;
  final bool showWidget;
  final Widget? widget;
  final Widget? prefixIcon;
  final bool showGradient;
  final void Function()? onPressed;

  const CustomButton({
    Key? key,
    this.width = 140,
    this.height = 40,
    this.buttonIconWidth = 12,
    required this.text,
    this.fontSize = 16,
    this.horizontalPadding = 8,
    this.verticalPadding = 8,
    this.borderRadius = 5,
    this.fontWeight = FontWeight.w600,
    this.backgroundColor = Colors.transparent,
    this.textColor = whiteColor,
    this.elevation = 0,
    this.isBorder = false,
    this.isSuffixIcon = false,
    this.suffixIcon,
    this.isPrefixIcon = false,
    this.showWidget = false,
    this.widget,
    this.prefixIcon,
    this.iconColor = whiteColor,
    this.fontFamily = 'Avenir',
    this.borderColor = greyBorderColor,
    this.borderWidth = 1,
    this.suffixIconSize = 24,
    this.showGradient = true,
    required this.onPressed,
    this.suffixTextIconWidth = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
        color: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: elevation,
        height: height,
        shape: RoundedRectangleBorder(
          side: isBorder == true
              ? BorderSide(
                  color: borderColor,
                  width: borderWidth ?? 5,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor,
        minWidth: width,
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isPrefixIcon == true && prefixIcon != null)
              Container(child: prefixIcon),
            if (isPrefixIcon == true && prefixIcon != null)
              SizedBox(width: buttonIconWidth),
            showWidget == true
                ? Container(
                    child: widget,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      fontFamily: fontFamily,
                      color: textColor,
                    ),
                  ),
            if (isSuffixIcon == true && suffixIcon != null)
              SizedBox(
                width: suffixTextIconWidth,
              ),
            if (isSuffixIcon == true && suffixIcon != null)
              Container(child: suffixIcon),
          ],
        ),
      ),
    );
  }
}
