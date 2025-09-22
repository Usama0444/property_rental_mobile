import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/main_controller.dart';
import 'package:property_rental_app/universal_models/user_model.dart';
import 'pages/splash/splash_screen.dart';

//android channel for notification
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'propertyRentalID', // id
  'High Importance Notifications', // title
  importance: Importance.max,
  playSound: true,
);

//messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

RemoteMessage? message; //message to handle notification

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(MainController()));
  currentUser = await checkUserData();
  runApp(const MyApp());

  message = await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

///variables
final auth = FirebaseAuth.instance;

DocumentSnapshot<Map<String, dynamic>>? currentUser; //current user snap
Rx<UserModel>? currentUserDataModel; //current user model

///check user role
Future<DocumentSnapshot<Map<String, dynamic>>?> checkUserData() async {
  if (auth.currentUser != null) {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .get();
    if (data.exists && data.data()!.isNotEmpty) {
      if (data.get('userEmail') == '') {
        data.reference.delete();
        auth.currentUser!.delete();
        return null;
      }     
      print('assigning user model');
      currentUserDataModel = UserModel.fromDocumentSnapshot(data).obs;
      return data;
    } else {
      auth.currentUser!.delete();
      return null;
    }
  }
  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Property Rental',
        // home: LandingPage(),
        // home:
        //     currentUser != null ? BottomNavBar() : LandingPage(),
        home: SplashScreen(),
      ),
    );
  }
}
