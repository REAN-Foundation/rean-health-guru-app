import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GlassOfWaterConsumption.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/Conversion.dart';
import 'package:paitent/utils/GetHealthData.dart';
import 'package:paitent/utils/GetSleepData.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../base_widget.dart';

//ignore: must_be_immutable
class ViewMyAllDailyActivity extends StatefulWidget {
  String _path = '';

  ViewMyAllDailyActivity(String path) {
    _path = path;
  }

  @override
  _ViewMyAllDailyActivityState createState() => _ViewMyAllDailyActivityState();
}

class _ViewMyAllDailyActivityState extends State<ViewMyAllDailyActivity> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  ScrollController _scrollController;
  GetHealthData data;
  final durationInMin = Duration(minutes: 5);

  @override
  void initState() {
    _scrollController = ScrollController();
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    //loadSharedPref();
    //loadWaterConsuption();
    if (Platform.isIOS) {
      fetchData();
      sleepData = GetSleepData();
      data = GetHealthData();
      Timer.periodic(durationInMin, (Timer t) => fetchData());
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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
          Text('Fetching data...')
        ],
      ),
    );
  }

  Widget _contentDataReady() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 16,
        ),
        stepCounter(),
        SizedBox(
          height: 16,
        ),
        exerciseTime(),
        SizedBox(
          height: 16,
        ),
       /* sleepTime(),
        SizedBox(
          height: 16,
        ),*/
        burnedCalories(),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  movetoPosition() {
    switch (widget._path) {
      case "Steps":
        _scrollController.animateTo(0,
            duration: Duration(seconds: 0), curve: Curves.ease);
        break;
      case "Exercise":
        _scrollController.animateTo(340,
            duration: Duration(seconds: 1), curve: Curves.ease);
        break;
      case "Sleep":
        _scrollController.animateTo(680,
            duration: Duration(seconds: 2), curve: Curves.ease);
        break;
      case "Calories":
        _scrollController.animateTo(1020,
            duration: Duration(seconds: 2), curve: Curves.ease);
        break;
      default:
        _scrollController.animateTo(0,
            duration: Duration(seconds: 2), curve: Curves.ease);
        break;
    }
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
              elevation: 0,
              backgroundColor: primaryColor,
              brightness: Brightness.dark,
              title: Text(
                'Activity',
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
                            color: Color(0XFFf7f5f5),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12))),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _content(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                ),*/
              ],
            )),
      ),
    );
  }

  Widget stepCounter() {
    double stepPercent = steps / 10000;
    if (stepPercent > 1.0) {
      stepPercent = 1.0;
    }
    debugPrint('Step % : $stepPercent');
    return Container(
      height: 240,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
        alignment: Alignment.center,
        child: CircularPercentIndicator(
          radius: 160.0,
          lineWidth: 13.0,
          animation: true,
          percent: stepPercent,
          header: Column(
            children: [
              Text(
                'Steps',
                semanticsLabel: 'Steps',
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: textBlack),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
              ),
              ImageIcon(
                AssetImage('res/images/ic_steps_count.png'),
                size: 32,
                color: primaryColor,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                steps.toString(),
                semanticsLabel: steps.toString(),
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    fontSize: 22.0,
                    color: textBlack),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Steps',
                semanticsLabel: 'Steps',
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                    color: textGrey),
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: primaryColor,
        ),
      ),
    );
  }

  Widget exerciseTime() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise',
                  semanticsLabel: 'Exercise',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: textBlack),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                    Conversion.durationFromMinToHrsToString(
                        data.getExerciseTimeInMin().abs()),
                    semanticsLabel: Conversion.durationFromMinToHrsToString(
                        data.getExerciseTimeInMin().abs()),
                    style: const TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 22.0),
                    textAlign: TextAlign.center),
                Text("Duration",
                    semanticsLabel: 'Duration',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xffa8a8a8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ImageIcon(
              AssetImage('res/images/ic_exercise_person.png'),
              size: 48,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget sleepTime() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            Text(
              'Sleep',
              semanticsLabel: 'Sleep',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                  color: textBlack),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Here is your sleep details',
              semanticsLabel: 'Here is your sleep details',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: textBlack),
            ),
            SizedBox(
              height: 32,
            ),
            ImageIcon(
              AssetImage('res/images/ic_sleep_2.png'),
              size: 48,
              color: primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
                Conversion.durationFromMinToHrsToString(
                    sleepData.getSleepDuration().abs()),
                semanticsLabel: Conversion.durationFromMinToHrsToString(
                    sleepData.getSleepDuration().abs()),
                style: const TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 34.0),
                textAlign: TextAlign.center),
            Text("Duration",
                semanticsLabel: 'Duration',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xffa8a8a8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )),
            SizedBox(
              height: 8,
            ),
            if (sleepData.getSleepDuration().abs() < 360)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: primaryLightColor,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: primaryColor,
                        size: 32,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                          "You didn’t have enough sleep.\nIts better to sleep 7-9 hours everyday.",
                          semanticsLabel:
                              'You didn’tt have enough sleep. Its better to sleep 7-9 hours everyday.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget burnedCalories() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calories',
                  semanticsLabel: 'Calories',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: textBlack),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(totalCalories.toStringAsFixed(0),
                    semanticsLabel: totalCalories.toStringAsFixed(0),
                    style: const TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 22.0),
                    textAlign: TextAlign.center),
                Text("Cal",
                    semanticsLabel: 'Cal',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xffa8a8a8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ImageIcon(
              AssetImage('res/images/ic_calories_burned.png'),
              size: 48,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  recordMyCalories() async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['CaloriesBurned'] = totalActiveCalories;

      final BaseResponse baseResponse = await model.recordMyCalories(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMySteps() async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['StepCount'] = steps;
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMySteps(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
