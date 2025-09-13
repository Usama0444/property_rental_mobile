import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_rental_app/common_widgets/loading_dialog.dart';
import 'package:property_rental_app/pages/auth/login/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../main.dart';
import '../universal_models/user_model.dart';

///get user
Future<void> getCurrentUserData() async {
  if (auth.currentUser != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((value) async {
      if (value.exists && value.data()!.isNotEmpty) {
        currentUserDataModel = UserModel.fromDocumentSnapshot(value).obs;
        print('user data ==============');
        await setupToken();
        print(currentUser?.get('userEmail'));
      } else {
        auth.currentUser!.delete();
      }
    });
  }
}

//set up token for the device
Future<void> setupToken() async {
  // Get the token each time the application loads
  String? token = "";
  if (Platform.isAndroid) {
    token = await FirebaseMessaging.instance.getToken();
  }

  // Save the initial token to the database
  await saveTokenToDatabase(token);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

//save token to database
Future<void> saveTokenToDatabase(String? token) async {
  // Assume user is logged in for this example
  String userId = auth.currentUser!.uid;
  print('0000000000000000000000000000000000000 $userId');
  await FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .get()
      .then((value) async {
    print(token);
    print('token-----');
    if (value.data()!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'token': token,
        // 'university':'assda'
      });
    }
  }).then((value) {
    print('Token update done');
  }).onError((error, stackTrace) {});
}

///deleting account
Future<void> deleteUserAccount() async {
  
  if (auth.currentUser != null) {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .get();
    if (data.exists && data.data()!.isNotEmpty) {
      if (data.get('userEmail') != '') {
        try {
          await FirebaseAuth.instance.currentUser!.delete();
        } on FirebaseAuthException catch (e) {
          if (e.code == "requires-recent-login") {
            await _reauthenticateAndDelete(data);
          } else {
            print('deleting');
            await auth.currentUser?.delete();
          }
        } catch (e) {
          print(e.toString());
        }
      }
    } else {
      return null;
    }
  }
}

Future<void> _reauthenticateAndDelete(data) async {
  print('re-authenticating');
  try {
    debugPrint('trying');
    final providerData = auth.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await auth.currentUser!.reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await auth.currentUser!.reauthenticateWithProvider(GoogleAuthProvider());
    }
// Create a credential
    AuthCredential credential = EmailAuthProvider.credential(
        email: currentUserDataModel!.value.userEmail.text,
        password: currentUserDataModel!.value.password.text);

// Re-authenticate
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential)
        .then((value) async {
      await auth.currentUser?.delete().then((value) {
        debugPrint('deleted the account');
        Get.offAll(LoginScreen());
        data.reference.delete();
      });
    });
  } catch (e) {
    print(e.toString() + 'error 0000000000');
  }
}

///upload image to firebaseStorage
Future<String> uploadImageToFirebase(
    String refPath, Uint8List imagePath) async {
  String url = '';

  String id = auth.currentUser != null
      ? "${DateTime.now().millisecondsSinceEpoch}${auth.currentUser!.uid.toString()}"
      : '${DateTime.now().millisecondsSinceEpoch}';

//reference for storage
  final ref = FirebaseStorage.instance.ref(refPath).child(id);
//put file
  final uploadTask = await ref.putData(imagePath);

  url = await uploadTask.ref.getDownloadURL();

  return url;
}

///image from gallery or camera
Future<Uint8List?> getImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final image = await picker.pickImage(source: source);
  if (image != null) {
    Uint8List newImage = File(image.path.toString()).readAsBytesSync();
    newImage = await imageCompress(newImage);
    return newImage;
  } else {
    Get.snackbar('Not Selected', "Image not selected",
        backgroundColor: Colors.white);
    return null;
  }
}

Future<Uint8List?> getVideo(ImageSource imageSource) async {
  ImagePicker imagePicker = ImagePicker();
  final video = await imagePicker.pickVideo(source: imageSource);
  if (video != null) {
    print('Video picked');
    Uint8List? newVideo = await video.readAsBytes();
    print(newVideo);

    return newVideo;
  } else {
    print('No video picked');
    return null;
  }
}

