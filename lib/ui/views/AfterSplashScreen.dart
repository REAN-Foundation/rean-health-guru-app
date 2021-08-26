

import 'package:flutter/material.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:provider/provider.dart';

import '../../provider_setup.dart';
import '../router.dart';

class AfterSplashScreen extends StatefulWidget {

  bool isLogin;

  AfterSplashScreen(@required this.isLogin);

  @override
  _AfterSplashScreenViewState createState() => _AfterSplashScreenViewState();
}

class _AfterSplashScreenViewState extends State<AfterSplashScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Login Session: ${widget.isLogin}');
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'HealthCare Doctor',
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            fontFamily: 'Montserrat'
        ),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        initialRoute: widget.isLogin == false || widget.isLogin == null ? RoutePaths.On_Boarding : RoutePaths.Home,
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }

}