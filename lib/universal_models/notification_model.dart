import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class NotificationsModel {
  String ownerID;
  String buyerID;
  String propertyName;
  String body;
  String propertyOwnerName;
  String buyerName;
  String ownerNumber;
  String buyerNumber;
  bool isPaymentDone;
  int checkIn;
  String propertyID;
  String pendingPayment;
  String orderDate;
  String bookingType; //rent or sold

  // String
  NotificationsModel({
    required this.ownerID,
    required this.buyerName,
    required this.buyerNumber,
    required this.propertyID,
    required this.pendingPayment,
    required this.buyerID,
    required this.propertyName,
    required this.ownerNumber,
    required this.body,
    required this.orderDate,
    required this.propertyOwnerName,
    required this.bookingType,
    required this.isPaymentDone,
    required this.checkIn,
  });

  static NotificationsModel initialize() {
    return NotificationsModel(
        orderDate: DateFormat('dd MMMM, yyyy').format(DateTime.now()),
        ownerID: '',
        propertyID: '',
        buyerID: auth.currentUser!.uid,
        isPaymentDone: false,
        checkIn: 0,
        pendingPayment: '0',
        propertyName: '',
        bookingType: 'Tour',
        body: '',
        propertyOwnerName: '',
        ownerNumber: '',
        buyerName: '',
        buyerNumber: '');
  }

  // Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'ownerID': ownerID,
      'pendingPayment':pendingPayment,
      'buyerID': buyerID,
      'propertyName': propertyName,
      'bookingType': bookingType,
      'body': body,
      'propertyID': propertyID,
      'propertyOwnerName': propertyOwnerName,
      'ownerNumber': ownerNumber,
      'isPaymentDone': isPaymentDone,
      'checkIn': checkIn,
      'orderDate': orderDate,
      'buyerName': buyerName,
      'buyerNumber': buyerNumber
    };
  }

  static NotificationsModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return NotificationsModel(
      orderDate: snapshot.data()!['orderDate'],
      ownerID: data['ownerID'],
      buyerID: data['buyerID'],
      propertyID: snapshot.data()!['propertyID'],
      pendingPayment: snapshot.data()!['pendingPayment'],
      propertyName: data['propertyName'],
      checkIn: snapshot.data()!['checkIn'],
      bookingType: snapshot.data()!['bookingType'],
      isPaymentDone: snapshot.data()!['isPaymentDone'],
      body: data['body'],
      propertyOwnerName: data['propertyOwnerName'],
      ownerNumber: data['ownerNumber'],
      buyerName: data['buyerName'],
      buyerNumber: data['buyerNumber'],
    );
  }
}
