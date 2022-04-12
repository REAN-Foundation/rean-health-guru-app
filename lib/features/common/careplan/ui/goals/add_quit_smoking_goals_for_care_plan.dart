import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/careplan/view_models/patients_care_plan.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddQuitSmokingGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddQuitSmokingGoalsForCarePlanViewState createState() =>
      _AddQuitSmokingGoalsForCarePlanViewState();
}

class _AddQuitSmokingGoalsForCarePlanViewState
    extends State<AddQuitSmokingGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'Tobacco Free Till';

  // Group Value for Radio Button.
  int id = 1;

  String selectedGoal = '';
  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');
  late ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Set Care Plan Goals',
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  addGoals(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addGoals() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Smoking is the leading preventable cause of death and disability in the United States. Cigarette smoking results in a much higher risk of dying of coronary heart disease. Smoking robs the heart of oxygen-rich blood and increases the effects of other risk factors, including blood pressure, blood cholesterol levels and physical inactivity.',
            style: TextStyle(
                color: textBlack, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){

                },
                child: Container(
                  width: 120,
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child:  Center(
                    child: Text(
                      'View more >>',
                      style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 1,
                groupValue: id,
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = 'Forever';
                    id = 1;
                  });
                },
              ),
              Text(
                'Forever',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 2,
                groupValue: id,
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = 'Tobacco Free Till';
                    id = 2;
                  });
                },
              ),
              Text(
                'Tobacco Free Till',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 160,
                    height: 50.0,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              dob,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          ),
                          ImageIcon(
                            AssetImage('res/images/ic_calender.png'),
                            size: 24,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now().subtract(Duration(days: 0)),
                        onChanged: (date) {
                      debugPrint('change $date');
                    }, onConfirm: (date) {
                          unformatedDOB = date.toIso8601String();
                      setState(() {
                        dob = dateFormat.format(date);
                      });
                      debugPrint('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 3,
                groupValue: id,
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = 'I Don\'t Smoke';
                    id = 3;
                  });
                },
              ),
              Text(
                'I Don\'t Smoke',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setGoals();
                  //Navigator.of(context).pop();
                  //Navigator.pushNamed(context, RoutePaths.Home);
                },
                child: Container(
                    height: 40,
                    width: 120,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  setGoals() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['TobaccoFreeTargetDate'] = dob;
      map['StopSmokingForever'] = radioButtonItem == 'Forever';
      map['NonSmoker'] = radioButtonItem == 'I Don\'t Smoke';

      final body = <String, dynamic>{};
      body['Goal'] = map;
      body['GoalSettingTaskId'] = 'e73575f5-cd5d-4177-9af8-ae1565a576a8';

      final BaseResponse baseResponse = await model.addGoalsTask(
          startCarePlanResponseGlob!.data!.carePlan!.id.toString(),
          'physical-activity-goal',
          body);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        goalPlanScreenStack.removeAt(0);
        navigateToScreen();
      } else {
        progressDialog.close();
        if (baseResponse.error!
            .contains('goal already exists for this care plan')) {
          goalPlanScreenStack.removeAt(0);
          navigateToScreen();
        } else {
          showToast(baseResponse.message!, context);
        }
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  navigateToScreen() {
    debugPrint('Set Goals Plan Stack ==> ${goalPlanScreenStack.length}');
    if (goalPlanScreenStack.isEmpty) {
      Navigator.pushReplacementNamed(
          context, RoutePaths.Determine_Action_For_Care_Plan);
    } else if (goalPlanScreenStack.elementAt(0) == 'Blood Pressure') {
      Navigator.pushReplacementNamed(
          context, RoutePaths.ADD_BLOOD_PRESURE_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Blood Sugar') {
      Navigator.pushReplacementNamed(context, RoutePaths.ADD_GLUCOSE_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Weight') {
      Navigator.pushReplacementNamed(context, RoutePaths.ADD_WEIGHT_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Physical Activity') {
      Navigator.pushReplacementNamed(
          context, RoutePaths.ADD_PHYSICAL_ACTIVITY_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Quit Smoking') {
      Navigator.pushReplacementNamed(
          context, RoutePaths.ADD_QUIT_SMOKING_GOALS);
    }
  }
}
