

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/health_device/models/health_device_list_with_status.dart';
import 'package:patient/features/misc/models/get_health_report_settings_pojo.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/view_models/common_config_model.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CustomizeHealthReportView extends StatefulWidget {
  @override
  _CustomizeHealthReportViewState createState() => _CustomizeHealthReportViewState();
}

class _CustomizeHealthReportViewState extends State<CustomizeHealthReportView> {
  late ProgressDialog progressDialog;
  var model = CommonConfigModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<WearableDeviceDetails> deviceList = <WearableDeviceDetails>[];

  var _frequencyValue = '';
  bool _hJValue = false;
  bool _medicationAdherenceValue = true;
  bool _weightValue = true;
  bool _glucoseValue = true;
  bool _bPValue = true;
  bool _sleepValue = false;
  bool _labValuesValue = false;
  bool _physicalActivityValue = false;
  bool _nutritionValue = false;
  bool _dailyTaskValue = false;
  bool _moodNsymptomsValue = false;
  final _scrollController = ScrollController();

  bool loader = false;


  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    getAllRecords();
    super.initState();
  }

  getAllRecords() async {
    try {

      loader = true;
      setState(() {});

      final GetHealthReportSettingsPojo reportSettingsPojo =
      await model.getHealthReportSettings();
      debugPrint('Reports Settings ==> ${reportSettingsPojo.toJson()}');
      if (reportSettingsPojo.status == 'success') {
        _hJValue = reportSettingsPojo.data!.settings!.preference!.healthJourney!;
        _medicationAdherenceValue = reportSettingsPojo.data!.settings!.preference!.medicationAdherence!;
        _weightValue = reportSettingsPojo.data!.settings!.preference!.bodyWeight!;
        _glucoseValue = reportSettingsPojo.data!.settings!.preference!.bloodGlucose!;
        _bPValue = reportSettingsPojo.data!.settings!.preference!.bloodPressure!;
        _sleepValue = reportSettingsPojo.data!.settings!.preference!.sleepHistory!;
        _labValuesValue = reportSettingsPojo.data!.settings!.preference!.labValues!;
        _physicalActivityValue = reportSettingsPojo.data!.settings!.preference!.exerciseAndPhysicalActivity!;
        _nutritionValue = reportSettingsPojo.data!.settings!.preference!.foodAndNutrition!;
        _dailyTaskValue = reportSettingsPojo.data!.settings!.preference!.dailyTaskStatus!;
        _moodNsymptomsValue = reportSettingsPojo.data!.settings!.preference!.moodAndSymptoms!;
        loader = false;
        setState(() {});
        _frequencyValue = reportSettingsPojo.data!.settings!.preference!.reportFrequency!;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      } else {
        loader = false;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      }
    } on FetchDataException catch (CustomException) {
      loader = false;
      setState(() {});
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CommonConfigModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Customize report',
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
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: loader ? Center(child: Container( height: 32, width: 32, child: CircularProgressIndicator())) : body(),
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


  Widget body(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            Text(
              'Select Duration of Health Report',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Duration',
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _frequencyValue == '' ? null : _frequencyValue,
                        items: <String>[
                          'Week',
                          'Month',
                          //'Yearly'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Choose an option'),
                        onChanged: (data) {
                          debugPrint(data);
                          setState(() {
                            _frequencyValue = data.toString();
                          });
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16,),
            Text(
              'Please customize the report by enabling or disabling the sections you wish to include or exclude according to your preferences.',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scrollbar(
                  controller:  _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Health Journey',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _hJValue,
                              onChanged: (value) {
                                setState(() {
                                  _hJValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Medication Adherence',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _medicationAdherenceValue,
                              onChanged: (value) {
                                setState(() {
                                  _medicationAdherenceValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Body Weight',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _weightValue,
                              onChanged: (value) {
                                setState(() {
                                  _weightValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Blood Glucose',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _glucoseValue,
                              onChanged: (value) {
                                setState(() {
                                  _glucoseValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Blood Pressure',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _bPValue,
                              onChanged: (value) {
                                setState(() {
                                  _bPValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Sleep History',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _sleepValue,
                              onChanged: (value) {
                                setState(() {
                                  _sleepValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Lab Values',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _labValuesValue,
                              onChanged: (value) {
                                setState(() {
                                  _labValuesValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Exercise and Physical Activity',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _physicalActivityValue,
                              onChanged: (value) {
                                setState(() {
                                  _physicalActivityValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Food and Nutrition - Questionnaire',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _nutritionValue,
                              onChanged: (value) {
                                setState(() {
                                  _nutritionValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Daily Task Status',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _dailyTaskValue,
                              onChanged: (value) {
                                setState(() {
                                  _dailyTaskValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Mood and Symptoms',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            CupertinoSwitch(
                              value: _moodNsymptomsValue,
                              onChanged: (value) {
                                setState(() {
                                  _moodNsymptomsValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8,),
            model.busy ? Center(child: CircularProgressIndicator(color: primaryColor),) : savingSettingsWidget(),
          ],
      ),
    );
  }

  Widget savingSettingsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          //.icon
          onPressed: () async {
            FirebaseAnalytics.instance.logEvent(name: 'save_custom_health_report_button_click');
            if(_frequencyValue.isEmpty){
              showToast('Please select frequency.', context);
            }else{
              setHealthReportSettings();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          style: ButtonStyle(
              foregroundColor:
              MaterialStateProperty.all<Color>(primaryLightColor),
              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: primaryColor)))),
        ),
      ),
    );
  }

  /// HealthJourney : true
  /// MedicationAdherence : true
  /// BodyWeight : false
  /// BloodGlucose : true
  /// BloodPressure : true
  /// SleepHistory : true
  /// LabValues : true
  /// ExerciseAndPhysicalActivity : true
  /// FoodAndNutrition : true
  /// DailyTaskStatus : true
  /// MoodAndSymptoms : true

  setHealthReportSettings() async {
    try {
      final body = <String, dynamic>{};
      body["PatientUserId"] = patientUserId;

      final preference = <String, dynamic>{};
      preference['ReportFrequency'] = _frequencyValue;
      preference['HealthJourney'] = _hJValue;
      preference['MedicationAdherence'] = _medicationAdherenceValue;
      preference['BodyWeight'] = _weightValue;
      preference['BloodGlucose'] = _glucoseValue;
      preference['BloodPressure'] = _bPValue;
      preference['SleepHistory'] = _sleepValue;
      preference['LabValues'] = _labValuesValue;
      preference['ExerciseAndPhysicalActivity'] = _physicalActivityValue;
      preference['FoodAndNutrition'] = _nutritionValue;
      preference['DailyTaskStatus'] = _dailyTaskValue;
      preference['MoodAndSymptoms'] = _moodNsymptomsValue;
      body["Preference"] = preference;


      final GetHealthReportSettingsPojo baseResponse =
          await model.setHealthReportSettings(body);
      debugPrint('Records ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        showSuccessToast('Patient health report settings updated successfully.', context);
        Navigator.pop(context);
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }



}