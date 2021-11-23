import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';

import '../base_widget.dart';

class MedicationTimmerView extends StatefulWidget {
  @override
  _MedicationTimmerViewState createState() => _MedicationTimmerViewState();
}

class _MedicationTimmerViewState extends State<MedicationTimmerView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isPause = false;

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
                'Meditation',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_timer != null) ...[
                    _timer.isActive
                        ? countUpTimmer()
                        : Image.asset('res/images/medication_rean_bg.png'),
                  ],
                  if (_timer == null) ...[
                    Image.asset('res/images/medication_rean_bg.png'),
                  ],
                  SizedBox(
                    height: 80,
                  ),
                  FlipCard(
                    onFlip: () {
                      if (_timer != null && _timer.isActive) {
                        _pauseTimmer();
                      } else {
                        startTimer();
                      }
                    },
                    direction: FlipDirection.HORIZONTAL,
                    // default
                    front: Container(
                      padding: const EdgeInsets.all(0.0),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(60.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_timer != null) ...[
                            _timer.isActive
                                ? Icon(
                                    Icons.play_arrow,
                                    color: primaryColor,
                                    size: 64,
                                  )
                                : Text(
                                    "Start",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                          ],
                          if (_timer == null) ...[
                            Text(
                              "Start",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    back: Container(
                      padding: const EdgeInsets.all(0.0),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(60.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
            )),
      ),
    );
  }

  Widget countUpTimmer() {
    return Container(
      height: 360,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                minutes.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 60),
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
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            width: 80,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                seconds.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 60),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
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
