import 'package:flutter/material.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {

  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController controller;
  final String? labelText;
  final FontWeight? fontWeight;
  final bool? isSuffixIcon;
  final bool? isPrefixIcon;
  final String? hintText;
  final double borderRadius;
  final double borderWidth;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final double fontSize;
  final double? errorfontSize;
  final String? fontFamily;
  final int? maxLines;
  final Color? labelColor;
  final Color? hintColor;
  final Color? borderColor;
  final bool isBorder;
  final bool isShadow;
  final bool? filled;
  final Color? fillColor;
  final double elevation;
  final String? suffixText;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final void Function()? onTap;
  final bool readOnly;
  final bool autofocus;

  const CustomTextField({
    Key? key,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    required this.controller,
    this.labelText,
    this.enabled = true,
    this.maxLines = 1,
    this.hintText,
    this.errorfontSize,
    this.borderRadius = 4,
    this.borderWidth = 1,
    this.fontWeight = FontWeight.w500,
    this.suffixIcon,
    this.fontSize = 12,
    this.fontFamily = 'Avenir',
    this.isSuffixIcon = true,
    this.labelColor,
    this.hintColor = blackColor3B,
    this.borderColor = greyBorderColor,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isBorder = false,
    this.isShadow = false,
    this.filled = true,
    this.fillColor = whiteColor,
    this.elevation = 0,
    this.suffixText,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.hintStyle,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      ),
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: '∗',
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      cursorColor: primaryColor,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: filled,
        labelStyle: const TextStyle(
            color: blackColor3B, fontSize: 12, fontWeight: FontWeight.w500),
        labelText: labelText,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(width: 1.4, color: redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(width: 1.4, color: greyBorderColor)),
        disabledBorder: isBorder
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor ?? greyBorderColor)),
        hintText: hintText,
        errorStyle: TextStyle(
            color: redColor,
            fontSize: errorfontSize,
            fontFamily: 'Avenir',
            fontWeight: fontWeight ?? FontWeight.w800),
        hintStyle: TextStyle(
            color: hintColor,
            fontSize: fontSize ?? 14,
            fontFamily: 'Avenir',
            fontWeight: fontWeight ?? FontWeight.w800),
        contentPadding:
            const EdgeInsets.only(top: 16, left: 17, bottom: 0, right: 16),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor ?? greyBorderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: greyBorderColor)),
      ),
    );
  }
}
