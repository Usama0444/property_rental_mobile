import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import 'common_widgets/global_functions.dart';
import 'main.dart';

class MainController extends GetxController {
//firebase messaging
  final firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    onInitFrameCallBack();
    onMessage();
    onMessageOpened();
    await getCurrentUserData();
  }

  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;



      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
                playSound: true,
                // other properties...
              ),
            ));
      }
    });
  }

  //on message opened
  onMessageOpened(/*{required BuildContext context}*/) {

    print('hello world................');
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      RemoteNotification? notification = message.notification;
      // AndroidNotification? androidNotification = message.notification?.android;

      // List<String> contactstring =
      // message.data.values.elementAt(2);

      if (notification != null) {
        // if(notification.body =='sent connection request to assistant.'){
        //   Get.to(()=>  BottomNavScreen(indexx: 1));
        //
        // }
        // Get.to(()=>AssistantNotificationScreen());
      }
    });
  }

  onInitFrameCallBack() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (kDebugMode) {
        print('A new ON INIT event was published!');
      }
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1000), () async {});
      }
    });
  }

  //get token for device
  Future<String?> getToken() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    debugPrint("Token================================================ $fCMToken");
    return fCMToken;
  }

  //send push notification
  void sendPushNotification(
      {required String token,
        required String body,
        required String title,
        String? image,
        String? navigationId, String? sentTo}) async {
    try {
      await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAAKS6xQac:APA91bERlc0dnnvkN5dpVfqqPudWevPFkgPveOncvGzMjn7fIfhijXGyawFQLnl9TawNi3_DsLlLdbGrsiwZYjL3lji5EeUri9gRskWgwENZUmQLCpH7O9TCtzXMFHNxJoYp5hyu1YSB'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': "FLUTTER_NOTIFICATION_CLICK",
              'status': 'done',
              'body': body,
              'title': title,
              "sentTo": sentTo,
              "navigationId": navigationId,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'image': image,
            },
            "to": token
          }));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
