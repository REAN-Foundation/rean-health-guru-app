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
import 'package:progress_dialog/progress_dialog.dart';

class AddBloodPresureeGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddBloodPresureeGoalsForCarePlanViewState createState() =>
      _AddBloodPresureeGoalsForCarePlanViewState();
}

class _AddBloodPresureeGoalsForCarePlanViewState
    extends State<AddBloodPresureeGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedGoal = '';

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  final _systolicFocus = FocusNode();
  final _diastolicFocus = FocusNode();
  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return BaseWidget<PatientCarePlanViewModel>(
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
            'Normal blood pressure is less than 120/80 mm Hg (systolic pressure is less than 120 AND diastolic pressure is less than 80). Elevated is systolic pressure from 120-129 OR diastolic pressure less than 80. High blood pressure is systolic pressure of 130 or higher OR diastolic pressure of 80 or higher.',
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
              RichText(
                text: TextSpan(
                    text: 'Systolic',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '  mm Hg     ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: TextFormField(
                      controller: _systolicController,
                      focusNode: _systolicFocus,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _systolicFocus, _diastolicFocus);
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Diastolic',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '  mm Hg  ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: TextFormField(
                      controller: _diastolicController,
                      focusNode: _diastolicFocus,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {
                        /*_fieldFocusChange(
                            context,
                            _diastolicFocus,
                            _weightFocus);*/
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
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
                  if (_systolicController.text == '') {
                    showToast(
                        'Please enter systolic blood presure target', context);
                  } else if (_diastolicController.text == '') {
                    showToast(
                        'Please enter diastolic blood presure target', context);
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  setGoals() async {
    try {
      progressDialog.show();
      final map = <String, dynamic>{};
      map['TargetDate'] = dob;
      map['Systolic_Target'] = _systolicController.text;
      map['Systolic_HealthyRangeStart'] = 100;
      map['Systolic_HealthyRangeEnd'] = 130;
      map['Systolic_StartingValue'] = 140;
      map['Diastolic_Target'] = _diastolicController.text;
      map['Diastolic_HealthyRangeStart'] = 60;
      map['Diastolic_HealthyRangeEnd'] = 90;
      map['Diastolic_StartingValue'] = 85;

      final body = <String, dynamic>{};
      body['Goal'] = map;
      body['GoalSettingTaskId'] = getTask().details.id;

      final BaseResponse baseResponse = await model.addGoalsTask(
          startCarePlanResponseGlob.data.carePlan.id.toString(),
          'blood-pressure-goal',
          body);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        goalPlanScreenStack.removeAt(0);
        navigateToScreen();
      } else {
        progressDialog.hide();
        if (baseResponse.error
            .contains('goal already exists for this care plan')) {
          goalPlanScreenStack.removeAt(0);
          navigateToScreen();
        } else {
          showToast(baseResponse.message, context);
        }
      }
    } catch (e) {
      progressDialog.hide();
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
