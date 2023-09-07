import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:patient/core/constants/route_paths.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle when a notification is received while the app is in the foreground
      debugPrint("Notification ==> ${message.data.toString()}");
      _handleNotification(message.data, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a notification
      _handleNotification(message.data, context);
    });

    // You can also handle background notifications here
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
  }

  void _handleNotification(Map<String, dynamic> data, BuildContext context) {
    // Handle the notification data and navigate to the desired screen
    // For example, you can extract a route name from the data and navigate accordingly
    String routeName = data['type']; // Careplan registration reminder
    if (routeName != null) {
      switch (routeName) {
        case "Careplan registration reminder":
          debugPrint("<================== Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          Navigator.pushNamed(
              context, RoutePaths.Select_Care_Plan);
          break;
      }
      // Use Navigator to navigate to the specified screen
      // Navigator.pushNamed(context, routeName);
    }
  }

  Future<void> _handleBackgroundNotification(RemoteMessage message) async {
    // Handle background notifications here
  }

}
