import 'dart:async';
import 'dart:core';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:package_info/package_info.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final dynamic navigateAfterSeconds;
  final double? photoSize;
  final dynamic onClick;
  final Color? loaderColor;
  final Image? image;
  final Text loadingText;
  final ImageProvider? imageBackground;
  final Gradient? gradientBackground;
  final String? baseUrl;

  SplashScreen(
      {this.loaderColor,
      required this.seconds,
      this.photoSize,
      this.onClick,
      this.navigateAfterSeconds,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
      this.image,
      this.loadingText = const Text(''),
      this.imageBackground,
      this.gradientBackground,
      this.baseUrl});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
    try {
      final String? locale = await FlutterSimCountryCode.simCountryCode;
      if (locale!.trim().isNotEmpty) {
        setCurrentLocale(locale.toUpperCase());
        debugPrint('Country Local ==> ${locale.toUpperCase()}');
      } else {
        final Locale? countryLocale = await Devicelocale.currentAsLocale;
        setCurrentLocale(countryLocale!.countryCode!.toUpperCase());
        debugPrint(
            'Country Local ==> ${countryLocale.countryCode!.toUpperCase()}');
      }
    } catch (e) {
      final Locale? countryLocale = await Devicelocale.currentAsLocale;
      setCurrentLocale(countryLocale!.countryCode!.toUpperCase());
      debugPrint(
          'Country Local ==> ${countryLocale.countryCode!.toUpperCase()}');
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    getDailyCheckInDate();
    super.initState();
    Timer(Duration(seconds: widget.seconds), () {
      /*if (widget.navigateAfterSeconds is String) {
            // It's fairly safe to assume this is using the in-built material
            // named route component
            Navigator.of(context).pushReplacementNamed(
                widget.navigateAfterSeconds);
          } else if (widget.navigateAfterSeconds is Widget) {
            Navigator.of(context).pushReplacement(new AppPageRoute(
                builder: (BuildContext context) => widget
                    .navigateAfterSeconds));
          } else {
            throw new ArgumentError(
                'widget.navigateAfterSeconds must either be a String or Widget'
            );
          }*/

      if (getSessionFlag()) {
        Navigator.of(context).pushReplacementNamed(RoutePaths.Home);
      } else {
        if (getAppType() == 'AHA') {
          Navigator.of(context)
              .pushReplacementNamed(RoutePaths.On_Boarding_AHA);
        } else {
          Navigator.of(context).pushReplacementNamed(RoutePaths.On_Boarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: getAppType() == 'AHA' ? primaryLightColor : primaryColor,
      body: InkWell(
        onTap: widget.onClick,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /*Positioned(
                top: -height * .20,
                right: -MediaQuery
                    .of(context)
                    .size
                    .width * .4,
                child: BezierContainer()),*/
            MergeSemantics(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 240,
                          width: 240,
                          /*  decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))
                              ),*/
                          child: Semantics(
                            label: getAppType() == 'AHA'
                                ? 'American Heart Association Logo'
                                : 'REAN HealthGuru app logo',
                            image: true,
                            child: getAppType() == 'AHA'
                                ? Image.asset('res/images/aha_logo.png')
                                : Image.asset(
                                    'res/images/app_logo_tranparent.png'),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        getAppType() == 'AHA'
                            ? Text('HF Helper',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor))
                            : Container(),
                        //SizedBox(height: 60,),
                        /*new CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: new Container(
                                  child: widget.image
                              ),
                              radius: widget.photoSize,
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            widget.title*/
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color?>(
                              widget.loaderColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        //widget.loadingText
                        Semantics(
                          label: 'display',
                          readOnly: true,
                          child: Text(
                              'Version ' +
                                  (widget.baseUrl!.contains('dev')
                                      ? 'Dev_'
                                      : widget.baseUrl!.contains('uat')
                                          ? 'Alpha_'
                                          : '') +
                                  _packageInfo.version,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: getAppType() == 'AHA'
                                      ? primaryColor
                                      : Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*Positioned(
                bottom: -height * .30,
                right: MediaQuery
                    .of(context)
                    .size
                    .width * .35,
                child: Transform.rotate(angle: 160, child: BezierContainer())),*/
          ],
        ),
      ),
    );
  }

/*Widget _title() {
    return Hero(
      tag: "title",
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'REAN',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            children: [
              TextSpan(
                text: ' ',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'C',
                style: TextStyle(color: primaryColor, fontSize: 30),
              ),
              TextSpan(
                text: 'are',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ]),
      ),
    );
  }*/
}
