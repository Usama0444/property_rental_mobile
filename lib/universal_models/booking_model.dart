import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingModel {
  String buyerID;
  String propertyID;
  String sellerID;
  TextEditingController buyerName;
  String sellerName;
  TextEditingController buyerPhoneNo;
  String sellerPhoneNo;
  TextEditingController mPesa;
  String orderStatus;
  String bookingType; //rent or sold
  String pendingPayment;
  String totalPayment;
  bool isPaymentDone;
  String orderDate;
  RxList<String> selectedBedroom;
  int checkIn;
  int checkOut;

  //constructor
  BookingModel({
    required this.selectedBedroom,
    required this.mPesa,
    required this.buyerID,
    required this.propertyID,
    required this.sellerName,
    required this.sellerPhoneNo,
    required this.sellerID,
    required this.buyerName,
    required this.orderStatus,
    required this.bookingType,
    required this.totalPayment,
    required this.isPaymentDone,
    required this.orderDate,
    required this.pendingPayment,
    required this.buyerPhoneNo,
    required this.checkIn,
    required this.checkOut,
  });

// Initialize the model with default values

  static BookingModel initialize() {
    return BookingModel(
      bookingType: 'Tour',
      selectedBedroom: <String>[].obs,
      buyerID: '',
      buyerName: TextEditingController(),
      mPesa: TextEditingController(),
      buyerPhoneNo: TextEditingController(),
      isPaymentDone: false,
      orderStatus: 'Pending',
      sellerName: '',
      sellerPhoneNo: '',
      pendingPayment: '0',
      totalPayment: '0',
      propertyID: '',
      orderDate: DateFormat('dd MMMM,yyyy').format(DateTime.now()),
      sellerID: '',
      checkIn: 0,
      checkOut: 0,
    );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'buyerID': buyerID,
      'totalPayment': totalPayment,
      'propertyID': propertyID,
      'sellerID': sellerID,
      'buyerName': buyerName.text,
      'mPesa': mPesa.text,
      'orderStatus': orderStatus,
      'bookingType': bookingType,
      'isPaymentDone': isPaymentDone,
      'orderDate': orderDate,
      'selectedBedroom': selectedBedroom,
      'pendingPayment': pendingPayment,
      'buyerPhoneNo': buyerPhoneNo.text,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'sellerName': sellerName,
      'sellerPhoneNo': sellerPhoneNo
    };
  }

  // Create a model instance from a DocumentSnapshot
  static BookingModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return BookingModel(
      totalPayment: snapshot.data()!['totalPayment'],
      mPesa: TextEditingController(text: snapshot.data()!['mPesa']),
      buyerID: snapshot.data()!['buyerID'],
      propertyID: snapshot.data()!['propertyID'],
      sellerID: snapshot.data()!['sellerID'],
      buyerName: TextEditingController(text: snapshot.data()!['buyerName']),
      orderStatus: snapshot.data()!['orderStatus'],
      bookingType: snapshot.data()!['bookingType'],
      isPaymentDone: snapshot.data()!['isPaymentDone'],
      orderDate: snapshot.data()!['orderDate'],
      pendingPayment: snapshot.data()!['pendingPayment'],
      selectedBedroom: RxList<String>.from(
          snapshot.data()!['selectedBedroom'].map((e) => e.toString())),
      buyerPhoneNo:
          TextEditingController(text: snapshot.data()!['buyerPhoneNo']),
      checkIn: snapshot.data()!['checkIn'],
      checkOut: snapshot.data()!['checkOut'],
      sellerName: snapshot.data()!['sellerName'],
      sellerPhoneNo: snapshot.data()!['sellerPhoneNo'],
    );
  }
}
