import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/patients_vitals.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/biometricVitals/BiometricTrendView.dart';

import '../base_widget.dart';
import 'EnterAllVitalsView.dart';

class BiometricVitalsTrendsView extends StatefulWidget {
  @override
  _BiometricVitalsTrendsViewState createState() =>
      _BiometricVitalsTrendsViewState();
}

class _BiometricVitalsTrendsViewState extends State<BiometricVitalsTrendsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = EnterAllVitalsView();
        break;
      case 1:
        screen = BiometricTrendView();
        break;
    }

    return BaseWidget<PatientVitalsViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Vitals',
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: _buildTabDesign(),
              ),
              Expanded(child: screen)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabDesign() {
    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Semantics(
            label: 'Vitals 1 of 2',
            selected: true,
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_heart_biometric.png'),
                    size: 24,
                    color: _currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Vitals',
                    style: TextStyle(
                        color: _currentIndex == 0 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Semantics(
            label: 'Trends 2 of 2',
            selected: true,
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_trends.png'),
                    size: 28,
                    color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Trends',
                    style: TextStyle(
                        color: _currentIndex == 1 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
