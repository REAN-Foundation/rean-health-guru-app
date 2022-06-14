import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/get_sleep_data.dart';

import '../../../misc/ui/base_widget.dart';

class ViewMyDailySleep extends StatefulWidget {
  @override
  _ViewMyDailySleepState createState() => _ViewMyDailySleepState();
}

class _ViewMyDailySleepState extends State<ViewMyDailySleep> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HealthDataPoint> _healthDataList = [];
  var dateFormat = DateFormat('yyyy-MM-dd');
  GetSleepData? sleepData;
  int steps = 0;
  double weight = 0;
  double height = 0;
  double totalActiveCalories = 0;
  double totalBasalCalories = 0;
  double totalCalories = 0;
  double bmiValue = 0;
  int waterGlass = 0;
  String bmiResult = '';
  Color bmiResultColor = Colors.black87;
  late DateTime startDate;
  late DateTime endDate;
  int heartRateBmp = 0;

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    //loadSharedPref();
    if (Platform.isIOS) {
      //fetchData();
      //sleepData = GetSleepData();
    }
    super.initState();
  }

  Future<void> fetchData() async {
    /// Get everything from midnight until now
    //DateTime startDate = DateTime(2021, 01, 01, 0, 0, 0);
    //DateTime endDate = DateTime(2021, 07, 07, 23, 59, 59);

    /*startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);*/

    final HealthFactory health = HealthFactory();

    /// Define the types to get.
    final List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      //HealthDataType.HEART_RATE
      //HealthDataType.BASAL_ENERGY_BURNED,
      //HealthDataType.DISTANCE_WALKING_RUNNING,
    ];


    /// You MUST request access to the data types before reading them
    final bool accessWasGranted = await health.requestAuthorization(types);

    //this.steps = 0;
    if (accessWasGranted) {
      try {
        /// Fetch new data
        final List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        debugPrint('Caught exception in getHealthDataFromTypes: $e');
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      /*_healthDataList.forEach((x) {
        debugPrint('Data point:  $x');
        steps += x.value.round();
      });*/

      //debugPrint("Steps: $steps");

      //this.steps = steps;

      /// Update the UI to display the results

    } else {
      debugPrint('Authorization not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel?>(
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
                    fontWeight: FontWeight.w600),
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
                    sleep(),
                    SizedBox(
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
                            Container() /* Center(
                        child: SimpleTimeSeriesChart(_createSampleData()),
                      ),*/
                        ),
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
                          fontWeight: FontWeight.w600,
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
                      '6',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'hrs',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '32',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
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
