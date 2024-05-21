import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/main.dart';

class RecentSearchesModel {
  String propertyID;
  String userID;
  String search;

  //constructor
  RecentSearchesModel({
    required this.propertyID,
    required this.userID,
    required this.search,
  });

// Initialize the model with default values

  static RecentSearchesModel initialize() {
    return RecentSearchesModel(
      search: 'TextEditingController()',
      propertyID: '',
      userID: auth.currentUser!.uid,
    );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'propertyID': propertyID,
      'userID': userID,
      'search': search,
    };
  }

  // Create a model instance from a DocumentSnapshot
  static RecentSearchesModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return RecentSearchesModel(
      search:snapshot.data()!['search'],
      propertyID: snapshot.data()!['propertyID'],
      userID: snapshot.data()!['userID'],
    );
  }
}
