import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:patient/features/misc/ui/after_splash_screen.dart';
import 'package:patient/features/misc/ui/splash_screen.dart';
import 'package:patient/infra/provider_setup.dart';
import 'package:patient/infra/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//https://medium.com/@LohaniDamodar/flutter-separating-build-environment-with-multiple-firebase-environment-92e40e26d275

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login1.8');
  login ??= false;
  debugPrint('Main >> Login Session: $login');

  runApp(MyApp(login));
}
//ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? isLogin;

  MyApp(bool isLogin) {
    this.isLogin = isLogin;
    debugPrint('MyApp Constructor >> Login Session: $isLogin');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp >> Login Session: $isLogin');
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
          title: Text('REAN Care',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          image: Image.asset('res/images/app_logo_transparent.png'),
          backgroundColor: Colors.deepPurple,
          styleTextUnderTheLoader: TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.transparent,
          baseUrl: '',
        ),
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }

  loadSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('login');
  }
}
