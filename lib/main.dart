import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/provider_setup.dart';
import 'package:paitent/ui/router.dart';
import 'package:paitent/ui/views/AfterSplashScreen.dart';
import 'package:paitent/ui/views/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//https://medium.com/@LohaniDamodar/flutter-separating-build-environment-with-multiple-firebase-environment-92e40e26d275

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool("login1.2");
  if (login == null) {
    login = false;
  }
  debugPrint('Main >> Login Session: ${login}');

  runApp(MyApp(login));
}

class MyApp extends StatelessWidget {
  bool isLogin;
  String _baseUrl = '';

  MyApp(@required isLogin) {
    this.isLogin = isLogin;
    GetIt.instance.registerSingleton<ApiProvider>(ApiProvider(_baseUrl));
    debugPrint('MyApp Constructor >> Login Session: ${isLogin}');
  }

  @override
  void initState() {
    //loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp >> Login Session: ${isLogin}');
    debugPrint('ApiProvider >> Base URL: ${_baseUrl}');
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
        showSemanticsDebugger: false,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple, fontFamily: 'Montserrat'),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        //initialRoute: isLogin == false ? RoutePaths.Login : RoutePaths.Home,
        home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: AfterSplashScreen(isLogin),
          title: new Text('REAN Care',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          image: new Image.asset('res/images/app_logo_tranparent.png'),
          backgroundColor: Colors.deepPurple,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.transparent,
          baseUrl: _baseUrl,
        ),
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }

  void loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool("login");
  }
}
