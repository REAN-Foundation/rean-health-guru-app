import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;
  AppsFlyerService._internal();

  late AppsflyerSdk appsflyerSdk;

  Future<void> initSdk() async {

    String devKey = dotenv.env['APPS_FLYER_DEV_KEY'] ?? '';
    String appId = dotenv.env['APPS_FLYER_APP_ID'] ?? '';

    debugPrint("AppsFlyer Dev Key: ==>  $devKey");
    debugPrint("AppsFlyer App ID: ==>  $appId");

    // Normalize and validate appId: accept numeric or 'id' prefix (e.g. id123456789)
    String? validAppId;
    if (appId != null && appId.isNotEmpty) {
      var normalized = appId;
      if (normalized.toLowerCase().startsWith('id')) {
        normalized = normalized.substring(2);
      }
      final exp = RegExp(r'^\d+$');
      if (exp.hasMatch(normalized)) {
        validAppId = normalized;
      } else {
        debugPrint('Invalid AppsFlyer App ID: $appId. Skipping appId to avoid assertion.');
      }
    }

    final AppsFlyerOptions options = (validAppId != null)
        ? AppsFlyerOptions(
      afDevKey: devKey,
      appId: validAppId, // only set when valid
      showDebug: true,
    )
        : AppsFlyerOptions(
      afDevKey: devKey,
      showDebug: true,
    );

    appsflyerSdk = AppsflyerSdk(options);

    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    getDeviceId();
    showDeepLink();
  }

  /// Optional: log events
  Future<void> logEvent(String eventName, Map<String, dynamic> values) async {
    await appsflyerSdk.logEvent(eventName, values);
  }

  getDeviceId() async {
    String? id = await AppsFlyerService().appsflyerSdk.getAppsFlyerUID();
    debugPrint("AppsFlyer UID: ==>  $id");
  }

  showDeepLink(){
    appsflyerSdk.onDeepLinking((deepLink) {
      debugPrint("AppsFlyer Deeplink: ==>  ${deepLink.deepLink}"); // "installpage"
    });
  }

}
