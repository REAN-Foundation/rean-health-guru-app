import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/activity/ui/view_my_all_daily_stress.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/infra/themes/app_colors.dart';

import '../../../misc/ui/base_widget.dart';
import 'enter_all_mental_well_being_view.dart';

//ignore: must_be_immutable
class AllMentalWellBeingView extends StatefulWidget {
  var _currentIndex = 0;

  AllMentalWellBeingView(int index) {
    _currentIndex = index;
  }

  @override
  _AllMentalWellBeingViewState createState() => _AllMentalWellBeingViewState();
}

class _AllMentalWellBeingViewState extends State<AllMentalWellBeingView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    late Widget screen;
    switch (widget._currentIndex) {
      case 0:
        FirebaseAnalytics.instance.logEvent(name: 'mental_wel_being_enter_values_tab_click');
        screen = EnterAllMentalWellBeingView();
        break;
      case 1:
        FirebaseAnalytics.instance.logEvent(name: 'mental_wel_being_view_values_tab_click');
        screen = ViewMyAllDailyStress(false);
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
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              'Mental Well-Being',
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
              label: 'Record Mental Well-Being 1 of 2',
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget._currentIndex = 0;
                  });
                },
                child: ExcludeSemantics(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage('res/images/ic_record_mental_well_being.png'),
                        size: 24,
                        color: widget._currentIndex == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Record Mental Well-Being',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: widget._currentIndex == 0
                                ? Colors.white
                                : Colors.grey,
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
              label: 'View Mental Well-Being 2 of 2',
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget._currentIndex = 1;
                  });
                },
                child: ExcludeSemantics(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage('res/images/ic_stress.png'),
                        size: 24,
                        color: widget._currentIndex == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'View Mental Well-Being',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: widget._currentIndex == 1
                                ? Colors.white
                                : Colors.grey,
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
