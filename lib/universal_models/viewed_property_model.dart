import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ViewedPropertyModel {
  RxList<String> propertyIds;
  ViewedPropertyModel({required this.propertyIds});

  static ViewedPropertyModel initialize() {
    return ViewedPropertyModel(propertyIds: <String>[].obs);
  }

  Future<Map<String, dynamic>> toMap() async {
    return {'propertyIds': propertyIds};
  }

  static ViewedPropertyModel fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ViewedPropertyModel(
        propertyIds:
            RxList<String>.from(data['propertyIds'].map((e) => e.toString())));
  }
}
