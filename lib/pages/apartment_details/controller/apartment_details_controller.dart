import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/universal_models/feedback_model.dart';

class ApartmentDetailsController extends GetxController {
  
  RxBool isFavourite = false.obs;
  var isSelectedImage = ''.obs;
  var index = 0.obs;
  var isSelected = true.obs;

  var initialIndex = 0.obs;

  RxBool isLoading = false.obs;
  var similarBedsitterIndex = 0.obs;

  Set<Marker> markers = <Marker>{}.obs;
  var selectedWidget = 0.obs;

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  final initialPosition = const CameraPosition(
    target: LatLng(33.60045758933767, 73.15116840774387),
    zoom: 14,
  );

  @override
  void onInit() async {
    // TODO: implement onInit
    // await addMarker(33.60045758933767, 73.15116840774387);
    super.onInit();
  }

  /// add first marker on map
  addMarker(lat, long) async {
    markers.add(
      Marker(
        icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset(
            "assets/images/marker_image.png",
            80,
          ),
        ),
        markerId: MarkerId(1.toString()),
        position: LatLng(lat, long),
      ),
    );

    isLoading.value = true;
  }

  /// covert marker icon function accordingly to design

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final postFeedBackController = TextEditingController();
  final List<String> imagesList = [
    'assets/images/apartment_3.png',
    'assets/images/apartment_4.png',
    'assets/images/apartment_5.png',
    'assets/images/apartment_3.png',
    'assets/images/apartment_4.png',
    'assets/images/apartment_5.png',
    'assets/images/apartment_3.png',
    'assets/images/apartment_4.png',
    'assets/images/apartment_5.png',
    'assets/images/apartment_3.png',
    'assets/images/apartment_4.png',
    'assets/images/apartment_5.png',
  ];

  final List<Map<String, dynamic>> highlightsList = [
    {
      'title': 'No of rooms',
      'value': "1",
    },
    {
      'title': 'Drawers',
      'value': 'Wardrobe',
    },
    {
      'title': 'Wifi',
      'value': 'Yes',
    },
    {
      'title': 'Water',
      'value': 'Yes',
    },
    {
      'title': 'Security',
      'value': 'Yes',
    },
  ];

  FeedBackModel feedbackModel = FeedBackModel.initialize();
  Future<void> addFeedback(sellerID,propertyID) async {
    loadingDialog(message: 'Please wait !!', loading: true);

    feedbackModel.sellerID=sellerID;
    feedbackModel.propertyID=propertyID;
    // feedbackModel.buyerID=buyerID;
    var data = await feedbackModel.toMap();
    await FirebaseFirestore.instance
        .collection('feedbacks')
        .add(data)
        .then((value) async {
      Get.back();
      loadingDialog(message: 'Feedback added.', button: true);

      feedbackModel.feedback.clear();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  final List<Map<String, dynamic>> bedsittersList = [
    {
      "image": 'assets/images/apartment_1.png',
      "title": 'Lake view apartments',
      "price": '150,000',
      "bedrooms": 2,
      "available": 1,
    },
    {
      "image": 'assets/images/apartment_2.png',
      "title": 'Lake view apartments',
      "price": '150,000',
      "bedrooms": 2,
      "available": 1,
    },
    {
      "image": 'assets/images/apartment_1.png',
      "title": 'Lake view apartments',
      "price": '150,000',
      "bedrooms": 2,
      "available": 1,
    },
  ];

  final List<Map<String, dynamic>> expansionList = [
    {
      'title': 'Is it free to create an account?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'Do you charge commission on property?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'Are you an agency / Agents?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'How do I know a mover is from Qwarqo?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'Am I guaranteed to get a house/property?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title':
          'How long does it take to get a feedback after a request is sent?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'If i request for a mover, do i pay after or before?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'Can i cancel my request?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'Do i need to create an account to use your website?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'How do I know a mover is from Qwarqo?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
    {
      'title': 'How much is the premium account?',
      'subTitle': ' Yes creating an account is absolutely free.',
    },
  ];
}
