import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../main_controller.dart';

class UserModel {
  TextEditingController userName;
  TextEditingController userEmail;
  TextEditingController phoneNo;
  String? token;
  String userID;
  String countryCode;
  TextEditingController password;
  RxBool isRecentViewed;
  RxBool isEmailRecommendation;
  RxBool isNotifications;
  DateTime createdAt;

  //constructor
  UserModel({
    required this.phoneNo,
    required this.userName,
    required this.userEmail,
    this.token,
    required this.countryCode,
    required this.userID,
    required this.password,
    required this.isEmailRecommendation,
    required this.isNotifications,
    required this.isRecentViewed,
    required this.createdAt,
  });

  // Initialize the model with default values
  static UserModel initialize() {
    return UserModel(
      isNotifications: false.obs,
      phoneNo: TextEditingController(),
      userName: TextEditingController(),
      userEmail: TextEditingController(),
      userID: currentUser != null ? currentUser!.id : '',
      password: TextEditingController(),
      token: '',
      isEmailRecommendation: false.obs,
      isRecentViewed: true.obs,
      countryCode: 'KE',
      createdAt: DateTime.now(),
    );
  }

  // Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    token = await Get.put(MainController()).getToken();
    print(token);

    print('=========aaaaaaaaaaaaaaaaa');
    return {
      'userName': userName.text,
      'userEmail': userEmail.text,
      'password': password.text,
      'userID': userID,
      'phoneNo': phoneNo.text,
      'isEmailRecommendation': isEmailRecommendation.value,
      'isRecentViewed': isRecentViewed.value,
      'isNotifications': isNotifications.value,
      'token': token,
      'countryCode': countryCode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a model instance from a DocumentSnapshot
  static UserModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      phoneNo: TextEditingController(
        text: snapshot.data()?['phoneNo'] ?? '',
      ),
      userName: TextEditingController(
        text: snapshot.data()?['userName'] ?? '',
      ),
      userEmail: TextEditingController(
        text: snapshot.data()?['userEmail'] ?? '',
      ),
      password: TextEditingController(text: snapshot.data()!['password']),
      userID: snapshot.data()!.containsKey('userID')
          ? snapshot.data()!['userID']
          : auth.currentUser!.uid,
      countryCode: snapshot.data()!['countryCode'],
      isEmailRecommendation: RxBool(snapshot.data()!['isEmailRecommendation']),
      token: snapshot.data()!['token'] ?? '',
      isRecentViewed: RxBool(snapshot.data()!['isRecentViewed']),
      isNotifications: RxBool(snapshot.data()!['isNotifications']),
      createdAt: (snapshot.data()!['createdAt'] as Timestamp).toDate(),
    );
  }
}