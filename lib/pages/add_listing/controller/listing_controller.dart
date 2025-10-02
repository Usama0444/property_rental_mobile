import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/pages/ads_posted_successfully/ads_posted_succesfully.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';

class EnterPropertyDetailsController extends GetxController {
  // AddListingModel listingModel = AddListingModel.initialize();

  ///edit working hours

  List<EditWorkingHoursModel> hours = [
    EditWorkingHoursModel(
        dayName: 'Monday',
        timings: <Timing>[
          Timing(
              startTime: (TimeOfDay.now()).obs, endTime: (TimeOfDay.now()).obs)
        ].obs),
  ];

  ///
  void addWorkingHoursRow(/*String selectedDay,*/ int index) {
    print('Adding a new row');

    hours[index].timings.add(Timing(
          startTime: Rx<TimeOfDay>(TimeOfDay.now()),
          endTime: Rx<TimeOfDay>(TimeOfDay.now()),
        ));
    // hours.add(
    //   EditWorkingHoursModel(
    //     dayName: selectedDay,
    //     timings: <Timing>[
    //       Timing(
    //         startTime: Rx<TimeOfDay>(TimeOfDay.now()),
    //         endTime: Rx<TimeOfDay>(TimeOfDay.now()),
    //       ),
    //     ].obs,
    //   ),
    // );
  }

  ///
  void removeWorkingHoursRow(int topIndex, int index) {
    print('Removing a new row');
    // if (topIndex >= 0 && topIndex < hours.length)
    //   if (index >= 0 &&
    //     index < hours[topIndex].timings.length) {
    hours[topIndex].timings.removeAt(index);
    // }
  }

  String? address;
  String getFullAddress(listingModel) {
    String address = listingModel.street.text +
        ", " +
        listingModel.town.text +
        ", " +
        listingModel.countryName.value;
        // 'Kenya';
    return address.trim();
  }

  Future<List<Location>> getAddressCoordinates(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);
      return locations;
    } catch (e) {
      print("Error fetching coordinates: $e");
      return [];
    }
  }

  ///publish listing function
  Future<void> publishListing(AddListingModel listingModel) async {
    loadingDialog(message: 'Please wait !!', loading: true);
    var data = await listingModel.toMap();
    print(data);
    await FirebaseFirestore.instance
        .collection('listings')
        .add(data)
        .then((value) {
      Get.back();
      Get.to(() => AdsPostedSuccessfully(
            listingId: value.id,
          ));
    }).onError((error, stackTrace) {
      print(error.toString());
      print("Address not found.");
    });
  }

  ///update listing function
  Future<void> updateListing(AddListingModel? listModel, listingId) async {
    loadingDialog(message: 'Please wait !!', loading: true);
    var data = await listModel!.toMap();
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .update(data)
        .then((value) {
      Get.back();
      Get.to(() => AdsPostedSuccessfully(
            listingId: listingId,
          ));
    }).onError((error, stackTrace) {
      print(error.toString());
      print("Address not found.");
    });
  }

  final titleOrNameController = TextEditingController();
  final propertyTypeController = TextEditingController();
  final phoneNoController = TextEditingController();
  final countryController = TextEditingController();
  final townController = TextEditingController();
  final costController = TextEditingController();
  final streetController = TextEditingController();
  final extraCostController = TextEditingController();
  final descriptionController = TextEditingController();

  RxString typeDropdownValue = "Apartment".obs;
  final propertyTypeList = [
    "Single Room",
    "Studio",
    "Apartment",
    "Villa",
    "Town House",
    "Pent House",
    "Bungalow",
    "Mansion ",
    "Bedsitters"
  ];

  final List<String> bedroomsList = [
    'Single Room',
    'Bedsitter',
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
  RxString countryDropdownValue = "Kenya".obs;
  final countryList = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Kenya',
    'Pakistan'
  ];

  RxString townDropdownValue = "Bad Homburg".obs;
  final townList = [
    "Bad Homburg",
    'Darmstadt',
    'Frankfurt am Main',
    "Fulda",
    'Hanau',
    'Kassel',
    'Lorsch',
  ];

  ///facilities
  var isListingAs = 'f'.obs;

  final List<Map<String, dynamic>> facilitiesList = [
    {'icon': 'assets/icons/wifi.png', 'title': 'Wifi'},
    {'icon': 'assets/icons/water.png', 'title': 'Water'},
    {'icon': 'assets/icons/parking.png', 'title': 'Parking'},
    {'icon': 'assets/icons/drawer.png', 'title': 'Drawers'},
    {'icon': 'assets/icons/sinks.png', 'title': 'Sinks'},
    {'icon': 'assets/icons/wardrobe.png', 'title': 'Wardrobe'},
    {'icon': 'assets/icons/electricity.png', 'title': 'Electricity'},
    {'icon': 'assets/icons/furnishing.png', 'title': 'Furnishing'},
    {'icon': 'assets/icons/shieldtick_2.png', 'title': 'Security'},
  ];

  final List<Map<String, dynamic>> propertyList = [
    {'icon': 'assets/icons/rent_icon.png', 'title': 'Rent'},
    {'icon': 'assets/icons/sold_icon.png', 'title': 'For Sale'},
  ];
}

///
///

class EditWorkingHoursModel {
  EditWorkingHoursModel({required this.dayName, required this.timings});
  String dayName;
  RxList<Timing> timings;
}

class Timing {
  Timing({required this.startTime, required this.endTime});
  Rx<TimeOfDay> startTime;
  Rx<TimeOfDay> endTime;
}
