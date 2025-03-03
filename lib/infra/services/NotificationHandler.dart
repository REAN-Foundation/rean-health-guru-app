import 'package:event/event.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:patient/infra/services/NavigationService.dart';
import 'package:patient/infra/utils/CommonAlerts.dart';
import 'package:patient/infra/utils/common_utils.dart';

class NotificationHandler {

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle when a notification is received while the app is in the foreground
      debugPrint("Notification onMessage ==> ${message.data.toString()}");
      String routeName = message.data['type'];
      debugPrint("Route Name ==> $routeName");
      if(routeName == "Reminder"){
        debugPrint("Display Onces ==> $displayAlertOnces");
        //myEvent.broadcast(NotificationBody(message.notification!.title.toString(), message.notification!.body.toString(), message.data['type']));
        if(displayAlertOnces) {
          displayAlertOnces = false;
          CommonAlerts.reminderAlert(
              message: message.notification!.title.toString(),
              context: NavigationService.navigatorKey.currentContext!);
          changeDisplayOnceFlag();
        }
      }else if(routeName == "Careplan registration reminder"){
        if(displayAlertOnces) {
          displayAlertOnces = false;
          CommonAlerts.showHealthJourneyDialog(
              context: NavigationService.navigatorKey.currentContext!);
          changeDisplayOnceFlag();
        }
      }else if(routeName == "BloodPressureAlert"){
        notificationMessage = message.notification!.body.toString();
        if(displayAlertOnces) {
          displayAlertOnces = false;
          CommonAlerts.abnormalReadingAlert(
              message: message.notification!.body.toString(),
              context: NavigationService.navigatorKey.currentContext!);
          changeDisplayOnceFlag();
        }
      }
      //_handleNotification(message.data);
      //showNotification(message);
    });

    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a notification
      debugPrint("Notification onMessageOpenedApp ==> ${message.data.toString()}");
      //_handleNotification(message.data);
    });*/

    // You can also handle background notifications here
    //FirebaseMessaging.onBackgroundMessage(showNotification);
  }

  changeDisplayOnceFlag(){
    Future.delayed(
        const Duration(seconds: 10), () {
        displayAlertOnces = true;
    });
  }



 /* void _handleNotification(Map<String, dynamic> data) {
    // Handle the notification data and navigate to the desired screen
    // For example, you can extract a route name from the data and navigate accordingly
    String routeName = data['type']; // Careplan registration reminder
    if (routeName != null) {
      switch (routeName) {
        case "Careplan registration reminder":
          debugPrint("<================== Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          *//*Navigator.pushNamed(
              context, RoutePaths.Select_Care_Plan);*//*
          break;
      }
      // Use Navigator to navigate to the specified screen
      // Navigator.pushNamed(context, routeName);
    }
  }*/

  /*Future<void> _handleBackgroundNotification(RemoteMessage message) async {
    // Handle background notifications here
    debugPrint("Notification _handleBackgroundNotification ==> ${message.data.toString()}");
    _handleNotification(message.data);
  }*/

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse)  {

    if (notificationResponse != null) {
      debugPrint('notification payload: $notificationResponse');
    } else {
      debugPrint("Notification Done");
    }
    //Get.to(()=>SecondScreen(payload));
  }

  static Future<void> showNotification(RemoteMessage payload) async {
    debugPrint('Show Notification');
    var android = AndroidInitializationSettings('reancare_logo');
    //var initiallizationSettingsIOS = IOSInitializationSettings();
    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(

      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initialSetting = InitializationSettings(android: android, iOS: initializationSettingsIOS);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initialSetting);


    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'fcm_default_channel',
        'Urgent',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
    );
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(0, payload.notification!.title, payload.notification!.body, platformChannelSpecifics, payload: payload.toString());
  }


}

// An example custom 'argument' class
class NotificationBody extends EventArgs {
  String? title;
  String? body;
  String? type;
  NotificationBody(this.title, this.body, this.type);
}

