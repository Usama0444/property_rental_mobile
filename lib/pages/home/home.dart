import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/custom_text_field.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/home/all_featured_listings.dart';
import 'package:property_rental_app/pages/home/all_new_listings.dart';
import 'package:property_rental_app/pages/home/all_recommended_listings.dart';
import 'package:property_rental_app/pages/home/controller/home_controller.dart';
import 'package:property_rental_app/pages/home/widget/filter_bottomsheet.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'widget/agent_profile_widget.dart';
import 'widget/bedsitter_widget.dart';
import 'widget/browse_property.dart';
import 'widget/buy_rent_widget.dart';
import 'widget/fab_button.dart';
import 'widget/rentbuy_button.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const SizedBox(
        width: 145,
        child: FabButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 286,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: whiteColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        alignment: Alignment.bottomCenter,
                        'assets/images/home_image_2.png',
                        // height: 220,
                        width: 400,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 68, left: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                      width: 124,
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                height: 286,
                color: primaryColor.withOpacity(0.1),
              ),
              Positioned(
                bottom: 16,
                left: 22,
                right: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RentBuyButton(key: key,),
                    const SizedBox(
                      height: 11,
                    ),
                    SizedBox(
                      width: Get.width,
                      child: GestureDetector(
                        onTap: () {
                          filterBottomSheet();
                        },
                        child: CustomTextField(
                          hintText: 'Search for City, Community or Building',
                          controller: controller.searchController,
                          fillColor: whiteColor,
                          isSuffixIcon: true,
                          enabled: false,
                          suffixIcon: Image.asset(
                            'assets/icons/search_icon.png',
                            height: 20,
                            width: 20,
                            scale: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 16,
              // ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),

                  // /// Sell your property...
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: SellYourProperty(),
                  // ),
                  const SizedBox(height: 24),

                  /// Browse property by categories...
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BrowsProperty(propertyType:controller.propertyType2.value ),
                  ),

                  const SizedBox(height: 24),

                  /// Buy property widget...

                  BuyRentWidget(),

                  const SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommended Listings',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(()=> AllRecommendedListings());
                                // Get.find<BottomNavController>().tabIndex.value =
                                //     1;
                                // Get.to(() => BottomNavBar());
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    'assets/icons/arrow_right.png',
                                    height: 16,
                                    width: 16,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                  FutureBuilder(
  future: FirebaseFirestore.instance
      .collection('bookings')
      .where('orderStatus', isNotEqualTo: 'Completed')
      .get(),
  builder: (context, bookingSnapshot) {
    if (bookingSnapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (bookingSnapshot.hasError) {
      print(bookingSnapshot.error.toString());
      return Text('Error: ${bookingSnapshot.error}');
    }

    final currentDate = DateTime.now().millisecondsSinceEpoch;
    final bookedProperties = bookingSnapshot.data?.docs
            .where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final checkOut = int.parse(data['checkOut'].toString());
              return currentDate <= (checkOut + 86400000);
            })
            .map((doc) => {
                  'propertyID': doc['propertyID'] as String,
                  'buyerID': doc['buyerID'] as String,
                })
            .toList() ??
        [];

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('listings')
          .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
          .where('isActive', isEqualTo: true)
          .where('isRecommended', isEqualTo: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }
        final availableListings = snapshot.data!.docs
            .where((doc) {
              final bookingForProperty = bookedProperties.firstWhere(
                (booking) => booking['propertyID'] == doc.id,
                orElse: () => {},
              );
              return bookingForProperty.isEmpty ||
                  bookingForProperty['buyerID'] == auth.currentUser!.uid;
            })
            .map((doc) => AddListingModel.fromDocumentSnapshot(doc))
            .toList();

        if (availableListings.isEmpty) {
          return const Text('No available listings');
        }
        return SizedBox(
          height: 120,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableListings.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final listingModel = availableListings[index];
              return BedsittersWidget(
                listingID: listingModel.docId,
                listingModel: listingModel,
              );
            },
          ),
        );
      },
    );
  },
),
                        const SizedBox(
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Featured Listings',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                 Get.to(()=> AllFeaturedListings());
                                // Get.find<BottomNavController>().tabIndex.value =
                                //     1;
                                // Get.to(() => BottomNavBar());
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                    'assets/icons/arrow_right.png',
                                    height: 16,
                                    width: 16,
                                  )
                                ]),
                            ),
                          ]),
                        const SizedBox(height: 8),
                        FutureBuilder(
  future: FirebaseFirestore.instance
      .collection('listings')
      .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
      .where('isActive', isEqualTo: true)
      .where('isFeatured', isEqualTo: true)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(color: primaryColor);
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Text('No data available');
    }
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          AddListingModel listingModel =
              AddListingModel.fromDocumentSnapshot(snapshot.data!.docs[index]);
          return BedsittersWidget(
            listingID: snapshot.data!.docs[index].id,
            listingModel: listingModel,
          );
        },
      ),
    );
  },
),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'New Listings',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                 Get.to(() => AllNewListings());
                                // Get.find<BottomNavController>().tabIndex.value =
                                //     1;
                                // Get.to(() => BottomNavBar());
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    'assets/icons/arrow_right.png',
                                    height: 16,
                                    width: 16,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                     FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('listings')
        .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
      .where('isActive', isEqualTo: true).where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime.now().subtract(const Duration(days: 2)), 
            ))
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        )
      // .where(Filter.and(
      //     Filter('sellerID', isNotEqualTo: auth.currentUser!.uid),
      //     Filter('selectedBedroom', arrayContainsAny: [
      //       "Studio",
      //       '0',
      //       '1',
      //       '2',
      //       '3'
      //     ])))
      // .where('isActive', isEqualTo: true)
      // .withConverter<Map<String, dynamic>>(
      //   fromFirestore: (snapshot, _) => snapshot.data()!,
      //   toFirestore: (data, _) => data,
      // )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Or any other loading indicator
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Text('No data available'); // Or any other empty state widget
    }
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          AddListingModel listingModel =
              AddListingModel.fromDocumentSnapshot(
                  snapshot.data!.docs[index]);
          return BedsittersWidget(
            listingID: snapshot.data!.docs[index].id,
            listingModel: listingModel,
          );
        },
      ),
    );
  },
),  const SizedBox(
                          height: 40,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'We Went An Extra Mile For Them!',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'What our users say about us',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Lörem ipsum oska öbel. Ilesorad openg bell medan krogen. Devis tis, fasamma kagon. Giganenade piktig kroledes pågt nisade. Mävus plan. Lörem ipsum oska öbel. ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                fontFamily: 'Avenir',
                              ), 
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Obx(() =>
                         SizedBox(
                            height: 216,
                            
                            child: controller.highRatings.isEmpty
                                ? const Center(child: Text('No Rating'))
                                :
                            ListView.builder(
                                itemCount: controller.highRatings.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AgentProfileWidget(
                                    agentProfileModel:
                                        controller.highRatings[index],
                                  );
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
