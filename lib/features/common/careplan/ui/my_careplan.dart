import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/features/common/careplan/ui/summary_of_my_careplan.dart';
import 'package:patient/features/common/medication/view_models/patients_medication.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';

class MyCarePlanView extends StatefulWidget {
  @override
  _MyCarePlanViewState createState() => _MyCarePlanViewState();
}

class _MyCarePlanViewState extends State<MyCarePlanView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
/*    late Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = SummaryOfMyCarePlanView();
        break;
      case 1:
        screen = TeamOfMyCarePlanView();
        break;
      case 2:
        screen = WeekMyCarePlanView();
        break;
    }*/

    return BaseWidget<PatientMedicationViewModel?>(
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
              'My Care Plan',
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
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: SummaryOfMyCarePlanView(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

/*Widget _buildTabDesign() {
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
            label: 'give summary of my care plan view',
            button: true,
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
                    AssetImage('res/images/ic_summary_care_plan.png'),
                    size: 32,
                    color: _currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Summary',
                    style: TextStyle(
                        color: _currentIndex == 0 ? Colors.white : Colors.grey,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
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
                  AssetImage('res/images/ic_team_care_plan.png'),
                  size: 32,
                  color: _currentIndex == 1 ? Colors.white : Colors.grey,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Team',
                  style: TextStyle(
                      color: _currentIndex == 1 ? Colors.white : Colors.grey,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          */ /*InkWell(
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage(
                      'res/images/ic_week_care_plan.png'),
                  size: 32,
                  color: _currentIndex == 2 ? Colors.white : Colors.grey,
                ),
                SizedBox(height: 4,),
                Text(
                  'Week',
                  style: TextStyle(
                      color: _currentIndex == 2 ? Colors.white : Colors.grey,
                      fontSize: 12),
                ),
              ],
            ),
          ),*/ /*
        ],
      ),
    );
  }*/
}
