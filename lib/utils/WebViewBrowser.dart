import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  void initState() {
    super.initState();
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
        brightness: Brightness.dark,
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
                        child: WebView(
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
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
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
