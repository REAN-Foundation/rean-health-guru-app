import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

//ignore: must_be_immutable
class WebViewBrowser extends StatefulWidget {
  String? _url;
  String? _tittle;

  WebViewBrowser({
    @required String? tittle,
    String? url,
  }) {
    _tittle = tittle;
    _url = url;
  }

  @override
  _WebViewBrowserState createState() => _WebViewBrowserState();
}

class _WebViewBrowserState extends State<WebViewBrowser> {
  bool isLoading = true;
  late String url;

  late final WebViewController _controller;


  @override
  void initState() {
    super.initState();
    url = widget._url.toString();
    /*if (Platform.isAndroid)
      WebView.platform = AndroidWebView();*/
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
            isLoading = true;
            setState(() {});
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            isLoading = false;
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            //openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(url));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features


    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('URL ==> ${widget._url}');
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text(
          widget._tittle!.substring(0, 1).toUpperCase() +
              widget._tittle!.substring(1),
          style: TextStyle(
              fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                color: primaryColor,
                height: 100,
                width: MediaQuery.of(context).size.width,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: primaryColor,
                height: 0,
                width: MediaQuery.of(context).size.width,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isLoading
                          ? Expanded(
                          flex: 3000,
                              child: Center(child: CircularProgressIndicator()))
                          : Container(),
                      Expanded(
                        child: WebViewWidget(controller: _controller), /*WebView(
                          initialUrl: widget._url,
                          onPageStarted: (String url) {
                            print('Page started loading: $url');
                            isLoading = true;
                            setState(() {});
                          },
                          onPageFinished: (String url) {
                            print('Page finished loading: $url');
                            isLoading = false;
                            setState(() {});
                          },
                          gestureNavigationEnabled: true,
                          allowsInlineMediaPlayback: true,
                          javascriptMode: JavascriptMode.unrestricted,
                        ),*/
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
