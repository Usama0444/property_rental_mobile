import 'package:flutter/material.dart';
import 'package:property_rental_app/constants/app_colors.dart';

class NewAdvertWidget extends StatelessWidget {
  const NewAdvertWidget({
    super.key,
    required this.noCount,
    required this.title,
    required this.description,
  });

  final int noCount;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noCount.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: blackColor3B,
                    fontSize: 16,
                    fontFamily: 'Avenir',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: blackColor3B,
                          fontSize: 16,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        description,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: blackColor3B,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
