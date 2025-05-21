import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_web_wiew;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:patient/features/common/health_device/models/health_device_list_with_status.dart';
import 'package:patient/features/common/health_device/view_models/health_device_view_model.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../infra/networking/custom_exception.dart';
import '../../../../infra/utils/common_utils.dart';
import '../../../../infra/utils/string_utility.dart';
import '../models/terra_session_id.dart';

class ConnectHealthDevicesView extends StatefulWidget {
  @override
  _ConnectHealthDevicesViewState createState() => _ConnectHealthDevicesViewState();
}

class _ConnectHealthDevicesViewState extends State<ConnectHealthDevicesView> {
  late ProgressDialog progressDialog;
  var model = HealthDeviceViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<WearableDeviceDetails> deviceList = <WearableDeviceDetails>[];

  getHealthDeviceListWithStatus() async {
    try {
      final HealthDeviceListWithStatus healthDeviceListWithStatus =
      await model.getHealthDeviceListWithTheirList();

      if (healthDeviceListWithStatus.status == 'success') {
        deviceList.clear();
        debugPrint(
            'Health Device List ==> ${healthDeviceListWithStatus.toJson()}');
        deviceList.addAll(healthDeviceListWithStatus.data!.wearableDeviceDetails!.toList());
        setState(() {

        });
      } else {
        showToast(healthDeviceListWithStatus.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    getHealthDeviceListWithStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HealthDeviceViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Connect Health Device',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
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
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: model!.busy ? Center(child: Container( height: 32, width: 32, child: CircularProgressIndicator())) : body(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16,),
          Text(
            'Choose a healthcare gadget/wearable.',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16,),
          listView(),
        ],
    );
  }


  Widget listView() {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  _makeListCard(context, index),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 8,
                );
              },
              itemCount: deviceList.length,
              shrinkWrap: true),
        ),
      ),
    );
  }

  _makeListCard(BuildContext context, int index) {

    WearableDeviceDetails details = deviceList.elementAt(index);

    return Card(
      semanticContainer: false,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
        color: primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(6.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            details.status == 'Disconnected' ? Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
            ) : Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 160,
              child: Text(
                details.provider.toString().toCapitalized(),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Material(
              color: Colors.transparent,
              child: Semantics(
                button: details.status == 'Disconnected' ? true : false,
                child: InkWell(
                  onTap: () {
                    if( details.status == 'Disconnected') {
                      generateSeesionId(details.provider.toString());
                    }else{
                      showToast('You are already connected to '+details.provider.toString().toCapitalized(), context);
                    }
                  },
                  child: Container(
                    height: 36,
                    width: 128,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: details.status == 'Disconnected' ? primaryColor : Colors.grey, width: 1),
                        color: details.status == 'Disconnected' ? primaryColor : Colors.grey,),
                    child: Center(
                      child: Text(
                        details.status == 'Disconnected' ? 'Connect' : 'Connected',
                        semanticsLabel: details.status == 'Disconnected' ? 'Connect to '+details.provider.toString() : 'Connected to '+details.provider.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );

  }

  Future<dynamic> generateSeesionId(String provider) async {
    progressDialog.show(max: 100, msg: 'Loading...');
    Map<String, String>? headers = <String, String>{};
    headers['x-api-key'] = dotenv.env['TERRA_API_KEY'].toString();
    headers['Dev-Id'] = dotenv.env['TERRA_DEVELOPER_ID'].toString();
    headers['Content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    /*if(dotenv.env['TERRA_API_KEY'].toString().isNotEmpty && dotenv.env['TERRA_DEVELOPER_ID'].toString().isNotEmpty){
      showToast('Terra Keys Imported', buildContext);
    }*/


    Map<String, String>? body = <String, String>{};
    body['reference_id'] = patientUserId.toString();
    body['providers'] = provider;
    body['language'] = 'en';

    debugPrint('Base Url ==> POST https://api.tryterra.co/v2/auth/generateWidgetSession');
    debugPrint('Request Body ==> ${json.encode(body).toString()}');
    debugPrint('Headers ==> ${json.encode(headers).toString()}');

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse('https://api.tryterra.co/v2/auth/generateWidgetSession'),
          body: json.encode(body), headers: headers)
          .timeout(const Duration(seconds: 40));
      /*if(progressDialog!.isOpen()) {
        progressDialog!.close();
      }
      progressDialog!.close();*/
      debugPrint('Terra Response Body ==> ${response.body}');
      debugPrint('Terra Response Code ==> ${response.statusCode}');
      responseJson = json.decode(response.body.toString());
      TerraSessionId sessionId = TerraSessionId.fromJson(responseJson);

      if(response.statusCode == 201) {
        debugPrint('Terra Session URL ==> ${sessionId.url!}');
        initTerraWebView(sessionId.url.toString());
        progressDialog.close();
      }else{
        progressDialog.close();
        showToast(sessionId.message.toString(), context);
        //showToast('Opps, something wents wrong!\nPlease try again', context);
      }
    } on SocketException {
      progressDialog.close();
      showToast('SocketException', context);
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      progressDialog.close();
      showToast('TimeoutException', context);
      throw FetchDataException('No Internet connection');
    } on Exception catch (e) {
      progressDialog.close();
      showToast(e.toString(), context);
      print("throwing new error");
      throw Exception("Error on server");
    }
    return responseJson;
  }

  initTerraWebView(String url) async {
    progressDialog.close();
    Navigator.pop(context);
    if (await canLaunchUrl(Uri.parse(url))) {
      await custom_web_wiew.launchUrl(Uri.parse(url));
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
  }

}