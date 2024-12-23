import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';

import '../../../../infra/utils/string_utility.dart';
import '../../../misc/models/base_response.dart';

class MeditationTimmerView extends StatefulWidget {
  @override
  _MeditationTimmerViewState createState() => _MeditationTimmerViewState();
}

class _MeditationTimmerViewState extends State<MeditationTimmerView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  Timer? _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isPause = false;
  DashboardTile? mindfulnessTimeDashboardTile;
  int oldStoreSec = 0;
  var dateFormat = DateFormat('yyyy-MM-dd');

  loadSharedPrefs() async {
    try {
      mindfulnessTimeDashboardTile = DashboardTile.fromJson(
          await _sharedPrefUtils.read('mindfulnessTime'));
      if (mindfulnessTimeDashboardTile!.date!
              .difference(DateTime.now())
              .inDays ==
          0) {
        oldStoreSec =
            int.parse(mindfulnessTimeDashboardTile!.discription.toString());
      }

      //debugPrint('Emergency Dashboard Tile ==> ${emergencyDashboardTile.date}');
      setState(() {});
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
    /*catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }*/
  }

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
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
              backgroundColor: primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              title: Text(
                'Mindfulness',
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
                          padding: const EdgeInsets.all(0.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color(0XFFf7f5f5),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ExcludeSemantics(
                                    child: Container(
                                        height: 200,
                                        child: getAppType() == 'AHA'
                                            ? Image.asset(
                                                'res/images/medication_aha_bg.png')
                                            : Image.asset(
                                                'res/images/medication_rean_bg.png')),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  if (_timer != null) ...[
                                    _timer!.isActive
                                        ? countUpTimmer()
                                        : mindfulnessMessage()
                                  ],
                                  if (_timer == null) ...[
                                    mindfulnessMessage(),
                                  ],
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Stack(
                                    children: [
                                      getAppType() == 'AHA'
                                          ? ExcludeSemantics(
                                            child: Image.asset(
                                                'res/images/medication_aha_bottom_bg.png'),
                                          )
                                          : ExcludeSemantics(
                                            child: Image.asset(
                                                'res/images/medication_rean_bottom_bg.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                          ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Center(
                                            child: FlipCard(
                                              onFlip: () {
                                                if (_timer != null &&
                                                    _timer!.isActive) {
                                                  _pauseTimmer();
                                                } else {
                                                  startTimer();
                                                }
                                              },
                                              direction:
                                                  FlipDirection.HORIZONTAL,
                                              // default
                                              front: Container(
                                                height: 140,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                    color: primaryLightColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                70.0))),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  60.0))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (_timer != null) ...[
                                                        _timer!.isActive
                                                            ? Semantics(
                                                                button: true,
                                                                label: 'Play',
                                                                child:
                                                                    ExcludeSemantics(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            0.0),
                                                                    height: 120,
                                                                    width: 120,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        border: Border.all(
                                                                            color:
                                                                                primaryColor,
                                                                            width:
                                                                                2.0),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(60.0))),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          color:
                                                                              primaryColor,
                                                                          size:
                                                                              64,
                                                                          semanticLabel: 'Play',
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : startButton()
                                                      ],
                                                      if (_timer == null) ...[
                                                        startButton(),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              back: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                height: 140,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                    color: primaryLightColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                70.0))),
                                                child: Semantics(
                                                  button: true,
                                                  label: 'Pause',
                                                  child: ExcludeSemantics(
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 2.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      60.0))),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.pause,
                                                            color: primaryColor,
                                                            semanticLabel: 'Pause',
                                                            size: 64,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 64,
                                          ),
                                          if (_timer != null) ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 32.0),
                                                    child: ElevatedButton(
                                                      child: Text('Save'),
                                                      onPressed: () {
                                                        FirebaseAnalytics.instance.logEvent(name: 'mental_wel_being_mindfulness_finish_button_click');
                                                        showSuccessToast('Mindfulness duration recorded successfully', context);
                                                        saveMindfulnessTime();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: primaryColor,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      50,
                                                                  vertical: 14),
                                                          textStyle: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget startButton() {
    return Semantics(
      label: 'Start',
      button: true,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 116,
          width: 116,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(60.0))),
          child: Center(
            child: Text(
              "Start",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget mindfulnessMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      height: 100,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Mindfulness for a better you',
          semanticsLabel: 'Mindfulness for a better you',
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget countUpTimmer() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                minutes.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: 20,
            child: Center(
              child: Text(
                ":",
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                seconds.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveMindfulnessTime() async {
    int newSec = Duration(minutes: minutes).inSeconds;
    newSec = newSec + seconds + oldStoreSec;
    _sharedPrefUtils.save(
        'mindfulnessTime',
        DashboardTile(DateTime.now(), 'mindfulnessTime', newSec.toString())
            .toJson());
    _timer!.cancel();
    _timer = null;
    minutes = 0;
    seconds = 0;
    hours = 0;
    final map = <String, dynamic>{};
    map['PatientUserId'] = patientUserId;
    map['DurationInMins'] = Duration(seconds: newSec).inMinutes.toString();
    map['RecordDate'] = dateFormat.format(DateTime.now());

    final BaseResponse baseResponse = await model.recordMyMindfulness(map);
    if (baseResponse.status == 'success') {
    } else {}
    setState(() {});
    Navigator.of(context).pop();
  }

  void startTimer() {
    debugPrint('Start Timer');
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds + 1;
            if (seconds > 59) {
              minutes += 1;
              seconds = 0;
              if (minutes > 59) {
                hours += 1;
                minutes = 0;
              }
            }
          }
        },
      ),
    );
  }

  _pauseTimmer() {
    isPause = true;
    _timer!.cancel();
  }
}
