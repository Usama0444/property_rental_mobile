import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:property_rental_app/main.dart';

class FeedBackModel {
  String buyerID;
  String propertyID;
  String sellerID;
  TextEditingController feedback;
  String orderDate;

  //constructor
  FeedBackModel({
    required this.buyerID,
    required this.propertyID,
    required this.sellerID,
    required this.orderDate,
    required this.feedback,
  });

// Initialize the model with default values

  static FeedBackModel initialize() {
    return FeedBackModel(
      buyerID: auth.currentUser!.uid,
      feedback: TextEditingController(),
      propertyID: '',
      orderDate: DateFormat('dd MMMM,yyyy').format(DateTime.now()),
      sellerID: '',
    );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'buyerID': buyerID,
      'propertyID': propertyID,
      'sellerID': sellerID,
      'orderDate': orderDate,
      'feedback': feedback.text,
    };
  }

  // Create a model instance from a DocumentSnapshot
  static FeedBackModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return FeedBackModel(
      feedback: TextEditingController(text: snapshot.data()!['feedback']),
      buyerID: snapshot.data()!['buyerID'],
      propertyID: snapshot.data()!['propertyID'],
      sellerID: snapshot.data()!['sellerID'],
      orderDate: snapshot.data()!['orderDate'],
    );
  }
}
