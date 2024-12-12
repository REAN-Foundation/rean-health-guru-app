import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/activity/ui/enter_all_movements_view.dart';
import 'package:patient/features/common/activity/ui/view_my_all_daily_activity_trends.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/infra/services/user_analytics_service.dart';
import 'package:patient/infra/themes/app_colors.dart';

import '../../../misc/ui/base_widget.dart';

//ignore: must_be_immutable
class AllMovementsView extends StatefulWidget {
  var _currentIndex = 0;

  AllMovementsView(int index) {
    _currentIndex = index;
  }

  @override
  _AllMovementsViewState createState() => _AllMovementsViewState();
}

class _AllMovementsViewState extends State<AllMovementsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    late Widget screen;
    switch (widget._currentIndex) {
      case 0:
        UserAnalyticsServices.registerScreenEntryEvent('enter-all-physical-activites-screen', 'enter-all-physical-activites-flow', 'enter-all-physical-activites-screen-entry', '', null);
        screen = EnterAllMovementsView();
        break;
      case 1:
        UserAnalyticsServices.registerScreenEntryEvent('physical-activites-trends-screen', 'physical-activites-trends-flow', 'physical-activites-trends-screen-entry', '', null);
        screen = ViewMyAllDailyActivityTrends();
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
              'Physical Activity',
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
              label: 'Record Movements 1 of 2',
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
                        AssetImage('res/images/ic_activity.png'),
                        size: 24,
                        color: widget._currentIndex == 0
                            ? Colors.white
                            : primaryExtraLightColor,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Record Movements',
                        style: TextStyle(
                            color: widget._currentIndex == 0
                                ? Colors.white
                                : primaryExtraLightColor,
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
              label: 'View Moments 2 of 2',
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
                        AssetImage('res/images/ic_stand.png'),
                        size: 28,
                        color: widget._currentIndex == 1
                            ? Colors.white
                            : primaryExtraLightColor,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'View Movements',
                        style: TextStyle(
                            color: widget._currentIndex == 1
                                ? Colors.white
                                : primaryExtraLightColor,
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
