import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/main.dart';
import 'package:property_rental_app/pages/ads_posted_successfully/ads_posted_succesfully.dart';
import 'package:property_rental_app/pages/bottom_nav_bar/user_bottom_nav_bar.dart';
import 'package:property_rental_app/universal_models/add_listing_model.dart';
import 'package:property_rental_app/universal_models/booking_model.dart';
import 'package:property_rental_app/universal_models/user_model.dart';

import '../../../main_controller.dart';
import '../../../universal_models/notification_model.dart';
import '../../booking_status/booking_status.dart';

class BookingsController extends GetxController {
  NotificationsModel notifyModel = NotificationsModel.initialize();
  final List<String> bedroomsList = [
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

  var selectedBedroom = 10.obs;

  var checkInDate = DateTime.now().obs;
  var checkOutDate = DateTime.now().obs;

  BookingModel bookingMdl = BookingModel.initialize();

  ///publish listing function
  Future<void> rentBooking(
      AddListingModel listingModel, sellerID, listingID, payment) async {
    loadingDialog(message: 'Please wait !!', loading: true);
    currentUser = await checkUserData();
    print(sellerID);

    DocumentSnapshot userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerID)
        .get();
    UserModel uModel = UserModel.fromDocumentSnapshot(
        userdata as DocumentSnapshot<Map<String, dynamic>>);
    currentUser = await checkUserData();
    print(currentUserDataModel!.value.userName);
    print('-------------');
    bookingMdl.checkIn = checkInDate.value.millisecondsSinceEpoch;
    bookingMdl.checkOut = checkOutDate.value.millisecondsSinceEpoch;
    bookingMdl.buyerID = auth.currentUser!.uid;
    bookingMdl.sellerID = sellerID;
    bookingMdl.propertyID = listingID;
    bookingMdl.isPaymentDone = true;
    bookingMdl.buyerName = currentUserDataModel!.value.userName;
    bookingMdl.buyerPhoneNo = currentUserDataModel!.value.phoneNo;
    bookingMdl.bookingType = 'Rent';
    bookingMdl.sellerName = uModel.userName.text;
    bookingMdl.sellerPhoneNo = uModel.phoneNo.text;
    var data = await bookingMdl.toMap();
    await FirebaseFirestore.instance
        .collection('bookings')
        .add(data)
        .then((value) async {
      ///sending notification
      notifyModel.ownerID = sellerID;
      notifyModel.buyerID = auth.currentUser!.uid;
      notifyModel.propertyID = listingID;
      notifyModel.propertyName = listingModel.propertyName.text;
      notifyModel.propertyOwnerName = uModel.userName.text;
      notifyModel.ownerNumber = uModel.phoneNo.text;
      notifyModel.isPaymentDone = true;
      notifyModel.checkIn = bookingMdl.checkIn;
      notifyModel.pendingPayment = '0';
      notifyModel.bookingType = 'Rent';
      notifyModel.buyerName = currentUserDataModel!.value.userName.text;
      notifyModel.buyerNumber = currentUserDataModel!.value.phoneNo.text;

      var dataNotify = await notifyModel.toMap();

      await FirebaseFirestore.instance
          .collection('notifications')
          // .doc(value.id)
          .add(dataNotify)
          .then((value) {
        Get.back();
        Get.to(
            () => BookingStatus(listingModel: listingModel, payment: payment));
        print('done');

        Get.put(MainController()).sendPushNotification(
          token: uModel.token.toString(),
          // image: userModel.userImage.toString(),
          title: currentUserDataModel!.value.userName.text,
          body: 'has booked ${notifyModel.propertyName} for rent.',
        );
        bookingMdl = BookingModel.initialize();
      }).onError((error, stackTrace) {
        print(error.toString());
      });
      // Get.back();
    }).onError((error, stackTrace) {
      print(error.toString());
      // print("Address not found.");
    });
  }

  ///

