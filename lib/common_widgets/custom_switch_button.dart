import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class CustomSwitchButtonWidget extends StatelessWidget {
  const CustomSwitchButtonWidget({
    Key? key,
    required this.status,
    required this.onToggle,
  }) : super(key: key);
  final bool status;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      activeToggleColor: whiteColor,
      inactiveToggleColor: whiteColor,
      activeColor: primaryColor,
      inactiveColor: const Color(0xFF696969),
      width: 39.0,
      height: 22.0,
      valueFontSize: 8.0,
      toggleSize: 16.0,
      value: status,
      borderRadius: 40.0,
      padding: 3.0,
      showOnOff: false,
      onToggle: onToggle,
    );
  }
}
