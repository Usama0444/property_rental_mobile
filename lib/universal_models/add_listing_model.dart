import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import '../common_widgets/global_functions.dart';
import '../main.dart';

class AddListingModel {
  String docId; // Add docId property
  TextEditingController propertyName;
  TextEditingController phoneNo;
  RxString listingRole;
  RxList<String> selectedBedroom;
  RxString propertyType;
  RxString countryName;
  TextEditingController town;
  TextEditingController street;
  TextEditingController cost;
  TextEditingController description;
  TextEditingController extraPay;
  TextEditingController payment;
  TextEditingController monthlyCost;
  TextEditingController totalSaleCost;
  String sellerID;
  double latitude;
  double longitude;
  RxList<String> facilities;
  List<RxString> listingImages;
  RxList<Rx<Uint8List>> listingImageMemories;
  RxList<IndicatePayListModel> indicatePayList;
  bool isRecommended;
  RxString rentType;
  bool isVerified;
  bool isFeatured;
  bool isPending;
  bool isApproved;
  bool isActive;
  DateTime createdAt;

  //constructor
  AddListingModel({
    required this.docId, // Add docId to constructor
    required this.listingImages,
    required this.indicatePayList,
    required this.listingImageMemories,
    required this.longitude,
    required this.latitude,
    required this.propertyName,
    required this.countryName,
    required this.phoneNo,
    required this.payment,
      required this.monthlyCost,
    required this.totalSaleCost,
    required this.propertyType,
    required this.town,
    required this.listingRole,
    required this.selectedBedroom,
    required this.extraPay,
    required this.sellerID,
    required this.cost,
    required this.description,
    required this.street,
    required this.facilities,
    required this.isRecommended,
    required this.isVerified,
    required this.isFeatured,
     required this.isPending,
        required this.isActive,
    required this.isApproved,
    required this.createdAt,
    required this.rentType,
   
  });

// Initialize the model with default values

  static AddListingModel initialize() {
    return AddListingModel(
      docId: '',
        indicatePayList: RxList<IndicatePayListModel>.generate(
            1, (index) => IndicatePayListModel.initialize()),

        // indicatePayList: <IndicatePayListModel>[].obs,
        listingImages: [],
        listingImageMemories: RxList<Rx<Uint8List>>(),
        street: TextEditingController(),
        town: TextEditingController(),
        propertyName: TextEditingController(),
        sellerID: auth.currentUser!.uid,
        cost: TextEditingController(),
        description: TextEditingController(),
        extraPay: TextEditingController(),
        phoneNo: TextEditingController(),
        payment: TextEditingController(),
              monthlyCost: TextEditingController(),
      totalSaleCost: TextEditingController(),
rentType: 'Daily'.obs,
        listingRole: 'Rent'.obs,
        facilities: <String>[].obs,
        selectedBedroom: <String>[].obs,
        propertyType: 'Apartment'.obs,
        countryName: 'Kenya'.obs,
        latitude: 0.0,
        longitude: 0.0,
              isRecommended: false,
      isVerified: false,
      isFeatured: false,
      isActive: true,
    isPending: true,
    isApproved: false,
      createdAt: DateTime.now(),
        );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    List<String> imageUrls = [];
    // Convert indicatePayList to a list of maps
    List<Map<String, dynamic>> indicatePayListMaps = [];
    for (var item in indicatePayList) {
      indicatePayListMaps.add(await item.toMap());
    }
    for (var image in listingImages) {
      imageUrls.add(image.value);
    }
    for (int i = 0; i < listingImageMemories.length; i++) {
      print('adding media in listing');
      String uploadedUrl = await uploadImageToFirebase(
          'listings', listingImageMemories[i].value);
      imageUrls.add(uploadedUrl);
    }
    return {
      'listingImages': imageUrls,
      'listingImageMemories': Uint8List(0),
      'propertyName': propertyName.text,
      'countryName': countryName.value,
      'town': town.text,
      'rentType': rentType.value,
      'extraPay': extraPay.text,
      'sellerID': sellerID,
      'phoneNo': phoneNo.text,
      'description': description.text,
      'payment': payment.text,
        'monthlyCost': monthlyCost.text,
      'totalSaleCost': totalSaleCost.text,
      'cost': cost.text,
      'street': street.text,
      'listingRole': listingRole.value,
      'selectedBedroom': selectedBedroom,
      'propertyType': propertyType.value,
      'facilities': facilities,
      'latitude': latitude,
      'longitude': longitude,
      'indicatePayList': indicatePayListMaps,
      'isRecommended': isRecommended,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'isPending': isPending,
      'isActive': isActive,
      'isApproved':isApproved,
      'createdAt': Timestamp.fromDate(createdAt),
      // indicatePayList.map((element) => element.toMap()).toList(),
    };
  }

// Create a model instance from a DocumentSnapshot
  static AddListingModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    List<String> images = List<String>.from(snapshot.data()!['listingImages']);
    List<RxString> listingImages = [];
    final List<dynamic> timingsData = snapshot.data()!['indicatePayList'] ?? [];

