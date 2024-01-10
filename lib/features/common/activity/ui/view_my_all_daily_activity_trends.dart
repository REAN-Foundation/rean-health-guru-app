import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/nutrition/models/glass_of_water_consumption.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/get_sleep_data.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

//ignore: must_be_immutable
class ViewMyAllDailyActivityTrends extends StatefulWidget {
  @override
  _ViewMyAllDailyActivityTrendsState createState() =>
      _ViewMyAllDailyActivityTrendsState();
}

class _ViewMyAllDailyActivityTrendsState
    extends State<ViewMyAllDailyActivityTrends> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat('yyyy-MM-dd');
  GetSleepData? sleepData;
  int steps = 0;
  int stepsDevice = 0;
  double weight = 0;
  double height = 0;
  double totalActiveCalories = 0;
  double totalBasalCalories = 0;
  double totalCalories = 0;
  double bmiValue = 0;
  int waterGlass = 0;
  String bmiResult = '';
  Color bmiResultColor = Colors.black87;
  GlassOfWaterConsumption? glassOfWaterConsumption;
  DateTime? startDate;
  DateTime? endDate;
  int heartRateBmp = 0;
  ScrollController? _scrollController;
  GetHealthData? data;
  final durationInMin = Duration(minutes: 3);
  late AndroidDeviceInfo androidInfo;
  late IosDeviceInfo iosInfo;
  late Timer _timerRefrehs;
  late Timer _timerRefreh;
  Color buttonColor = primaryLightColor;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  MovementsTracking? _standMovemntsTracking;
  int standMovements = 0;
  MovementsTracking? _stepsMovemntsTracking;
  int stepsMovements = 0;
  MovementsTracking? _exerciseMovemntsTracking;
  int exerciseMovements = 0;
  DateTime? todaysDate;
  var stepcount = 0;

  getDeviceData() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    }

    if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;

      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
    }
  }

  @override
  void initState() {
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    loadStandMovement();
    loadStepsMovement();
    loadExerciseMovement();
    getDeviceData();
    _scrollController = ScrollController();
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 1, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    //loadSharedPref();
    //loadWaterConsuption();
    if (Platform.isIOS) {
      fetchData();
      sleepData = GetSleepData();
      data = GetHealthData();
      try {
        _timerRefrehs = Timer.periodic(durationInMin, (Timer t) => fetchData());
        _timerRefreh = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {});
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    super.initState();
  }

  loadStandMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('standTime');

      if (movements != null) {
        _standMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_standMovemntsTracking != null) {
        if (todaysDate == _standMovemntsTracking!.date) {
          debugPrint('Stand ==> ${_standMovemntsTracking!.value!}');
          standMovements = _standMovemntsTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  loadStepsMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('stepCount');

      if (movements != null) {
        _stepsMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_stepsMovemntsTracking != null) {
        if (todaysDate == _stepsMovemntsTracking!.date) {
          debugPrint('Steps ==> ${_stepsMovemntsTracking!.value!}');
          stepsMovements = _stepsMovemntsTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  loadExerciseMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('exerciseTime');

      if (movements != null) {
        _exerciseMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_exerciseMovemntsTracking != null) {
        if (todaysDate == _exerciseMovemntsTracking!.date) {
          debugPrint('Exercise ==> ${_exerciseMovemntsTracking!.value!}');
          exerciseMovements = _exerciseMovemntsTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  @override
  void dispose() {
    _timerRefreh.cancel();
    _timerRefrehs.cancel();
    super.dispose();
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

    //setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    final bool accessWasGranted = await health.requestAuthorization(types);

    //this.steps = 0;
    if (accessWasGranted) {
      try {
        /// Fetch new data
        final List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startDate!, endDate!, types);

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
        standCounter(),
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
        //burnedCalories(),
        SizedBox(
          height: 16,
        ),
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
    debugPrint('Iphone Name ==> ${iosInfo.name}'); //Tushar-Katakdounds-iPhone
    clearAllRecords();
    for (int i = 0; i < _healthDataList.length; i++) {
      final HealthDataPoint p = _healthDataList[i];
      if (p.typeString == 'STEPS') {
        if (Platform.isIOS) {
          if (p.sourceName == iosInfo.name) {
            steps = steps + p.value.toInt();
          } else {
            stepsDevice = stepsDevice + p.value.toInt();
          }
          if (stepsDevice > steps) {
            steps = stepsDevice;
          }
        } else {
          steps = steps + p.value.toInt();
        }
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
    stepsDevice = 0;
    //weight = 0;
    //height = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
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
                                topRight: Radius.circular(0),
                                topLeft: Radius.circular(0))),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (Platform.isIOS) _content(),
                              if (Platform.isAndroid) _contentDataReady(),
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

  Widget standCounter() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Stand',
                      semanticsLabel: 'Stand',
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: textBlack),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ImageIcon(
                  AssetImage('res/images/ic_stand.png'),
                  size: 48,
                  color: primaryColor,
                ),
                SizedBox(
                  height: 16,
                ),
                MergeSemantics(
                  child: Column(
                    children: [
                      Text(Conversion.durationFromMinToHrsToString(standMovements),
                          semanticsLabel:
                              Conversion.durationFromMinToHrsToString(standMovements).replaceAll('min', 'minutes').replaceAll('hr', 'hours'),
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
                            color: textBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Positioned(
            top: 4,
            right: 4,
            child: InfoScreen(
              tittle: 'Stand Information',
              description:
              'Standing is better for the back than sitting. It strengthens leg muscles and improves balance. It burns more calories than sitting.',
              height: 208),)*/
          /*Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12))),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 32,
                      color: primaryColor,
                      semanticLabel: 'Add Stand minutes',
                    ),
                    onPressed: () {

                    }),
              ),
            ),
          )*/
        ],
      ),
    );
  }

  Widget stepCounter() {
    int stepsToDisplay = 0;
    if (Platform.isIOS) {
      /*if (steps > stepsMovements) {
        stepsToDisplay = steps;
      } else {
        stepsToDisplay = stepsMovements;
      }*/
      stepsToDisplay = steps + stepsMovements;
    } else {
      stepsToDisplay = stepsMovements;
    }

    if(stepsToDisplay != stepcount) {
      recordMySteps(stepsToDisplay);
    }

    stepcount = stepsToDisplay;
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ImageIcon(
                  AssetImage('res/images/ic_steps_count.png'),
                  size: 48,
                  color: primaryColor,
                ),
                SizedBox(
                  height: 16,
                ),
                MergeSemantics(
                  child: Column(
                    children: [
                      Text(stepsToDisplay.toString(),
                          semanticsLabel: stepsToDisplay.toString(),
                          style: const TextStyle(
                              color: textBlack,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0),
                          textAlign: TextAlign.center),
                      Text("Steps",
                          semanticsLabel: 'Steps',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: textBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  ),
                ),

              ],
            ),
          ),
          /*Positioned(
            top: 4,
            right: 4,
            child: InfoScreen(
              tittle: 'Steps Information',
              description:
              'Steps will increase cardiovascular and pulmonary (heart and lung) fitness. reduced risk of heart disease and stroke. improved management of conditions such as hypertension (high blood pressure), high cholesterol, joint, and muscular pain or stiffness, and diabetes. stronger bones and improved balance.',
              height: 288),)*/
          /*Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12))),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 32,
                      color: primaryColor,
                      semanticLabel: 'Add Step count',
                    ),
                    onPressed: () {

                    }),
              ),
            ),
          )*/
        ],
      ),
    );
  }

  Widget stepCounterOld() {
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
              MergeSemantics(
                child: Column(
                  children: [
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
                          color: secondaryTextBlack),
                    ),
                  ],
                ),
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
    int exerciseToDisplay = 0;
    if (Platform.isIOS) {
      debugPrint(
          "Inside Exercise Time ==> ${data!.getExerciseTimeInMin().abs()}");
      /*if (data!.getExerciseTimeInMin() > exerciseMovements) {
        exerciseToDisplay = data!.getExerciseTimeInMin().abs();
      } else {
        exerciseToDisplay = exerciseMovements;
      }*/
      exerciseToDisplay =
          data!.getExerciseTimeInMin().abs() + exerciseMovements;
    } else {
      exerciseToDisplay = exerciseMovements;
    }
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ImageIcon(
                  AssetImage('res/images/ic_exercise_person.png'),
                  size: 48,
                  color: primaryColor,
                ),
                SizedBox(
                  height: 16,
                ),
                MergeSemantics(
                  child: Column(
                    children: [
                      Text(Conversion.durationFromMinToHrsToString(exerciseToDisplay),
                          semanticsLabel:
                              Conversion.durationFromMinToHrsToString(exerciseToDisplay).replaceAll('min', 'minutes').replaceAll('hr', 'hours'),
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
                            color: textBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InfoScreen(
              tittle: 'Exercise Information',
              description:
              'Fit in 150+\nGet at least 150 minutes per week of moderate-intensity aerobic activity or 75 minutes per week of vigorous aerobic activity (or a combination of both), preferably spread throughout the week.',
              height: 248),)
        ],
      ),
    );
  }

  Widget exerciseTimeOld() {
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
                        data!.getExerciseTimeInMin().abs()),
                    semanticsLabel: Conversion.durationFromMinToHrsToString(
                        data!.getExerciseTimeInMin().abs()),
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
                      color: secondaryTextBlack,
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
                    sleepData!.getSleepDurationASleep().abs()),
                semanticsLabel: Conversion.durationFromMinToHrsToString(
                    sleepData!.getSleepDurationASleep().abs()),
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
                  color: secondaryTextBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )),
            SizedBox(
              height: 8,
            ),
            if (sleepData!.getSleepDurationASleep().abs() < 360)
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
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Calories',
              semanticsLabel: 'Calories',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  color: textBlack),
            ),
            SizedBox(
              height: 16,
            ),
            ImageIcon(
              AssetImage('res/images/ic_calories_burned.png'),
              size: 48,
              color: primaryColor,
            ),
            SizedBox(
              height: 16,
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
                  color: secondaryTextBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )),
          ],
        ),
      ),
    );
  }

  Widget burnedCaloriesOld() {
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
                      color: secondaryTextBlack,
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

  recordMySteps(int stepsToDisplay) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['StepCount'] = stepsToDisplay;
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

  recordMyStand() async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Stand'] = standMovements;
      map['Unit'] = 'Minutes';
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyStand(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
