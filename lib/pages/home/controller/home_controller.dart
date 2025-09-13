import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/no_internet_dialog.dart';
import 'package:property_rental_app/pages/home/model/home_model.dart';
import 'package:property_rental_app/universal_models/rating_model.dart';
import 'package:property_rental_app/universal_models/recent_searches_model.dart';
import 'package:property_rental_app/universal_models/viewed_property_model.dart';

import '../../../main.dart';

class HomeController extends GetxController {
    final highRatings = <RatingModel>[].obs;

  ViewedPropertyModel vpModel = ViewedPropertyModel.initialize();
  RecentSearchesModel rcModel = RecentSearchesModel.initialize();
    @override
  void onInit() {
    super.onInit();
    print(highRatings.length);
    fetchHighRatings();
  }

  Future<void> addSearches(
      // required propertyID,
      ) async {
    // rcModel.propertyID=propertyID;
    rcModel.search = filterSearchCtrl.text.toString();
    var data = await rcModel.toMap();
    var searchQuery = await FirebaseFirestore.instance
        .collection('recentSearches')
        .where('userID', isEqualTo: auth.currentUser!.uid)
        .where('search', isEqualTo: filterSearchCtrl.text.toString())
        .get();

    if (searchQuery.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('recentSearches')
          .add(data)
          .then((value2) async {
        // Get.back();
        print('done');
      }).onError((error, stackTrace) {
        print(error.toString());
        print('6==============error');
      });
    } else {
      print('Search already exists');
    }
  }
 Future<void> fetchHighRatings() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('starRating', isGreaterThanOrEqualTo: 4)
        .where('starRating', isLessThanOrEqualTo: 5)
        .orderBy('timestamp', descending: true)
        .get();
    print('Fetched ${querySnapshot.docs.length} documents');
    highRatings.assignAll(
      querySnapshot.docs.map((doc) {
        print('Document data: ${doc.data()}');
        return RatingModel.fromFirestore(doc);
      }).toList(),
    );
    print('highRatings length: ${highRatings.length}');
  } catch (e) {
    print('Error fetching high ratings: $e');
    Get.snackbar('Error', 'Failed to load ratings.');
  }
}
  Future<void> addViewProperty({
    required propertyID,
    /* required token*/
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetDialog();
    } else {
      // loadingDialog(message: 'Please wait !!', loading: true);
      var userDocRef = FirebaseFirestore.instance
          .collection('viewedProperty')
          .doc(auth.currentUser!.uid);
      userDocRef.get().then((value) async {
        print('2==============');

        if (value.exists) {
          print('auth exists');

          // if(prope)
          value.reference.update({
            'propertyIds': FieldValue.arrayUnion([propertyID])
          }).then((value) async {
            // Get.back();
            print('done updating a to existing auth');
          }).onError((error, stackTrace) {
            print(error.toString());
            print('4==============');
          });
        } else {
          await FirebaseFirestore.instance
              .collection('viewedProperty')
              .doc(auth.currentUser!.uid)
              .set({
            'propertyIds': [propertyID]
          }).then((value2) async {
            // Get.back();
            print('done');
          }).onError((error, stackTrace) {
            print(error.toString());
            print('6==============error');
          });
        }
      });
    }
  }

  var isVerified = false.obs;
  var isFromBottom = true.obs;
  RxString propertyStatus = 'all'.obs;
  RxString propertyType2 = 'Rent'.obs;

  // final searchController = TextEditingController();

  ///filter
  RxBool isFilter = false.obs;
  RxString buyRentValue = ''.obs;
  RxString propertyTypeValue = ''.obs;
  RxString bedroomCount = ''.obs;
  var isBuyRent = 10.obs;
  var propertyTypeButton = 0.obs;
  var propertyType = 10.obs;
  var selectedBedroom = 10.obs;

  var minValue = 1000.0.obs;
  var maxValue = 1040000.0.obs;
  Stream<QuerySnapshot> filter() {
    print('filter working');

    // Start with a base query
    Query baseQuery = FirebaseFirestore.instance
        .collection('listings')
        .where('sellerID', isNotEqualTo: auth.currentUser!.uid);

    // Apply filters based on user selections
    if (filterSearchCtrl.text.isNotEmpty) {
      print(filterSearchCtrl.text);
      print('hsedvk');
      baseQuery = baseQuery.where(Filter.or(
        Filter('countryName', isEqualTo: filterSearchCtrl.text),
        Filter('street', isEqualTo: filterSearchCtrl.text),
        Filter('town', isEqualTo: filterSearchCtrl.text),
      ));
    }

    if (isBuyRent.value != 10) {
      print('buyrent');
      baseQuery = baseQuery.where('listingRole', isEqualTo: buyRentValue.value);
    }

    if (propertyType.value != 10) {
      print('propertyType');

      baseQuery =
          baseQuery.where('propertyType', isEqualTo: propertyTypeValue.value);
    }

    if (selectedBedroom.value != 10) {
      print('selectedBedroom');
      print(bedroomCount.value);
      baseQuery =
          baseQuery.where('selectedBedroom', arrayContains: bedroomCount.value);
    }
    // double minCost = double.parse(minValue.value.toString());
    // double maxCost = double.parse(maxValue.value.toString());

    // if (minCost >= 1000.0 && maxCost <= 104000.0) {
    //
    //   print(minCost.toString());
    //   print(maxCost.toString());
    //
    //   baseQuery = baseQuery.where(Filter.and(
    //       Filter('cost', isGreaterThanOrEqualTo: num.parse(minCost.toString())),
    //       Filter('cost', isLessThanOrEqualTo: num.parse(maxCost.toString()))));
    //   // baseQuery = baseQuery.where('cost', isGreaterThanOrEqualTo: minCost.toString())
    //   //     .where('cost', isLessThanOrEqualTo: maxCost.toString());
    // }
//     if (minValue.value >= 1000.0 && maxValue.value <= 104000.0) {
//       int minCost = int.parse(minValue.value);
//       int maxCost = int.parse(maxValue.value);
//       print('time ')
// ;      baseQuery = baseQuery.where(Filter.and(Filter('cost', isGreaterThanOrEqualTo: minValue.value.toString()), Filter('cost', isLessThanOrEqualTo: maxValue.value.toString())));
//           // .where('cost', isGreaterThanOrEqualTo: minValue.value)
//           // .where('cost', isLessThanOrEqualTo: maxValue.value);
//     }

    print(baseQuery.toString());
    // Return the filtered stream
    return baseQuery.snapshots();
  }

  // Stream<QuerySnapshot> filterr() {
  //   print('filter working)');
  //
  //   print(buyRentValue.value);
  //   print(propertyTypeValue.value);
  //   print(bedroomCount.value);
  //   ///all
  //   return filterSearchCtrl.text != '' &&
  //           isBuyRent.value != 10 &&
  //           propertyType.value != 10 &&
  //           selectedBedroom.value != 10
  //       ? FirebaseFirestore.instance
  //           .collection('listings')
  //           .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
  //           .where('listingRole', isEqualTo: buyRentValue.value)
  //           .where('propertyType', isEqualTo: propertyTypeValue.value)
  //          /* .where('selectedBedroom', arrayContains: [bedroomCount.value])*/.snapshots()
  //       : FirebaseFirestore.instance
  //           .collection('listings')
  //           .where('sellerID', isNotEqualTo: auth.currentUser!.uid)
  //           .snapshots();
  // }

  // Stream<QuerySnapshot> filterr(){
  //   ///all
  //   return .value != '' &&
  //   sizeFilter.value != '' &&
  //   categoryDropdownValue.value != ''
  //   ? FirebaseFirestore.instance
  //       .collection("products")
  //       .orderBy('product_price',
  //   descending: sizeFilter.value == 'Low to high')
  //       .where('product_size', isEqualTo: sizeFilter.value)
  //       .where('product_category', isEqualTo: categoryDropdownValue.value)
  //   .snapshots()
  // }

  var isSelectedIndex = 0.obs;
  var selectedName = 'Apartment'.obs;
  var initialPage = 0.obs;
  var buySaleRentIndex = 0.obs;

  var checkInDate = DateTime.now().obs;
  var checkOutDate = DateTime.now().obs;

  final searchController = TextEditingController();
  final filterSearchCtrl = TextEditingController();

  final List<Map<String, dynamic>> propertiesCategories = [
    {'icon': 'assets/icons/hostel_icon.png', 'title': 'Apartment'},
    {'icon': 'assets/icons/bedsitters.png', 'title': 'Bedsitters'},
    {'icon': 'assets/icons/single_room.png', 'title': 'Single room'},
    {'icon': 'assets/icons/bedrooms.png', 'title': '1,2,3+ Bedrooms'},
    {'icon': 'assets/icons/for_sale.png', 'title': 'For Sale'},
  ];
  // 'Apartment',
  // 'Villa',
  // 'Duplex',
  // 'Pent House',
  // 'Compound',
  // 'Town House',
  // 'Full Floor',
  // 'Half Floor',
  // 'Second Floor',
  final List<Map<String, dynamic>> propertiesList = [
    {
      "image": 'assets/images/apartment_1.png',
      "title": 'Treeline apartment',
      "price": 'KSH 27,000',
      "location": 'Nairobi,GITARU, OFF NAIROBI-N..',
      "bedrooms": 2,
      "available": 1,
    },
    {
      "image": 'assets/images/apartment_2.png',
      "title": 'Treeline apartment',
      "price": 'KSH 27,000',
      "location": 'Nairobi,GITARU, OFF NAIROBI-N..',
      "bedrooms": 2,
      "available": 1,
    },
    {
      "image": 'assets/images/apartment_1.png',
      "title": 'Treeline apartment',
      "price": 'KSH 27,000',
      "location": 'Nairobi,GITARU, OFF NAIROBI-N..',
      "bedrooms": 2,
      "available": 1,
    },
  ];

  final List<Map<String, dynamic>> buySaleRentList = [
    {
      "image": 'assets/images/buy_property_2.png',
      "title": 'Buy a Property',
      "subTitle": 'Find Where “Perfect” Meets “Happy”',
      "buttonTitle": 'Browse Properties',
    },
    {
      "image": 'assets/images/sell_property.png',
      "title": 'Sell a Property',
      "subTitle": 'Get The Best Value In Any Economy',
      "buttonTitle": 'Add Details',
    },
    {
      "image": 'assets/images/sell_property.png',
      "title": 'Rent a property',
      "subTitle": 'Live Where You Can Love',
      "buttonTitle": 'Find Rentals',
    },
  ];

  final List<String> propertyTypeList = [
    'Apartment',
    'Villa',
    'Duplex',
    'Pent House',
    'Compound',
    'Town House',
    'Full Floor',
    'Half Floor',
    'Second Floor',
    'Bedsitters'
  ];

  final List<String> bedroomsList = [
    'Studio',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '7+',
  ];

  final List<HomeModel> bedsittersList = [
    HomeModel(
      image: 'assets/images/bedroom.png',
      title: 'Lake view apartments',
      price: 150000,
      noBedroom: 2,
      available: 1,
    ),
    HomeModel(
      image: 'assets/images/bedroom_1.png',
      title: 'Lake view apartments',
      price: 150000,
      noBedroom: 2,
      available: 1,
    ),
    HomeModel(
      image: 'assets/images/bedroom_2.png',
      title: 'Lake view apartments',
      price: 150000,
      noBedroom: 2,
      available: 1,
    ),
  ];

  final List<AgentProfileModel> agentsProfileList = [
    AgentProfileModel(
      image: 'assets/images/profile_1.png',
      name: "Steve B.",
      description:
          'Lörem ipsum aliga sosade, langen. Gugorade niras tenende. Teleck terahoda hexarad ',
    ),
    AgentProfileModel(
      image: 'assets/images/profile_2.png',
      name: "Mr-Hamani A.",
      description:
          'Lörem ipsum aliga sosade, langen. Gugorade niras tenende. Teleck terahoda hexarad ',
    ),
    AgentProfileModel(
      image: 'assets/images/profile_1.png',
      name: "Steve B.",
      description:
          'Lörem ipsum aliga sosade, langen. Gugorade niras tenende. Teleck terahoda hexarad ',
    ),
  ];
}
