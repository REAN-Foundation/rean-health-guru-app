import 'dart:async';
import 'dart:io';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/GlassOfWaterConsumption.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/GetSleepData.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/SimpleTimeSeriesChart.dart';

import '../base_widget.dart';

class ViewMyDailySleep extends StatefulWidget {
  @override
  _ViewMyDailySleepState createState() => _ViewMyDailySleepState();
}

class _ViewMyDailySleepState extends State<ViewMyDailySleep> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat('yyyy-MM-dd');
  GetSleepData sleepData;
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
  GlassOfWaterConsumption glassOfWaterConsumption;
  DateTime startDate;
  DateTime endDate;
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

    setState(() => _state = AppState.FETCHING_DATA);

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
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      debugPrint('Authorization not granted');
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
        ),
        /*stepCounter(),
        SizedBox(
          height: 16,
        ),
        */ /*heartRate(),
        SizedBox(
          height: 8,
        ),*/ /*
        calories(),
        SizedBox(
          height: 8,
        ),*/
        /* sleep(),
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
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Center(
            child: Container(),
          ),
        ),*/
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: heartRate()),
            SizedBox(width: 8,),
            Expanded(
                flex: 1,
                child: bmi()),
          ],
        ),
        SizedBox(height: 8,),
        glassForWater(),
        SizedBox(height: 8,),
        sleep(),*/
      ],
    );
  }

  Widget _contentNotFetched() {
    return Text(''); //Press the download button to fetch data
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  _content() {
    if (_state == AppState.DATA_READY) {
      calculateSteps();
      debugPrint('DATA_READY');
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA) {
      debugPrint('NO_DATA');
      return _contentDataReady();
    } else if (_state == AppState.FETCHING_DATA) {
      debugPrint('FETCHING_DATA');
      return _contentFetchingData();
    } else if (_state == AppState.AUTH_NOT_GRANTED) {
      debugPrint('AUTH_NOT_GRANTED');
      return _authorizationNotGranted();
    }
    return _contentNotFetched();
  }

  calculateSteps() {
    clearAllRecords();
    for (int i = 0; i < _healthDataList.length; i++) {
      final HealthDataPoint p = _healthDataList[i];
      if (p.typeString == 'STEPS') {
        steps = steps + p.value.toInt();
      } else if (p.typeString == 'WEIGHT') {
        if (p.value.toDouble() != 0) {
          //weight = p.value.toDouble();
        }
      } else if (p.typeString == 'HEIGHT') {
        if (p.value.toDouble() != 0) {
          //height = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'ACTIVE_ENERGY_BURNED') {
        totalActiveCalories = totalActiveCalories + p.value.toDouble();
      } else if (p.typeString == 'BASAL_ENERGY_BURNED') {
        totalBasalCalories = totalBasalCalories + p.value.toDouble();
      } else if (p.typeString == 'HEART_RATE') {
        heartRateBmp = p.value.toInt();
      }
    }

    if (height == 0.0 || weight == 0.0) {
    } else {
      calculetBMI();
    }

    totalCalories = totalActiveCalories + totalBasalCalories;

    debugPrint('STEPS : $steps');
    debugPrint('ACTIVE_ENERGY_BURNED : $totalActiveCalories');
    debugPrint('BASAL_ENERGY_BURNED : $totalBasalCalories');
    debugPrint('CALORIES_BURNED : $totalBasalCalories');
    debugPrint('WEIGHT : $weight');
    debugPrint('Height : $height');
    //recordMySteps();
    //recordMyCalories();
  }

  calculetBMI() {
    final double heightInMeters = height / 100;
    final double heightInMetersSquare = heightInMeters * heightInMeters;

    bmiValue = weight / heightInMetersSquare;

    if (bmiValue == 0.0) {
      bmiResult = '';
    } else if (bmiValue < 18.5) {
      bmiResult = 'Underweight';
      bmiResultColor = Colors.indigoAccent;
    } else if (bmiValue > 18.6 && bmiValue < 24.9) {
      bmiResult = 'Healthy';
      bmiResultColor = Colors.green;
    } else if (bmiValue > 25 && bmiValue < 29.9) {
      bmiResult = 'Overweight';
      bmiResultColor = Colors.orange;
    } else if (bmiValue > 30 && bmiValue < 39.9) {
      bmiResult = 'Obese';
      bmiResultColor = Colors.deepOrange;
    } else {
      bmiResult = 'Severely Obese';
      bmiResultColor = Colors.red;
    }

    if (Platform.isAndroid) {
      setState(() {});
    }

    /*new Timer(const Duration(milliseconds: 3000), () {
      setState(() {
      });
    });
*/
  }

  clearAllRecords() {
    //bmiValue = 0 ;
    totalActiveCalories = 0;
    totalBasalCalories = 0;
    totalCalories = 0;
    steps = 0;
    //weight = 0;
    //height = 0;
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      padding: const EdgeInsets.all(16),
                      height: 200,
                      child: Center(
                        child: SimpleTimeSeriesChart(_createSampleData()),
                      ),
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
                      '6',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
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

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(DateTime.now(), 6),
      new TimeSeriesSales(DateTime.now().subtract(Duration(days: 1)), 7),
      new TimeSeriesSales(DateTime.now().subtract(Duration(days: 2)), 6.5),
      new TimeSeriesSales(DateTime.now().subtract(Duration(days: 3)), 7.5),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
