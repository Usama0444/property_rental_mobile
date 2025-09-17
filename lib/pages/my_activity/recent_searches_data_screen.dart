import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import '../../common_widgets/custom_appbar.dart';
import '../home/controller/home_controller.dart';
import '../search_screen/widget/search_property_widget.dart';

class RecentSearchesResultScreen extends StatelessWidget {
  RecentSearchesResultScreen({
    super.key,
    required this.searchText,
  });

  final controller = Get.put(HomeController());

  final String searchText;
  @override
  Widget build(BuildContext context) {
    print(searchText);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'Recent Search Results',
            isBackButton: true,
          ),
          const SizedBox(
            height: 8,
          ),
         Expanded(
  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('listings')
        .where(Filter.or(
          Filter('countryName', isEqualTo: searchText),
          Filter('street', isEqualTo: searchText),
          Filter('town', isEqualTo: searchText),
        ))
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
        .get(),
    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox();
      }
      if (snapshot.hasError) {
        print(snapshot.error.toString());
        return Text('Error: ${snapshot.error}');
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: Get.height / 3.5),
          child: const Center(
            child: SizedBox(
              child: Text(
                'No matched searches.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
          ),
        );
      }
      print(snapshot.data!.docs.length);
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              AddListingModel listingModel =
                  AddListingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SearchPropertyWidget(
                  listingId: snapshot.data!.docs[index].id,
                  searchModel: listingModel,
                ),
              );
            },
          ),
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }
}
