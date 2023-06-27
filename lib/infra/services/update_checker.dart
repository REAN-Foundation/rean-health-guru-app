import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateChecker{

  UpdateChecker(BuildContext context){
    _context = context;
    _initPackageInfo();
  }

  String minimumAppVersion =  RemoteConfigValues.minimumAppVersionRequired;
  //String minimumAppVersion =  '1.9.0';
  late BuildContext _context;


  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
        _packageInfo = info;

    print('ForceUpdateChecker App Name ==> ${_packageInfo.appName}');
    print('ForceUpdateChecker Version ==> ${_packageInfo.version}');
    print('ForceUpdateChecker Build Number ==> ${_packageInfo.buildNumber}');
    print('ForceUpdateChecker Package Name ==> ${_packageInfo.packageName}');
    checkForceUpdateAppVersion();
  }

  checkForceUpdateAppVersion() async {
    print('ForceUpdateChecker in checkAppVersion 1');
    String currentAppVersion = _packageInfo.version;
    if (currentAppVersion.compareTo(minimumAppVersion) < 0) {
      print('ForceUpdateChecker in checkAppVersion 2');
      // Perform actions for force update, such as showing a dialog or redirecting to app store
      // You can use packages like `url_launcher` to open the app store URL
      showForceUpdateDialog();
    }
  }

  void showForceUpdateDialog() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Force Update Required', style: TextStyle( fontSize: 18, fontWeight: FontWeight.w600),),
          content: Text('A new version of the app is now available. To ensure uninterrupted usage, kindly update to the latest version.', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500),),
          actions: [
            ElevatedButton(
              child: Text('UPDATE'),
              onPressed: () {
                launchAppStore(); // Function to open the app store URL
              },
            ),
          ],
        );

       /* return  Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(24),
          //this right here
          child: Card(
            elevation: 0.0,
            margin: EdgeInsets.zero,
            semanticContainer: false,
            child: Container(
              height: 340.0,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4)),
                      color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                    ),
                    child: Center(
                      child: Container(
                        height: 160,
                        child: ExcludeSemantics(
                          child: Icon(Icons.security_update, size: 32, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Text(
                    'A new version of the app is available. Please update to continue using the app.',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Semantics(
                            button: true,
                            label: 'Update App',
                            child: ExcludeSemantics(
                              child: InkWell(
                                onTap: () {
                                  launchAppStore();
                                },
                                child: Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width - 32,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      border:
                                      Border.all(color: primaryColor, width: 1),
                                      color: primaryColor),
                                  child: Center(
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );*/
      },
    );
  }

  launchAppStore() async {
    late String appStoreUrl; // Replace with your app's store URL

    if(Platform.isAndroid){
      appStoreUrl = dotenv.env['PLAY_STORE_URL'].toString();
    }else{
      appStoreUrl = dotenv.env['APP_STORE_URL'].toString();
    }

    if (await canLaunchUrlString(appStoreUrl)) {
      await launchUrlString(appStoreUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $appStoreUrl';
    }
  }


}