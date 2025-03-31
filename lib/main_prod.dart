import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/infra/networking/awards_api_provider.dart';
import 'package:patient/infra/networking/user_analytics_api_provider.dart';

import 'package:patient/infra/provider_setup.dart';
import 'package:patient/infra/router.dart';
import 'package:patient/infra/services/NavigationService.dart';
import 'package:patient/infra/services/NotificationHandler.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/route_paths.dart';
import 'infra/networking/api_provider.dart';
import 'infra/networking/chat_api_provider.dart';

//flutter build apk --release --flavor dev -t lib/main_dev.dart

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse != null) {
    debugPrint('notification payload: $notificationResponse');
  } else {
    debugPrint("Notification Done");
  }
}


Future<void> showNotification(RemoteMessage payload) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_notification_channel_id',
    'Notification',
    importance: Importance.max,
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationHandler().initialize();
  Permission.notification.request();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission();
  await dotenv.load(fileName: 'res/.env');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login1.8.167');
  login ??= false;
  String? sponsor = prefs.getString('Sponsor');
  setSponsor(sponsor??'');
  runApp(MyApp(login));
}
//ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? isLogin;
  String? _baseUrl;
  String? _botBaseUrl;
  String? _awardBaseUrl;
  String? _userAnalyticsBaseUrl;
  
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  MyApp(bool isLogin) {
    debugPrint('Print from .env ==> ${dotenv.env['PROD_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['DEV_BOT_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['AWARD_BASE_URL']}');
    _baseUrl = dotenv.env['PROD_BASE_URL'];
    _botBaseUrl = dotenv.env['PROD_BOT_BASE_URL'];
    _awardBaseUrl = dotenv.env['AWARD_BASE_URL'];
    _userAnalyticsBaseUrl = dotenv.env['USER_ANALYTICS_BASE_URL'];
    this.isLogin = isLogin;
    setSessionFlag(isLogin);
    setBaseUrl(_baseUrl);
    setAppName('REAN HealthGuru');
    setAppFlavour('REAN HealthGuru');
    GetIt.instance.registerSingleton<ApiProvider>(ApiProvider(_baseUrl));
    GetIt.instance
        .registerSingleton<ChatApiProvider>(ChatApiProvider(_botBaseUrl));
    GetIt.instance
        .registerSingleton<AwardApiProvider>(AwardApiProvider(_awardBaseUrl));
    GetIt.instance
        .registerSingleton<UserAnalyticsApiProvider>(UserAnalyticsApiProvider(_userAnalyticsBaseUrl));
    debugPrint('MyApp Constructor >> Login Session: $isLogin');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp >> Login Session: $isLogin');
    debugPrint('ApiProvider >> Base URL: $_baseUrl');
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'REAN HealthGuru',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple, fontFamily: 'Montserrat'),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        initialRoute: RoutePaths.Splash_Screen,
        /*home: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: AfterSplashScreen(isLogin),
            title: new Text('REAN Care\n\nDev-Build' , style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
            image: new Image.asset('res/images/app_logo_transparent.png'),
            backgroundColor: primaryColor,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.transparent,
            baseUrl: _baseUrl,
        ),*/
        onGenerateRoute: Routers.generateRoute,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }

  loadSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('login');
  }
}
