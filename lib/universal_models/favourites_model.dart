import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FavouriteModel {
  RxList<String> likes;

  FavouriteModel({
    required this.likes,
  });

  static FavouriteModel initialize() {
    return FavouriteModel(
      likes: <String>[].obs,
    );
  }

  // Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'likes': likes,
    };
  }

  static FavouriteModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return FavouriteModel(
      likes: RxList<String>.from(data['likes'].map((e) => e.toString())),
    );
  }
}
