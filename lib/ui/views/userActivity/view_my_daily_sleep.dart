import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/GetSleepData.dart';

import '../base_widget.dart';

class ViewMyDailySleep extends StatefulWidget {
  @override
  _ViewMyDailySleepState createState() => _ViewMyDailySleepState();
}

class _ViewMyDailySleepState extends State<ViewMyDailySleep> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetSleepData sleepData;
  String sleepHours = '';
  String sleepMin = '';

  @override
  void initState() {
    if (Platform.isIOS) {
      sleepData = GetIt.instance<GetSleepData>();
    }
    Future.delayed(const Duration(seconds: 3), () => getSleepHours());
    super.initState();
  }

  getSleepHours() {
    var msg = sleepData.getSleepDuration();

    if (msg == 'No Sleep data available') {
      showToast(msg, context);
      Navigator.pop(context);
      return;
    }

    double sleepTime = double.parse(sleepData.getSleepDuration());

    var time = sleepTime / 60;

    var parts = time.toString().split('.');

    sleepHours = parts[0].trim();
    sleepMin = parts[1].trim().substring(0, 2);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text(
                'Sleep',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700),
              ),
              iconTheme: IconThemeData(color: Colors.black),
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    sleepHours != ''
                        ? sleep()
                        : Center(
                            child: Text(
                              'Wait while sleep data is loading...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: primaryColor),
                            ),
                          ),
                    /* SizedBox(
                      height: 16,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [primaryLightColor, colorF6F6FF]),
                            border: Border.all(color: primaryLightColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        padding: const EdgeInsets.all(16),
                        height: 200,
                        child:
                            Container() */ /* Center(
                        child: SimpleTimeSeriesChart(_createSampleData()),
                      ),*/ /*
                        ),*/
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget sleep() {
    return Card(
      semanticContainer: false,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('res/images/ic_sleep_moon.png'),
                      size: 24,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Sleep',
                      semanticsLabel: 'Sleep',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      sleepHours,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'hr',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      sleepMin,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'min',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 00,
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.black87,
                    size: 24,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'You didn’t have\nenough sleep.\nIts better to sleep\n7-9 hours every day',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

/*static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime.now(), 6),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 1)), 7),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 2)), 6.5),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 3)), 7.5),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }*/
}
