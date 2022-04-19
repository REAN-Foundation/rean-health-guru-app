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

class AddPhysicalActivityGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddPhysicalActivityGoalsForCarePlanViewState createState() =>
      _AddPhysicalActivityGoalsForCarePlanViewState();
}

class _AddPhysicalActivityGoalsForCarePlanViewState
    extends State<AddPhysicalActivityGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedGoal = '';
  String? durationGoal = '';
  String? frequencyGoal = 'Daily';

  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _frequncyController = TextEditingController();

  final _durationFocus = FocusNode();
  final _frequencyFocus = FocusNode();

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
      padding:
          const EdgeInsets.only(left: 0.0, right: 0.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Physical activity is important. Just 150 minutes of moderate-intensity aerobic exercise a week is enough to lower both cholesterol and high blood pressure. And there are lots of options: brisk walking, swimming, bicycling or even a dance class can fit the bill.',
            style: TextStyle(
                color: textBlack, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          /* Row(
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
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(
                      text: 'Activity',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: '',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic)),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: colorF6F6FF),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Activity',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Yoga',
                        child: Text(
                          'Yoga',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Brisk walking',
                        child: Text(
                          'Brisk walking',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGoal = value;
                      });
                    },
                    value: selectedGoal == '' ? null : selectedGoal,
                  ),
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
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(
                      text: 'Duration',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic)),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: TextFormField(
                      controller: _durationController,
                      focusNode: _durationFocus,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _durationFocus, _frequencyFocus);
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: 130,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: colorF6F6FF),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Duration',
                    style: TextStyle(
                        color: textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Minutes',
                      child: Text(
                        'Minutes',
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Hours',
                      child: Text(
                        'Hours',
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      durationGoal = value;
                    });
                  },
                  value: durationGoal == '' ? null : durationGoal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(
                      text: 'Frequency',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: '',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic)),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: TextFormField(
                      controller: _frequncyController,
                      focusNode: _frequencyFocus,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {
                        /*_fieldFocusChange(
                            context,
                            _frequencyFocus,
                            _weightFocus);*/
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: 130,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: colorF6F6FF),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Daily',
                    style: TextStyle(
                        color: textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Daily',
                      child: Text(
                        'Daily',
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Weekly',
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      frequencyGoal = value;
                    });
                  },
                  value: frequencyGoal == '' ? null : frequencyGoal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                child: RichText(
                  text: TextSpan(
                      text: 'Start At',
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  setGoals() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['TargetDate'] = dob;
      map['ActivityTargetValue'] = _durationController.text;
      map['ActivityUnit'] = durationGoal;
      map['ActivityType'] = selectedGoal;
      map['IntensityLevel'] = 102;
      map['Frequency'] = _frequncyController.text;
      map['FrequencyUnit'] = frequencyGoal;

      final body = <String, dynamic>{};
      body['Goal'] = map;
      body['GoalSettingTaskId'] = getTask()!.details!.id;

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
