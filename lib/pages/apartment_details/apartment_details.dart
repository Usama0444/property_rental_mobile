import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_rental_app/common_widgets/custom_appbar.dart';
import 'package:property_rental_app/common_widgets/global_functions.dart';
import 'package:property_rental_app/common_widgets/video_widget.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:property_rental_app/pages/apartment_details/controller/apartment_details_controller.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/pages/apartment_details/widget/select_your_reservation.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../common_widgets/custom_button.dart';
import '../../main.dart';
import '../../universal_models/favourites_model.dart';
import 'widget/select_reservation_check_in.dart';
import 'widget/book_tour_widget.dart';
import 'widget/expansion_widget.dart';
import 'widget/feedback_widget.dart';
import 'widget/slider_property.dart';
import 'widget/tips_for_safety.dart';

class ApartmentDetails extends StatelessWidget {
  ApartmentDetails(
      {super.key,
      this.isForSale,
      this.listingId,
      required this.comingFromMyAdd});

  final apartmentDetailsController = Get.put(ApartmentDetailsController());
  final bool? isForSale;
  final String? listingId;
  final bool? comingFromMyAdd;

  @override
  Widget build(BuildContext context) {
    // updateUserToken();
    print(listingId);

    ///added dummy Id
    // apartmentDetailsController.addMarker();
    return Scaffold(
      backgroundColor: backgroundColor,
      persistentFooterButtons: [
        comingFromMyAdd != true
            ? BookTourWidget(
                isSale: isForSale,
                listingID: listingId!,
                comingFromMyAdd: comingFromMyAdd)
            : const SizedBox()
      ],
      body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('listings')
      .doc(listingId)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Padding(
        padding: EdgeInsets.only(top: Get.height / 2, left: Get.width / 9),
        child: const Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return const Text('Error loading listing data');
    }
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Text('Data doesn\'t exist');
    }
    AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(snapshot.data!);
    apartmentDetailsController.addMarker(
        listingModel.latitude, listingModel.longitude);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: '',
                leftTap: () {
                  if (comingFromMyAdd == true) {
                    Get.offAll(() => BottomNavBar());
                  } else {
                    Get.back();
                  }
                },
                isBackButton: true,
                isSuffixIcon: true,
                isBottomBorder: false,
                suffixWidget: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final box = context.findRenderObject() as RenderBox?;
                        await Share.share(
                          'Share',
                          subject: 'Are your want to share',
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                      child: Image.asset(
                        'assets/icons/share.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    comingFromMyAdd == false
                        ? FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('favourites')
      .doc(listingId)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    print("$listingId +'/////'");
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Padding(
        padding: EdgeInsets.only(
          top: Get.height / 2,
          right: Get.width / 3,
        ),
        child: const Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return const Text('Error loading favourites data');
    }
    FavouriteModel? model;

    if (!snapshot.hasData || !snapshot.data!.exists) {
      print('data doesnts');
      model = FavouriteModel.initialize();
    } else {
      print('data ecxists');
      model = FavouriteModel.fromDocumentSnapshot(snapshot.data!);
    }

                              return GestureDetector(
                                onTap: () {
                                  if (!snapshot.data!.exists) {
                                    FirebaseFirestore.instance
                                        .collection('favourites')
                                        .doc(listingId)
                                        .set({
                                      'likes': [auth.currentUser!.uid]
                                    }).then((value) {
                                      print('jskbvf');
                                    }).onError((error, stackTrace) {
                                      print(error.toString());
                                    });
                                  } else {
                                    if (model!.likes
                                        .contains(auth.currentUser!.uid)) {
                                      model.likes.remove(auth.currentUser!.uid);
                                      // listOfLikes.remove(index);
                                    } else {
                                      model.likes.add(auth.currentUser!.uid);

                                      // listOfLikes.add(index);
                                    }

                                    FirebaseFirestore.instance
                                        .collection('favourites')
                                        .doc(listingId)
                                        .update({'likes': model.likes});
                                  }

                                  // searchModelUI.isFavourite.value = !searchModelUI.isFavourite.value;
                                },
                                child: Obx(
                                  () => Image.asset(
                                    model!.likes.contains(auth.currentUser!.uid)
                                        ? 'assets/icons/favourite_fill.png'
                                        : 'assets/icons/favourite_unfill.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox()

                    // GestureDetector(
                    //   onTap: () {
                    //     apartmentDetailsController.isFavourite.value =
                    //         !apartmentDetailsController.isFavourite.value;
                    //   },
                    //   child: Obx(
                    //     () => Image.asset(
                    //       apartmentDetailsController.isFavourite.value == true
                    //           ? 'assets/icons/favourite_fill.png'
                    //           : 'assets/icons/favourite_unfill.png',
                    //       height: 24,
                    //       width: 24,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              /// image and slider listview...

              SizedBox(
                  height: listingModel.listingImages.length == 1
                      ? 255
                      : Get.height * 0.6,
                  child: Stack(
                    children: [
                      ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: listingModel.listingImages.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Image.network(
                                  listingModel.listingImages[index].value,
                                  width: Get.width,
                                  height: 246,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return PlayVideo(
                                      path: listingModel
                                          .listingImages[index].value,
                                    );
                                  },
                                ),
                                Container(
                                  height: index== listingModel.listingImages.length?30: 8,
                                  width: Get.width,
                                  color: whiteColor,
                                ),
                              ],
                            );
                          }),
                      Positioned(
                          bottom: 0,
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100))),
                            // color: Colors.orange,
                            height: 25,
                            width: Get.width,
                            // child: Icon(Icons.expand_less,color:Colors.grey.withOpacity(0.5) ,fill:0.2 ,size: 40,),
                            child: Center(
                                child: Image.asset(
                              'assets/images/arrow up.png',
                              color: Colors.grey.withOpacity(0.5),
                              height: 14,
                              width: 44,
                              fit: BoxFit.cover,
                            )),
                          ))
                    ],
                  )),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            listingModel.propertyName.text,
                            // 'KSH 2350/Night',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w800,
                              color: blackColor3B,
                              fontSize: 20,
                              fontFamily: 'Avenir',
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: skyColor,
                          //       borderRadius: BorderRadius.circular(26)),
                          //   padding: const EdgeInsets.only(
                          //       left: 8, right: 12, top: 4, bottom: 4),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         'assets/icons/verified_icon.png',
                          //         height: 16,
                          //         width: 16,
                          //       ),
                          //       const Text(
                          //         'Verified',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w600,
                          //           color: blueLightColor,
                          //           fontSize: 12,
                          //           fontFamily: 'Avenir',
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CustomButton(
                    //       text: listingModel.listingRole.value != 'Rent'
                    //           ? 'Book a Tour'
                    //           : 'Book Now',
                    //       height: 44,
                    //       width: 133,
                    //       onPressed: () {
                    //         listingModel.listingRole.value != 'Rent'
                    //             ? reservationBottomSheet(listingModel.sellerID)
                    //             : reservationCheckInBottomSheet();
                    //       }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        listingModel.propertyType.value,
                        // 'Treeline apartment',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: blackColor,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/location_icon.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              listingModel.street.text +
                                  ", " +
                                  listingModel.town.text +
                                  ", " +
                                  listingModel.countryName.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              // 'Nairobi,GITARU, OFF NAIROBI-N..',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: blackColor,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Divider...
                    const SizedBox(height: 16),
                    const Divider(
                      color: greyBorderColor,
                      height: 1,
                    ),

                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Highlights',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: blackColor3B,
                                fontSize: 20,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              color: const Color(0xFFF3F3F3),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'No of rooms',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: blackColor3B,
                                      fontSize: 16,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  Text(
                                    listingModel.selectedBedroom.last,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: blackColor3B,
                                      fontSize: 16,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(
                                listingModel.facilities.length,
                                (index) => Container(
                                  color: index.isEven
                                      ? whiteColor
                                      : const Color(0xFFF3F3F3),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 15,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        listingModel.facilities[index],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: blackColor3B,
                                          fontSize: 16,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                      const Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: blackColor3B,
                                          fontSize: 16,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Tips for your safety widget....
                            const TipsforSafety(),

                            listingModel.indicatePayList.first.extraCost.text !=
                                    ''
                                ? Column(
                                    children: List.generate(
                                      listingModel.indicatePayList.length,
                                      (index) => Container(
                                        color:
                                            // index.isEven ?
                                            whiteColor,
                                        // : const Color(0xFFF3F3F3),
                                        padding: const EdgeInsets.symmetric(
                                          // horizontal: 12,
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 32),
                                            index == 0 &&
                                                    listingModel
                                                            .indicatePayList[
                                                                index]
                                                            .extraCost
                                                            .text !=
                                                        ''
                                                ? const Text(
                                                    'Extra Payment',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: blackColor3B,
                                                      fontSize: 16,
                                                      fontFamily: 'Avenir',
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(height: 4),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  listingModel
                                                      .indicatePayList[index]
                                                      .extraName
                                                      .text,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: blackColor3B,
                                                    fontSize: 16,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                                Text(
                                                  ' KSH ${listingModel.indicatePayList[index].extraCost.text}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: textColor
                                                        .withOpacity(0.7),
                                                    fontSize: 14,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                            // Text(
                            //   listingModel.description.text,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     color: textColor.withOpacity(0.7),
                            //     fontSize: 14,
                            //     fontFamily: 'Avenir',
                            //   ),
                            // ),
                            SizedBox(
                                height: listingModel.indicatePayList.length != 0
                                    ? 32
                                    : 0),

                            const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: blackColor3B,
                                fontSize: 16,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              listingModel.description.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textColor.withOpacity(0.7),
                                fontSize: 14,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Where will you be',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: blackColor3B,
                                fontSize: 16,
                                fontFamily: 'Avenir',
                              ),
                            ),
                            const SizedBox(height: 12),

                            ///
                            ///  Map portion...
                            ///
                            Container(
                              height: 220,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                              child: Obx(
              () => apartmentDetailsController.isLoading.value == false
                  ? const SizedBox()
                  : GoogleMap(
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      markers: apartmentDetailsController.markers,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(listingModel.latitude, listingModel.longitude),
                        zoom: 14,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        if (!apartmentDetailsController.mapController.isCompleted) {
                          apartmentDetailsController.mapController.complete(controller);
                        }
                      },
                    ),
            ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            ///book widget
                            Container(
                                height: 78,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 3,
                                        blurRadius: 10)
                                  ],
                                ),
                                width: Get.width,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                child:FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('listings')
      .doc(listingId!)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox();
    }
    if (snapshot.hasError) {
      print(snapshot.error.toString());
      return const Text('Error loading listing data');
    }
    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Text('Data doesn\'t exist');
    }
    AddListingModel listingModel = AddListingModel.fromDocumentSnapshot(snapshot.data!);

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                                 showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Allows dynamic height
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7, // Takes 70% of screen height initially
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header with title and close button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Property Reviews',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                              size: 24,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    // Feedback list
                    Expanded(
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('feedbacks')
      .where('propertyID', isEqualTo: listingId)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot2) {
    if (snapshot2.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    if (snapshot2.hasError) {
      print('Error: ${snapshot2.error}');
      return const Center(
        child: Text(
          'Error loading feedback',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 14,
            color: Colors.redAccent,
          ),
        ),
      );
    }
                          if (!snapshot2.hasData || snapshot2.data!.docs.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No feedback available',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Build feedback list
                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: snapshot2.data!.docs.length,
                            itemBuilder: (context, index) {
                              var feedback = snapshot2.data!.docs[index];
                              String buyerID = feedback['buyerID'];
                              String feedbackText = feedback['feedback'];
                              String orderDate = feedback['orderDate'];

                              // Fetch buyer name
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(buyerID)
                                    .get(),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                                    return const ListTile(
                                      title: Text(
                                        'Loading...',
                                        style: TextStyle(fontFamily: 'Avenir'),
                                      ),
                                    );
                                  }
                                  if (userSnapshot.hasError) {
                                    print('Error fetching user: ${userSnapshot.error}');
                                    return const ListTile(
                                      title: Text(
                                        'Error loading user',
                                        style: TextStyle(
                                          fontFamily: 'Avenir',
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    );
                                  }

                                  String buyerName = userSnapshot.data!.exists
                                      ? userSnapshot.data!['userName'] ?? 'Unknown User'
                                      : 'Unknown User';

                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.blue.shade100,
                                                child: Text(
                                                  buyerName[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Avenir',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  buyerName,
                                                  style: const TextStyle(
                                                    fontFamily: 'Avenir',
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            feedbackText,
                                            style: const TextStyle(
                                              fontFamily: 'Avenir',
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                orderDate,
                                                style: const TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
     
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listingModel.listingRole != 'Rent'
                                                    ? 'KSH ${listingModel.payment.text}'
                                                    : 'KSH ${listingModel.payment.text}/Night',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: blackColor3B,
                                                  fontSize: 16,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              // listingModel.listingRole == 'Rent'
                                              //     ?
                                              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('feedbacks')
      .where('propertyID', isEqualTo: listingId!)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (data, _) => data,
      )
      .get(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot2) {
    if (snapshot2.connectionState == ConnectionState.waiting) {
      return const SizedBox();
    }
    if (snapshot2.hasError) {
      print(snapshot2.error.toString());
      return const Center(
        child: Text(
          'Error loading feedback',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 14,
            color: Colors.redAccent,
          ),
        ),
      );
    }
                                                    // if (snapshot2.data!.docs.isEmpty) {
                                                    //   return SizedBox();
                                                    // }
                                                    return Text(
                                                      '${snapshot2.data!.docs.length == 0 ? 0 : snapshot2.data!.docs.length} Reviews',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: blackColor3B,
                                                        fontSize: 12,
                                                        fontFamily: 'Avenir',
                                                      ),
                                                    );
                                                  })
                                              // : Text(
                                              //     isForSale == true
                                              //         ? 'Click to add tour details'
                                              //         : '13+ Reviews',
                                              //     style: const TextStyle(
                                              //       fontWeight: FontWeight.w700,
                                              //       color: blackColor3B,
                                              //       fontSize: 12,
                                              //       fontFamily: 'Avenir',
                                              //     ),
                                              //   ),
                                            ],
                                          ),
                                        ),
                                        comingFromMyAdd == false
                                            ? CustomButton(
                                                text:
                                                    listingModel.listingRole !=
                                                            'Rent'
                                                        ? 'Book a Tour'
                                                        : 'Book Now',
                                                height: 44,
                                                width: 133,
                                                onPressed: () {
                                                  print(listingModel.sellerID);
                                                  print(listingModel
                                                      .description.text);
                                                  print('listingID');
                                                  listingModel.listingRole !=
                                                          'Rent'
                                                      ? reservationBottomSheet(
                                                          listingModel.sellerID,
                                                          listingModel,
                                                          listingId!)
                                                      : reservationCheckInBottomSheet(
                                                          listingModel:
                                                              listingModel,
                                                          listingID:
                                                              listingId!);
                                                })
                                            : const SizedBox()
                                      ],
                                    );
                                  },
                                )),

                            SizedBox(height: comingFromMyAdd != true ? 32 : 0),

                            /// feedback widget...
                            comingFromMyAdd != true
                                ? FeedBackWidget(
                                    propertyID: listingModel.docId,
                                    sellerID: listingModel.sellerID)
                                : const SizedBox(),
                            SizedBox(height: comingFromMyAdd != true ? 20 : 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                comingFromMyAdd != true
                                    ? const Text(
                                        'Recommended Properties',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: blackColor,
                                          fontFamily: 'Avenir',
                                        ),
                                      )
                                    : const SizedBox(),
                                // GestureDetector(
                                //   onTap: () {
                                //     Get.back();
                                //   },
                                //   child: Row(
                                //     children: [
                                //       const Text(
                                //         'View All',
                                //         style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w800,
                                //           color: primaryColor,
                                //           fontFamily: 'Avenir',
                                //         ),
                                //       ),
                                //       const SizedBox(
                                //         width: 4,
                                //       ),
                                //       Image.asset(
                                //         'assets/icons/arrow_right.png',
                                //         height: 16,
                                //         width: 16,
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ]),
                    ),

                    /// property slider widget...

                    comingFromMyAdd != true
                        ? RecommendedProperties()
                        : const SizedBox(),

                    // const SizedBox(height: 24),
                    // Obx(
                    //   () => Center(
                    //     child: PageViewDotIndicator(
                    //       currentItem: apartmentDetailsController.initialIndex.value,
                    //       count: apartmentDetailsController.bedsittersList.length,
                    //       unselectedColor: lightGreyD9,
                    //       selectedColor: primaryColor,
                    //       size: const Size(40, 6),
                    //       unselectedSize: const Size(22, 6),
                    //       duration: const Duration(milliseconds: 200),
                    //       margin: const EdgeInsets.symmetric(horizontal: 4),
                    //       padding: EdgeInsets.zero,
                    //       alignment: Alignment.center,
                    //       fadeEdges: false,
                    //       boxShape: BoxShape.rectangle,
                    //       //defaults to circle
                    //       borderRadius: BorderRadius.circular(50),
                    //       //only for rectangle shape
                    //       onItemClicked: (index) {
                    //         apartmentDetailsController.initialIndex.value = index;
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 36),
                    const Center(
                      child: Text(
                        "FAQs",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Text(
                          'Answers to a few questions are given here.',
                          // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            fontFamily: 'Avenir',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),

                    ListView.builder(
                      itemCount:
                          apartmentDetailsController.expansionList.length,
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ExpansionWidget(
                            title: apartmentDetailsController
                                .expansionList[index]['title'],
                            subTitle: apartmentDetailsController
                                .expansionList[index]['subTitle'],
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 34,
                    )
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Future<String?> videoThumbnail({required String urlForThumbnail}) async {
    print(urlForThumbnail + '1111111111111111===========');
    try {
      final uniqueFilename = '${DateTime.now().millisecondsSinceEpoch}.webp';
      var fileName = await VideoThumbnail.thumbnailFile(
        video: urlForThumbnail,
        quality: 75,
        // thumbnailPath: (await getTemporaryDirectory()).path,
        thumbnailPath:
            (await getTemporaryDirectory()).path + '/$uniqueFilename',
        imageFormat: ImageFormat.WEBP,
      );

      // print('${fileName}file 41');
      return fileName;
    } catch (error) {
      print('Error generating thumbnail: $error');
      return null; // Or provide a default file path if needed
    }
  }
}
// Container(
//   child: Column(
//     children: [
//       Obx(() => GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     contentPadding: EdgeInsets.zero,
//                     // insetPadding:  EdgeInsets.symmetric(
//                     //     horizontal: 12, vertical: listingModel
//                     //     .listingImages.length>=2?32:2),
//                     insetPadding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical:
//                             listingModel.listingImages.length >= 2
//                                 ? 32
//                                 : 200),
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6)),
//                     content: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           topRight: Radius.circular(6),
//                         ),
//                       ),
//
//                       constraints: BoxConstraints(
//                         // minHeight: 52,
//                         // maxHeight: Get.height,
//                         maxWidth: Get.width,
//                         minWidth: Get.width,
//                       ),
//                       child: Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () => Get.back(),
//                             child: Container(
//                               width: Get.width,
//                               height: 48,
//                               decoration: const BoxDecoration(
//                                 color: blackColor3B,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(6),
//                                   topRight: Radius.circular(6),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 12),
//                               child: Image.asset(
//                                 'assets/icons/close-circle.png',
//                                 alignment: Alignment.centerRight,
//                                 height: 24,
//                                 width: 24,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: ListView.builder(
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 itemCount: listingModel
//                                     .listingImages.length,
//                                 itemBuilder: (context, index) {
//                                   return Column(
//                                     children: [
//                                       Image.network(
//                                         listingModel
//                                             .listingImages[index]
//                                             .value,
//                                         width: Get.width,
//                                         height: 246,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context,
//                                             error, stackTrace) {
//                                           return PlayVideo(
//                                             path: listingModel
//                                                 .listingImages[
//                                                     index]
//                                                 .value,
//                                           );
//                                         },
//                                       ),
//                                       Container(
//                                         height: 8,
//                                         width: Get.width,
//                                         color: whiteColor,
//                                       ),
//                                     ],
//                                   );
//                                 }),
//                           ),
//                           Container(
//                             width: Get.width,
//                             height: 8,
//                             decoration: const BoxDecoration(
//                               color: whiteColor,
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(6),
//                                 bottomRight: Radius.circular(6),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Stack(
//               children: [
//                 Image.network(
//                   ////////////
//                   apartmentDetailsController.isSelected.value ==
//                           true
//                       ? apartmentDetailsController
//                                   .isSelectedImage.value ==
//                               ''
//                           ? listingModel.listingImages[0].value
//                           : apartmentDetailsController
//                               .isSelectedImage.value
//                       : listingModel.listingImages[0].value,
//                   width: Get.width,
//                   height: 246,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return FutureBuilder(
//                       future: videoThumbnail(
//                           urlForThumbnail:
//                               apartmentDetailsController
//                                           .isSelectedImage
//                                           .value ==
//                                       ''
//                                   ? listingModel
//                                       .listingImages[0].value
//                                   : apartmentDetailsController
//                                       .isSelectedImage.value),
//                       builder: (context, snapshot) {
//                         print(snapshot.data.toString());
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return SizedBox(
//                               width: Get.width,
//                               height: 246,
//                               child: const Center(
//                                   child:
//                                       CircularProgressIndicator(
//                                 color: primaryColor,
//                               )));
//                         }
//                         if (snapshot.hasError) {
//                           print(snapshot.error.toString());
//                           print('error');
//                         }
//                         if (snapshot.connectionState ==
//                             ConnectionState.done) {
//                           return SizedBox(
//                               width: Get.width,
//                               height: 246,
//                               child: Image.file(
//                                 File(snapshot.data.toString()),
//                                 width: Get.width,
//                                 height: 246,
//                                 fit: BoxFit.cover,
//                               ));
//                         } else {
//                           return const SizedBox(
//                               width: 80,
//                               height: 55,
//                               child: Center(child: SizedBox()));
//                         }
//                       },
//                     );
//                   },
//                 ),
//                 Positioned(
//                   bottom: 8,
//                   left: 12,
//                   child: Container(
//                     height: 22,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 3, horizontal: 6),
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${apartmentDetailsController.index.value + 1} / ${listingModel.listingImages.length}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: whiteColor,
//                           fontSize: 12,
//                           fontFamily: 'Avenir',
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )),
//       const SizedBox(height: 8),
//       Padding(
//         padding: const EdgeInsets.only(left: 16),
//         child: SizedBox(
//           height: 55,
//           child: ListView.builder(
//             itemCount: listingModel.listingImages.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   apartmentDetailsController.isSelected.value =
//                       true;
//                   apartmentDetailsController
//                           .isSelectedImage.value =
//                       listingModel.listingImages[index]
//                           .toString();
//
//                   apartmentDetailsController.index.value = index;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 8),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(
//                           color: const Color(0xFF6C757D),
//                           width: 1),
//                     ),
//                     child: Image.network(
//                       listingModel.listingImages[index].value,
//                       width: 80,
//                       height: 55,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return FutureBuilder(
//                           future: videoThumbnail(
//                               urlForThumbnail: listingModel
//                                   .listingImages[index].value),
//                           builder: (context, snapshot) {
//                             print(snapshot.data.toString());
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const SizedBox(
//                                   width: 80,
//                                   height: 55,
//                                   child: Center(
//                                       child:
//                                           CircularProgressIndicator(
//                                     color: primaryColor,
//                                   )));
//                             }
//                             if (snapshot.hasError) {
//                               print(snapshot.error.toString());
//                               print('error');
//                             }
//                             if (snapshot.connectionState ==
//                                 ConnectionState.done) {
//                               return SizedBox(
//                                   width: 80,
//                                   height: 55,
//                                   child: Image.file(
//                                     File(
//                                         snapshot.data.toString()),
//                                     fit: BoxFit.cover,
//                                     width: 80,
//                                     height: 55,
//                                   ));
//                             } else {
//                               return const SizedBox(
//                                   width: 80,
//                                   height: 55,
//                                   child:
//                                       Center(child: SizedBox()));
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
