import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/no_internet_dialog.dart';
import 'package:property_rental_app/pages/home/model/home_model.dart';
import 'package:property_rental_app/universal_models/recent_searches_model.dart';
import 'package:property_rental_app/universal_models/viewed_property_model.dart';

import '../../../main.dart';

class SplashController extends GetxController {

  var buySaleRentIndex = 0.obs;


  final List<Map<String, dynamic>> buySaleRentList = [
    {
      "image": 'assets/images/landing img 1.png',
      "title": 'Thousand of the best real estate at affordable price',


    },
    {
      "image": 'assets/images/landing img 2.png',
      "title": 'Book a real estate quickly and easily with one click',

    },
    {
      "image": 'assets/images/landing img 3.png',
      "title": 'Let\'s find the real estate that suits your needs',

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
