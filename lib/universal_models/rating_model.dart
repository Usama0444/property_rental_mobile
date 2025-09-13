import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Timestamp;

class RatingModel {
  final String userId;
  final String userName;
  final String reviewText;
  final double starRating;
  final DateTime? timestamp;

  RatingModel({
    required this.userId,
    required this.userName,
    required this.reviewText,
    required this.starRating,
    this.timestamp,
  });

  factory RatingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RatingModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      reviewText: data['reviewText'] ?? '',
      starRating: (data['starRating'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'reviewText': reviewText,
      'starRating': starRating,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }
}