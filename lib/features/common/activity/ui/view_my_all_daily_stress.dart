import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/activity/ui/activity_meditation.dart';
import 'package:patient/features/common/activity/ui/activity_sleep.dart';
import 'package:patient/features/common/nutrition/models/glass_of_water_consumption.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/get_sleep_data.dart';
import 'package:patient/infra/utils/get_sleep_data_in_bed.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_screen.dart';

//ignore: must_be_immutable
class ViewMyAllDailyStress extends StatefulWidget {

  bool _appBarView = true;

  ViewMyAllDailyStress(bool appBarView) {
    _appBarView = appBarView;
  }

  @override
  _ViewMyAllDailyStressState createState() => _ViewMyAllDailyStressState();
}

class _ViewMyAllDailyStressState extends State<ViewMyAllDailyStress> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat('yyyy-MM-dd');
  GetSleepData? sleepDataASleep;
  GetSleepDataInBed? sleepDataInBed;
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
  GlassOfWaterConsumption? glassOfWaterConsumption;
  DateTime? startDate;
  DateTime? endDate;
  int heartRateBmp = 0;
  ScrollController? _scrollController;
  GetHealthData? data;
  DashboardTile? mindfulnessTimeDashboardTile;
  int oldStoreSec = 0;
  late Timer _timerRefrehs;
  MovementsTracking? _sleepTracking;
  int _sleepHrs = 0;
  int _sleepInMin = 0;
  DateTime? todaysDate;

  loadSharedPrefs() async {
    try {
      mindfulnessTimeDashboardTile = DashboardTile.fromJson(
          await _sharedPrefUtils.read('mindfulnessTime'));
      if (mindfulnessTimeDashboardTile!.date!
              .difference(DateTime.now())
              .inDays ==
          0) {
        oldStoreSec = int.parse(mindfulnessTimeDashboardTile!.discription!);
      }

      setState(() {
        debugPrint('MindfulnessTime Dashboard Tile ==> $oldStoreSec');
      });
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    loadSharedPrefs();
    loadSleepMovement();
    //loadWaterConsuption();
    if (Platform.isIOS) {
      fetchData();
      sleepDataASleep = GetSleepData();
      sleepDataInBed = GetSleepDataInBed();
      _timerRefrehs = Timer(Duration(seconds: 5), () {
        setState(() {});
      });
      //data = GetHealthData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timerRefrehs.cancel();
    super.dispose();
  }

  loadSleepMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('sleepTime');

      if (movements != null) {
        debugPrint('Sleep Inside');
        _sleepTracking = MovementsTracking.fromJson(movements);
        debugPrint('Sleep ${_sleepTracking!.date}');
      }

      if (_sleepTracking != null) {
        if (todaysDate == _sleepTracking!.date) {
          debugPrint('Sleep ==> ${_sleepTracking!.value!} Hrs ${int.parse(_sleepTracking!.discription.toString())} Min');
          _sleepHrs = _sleepTracking!.value!;
          _sleepInMin = int.parse(_sleepTracking!.discription.toString());
        }
      }
      //recordMySleepTimeInHrs(_sleepHrs.toString());
      //recordMySleepTimeInHrs("1");
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }
  final Health health = Health();
  Future<void> fetchData() async {
    /// Get everything from midnight until now
    //DateTime startDate = DateTime(2021, 01, 01, 0, 0, 0);
    //DateTime endDate = DateTime(2021, 07, 07, 23, 59, 59);

    /*startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);*/



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
            await health.getHealthDataFromTypes(startTime: startDate!, endTime:  endDate!, types: types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        debugPrint('Caught exception in getHealthDataFromTypes: $e');
      }

      /// Filter out duplicates
      _healthDataList = health.removeDuplicates(_healthDataList);

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
        sleepTime(),
        SizedBox(
          height: 16,
        ),
        mindfulnessTime(),
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

  calculateSteps() async {
    clearAllRecords();
    steps = (await health.getTotalStepsInInterval(startDate!, endDate!, includeManualEntry: true))!.toInt();
    for (int i = 0; i < _healthDataList.length; i++) {
    final HealthDataPoint p = _healthDataList[i];
    /*if (p.typeString == 'STEPS') {
        if (Platform.isIOS) {
          if (p.sourceName == iosInfo.name) {
            steps = steps + p.value.toJson()["numericValue"].toInt();
          } else {
            stepsDevice = stepsDevice + p.value.toInt();
          }
          if (stepsDevice > steps) {
            steps = stepsDevice;
          }
        } else {
          steps = steps + p.value.toInt();
        }
      } else*/ if (p.typeString == 'WEIGHT') {
    if (p.value.toJson()["numericValue"] != 0) {
    //weight = p.value.toDouble();
    }
    } else if (p.typeString == 'HEIGHT') {
    if (p.value.toJson()["numericValue"] != 0) {
    //height = p.value.toDouble() * 100;
    }
    } else if (p.typeString == 'ACTIVE_ENERGY_BURNED') {
    totalActiveCalories = totalActiveCalories + p.value.toJson()["numericValue"];
    } else if (p.typeString == 'BASAL_ENERGY_BURNED') {
    totalBasalCalories = totalBasalCalories + p.value.toJson()["numericValue"];
    } else if (p.typeString == 'HEART_RATE') {
    heartRateBmp = p.value.toJson()["numericValue"];
    }
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
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,

            appBar: widget._appBarView ? AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              title: Text(
                'Mental Well-Being',
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
            ) : PreferredSize(
                preferredSize: Size.fromHeight(0.0), // here the desired height
                child: AppBar(

                )
            ),
            body: widget._appBarView ? Stack(
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
            ):
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Color(0XFFf7f5f5),
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
        ),
      ),
    );
  }

  Widget sleepTime() {
    var sleepToDisplay = 0;
    if(_sleepHrs != 0 || _sleepInMin != 0){
      sleepToDisplay = _sleepHrs * 60;
      sleepToDisplay = sleepToDisplay + _sleepInMin;
    }else if (Platform.isIOS) {
      debugPrint(
          'Sleep in Bed ==>${sleepDataInBed!.getSleepDurationInBed().abs()} ');
      debugPrint(
          'ASleep ==>${sleepDataASleep!.getSleepDurationASleep().abs()} ');

      var sleepInBed = sleepDataInBed!.getSleepDurationInBed().abs();
      var aSleep = sleepDataASleep!.getSleepDurationASleep().abs();

      if (aSleep > 0) {
        sleepToDisplay = aSleep;
      } else {
        sleepToDisplay = sleepInBed;
      }
      if(sleepToDisplay != 0) {
        recordMySleepTimeInHrs(
            Conversion.durationFromMinToHrsToString(sleepToDisplay));
      }
    } else {
      //https://pub.dev/packages/time_range_picker
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sleep',
                    semanticsLabel: 'Sleep',
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
                AssetImage('res/images/ic_sleep_2.png'),
                size: 48,
                color: primaryColor,
              ),
              SizedBox(
                height: 16,
              ),
              MergeSemantics(
                child: Column(
                  children: [
                    Text(Conversion.durationFromMinToHrsToString(sleepToDisplay),
                        semanticsLabel:
                            Conversion.durationFromMinToHrsToString(sleepToDisplay).replaceAll('hr', 'hours').replaceAll('min', 'minutes'),
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
              SizedBox(
                height: 8,
              ),
              if (sleepToDisplay < 420)
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
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.info_outline_rounded,
                          color: primaryColor,
                          size: 32,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                              "You didn’t have enough sleep. It's better to sleep 7-9 hours everyday.",
                              semanticsLabel:
                                  "You didn’tt have enough sleep. It's better to sleep 7-9 hours everyday.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ActivitySleepView(false, (){
                      loadSleepMovement();
                      setState(() {

                      });
                }),
              ),
            ],
          ),
          Positioned(
              top: 4,
              right: 4,
              child: InfoScreen(
                  tittle: 'Sleep Information',
                  description:
                  'Getting a good night’s sleep every night is vital to cardiovascular health. Adults should aim for an average of 7-9 hours. Too little or too much sleep is associated with heart disease.',
                  height: 224),)
        ],
      ),
    );
  }

  Widget mindfulnessTime() {
    debugPrint('MindfulnessTime Dashboard Tile inisde ==> $oldStoreSec');
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Mindfulness',
                    semanticsLabel: 'Mindfulness',
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
                AssetImage('res/images/ic_mindfulness.png'),
                size: 48,
                color: primaryColor,
              ),
              SizedBox(
                height: 16,
              ),
              MergeSemantics(
                child: Column(
                  children: [
                    Text(Conversion.durationFromSecToMinToString(oldStoreSec).substring(0,6),
                        semanticsLabel:
                            Conversion.durationFromSecToMinToString(oldStoreSec).substring(0,6).replaceAll('sec', 'second').replaceAll('min', 'minutes').replaceAll('hrs', 'hours') + 'Duration',
                        style: const TextStyle(
                            color: textBlack,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 22.0),
                        textAlign: TextAlign.center),
                    ExcludeSemantics(
                      child: Text("Duration",
                          semanticsLabel: 'Duration',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: secondaryTextBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),

              /*SizedBox(
                child: OutlinedButton(
                  child: Text('Start'),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.Meditation).then((_) {
                      loadSharedPrefs();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: primaryColor),
                    padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    primary: primaryColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ActivityMeditationView(false , (){
                      loadSharedPrefs();
                      setState(() {

                      });
                }),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child:  InfoScreen(
                tittle: 'Mindfulness Information',
                description:
                'Practicing mindfulness and meditation may help you manage stress and high blood pressure, sleep better, feel more balanced and connected, and even lower your risk of heart disease.',
                height: 240),
          )
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

  recordMySleepTimeInHrs(String sleepInHrs) async {
    try {
      debugPrint('Sleep Hrs in API ==> $sleepInHrs');
      if(sleepInHrs != 0 ) {
        final map = <String, dynamic>{};
        map['PatientUserId'] = patientUserId;
        map['SleepDuration'] = sleepInHrs.substring(0,1);
        map['SleepMinutes'] = sleepInHrs.substring(sleepInHrs.length-6 , sleepInHrs.length-4);
        map['Unit'] = 'Hrs';
        map['RecordDate'] = dateFormat.format(DateTime.now());

        final BaseResponse baseResponse = await model.recordMySleep(map);
        if (baseResponse.status == 'success') {
          setState(() {});
        } else {}
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
