import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/DashboardTile.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';

import '../base_widget.dart';

class MeditationTimmerView extends StatefulWidget {
  @override
  _MeditationTimmerViewState createState() => _MeditationTimmerViewState();
}

class _MeditationTimmerViewState extends State<MeditationTimmerView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  Timer _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isPause = false;
  DashboardTile mindfulnessTimeDashboardTile;
  int oldStoreSec = 0;

  loadSharedPrefs() async {
    try {
      mindfulnessTimeDashboardTile = DashboardTile.fromJson(
          await _sharedPrefUtils.read('mindfulnessTime'));
      if (mindfulnessTimeDashboardTile.date.difference(DateTime.now()).inDays ==
          0) {
        oldStoreSec = int.parse(mindfulnessTimeDashboardTile.discription);
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
    return BaseWidget<PatientHealthMarkerViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: primaryColor,
              brightness: Brightness.dark,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 260,
                                    child: getAppType() == 'AHA'
                                        ? Image.asset(
                                            'res/images/medication_aha_bg.png')
                                        : Image.asset(
                                            'res/images/medication_rean_bg.png')),
                                SizedBox(
                                  height: 16,
                                ),
                                if (_timer != null) ...[
                                  _timer.isActive
                                      ? countUpTimmer()
                                      : mindfulnessMessage()
                                ],
                                if (_timer == null) ...[
                                  mindfulnessMessage(),
                                ],
                                SizedBox(
                                  height: 32,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      getAppType() == 'AHA'
                                          ? Image.asset(
                                              'res/images/medication_aha_bottom_bg.png')
                                          : Image.asset(
                                              'res/images/medication_rean_bottom_bg.png',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                    _timer.isActive) {
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
                                                        _timer.isActive
                                                            ? Semantics(
                                                                label: 'Play',
                                                                button: true,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
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
                                                                          BorderRadius.all(
                                                                              Radius.circular(60.0))),
                                                                  child: Column(
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
                                                                      ),
                                                                    ],
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
                                                  label: 'Pause',
                                                  button: true,
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: primaryColor,
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
                                                          size: 64,
                                                        ),
                                                      ],
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
                                                      child: Text('Finish'),
                                                      onPressed: () {
                                                        saveMindfulnessTime();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          primary: primaryColor,
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
                                ),
                              ],
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
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
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

  saveMindfulnessTime() {
    int newSec = Duration(minutes: minutes).inSeconds;
    newSec = newSec + seconds + oldStoreSec;
    _sharedPrefUtils.save(
        'mindfulnessTime',
        DashboardTile(DateTime.now(), 'mindfulnessTime', newSec.toString())
            .toJson());
    _timer.cancel();
    _timer = null;
    minutes = 0;
    seconds = 0;
    hours = 0;
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
    _timer.cancel();
  }
}
