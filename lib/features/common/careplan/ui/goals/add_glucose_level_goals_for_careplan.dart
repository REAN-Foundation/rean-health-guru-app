import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddGlucoseLevelGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddGlucoseLevelGoalsForCarePlanViewState createState() =>
      _AddGlucoseLevelGoalsForCarePlanViewState();
}

class _AddGlucoseLevelGoalsForCarePlanViewState
    extends State<AddGlucoseLevelGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedGoal = '';

  final TextEditingController _fastingController = TextEditingController();

  final _fastingFocus = FocusNode();
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
            'Normal fasting blood glucose level should be less than 100 mg/dL. If you are diabetic, a HbA1c (glycosylated hemoglobin) below 7 percent is recommended, but your safe range may be lower or higher. Managing diabetes is important to your long-term health, especially if you have heart disease. Diabetes is best controlled by diet, weight loss, ',
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
          ),
          const SizedBox(height: 16,),*/

          RichText(
            text: TextSpan(
                text: 'Fasting Blood Glucose',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: '  mg / dL     ',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.italic)),
                ]),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: TextFormField(
                controller: _fastingController,
                focusNode: _fastingFocus,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (term) {},
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          ),

          /* SizedBox(height: 16,),

              RichText(
                text: TextSpan(
                    text: 'Postprandial Blood Glucose',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "  mg / dL ",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle:
                              FontStyle.italic)),
                    ]),
              ),
          SizedBox(height: 4,),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(8.0),
                    border: Border.all(
                        color: primaryColor, width: 1),
                    color: Colors.white),
                child: TextFormField(
                    controller: _ppController,
                    focusNode: _ppFocus,
                    maxLines: 1,
                    textInputAction:
                    TextInputAction.done,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (term) {
                      */ /*_fieldFocusChange(
                          context,
                          _ppFocus,
                          _weightFocus);*/ /*
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true)),
              ),*/

          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Target Date',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '          ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
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
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (_fastingController.text == '') {
                    showToast('Please enter fasting blood sugar', context);
                  } else if (dob.isEmpty) {
                    showToast('Please select taget date', context);
                  } else {
                    setGoals();
                  }
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
      map['TargetDate'] = dob;
      map['BloodSugar_Target'] = _fastingController.text;
      map['BloodSugar_HealthyRangeStart'] = 100;
      map['BloodSugar_HealthyRangeEnd'] = 130;
      map['BloodSugar_StartingValue'] = 140;
      map['MeasurementUnit'] = 'mg/dl';

      final body = <String, dynamic>{};
      body['Goal'] = map;
      body['GoalSettingTaskId'] = getTask()!.id;

      final BaseResponse baseResponse = await model.addGoalsTask(
          startCarePlanResponseGlob!.data!.carePlan!.id.toString(),
          'blood-sugar-goal',
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
