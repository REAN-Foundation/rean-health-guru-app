import 'package:flutter/material.dart';
import 'package:paitent/infra/provider_setup.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class AfterSplashScreen extends StatefulWidget {
  bool? isLogin;

  AfterSplashScreen(this.isLogin);

  @override
  _AfterSplashScreenViewState createState() => _AfterSplashScreenViewState();
}
//ignore: must_be_immutable
class _AfterSplashScreenViewState extends State<AfterSplashScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Login Session: ${widget.isLogin}');
    return MultiProvider(
      providers: providers,
      child: Container(),
    );
  }
}
