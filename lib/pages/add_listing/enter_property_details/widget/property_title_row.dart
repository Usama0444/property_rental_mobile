import 'package:flutter/material.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class PropertyTitleRow extends StatelessWidget {
  const PropertyTitleRow({
    super.key,
    required this.title,
    this.isRequired = true,
  });

  final String title;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: blackColor3B,
            fontFamily: 'Avenir',
          ),
        ),
        isRequired == true
            ? const Text(
                '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontFamily: 'Avenir',
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
