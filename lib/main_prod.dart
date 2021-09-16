import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/provider_setup.dart';
import 'package:paitent/ui/router.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_contstants.dart';
import 'networking/ApiProvider.dart';
import 'networking/ChatApiProvider.dart';

//flutter build apk --release --flavor dev -t lib/main_dev.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: 'res/.env');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool('login1.2');
  login ??= false;
  runApp(MyApp(login));
}

class MyApp extends StatelessWidget {
  bool isLogin;
  String _baseUrl;
  String _botBaseUrl;

  MyApp(@required bool isLogin) {
    debugPrint('Print from .env ==> ${dotenv.env['PROD_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['DEV_BOT_BASE_URL']}');
    _baseUrl = dotenv.env['PROD_BASE_URL'];
    _botBaseUrl = dotenv.env['PROD_BOT_BASE_URL'];
    this.isLogin = isLogin;
    setSessionFlag(isLogin);
    setBaseUrl(_baseUrl);
    GetIt.instance.registerSingleton<ApiProvider>(ApiProvider(_baseUrl));
    GetIt.instance
        .registerSingleton<ChatApiProvider>(ChatApiProvider(_botBaseUrl));
    debugPrint('MyApp Constructor >> Login Session: $isLogin');
  }

  @override
  void initState() {
    //loadSharedPrefs();
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple, fontFamily: 'Montserrat'),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        initialRoute: RoutePaths.Splash_Screen,
        /*home: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: AfterSplashScreen(isLogin),
            title: new Text('REAN Care\n\nDev-Build' , style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
            image: new Image.asset('res/images/app_logo_tranparent.png'),
            backgroundColor: Colors.deepPurple,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.transparent,
            baseUrl: _baseUrl,
        ),*/
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }

  void loadSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('login');
  }
}
