import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SearchModel {
  String image;
  bool verified;
  RxBool isFavourite = false.obs;
  String propertyName;
  String paymentMethod;
  int cash;
  String address;
  int totalBedroom;
  int availableBedrooms;
  String buttonText;
  String status;

  SearchModel({
    required this.image,
    required this.verified,
    required this.isFavourite,
    required this.propertyName,
    required this.paymentMethod,
    required this.cash,
    required this.address,
    required this.totalBedroom,
    required this.availableBedrooms,
    required this.buttonText,
    required this.status,
  });
}