    final List<IndicatePayListModel> timingsList = timingsData
        .map((timingData) => IndicatePayListModel.fromMap(timingData))
        .toList();
    for (String image in images) {
      listingImages.add(RxString(image));
    }

    List<Rx<Uint8List>> imageMemories = [];
    for (int i = 0; i < images.length; i++) {
      imageMemories.add(Rx<Uint8List>(Uint8List(0)));
    }
        // Handle Timestamp for createdAt
    DateTime createdAt;
    if (snapshot.data()!['createdAt'] is Timestamp) {
      createdAt = (snapshot.data()!['createdAt'] as Timestamp).toDate();
    } else if (snapshot.data()!['createdAt'] is String) {
      createdAt = DateTime.parse(snapshot.data()!['createdAt']);
    } else {
      createdAt = DateTime.now(); // Fallback if createdAt is missing or invalid
    }
    // Convert cost to String
  final costValue = snapshot.data()!['cost'];
  String costString = costValue is String ? costValue : costValue.toString();
    return AddListingModel(
      indicatePayList: RxList<IndicatePayListModel>(timingsList),
      /* RxList<IndicatePayListModel>.from(snapshot
          .data()!['indicatePayList']
          .map((e) => IndicatePayListModel.fromMap(e))),*/
          docId: snapshot.id,
           rentType: RxString(snapshot.data()?['rentType'] ?? 'Daily'),
      listingImages: listingImages,
      listingImageMemories: RxList<Rx<Uint8List>>(imageMemories),
      latitude: snapshot.data()!['latitude'] ?? 33.602018,
      longitude: snapshot.data()!['longitude'] ?? 33.602018,
      propertyType: RxString(snapshot.data()!['propertyType']),
      propertyName: TextEditingController(
        text: snapshot.data()!['propertyName'],
      ),
      town: TextEditingController(
        text: snapshot.data()!['town'],
      ),
      payment: TextEditingController(
        text: snapshot.data()!['payment'],
      ),
        monthlyCost: TextEditingController(
          text: snapshot.data()!['monthlyCost']?.toString() ?? ''),
      totalSaleCost: TextEditingController(
          text: snapshot.data()!['totalSaleCost']?.toString() ?? ''),
      street: TextEditingController(
        text: snapshot.data()!['street'],
      ),
      extraPay: TextEditingController(text: snapshot.data()!['extraPay']),
      sellerID: snapshot.data()!['sellerID'],
      phoneNo: TextEditingController(text: snapshot.data()!['phoneNo']),
      description: TextEditingController(text: snapshot.data()!['description']),
     cost: TextEditingController(text: costString), // Use converted string
      listingRole: RxString(snapshot.data()!['listingRole']),
      facilities: RxList<String>.from(
          snapshot.data()!['facilities'].map((e) => e.toString())),
      selectedBedroom: RxList<String>.from(
          snapshot.data()!['selectedBedroom'].map((e) => e.toString())),
      countryName: RxString(snapshot.data()!['countryName']),
            isRecommended: snapshot.data()!['isRecommended'] ?? false,
      isVerified: snapshot.data()!['isVerified'] ?? false,
      isFeatured: snapshot.data()!['isFeatured'] ?? false,
      isPending: snapshot.data()!['isPending']?? false,
      isActive: snapshot.data()!['isActive']?? false,
      isApproved: snapshot.data()!['isApproved']?? false,
      createdAt: createdAt,

    );
  }
}

class IndicatePayListModel {
  TextEditingController extraName;
  TextEditingController extraCost;

  IndicatePayListModel({
    required this.extraName,
    required this.extraCost,
  });

  static IndicatePayListModel initialize() {
    return IndicatePayListModel(
        extraName: TextEditingController(), extraCost: TextEditingController());
  }

  /// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'extraCost': extraCost.text,
      'extraName': extraName.text,
    };
  }

  //
  static IndicatePayListModel fromMap(Map<String, dynamic> data) {
    return IndicatePayListModel(
        extraCost: TextEditingController(text: data['extraCost']),
        extraName: TextEditingController(text: data['extraName']));
  }
}

