import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/controller/bottom_bar_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/my_activity/recent_searches_data_screen.dart';
import 'package:property_rental_app/universal_models/recent_searches_model.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({
    super.key,
    required this.rcModel,
  });
  final RecentSearchesModel rcModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: greyBorderColor,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/residentail.png',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Residential property',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: blackColor3B,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/search_icon.png',
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search based on : ${rcModel.search.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: blackColor3B,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.find<BottomNavController>().tabIndex.value = 1;
              Get.to(() => RecentSearchesResultScreen(
                    searchText: rcModel.search.toString(),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/icons/right_angle.png',
                height: 24,
                width: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
