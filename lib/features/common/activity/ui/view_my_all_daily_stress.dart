import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
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
    loadSharedPrefs();
    //loadWaterConsuption();
    if (Platform.isIOS) {
      fetchData();
      sleepDataASleep = GetSleepData();
      sleepDataInBed = GetSleepDataInBed();
      _timerRefrehs = Timer.periodic(Duration(seconds: 3), (Timer t) {
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              brightness: Brightness.dark,
              title: Text(
                'Mental Health',
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

  Widget sleepTime() {
    var sleepToDisplay = 0;
    if (Platform.isIOS) {
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
    } else {
      //https://pub.dev/packages/time_range_picker
    }

    return Container(
      height: 240,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
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
                  'Sleep',
                  semanticsLabel: 'Sleep',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: textBlack),
                ),
                InfoScreen(
                    tittle: 'Sleep Information',
                    description:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    height: 260),
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
            Text(Conversion.durationFromMinToHrsToString(sleepToDisplay),
                semanticsLabel:
                    Conversion.durationFromMinToHrsToString(sleepToDisplay),
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
              )
          ],
        ),
      ),
    );
  }

  Widget mindfulnessTime() {
    debugPrint('MindfulnessTime Dashboard Tile inisde ==> $oldStoreSec');
    return Container(
      height: 240,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Align(
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
                  'Mindfulness',
                  semanticsLabel: 'Mindfulness',
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: textBlack),
                ),
                InfoScreen(
                    tittle: 'Mindfulness Information',
                    description:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    height: 260),
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
            Text(Conversion.durationFromSecToMinToString(oldStoreSec),
                semanticsLabel:
                    Conversion.durationFromSecToMinToString(oldStoreSec),
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
            SizedBox(
              height: 8,
            ),
            SizedBox(
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
            ),
          ],
        ),
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
