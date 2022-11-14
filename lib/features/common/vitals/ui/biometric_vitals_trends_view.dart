import 'package:flutter/material.dart';
import 'package:patient/features/common/vitals/ui/biometric_trends_view.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/infra/themes/app_colors.dart';

import '../../../misc/ui/base_widget.dart';
import 'enter_all_vitals_view.dart';

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
    late Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = EnterAllVitalsView();
        break;
      case 1:
        screen = BiometricTrendView();
        break;
    }

    return BaseWidget<PatientVitalsViewModel?>(
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
          Expanded(
            flex: 1,
            child: Semantics(
              label: 'Record Vitals 1 of 2',
              selected: true,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: ExcludeSemantics(
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
                        'Record Vitals',
                        style: TextStyle(
                            color:
                                _currentIndex == 0 ? Colors.white : Colors.grey,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Semantics(
              label: 'View Trends 2 of 2',
              selected: true,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: ExcludeSemantics(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage('res/images/ic_trends.png'),
                        size: 28,
                        color: _currentIndex == 1 ? Colors.white : primaryExtraLightColor,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'View Trends',
                        style: TextStyle(
                            color:
                                _currentIndex == 1 ? Colors.white : primaryExtraLightColor,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
