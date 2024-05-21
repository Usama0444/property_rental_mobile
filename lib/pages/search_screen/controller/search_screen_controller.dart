import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/pages/search_screen/model/search_model.dart';
import 'package:property_rental_app/universal_models/viewed_property_model.dart';

import '../../../common_widgets/loading_dialog.dart';
import '../../../common_widgets/no_internet_dialog.dart';
import '../../../main.dart';

class SearchScreenController extends GetxController {
  ViewedPropertyModel vpModel = ViewedPropertyModel.initialize();
  RxInt currentCarouselPage = 0.obs;
  CarouselController carouselController = CarouselController();
  final List<String> imgList = [
    'assets/images/dummy_profile.png',
    'assets/images/dummy_profile.png',
    'assets/images/dummy_profile.png',
  ];
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
  RxString propertyStatus = 'all'.obs;

  final searchController = TextEditingController();
///filter
  RxBool isFilter = false.obs;
  // Stream<QuerySnapshot> filterr(){
  //   ///all
  //   return .value != '' &&
  //       sizeFilter.value != '' &&
  //       categoryDropdownValue.value != ''
  //       ? FirebaseFirestore.instance
  //       .collection("products")
  //       .orderBy('product_price',
  //       descending: sizeFilter.value == 'Low to high')
  //       .where('product_size', isEqualTo: sizeFilter.value)
  //       .where('product_category', isEqualTo: categoryDropdownValue.value)
  //       .snapshots()
  // }


}