///image from gallery or camera
Future<List<Uint8List>?> getMultipleImage() async {
  final ImagePicker picker = ImagePicker();
  final List<XFile>? image = await picker.pickMultiImage();
  if (image != null && image.isNotEmpty) {
    List<Uint8List> newImages = [];
    for (var image in image) {
      Uint8List imageData = await File(image.path).readAsBytes();
      imageData = await imageCompress(imageData);
      newImages.add(imageData);
    }
    return newImages;
  } else {
    Get.snackbar('Not Selected', "Image not selected",
        backgroundColor: Colors.white);
    return null;
  }
}

///compress image
Future<Uint8List> imageCompress(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1920,
    minWidth: 1080,
    quality: 96,
  );
  return result;
}
Future<void> updateUserToken() async {
  print("==> Updating token ${FirebaseAuth.instance.currentUser!.uid}");
  try {
    final String? token = await FirebaseMessaging.instance.getToken();
    print("==> Token: $token");
    // if (token != null) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    print("==> User ID: $userId");
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'token': token,
    }) .then((value) => print("....................Token updated.....................")).onError((error, stackTrace) => print("................. ${error}"));
    print("==> Token updated");
    print("==> User ID: $userId");

    // } else {
    //
    //   print("Error: Token is null");
    // }
  } catch (e) {
    print("Error while updating token: $e");
  }
}
///check if time has expired
// checkTimeExpire(String dateString, String docId, String status) async {
//   //converting the date time to datetime format to check it properly
//   print(docId.toString()+'    fgsrfdxhdc');
//   DateTime checkOutDate =
//       DateTime.fromMillisecondsSinceEpoch(int.parse(dateString));
//   DateTime currentDate = DateTime.now();
//   // Extract date parts for comparison
//   int meetingYear = checkOutDate.year;
//   int meetingMonth = checkOutDate.month;
//   int meetingDay = checkOutDate.day;
//
//   int currentYear = currentDate.year;
//   int currentMonth = currentDate.month;
//   int currentDay = currentDate.day;
// print('=jsagfciu=====================');
//   if (currentYear >= meetingYear ||
//       currentMonth >= meetingMonth ||
//       currentDay > meetingDay) {
//     print('================');
//     if (status == 'Pending') {
//       await FirebaseFirestore.instance
//           .collection('bookings')
//           .doc(docId)
//           .update({
//         'orderStatus': 'Completed',
//       }).then((value) {
//         print('status changes');
//       });
//     }
//     else{
//       print('no data');
//     }
//   }
//
//   else{
//     print('no uiewgfig');
//
//   }
// }
/// Check if the time has expired and update the order status if needed.
checkTimeExpire(String dateString, String docId, String status) async {
  // Converting the date time to DateTime format to check it properly
  print('$docId    fgsrfdxhdc');
  DateTime checkOutDate =
  DateTime.fromMillisecondsSinceEpoch(int.parse(dateString));
  DateTime currentDate = DateTime.now();
  print(checkOutDate);
  print(currentDate);

  // Normalize the checkOutDate to the start of the next day
  DateTime normalizedCheckOutDate = DateTime(checkOutDate.year, checkOutDate.month, checkOutDate.day + 1);

  // Get the current date and time
  // DateTime currentDate = DateTime.now();

  // Normalize the current date to the start of the current day
  DateTime normalizedCurrentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

  // Compare dates
  if (normalizedCurrentDate.isAfter(normalizedCheckOutDate)) {
    print('================');
    if (status == 'Pending') {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docId)
          .update({
        'orderStatus': 'Completed',
      }).then((value) {
        print('status changes');
      });
    }
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openWhatsAppChat(String phoneNumber) async {
  final url = 'whatsapp://send?phone=$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
//
// Future<void> sendEmail(String email, String subject, String body) async {
//   final emailEncoded = Uri.encodeFull(email);
//   final subjectEncoded = Uri.encodeFull(subject);
//   final bodyEncoded = Uri.encodeFull(body);
//   final url = 'mailto:$emailEncoded?subject=$subjectEncoded&body=$bodyEncoded';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
Future<void> sendEmail(String email) async {
  final emailEncoded = Uri.encodeFull(email);
  final url = 'mailto:uzairmalok3456@gmail.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> _sendEmail(
  String email,
) async {
  final url = 'mailto:$email';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<String?> videoThumbnail({required String urlForThumbnail}) async {
  try {
    final uniqueFilename = '${DateTime.now().millisecondsSinceEpoch}.webp';
    var fileName = await VideoThumbnail.thumbnailFile(
      video: urlForThumbnail,
      quality: 75,
      thumbnailPath:  (await getTemporaryDirectory()).path + '/$uniqueFilename',
      // thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
    );

    // print('${fileName}file 41');
    return fileName;
  } catch (error) {
    print('Error generating thumbnail: $error');
    return null; // Or provide a default file path if needed
  }
}

Future<bool> checkBookingAvailability(
    int checkInDateMillis, int checkOutDateMillis) async {
  // Query Firestore to fetch bookings within the specified time frame
  QuerySnapshot bookingsSnapshot =
  await FirebaseFirestore.instance.collection('bookings').get();

  // Filter the fetched bookings locally to check for conflicts
  for (QueryDocumentSnapshot bookingDoc in bookingsSnapshot.docs) {
    int bookingCheckInMillis = bookingDoc['checkIn'];
    int bookingCheckOutMillis = bookingDoc['checkOut'];

    // Check if the booking overlaps with the specified time frame
    if (bookingCheckInMillis < checkOutDateMillis &&
        bookingCheckOutMillis > checkInDateMillis) {
      // If there's an overlap, return false (not available)
      return false;
    }
  }

  // If no overlapping bookings are found, return true (available)
  return true;
}
Future<bool> checkBookingAvailabilitySold(
    int checkInDateMillis,) async {
  // Query Firestore to fetch bookings within the specified time frame
  QuerySnapshot bookingsSnapshot =
  await FirebaseFirestore.instance.collection('bookings').get();

  // Filter the fetched bookings locally to check for conflicts
  for (QueryDocumentSnapshot bookingDoc in bookingsSnapshot.docs) {
    int bookingCheckInMillis = bookingDoc['checkIn'];
    int bookingCheckOutMillis = bookingDoc['checkOut'];

    // Check if the booking overlaps with the specified time frame
    if (bookingCheckInMillis == checkInDateMillis ) {
      print('entered it means exist555555555555555555555');
      // If there's an overlap, return false (not available)
      return false;
    }
  }

  // If no overlapping bookings are found, return true (available)
  return true;
}
// Future<ShortDynamicLink> createDynamicLink(String deepLink) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'YOUR_DYNAMIC_LINK_DOMAIN', // Replace with your domain
//     link: Uri.parse(deepLink),
//     androidParameters: AndroidParameters(
//       packageName: 'YOUR_PACKAGE_NAME', // Replace with your package name
//     ),
//     iosParameters: IOSParameters(
//       bundleId: 'YOUR_BUNDLE_ID', // Replace with your bundle ID
//     ),
//   );
//
//   final ShortDynamicLink shortLink = await FirebaseDynamicLinks.createShortLink(parameters);
//   return shortLink;
// }

// DateTime parseCustomDate(String dateString) {
//   // Trim whitespaces from the date string
//   dateString = dateString.trim();
//
//   List<String> dateParts = dateString.split('-');
//
//   if (dateParts.length == 3) {
//     try {
//       int day = int.parse(dateParts[0]);
//       int month = int.parse(dateParts[1]);
//       int year = int.parse(dateParts[2]);
//
//       return DateTime(year, month, day);
//     } catch (e) {
//       // Handle parsing errors more gracefully
//       throw FormatException("Error parsing date: $dateString. $e");
//     }
//   } else {
//     throw FormatException("Invalid date format: $dateString");
//   }
// }
//