  final selectedIndex = 0.obs;
  final selectedDateIndex = 0.obs;
  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());

  // BookingModel bookingModel = BookingModel.initialize();

  Future<void> addBooking(
    sellerID,
    listingID,
  AddListingModel  listingModel,
  ) async {
    print('done');

    bookingMdl.checkIn = selectedDate.value.millisecondsSinceEpoch;
    loadingDialog(message: 'Please wait !!', loading: true);
    DocumentSnapshot userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerID)
        .get();
    UserModel uModel = UserModel.fromDocumentSnapshot(
        userdata as DocumentSnapshot<Map<String, dynamic>>);
    bookingMdl.buyerID = auth.currentUser!.uid;
    bookingMdl.sellerID = sellerID;
    bookingMdl.sellerName = uModel.userName.text;
    bookingMdl.sellerPhoneNo = uModel.phoneNo.text;
    bookingMdl.totalPayment = listingModel.cost.text;
    bookingMdl.checkOut = bookingMdl.checkIn;
    var data = await bookingMdl.toMap();
    await FirebaseFirestore.instance
        .collection('bookings')
        .add(data)
        .then((value) async {
      ///sending notification

      notifyModel.ownerID = sellerID;
      notifyModel.propertyID = listingID;
      notifyModel.propertyName = listingModel.propertyName.text;
      notifyModel.propertyOwnerName = uModel.userName.text;
      notifyModel.ownerNumber = uModel.phoneNo.text;
      notifyModel.isPaymentDone =
          bookingMdl.pendingPayment == '0' ? true : false;
      notifyModel.checkIn = bookingMdl.checkIn;
      notifyModel.pendingPayment = bookingMdl.pendingPayment;
      notifyModel.bookingType = 'Tour';
      notifyModel.buyerNumber = bookingMdl.buyerName.text;
      notifyModel.buyerNumber = bookingMdl.buyerPhoneNo.text;

      var dataNotify = await notifyModel.toMap();

      await FirebaseFirestore.instance
          .collection('notifications')
          // .doc(value.id)
          .add(dataNotify)
          .then((value) {
        if (notifyModel.pendingPayment == '0') {
          Get.put(MainController()).sendPushNotification(
            token: uModel.token.toString(),
            // image: userModel.userImage.toString(),
            title: currentUserDataModel!.value.userName.text,
            body: 'has booked ${notifyModel.propertyName}.',
          );
        } else {
          Get.put(MainController()).sendPushNotification(
            token: uModel.token.toString(),
            // image: userModel.userImage.toString(),
            title: currentUserDataModel!.value.userName.text,
            body:
                'has booked ${notifyModel.propertyName}. Remaining payment is ${notifyModel.pendingPayment}',
          );
        }
        Get.offAll(BottomNavBar());
        bookingMdl.mPesa.clear();
        bookingMdl = BookingModel.initialize();
        print('notify done');
      }).onError((error, stackTrace) {
        print(error.toString());
      });

      // Get.back();
    }).onError((error, stackTrace) {
      loadingDialog(message: 'Something went wrong !!', button: true);
    });
  }


  Future<void> sendNotificationOnBooking(
    sellerID,
    listingID,
  AddListingModel  listingModel,bookingID
  ) async {
    print('done');


    loadingDialog(message: 'Please wait !!', loading: true);

    DocumentSnapshot bookingData = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingID)
        .get();
    BookingModel bookingModel = BookingModel.fromDocumentSnapshot(
        bookingData as DocumentSnapshot<Map<String, dynamic>>);

    ///
    DocumentSnapshot userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerID)
        .get();
    UserModel uModel = UserModel.fromDocumentSnapshot(
        userdata as DocumentSnapshot<Map<String, dynamic>>);
    // bookingMdl.buyerID = auth.currentUser!.uid;
    // bookingMdl.sellerID = sellerID;
    // bookingMdl.sellerName = uModel.userName.text;
    // bookingMdl.sellerPhoneNo = uModel.phoneNo.text;
    // bookingMdl.totalPayment = listingModel.cost.text;
    // bookingMdl.checkOut = bookingMdl.checkIn;


    // var data = await bookingMdl.toMap();
    // await FirebaseFirestore.instance
    //     .collection('bookings')
    //     .add(data)
    //     .then((value) async {
      ///sending notification
    notifyModel.checkIn = bookingModel.checkIn;

      notifyModel.ownerID = sellerID;
      // notifyModel.buyerID = ;
      notifyModel.propertyID = listingID;
      notifyModel.propertyName = listingModel.propertyName.text;
      notifyModel.propertyOwnerName = uModel.userName.text;
      notifyModel.ownerNumber = uModel.phoneNo.text;
      notifyModel.isPaymentDone =
          bookingMdl.pendingPayment == '0' ? true : false;
      notifyModel.checkIn = bookingModel.checkIn;
      notifyModel.pendingPayment = bookingModel.pendingPayment;
      notifyModel.bookingType = 'Tour';
      notifyModel.buyerName = bookingModel.buyerName.text;
      notifyModel.buyerNumber = bookingModel.buyerPhoneNo.text;

      var dataNotify = await notifyModel.toMap();
      //
      await FirebaseFirestore.instance
          .collection('notifications')
          // .doc(value.id)
          .add(dataNotify)
          .then((value) {

            print('sent');
        if (notifyModel.pendingPayment == '0') {
          Get.put(MainController()).sendPushNotification(
            token: uModel.token.toString(),
            // image: userModel.userImage.toString(),
            title: currentUserDataModel!.value.userName.text,
            body: 'has booked ${notifyModel.propertyName}.',
          );
        } else {
          Get.put(MainController()).sendPushNotification(
            token: uModel.token.toString(),
            // image: userModel.userImage.toString(),
            title: currentUserDataModel!.value.userName.text,
            body:
                'has booked ${notifyModel.propertyName}. Remaining payment is ${notifyModel.pendingPayment}',
          );
        }
        Get.offAll(BottomNavBar());
        bookingMdl.mPesa.clear();
        bookingMdl = BookingModel.initialize();
        print('notify done');
      }).onError((error, stackTrace) {
        print(error.toString());
      });

      // Get.back();
    // }).onError((error, stackTrace) {
    //   loadingDialog(message: 'Something went wrong !!', button: true);
    // });
  }
}
