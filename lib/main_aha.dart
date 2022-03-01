import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/networking/ChatApiProvider.dart';
import 'package:paitent/provider_setup.dart';
import 'package:paitent/ui/router.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_contstants.dart';
import 'networking/ApiProvider.dart';

Future<void> main() async {
  //enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: 'res/.env');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool('login1.5');
  login ??= false;
  primaryColor = Color(0XFFc10e21);
  primaryLightColor = Color(0XFFFFFFFF);
  runApp(MyApp(login));
}

//ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isLogin;
  String _baseUrl;
  String _botBaseUrl;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  Map<int, Color> color = {
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  };

  MyApp(bool isLogin) {
    getKnowdledgeLinkLastViewDate();
    debugPrint('Print from .env ==> ${dotenv.env['AHA_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['AHA_BOT_BASE_URL']}');
    _baseUrl = dotenv.env['AHA_BASE_URL'];

    _botBaseUrl = dotenv.env['AHA_BOT_BASE_URL'];
    this.isLogin = isLogin;
    setSessionFlag(isLogin);
    setAppType('AHA');
    setBaseUrl(_baseUrl);
    GetIt.instance.registerSingleton<ApiProvider>(ApiProvider(_baseUrl));
    GetIt.instance
        .registerSingleton<ChatApiProvider>(ChatApiProvider(_botBaseUrl));
    debugPrint('MyApp Constructor >> Login Session: $isLogin');
  }

  @override
  Widget build(BuildContext context) {
    final MaterialColor colorCustom = MaterialColor(0xFFB71C1C, color);
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
        title: 'HF Helper',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: colorCustom, fontFamily: 'Montserrat'),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        initialRoute: RoutePaths.Splash_Screen,
        /*home: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: AfterSplashScreen(isLogin),
            title: new Text('REAN Care\n\nDev-Build' , style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
            image: new Image.asset('res/images/app_logo_tranparent.png'),
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