///import 'dart:typed_data';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../common_widgets/global_functions.dart';
// import '../main.dart';
//
// class AddListingModel {
//   TextEditingController propertyName;
//   TextEditingController phoneNo;
//   RxString listingRole;
//   RxList<String> selectedBedroom;
//   RxString propertyType;
//   RxString countryName;
//   TextEditingController town;
//   TextEditingController street;
//   TextEditingController cost;
//   TextEditingController description;
//   TextEditingController extraPay;
//   TextEditingController payment;
//   String sellerID;
//   double latitude;
//   double longitude;
//   RxList<String> facilities;
//   List<RxString> listingImages;
//   RxList<Rx<Uint8List>> listingImageMemories;
//
//   //constructor
//   AddListingModel({
//     required this.listingImages,
//     required this.listingImageMemories,
//     required this.longitude,
//     required this.latitude,
//     required this.propertyName,
//     required this.countryName,
//     required this.phoneNo,
//     required this.payment,
//     required this.propertyType,
//     required this.town,
//     required this.listingRole,
//     required this.selectedBedroom,
//     required this.extraPay,
//     required this.sellerID,
//     required this.cost,
//     required this.description,
//     required this.street,
//     required this.facilities,
//   });
//
// // Initialize the model with default values
//
//   static AddListingModel initialize() {
//     return AddListingModel(
//         listingImages: [],
//         listingImageMemories: RxList<Rx<Uint8List>>(),
//         street: TextEditingController(),
//         town: TextEditingController(),
//         propertyName: TextEditingController(),
//         sellerID: auth.currentUser!.uid,
//         cost: TextEditingController(),
//         description: TextEditingController(),
//         extraPay: TextEditingController(),
//         phoneNo: TextEditingController(),
//         payment: TextEditingController(),
//         listingRole: 'Rent'.obs,
//         facilities: <String>[].obs,
//         selectedBedroom: <String>[].obs,
//         propertyType: 'Apartment'.obs,
//         countryName: 'Kenya'.obs,
//         latitude: 0.0,
//         longitude: 0.0);
//   }
//
// // Convert the model instance to a map for storing in Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     List<String> imageUrls = [];
//     for(var image in listingImages){
//
//       imageUrls.add(image.value);
//
//     }
//     for (int i = 0; i < listingImageMemories.length; i++) {
//       print('adding media in listing');
//       String uploadedUrl = await uploadImageToFirebase(
//           'listings', listingImageMemories[i].value);
//       imageUrls.add(uploadedUrl);
//       // print('rzg');
//       // String imageUrl = listingImages[i].value;
//       // if (imageUrl.contains('https://firebasestorage.googleapis.com/') &&
//       //     listingImageMemories[i].value.isEmpty) {
//       //   print('sdgsg');
//       //   imageUrls.add(imageUrl);
//       // } else if (listingImageMemories[i].value.isNotEmpty) {
//       //   print('41');
//       //   String uploadedUrl = await uploadImageToFirebase(
//       //       'profile', listingImageMemories[i].value);
//       //   imageUrls.add(uploadedUrl);
//       // }
//       // print(imageUrls);
//     }
//     return {
//       'listingImages': imageUrls,
//       'listingImageMemories': Uint8List(0),
//       'propertyName': propertyName.text,
//       'countryName': countryName.value,
//       'town': town.text,
//       'extraPay': extraPay.text,
//       'sellerID': sellerID,
//       'phoneNo': phoneNo.text,
//       'description': description.text,
//       'payment': payment.text,
//       'cost': cost.text,
//       'street': street.text,
//       'listingRole': listingRole.value,
//       'selectedBedroom': selectedBedroom,
//       'propertyType': propertyType.value,
//       'facilities': facilities,
//       'latitude': latitude,
//       'longitude': longitude,
//     };
//   }
//
// // Create a model instance from a DocumentSnapshot
//   static AddListingModel fromDocumentSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> snapshot) {
//     List<String> images = List<String>.from(snapshot.data()!['listingImages']);
//     List<RxString> listingImages = [];
//     for (String image in images) {
//       listingImages.add(RxString(image));
//     }
//
//     List<Rx<Uint8List>> imageMemories = [];
//     for (int i = 0; i < images.length; i++) {
//       imageMemories.add(Rx<Uint8List>(Uint8List(0)));
//     }
//     return AddListingModel(
//       listingImages: listingImages,
//       listingImageMemories: RxList<Rx<Uint8List>>(imageMemories),
//       latitude: snapshot.data()!['latitude'] ?? 33.602018,
//       longitude: snapshot.data()!['longitude'] ?? 33.602018,
//       propertyType: RxString(snapshot.data()!['propertyType']),
//       propertyName: TextEditingController(
//         text: snapshot.data()!['propertyName'],
//       ),
//       town: TextEditingController(
//         text: snapshot.data()!['town'],
//       ),   payment: TextEditingController(
//         text: snapshot.data()!['payment'],
//       ),
//       street: TextEditingController(
//         text: snapshot.data()!['street'],
//       ),
//       extraPay: TextEditingController(text: snapshot.data()!['extraPay']),
//       sellerID: snapshot.data()!['sellerID'],
//       phoneNo: TextEditingController(text: snapshot.data()!['phoneNo']),
//       description: TextEditingController(text: snapshot.data()!['description']),
//       cost: TextEditingController(text: snapshot.data()!['cost']),
//       listingRole: RxString(snapshot.data()!['listingRole']),
//       facilities: RxList<String>.from(
//           snapshot.data()!['facilities'].map((e) => e.toString())),
//       selectedBedroom: RxList<String>.from(
//           snapshot.data()!['selectedBedroom'].map((e) => e.toString())),
//       countryName: RxString(snapshot.data()!['countryName']),
//     );
//   }
// }
