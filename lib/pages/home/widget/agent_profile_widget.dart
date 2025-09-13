import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/home/model/home_model.dart';
import 'package:property_rental_app/universal_models/rating_model.dart';

class AgentProfileWidget extends StatelessWidget {
  const AgentProfileWidget({
    super.key,
    required this.agentProfileModel,
  });

  final RatingModel agentProfileModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 6,
            right: 6,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(1, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     border: Border.all(
              //       color: const Color(0xFF6C63FF),
              //     ),
              //   ),
              //   padding: const EdgeInsets.all(2),
              //   child: CircleAvatar(
              //     radius: 20,
              //     backgroundImage: AssetImage(
              //       'assets/images/profile_1.png',
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 8,
              ),
              Text(
                agentProfileModel.userName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: blackColor3B,
                  fontFamily: 'Avenir',
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 190,
                child: Text(
                  agentProfileModel.reviewText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 20,
          child: SvgPicture.asset(
            'assets/icons/comma.svg',
            height: 12,
            width: 12,
          ),
        )
      ],
    );
  }
}
