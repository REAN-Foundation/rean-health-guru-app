import 'package:device_apps/device_apps.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class InstallNewApp extends StatefulWidget {
  @override
  _InstallNewAppState createState() => _InstallNewAppState();
}

class _InstallNewAppState extends State<InstallNewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("res/images/bg_doodle.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 3, child: Container()),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getAppType() == 'AHA'
                      ? Image.asset(
                          'res/images/aha_logo.png',
                          semanticLabel: 'American Heart Association Logo',
                          height: 160,
                        )
                      : Image.asset(
                          'res/images/app_logo_transparent.png',
                          semanticLabel: 'REAN HealthGuru',
                          color: primaryColor,
                          height: 160,
                        ),
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Text(
                      "Exciting News: One AHA Helper app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
             /*     Text(getAppName(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),*/
                  /*SizedBox(
                    height: 16,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                    child: Text(
                        "HF Helper is merging with the Heart & Stroke Helper app! Take advantage of one app with all your health education and tracking needs in one place.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff636466),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: 220,
                    height: 48,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool isInstalled = await DeviceApps.isAppInstalled('org.heart.lipidprofile');
                          if(isInstalled){
                            DeviceApps.openApp('org.heart.lipidprofile');
                          }else {
                            await LaunchApp.openApp(
                              androidPackageName: 'org.heart.lipidprofile',
                              iosUrlScheme: 'hshelper://',
                              appStoreLink: 'itms-apps://itunes.apple.com/us/app/heart-stroke-helper/id1634663119',
                              // openStore: false
                            );
                          }
                        },
                        child: Text(
                          "Download App Now",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),

                  SizedBox(height: 16,),
                  Visibility(
                    visible: RemoteConfigValues.forceUserAppMerger,
                    child: TextButton(
                      onPressed: () {
                        /*if(auth!.isNotEmpty){
                          Navigator.pushNamedAndRemoveUntil(context, RoutePaths.Home, (Route<dynamic> route) => false);
                        }else{
                          Navigator.pushNamedAndRemoveUntil(context, RoutePaths.Login, (Route<dynamic> route) => false);
                        }*/
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                            decoration: TextDecoration.underline,
                            color: primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
