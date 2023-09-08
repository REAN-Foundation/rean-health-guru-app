import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/infra/utils/common_utils.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late BuildContext _context;

  Future<void> initialize(BuildContext context) async {
    _context = context;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle when a notification is received while the app is in the foreground
      debugPrint("Notification onMessage ==> ${message.data.toString()}");
      _handleNotification(message.data, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a notification
      debugPrint("Notification onMessageOpenedApp ==> ${message.data.toString()}");
      _handleNotification(message.data, context);
    });

    // You can also handle background notifications here
    FirebaseMessaging.onBackgroundMessage(showNotification);
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
    debugPrint("Notification _handleBackgroundNotification ==> ${message.data.toString()}");
    _handleNotification(message.data, _context);
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse)  {
    showToast(notificationResponse.toString(), _context);
    if (notificationResponse != null) {
      debugPrint('notification payload: $notificationResponse');
    } else {
      debugPrint("Notification Done");
    }
    //Get.to(()=>SecondScreen(payload));
  }

  Future<void> showNotification(RemoteMessage payload) async {

    var android = AndroidInitializationSettings('logo_rs');
    //var initiallizationSettingsIOS = IOSInitializationSettings();
    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(

      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initialSetting = new InitializationSettings(android: android, iOS: initializationSettingsIOS);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initialSetting, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
          showToast(notificationResponse.toString(), _context);
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          //selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          /*if (notificationResponse.actionId == navigationActionId) {
            //selectNotificationStream.add(notificationResponse.payload);
          }*/
          break;
      }
    },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,);




    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notification',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "logo_rs",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("notification")
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
