import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/my_activity/controller/my_activity_controller.dart';
import 'package:property_rental_app/pages/my_property_ads/widgets/property_ads_widget.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

class MyPropertyAds extends StatefulWidget {
  MyPropertyAds({super.key});

  @override
  _MyPropertyAdsState createState() => _MyPropertyAdsState();
}

class _MyPropertyAdsState extends State<MyPropertyAds> {
  final controller = Get.put(MyActivityController());
  late Future<QuerySnapshot<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _refreshFuture();
  }

  void _refreshFuture() {
    setState(() {
      _future = FirebaseFirestore.instance
          .collection('listings')
          .where('sellerID', isEqualTo: auth.currentUser!.uid)
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (snapshot, _) => snapshot.data()!,
            toFirestore: (data, _) => data,
          )
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(
            title: 'My Property Ads',
            isBackButton: true,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _future,
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Ads yet.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        fontSize: 14,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  );
                }
                final listings = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    AddListingModel listingModel =
                        AddListingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyAdsWidget(
                        listingId: snapshot.data!.docs[index].id,
                        searchModel: listingModel,
                        onActionComplete: _refreshFuture, // Pass callback to refresh
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}