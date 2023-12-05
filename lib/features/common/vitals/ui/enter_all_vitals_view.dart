import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EnterAllVitalsView extends StatefulWidget {
  @override
  _EnterAllVitalsViewState createState() => _EnterAllVitalsViewState();
}

class _EnterAllVitalsViewState extends State<EnterAllVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _weightController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final _bloodGlucosecontroller = TextEditingController();
  final _bloodOxygenSaturationController = TextEditingController();
  final _pulseRateController = TextEditingController();
  final _bodyTempratureController = TextEditingController();
  final _patientUserIdController = TextEditingController();
  final _bodyTempratureFocus = FocusNode();
  final _pulseRateFocus = FocusNode();
  final _bloodOxygenSaturationFocus = FocusNode();
  final _bloodGlucoseFocus = FocusNode();
  final _weightFocus = FocusNode();

  final _systolicFocus = FocusNode();
  final _diastolicFocus = FocusNode();
  ProgressDialog? progressDialog;
  String unit = 'Kg';
  GetHealthData getHealthData = GetIt.instance<GetHealthData>();
  var scrollContainer = ScrollController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    debugPrint('Country Local ==> ${getCurrentLocale()}');
    if (getCurrentLocale() == 'US') {
      unit = 'lbs';
    }
    //getVitalsFromDevice();
    super.initState();
  }

  getVitalsFromDevice() {
    if (getHealthData.getBloodOxygen() != '0.0') {
      _bloodOxygenSaturationController.text = getHealthData.getBloodOxygen();
      _bloodOxygenSaturationController.selection = TextSelection.fromPosition(
        TextPosition(offset: _bloodOxygenSaturationController.text.length),
      );
    }

    if (getHealthData.getBPDiastolic() != '0.0') {
      _diastolicController.text = getHealthData.getBPDiastolic();
      _diastolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _diastolicController.text.length),
      );
    }

    if (getHealthData.getBPSystolic() != '0.0') {
      _systolicController.text = getHealthData.getBPSystolic();
      _systolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _systolicController.text.length),
      );
    }

    if (getHealthData.getBodyTemprature() != '0.0') {
      _bodyTempratureController.text = getHealthData.getBodyTemprature();
      _bodyTempratureController.selection = TextSelection.fromPosition(
        TextPosition(offset: _bodyTempratureController.text.length),
      );
    }

    if (getHealthData.getHeartRate() != '0.0') {
      _pulseRateController.text = getHealthData.getHeartRate();
      _pulseRateController.selection = TextSelection.fromPosition(
        TextPosition(offset: _pulseRateController.text.length),
      );
    }

    if (getHealthData.getWeight() != '0.0') {
      _weightController.text = getHealthData.getWeight();
      _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length),
      );
    }

    if (getHealthData.getBloodGlucose() != '0.0') {
      _bloodGlucosecontroller.text = getHealthData.getBloodGlucose();
      _bloodGlucosecontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: _bloodGlucosecontroller.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientVitalsViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //const SizedBox(height: 16,),
                  for (int i = 0 ; i < RemoteConfigValues.vitalScreenTile.length ; i++)...[
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Weight')
                      weightFeilds(),
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Pressure')
                      bloodPresureFeilds(),
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Glucose')
                      bloodGlucoseFeilds(),
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Oxygen Sturation')
                      bloodOxygenSaturationFeilds(),
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Pulse Rate')
                      pulseRateFeilds(),
                    if(RemoteConfigValues.vitalScreenTile[i] == 'Body Temprature')
                      bodyTempratureFeilds(),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  const SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: model!.busy
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator())
                        : Semantics(
                            label: 'Save',
                            button: true,
                            child: InkWell(
                              onTap: () {
                                FirebaseAnalytics.instance.logEvent(name: 'enter_all_vitals_save_button_click');
                                toastDisplay = true;
                                validationToastDisplay = true;
                                /*if(_controller.text.toString().isEmpty){
                                showToast('Please enter your pulse', context);
                              }else{
                                addvitals();
                              }*/

                                if (_weightController.text
                                    .toString()
                                    .isNotEmpty) {
                                  if(isNumeric(_weightController.text)) {
                                    validationToastDisplay = false;
                                    addWeightVitals();
                                  }else{
                                    showToast('Please enter valid input', context);
                                  }
                                }/*else{
                                  validationToastDisplay = true;
                                }*/
                                if (_systolicController.text
                                        .toString()
                                        .isNotEmpty &&
                                    _diastolicController.text
                                        .toString()
                                        .isNotEmpty) {
                                  validationToastDisplay = false;
                                  addBPVitals();
                                }/*else{
                                  validationToastDisplay = true;
                                }*/
                                if (_bloodGlucosecontroller.text
                                    .toString()
                                    .isNotEmpty) {
                                  validationToastDisplay = false;
                                  addBloodGlucoseVitals();
                                }/*else{
                                  validationToastDisplay = true;
                                }*/
                                if (_bloodOxygenSaturationController.text
                                    .toString()
                                    .isNotEmpty) {
                                  validationToastDisplay = false;
                                  addBloodOxygenSaturationVitals();
                                }/*else{
                                  validationToastDisplay = true;
                                }*/
                                if (_pulseRateController.text
                                    .toString()
                                    .isNotEmpty) {
                                  validationToastDisplay = false;
                                  addPulseVitals();
                                }/*else{
                                  validationToastDisplay = true;
                                }*/
                                if (_bodyTempratureController.text
                                    .toString()
                                    .isNotEmpty) {
                                  if(isNumeric(_bodyTempratureController.text)) {
                                    validationToastDisplay = false;
                                    addTemperatureVitals();
                                  }else{
                                    showToast('Please enter valid input', context);
                                  }
                                }/*else{
                                  validationToastDisplay = true;
                                }*/

                                if(validationToastDisplay){
                                  showToast('Please enter valid input', context);
                                }
                              },
                              child: ExcludeSemantics(
                                child: Container(
                                    height: 40,
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                          color: primaryColor, width: 1),
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
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget weightFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_body_weight.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your weight',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: unit == 'lbs' ? ' (lbs) ' : ' (Kg) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Weight Information',
                      description:
                      'Achieving and maintaining a healthy weight is beneficial in loweing your risk for heart disease and stroke. Please refer to your doctor\'s recommended healthy weight range and frequency of measuring your weight at home.',
                      height: 240),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Weight measures in ' + unit,
                      child: TextFormField(
                          controller: _weightController,
                          focusNode: _weightFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _weightFocus, _systolicFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                          ],
                          decoration: InputDecoration(
                              /*hintText: unit == 'lbs'
                                  ? '(100 to 200)'
                                  : '(50 to 100)',*/
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bloodPresureFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_blood_pressure.png'),
                    size: 24,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Enter your blood pressure',
                    style: TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InfoScreen(
                        tittle: 'Blood Pressure Information',
                        description:
                        'If your blood pressure is below 120/80 mm Hg, be sure to get it checked at least once every two years, starting at age 20. If your blood pressure is higher, your doctor may want to check it more often. High blood pressure can be controlled through lifestyle changes and/or medication. \n*Normal: Less than 120/80 \n*Elevated: Systolic 120-129 AND Diastolic less than 80 \n*High Blood Pressure Stage 1: Systolic 130-139 OR Diastolic 80-89 \n*High Blood Pressure Stage 2: Systolic 140+ OR Diastolic 90+ \n*Hypertensive Crisis (Consult your doctor immediately): Systolic 180+ and/or Diastolic 120+',
                        height: 408),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Systolic (mmHg)',
                      style: TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Diastolic (mmHg)',
                      style: TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      textAlign: TextAlign.left,
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: textGrey, width: 1),
                          color: Colors.white),
                      child: Semantics(
                        label: 'Systolic measures in mm Hg',
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
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
                              //hintText: '(80 to 120)',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: textBlack, width: 1),
                          color: Colors.white),
                      child: Semantics(
                        label: 'Diastolic measures in mm Hg',
                        child: TextFormField(
                            controller: _diastolicController,
                            focusNode: _diastolicFocus,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _diastolicFocus, _bloodGlucoseFocus);
                            },
                            decoration: InputDecoration(
                              //hintText: '(60 to 80)',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                      ),
                    ),
                  ),
                  /*Expanded(
                    flex: 2,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: '',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " mm Hg ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: primaryColor,
                                      fontFamily: 'Montserrat',
                                      fontStyle:
                                      FontStyle.italic)),
                            ]),
                      ),
                    ),
                  ),*/
                ],
              ),
              //SizedBox(height: 16,),
              /*Text(
                "Enter your diastolic blood presure:",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
                textAlign: TextAlign.center,
              ),*/
              //SizedBox(height: 8,),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8.0),
                          border: Border.all(
                              color: primaryColor, width: 1),
                          color: Colors.white),
                      child: TextFormField(
                          controller: _diastolicController,
                          focusNode: _diastolicFocus,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.next,
                          inputFormatters: [
                            new FilteringTextInputFormatter.deny(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                              context,
                              _diastolicFocus,
                              _bloodGlucoseFocus);
                          },
                          decoration: InputDecoration(
                              hintText: "(60 to 80)",
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: '',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " mm Hg ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: primaryColor,
                                      fontFamily: 'Montserrat',
                                      fontStyle:
                                      FontStyle.italic)),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),*/
            ],
          )),
    );
  }

  Widget bloodGlucoseFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_blood_glucose.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Enter your blood glucose',
                          style: TextStyle(
                              color: textBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        RichText(
                          text: TextSpan(
                            text: ' (mg/dL) ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: textBlack,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4,),
                    Text(
                      '(Also known as blood sugar)',
                      style: TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Blood Glucose Information',
                      description:
                      'High blood glucose or "blood sugar" levels put you at greater risk of developing insulin resistance, prediabetes and type 2 diabetes. Prediabetes and Type 2 diabetes increases risk of heart disease and stroke. Blood glucose is measured through a blood test.\n\nPrediabetes: Fasting blood glucose range is 100 to 125 mg/dL\nDiabetes mellitus (Type 2 diabetes): 126 mg/dL',
                      height: 320),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Blood Glucose measures in mg/dL',
                      child: TextFormField(
                          focusNode: _bloodGlucoseFocus,
                          controller: _bloodGlucosecontroller,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _bloodGlucoseFocus,
                                _bloodOxygenSaturationFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                            //hintText: '(100 to 125)',
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bloodOxygenSaturationFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_oximeter.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                /*Text(
                  'Enter your blood oxygen\nsaturation',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.left,
                ),*/
                RichText(
                  text: TextSpan(
                    text: 'Enter your blood oxygen\nsaturation',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 14),
                    children: <TextSpan>[
                       TextSpan(
                          text: ' (%) ',
                          style: TextStyle(fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: textBlack,
                              fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Blood Oxygen Saturation Information',
                      description: "Pulse oximetry testing is conducted to estimate the percentage of hemoglobin in the blood that is saturated with oxygen.",
                      height: 220),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Blood oxygen Saturation messures in % ',
                      child: TextFormField(
                          focusNode: _bloodOxygenSaturationFocus,
                          controller: _bloodOxygenSaturationController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context,
                                _bloodOxygenSaturationFocus, _pulseRateFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(92 to 100)',
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pulseRateFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_pulse.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your pulse rate',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (bpm) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Pulse Rate Information',
                      description:
                          'Your heart rate, or pulse, is the number of times your heart beats per minute. Normal heart rate varies from person to person. For most of us (adults), between 60 and 100 beats per minute (bpm) is normal. ',
                      height: 240),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Pulse rate measures in bpm',
                      child: TextFormField(
                          focusNode: _pulseRateFocus,
                          controller: _pulseRateController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _pulseRateFocus, _bodyTempratureFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                            //hintText: '(65 to 95)',
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyTempratureFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_thermometer.png'),
                  color: primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Enter your body temperature',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (°F) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Body Temperature Information',
                      description: "The optimal temperature of the human body is 37 °C (98.6 °F), but various factors can affect this value, including exposure to the elements in the environment.",
                      height: 220),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Body Temprature messures in °F',
                      child: TextFormField(
                          focusNode: _bodyTempratureFocus,
                          controller: _bodyTempratureController,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (term) {},
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(95 to 100)',
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  addWeightVitals() async {
    try {
      double entertedWeight = double.parse(_weightController.text.toString());

      if (unit == 'lbs') {
        entertedWeight = entertedWeight / 2.20462;
      }
      final map = <String, dynamic>{};
      map['BodyWeight'] = entertedWeight.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "Kg";

      final BaseResponse baseResponse =
          await model.addMyVitals('body-weights', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBPVitals() async {
    try {
      final map = <String, dynamic>{};
      map['Systolic'] = _systolicController.text.toString();
      map['Diastolic'] = _diastolicController.text.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "mmHg";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse =
          await model.addMyVitals('blood-pressures', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBloodGlucoseVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BloodGlucose'] = _bloodGlucosecontroller.text.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "mg|dL";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse =
          await model.addMyVitals('blood-glucose', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBloodOxygenSaturationVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BloodOxygenSaturation'] =
          _bloodOxygenSaturationController.text.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "%";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse =
          await model.addMyVitals('blood-oxygen-saturations', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addPulseVitals() async {
    try {
      final map = <String, dynamic>{};
      map['Pulse'] = _pulseRateController.text.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "bpm";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse = await model.addMyVitals('pulse', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addTemperatureVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BodyTemperature'] = _bodyTempratureController.text.toString();
      map['PatientUserId'] = patientUserId;
      //map['Unit'] = "Farenheit";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse =
          await model.addMyVitals('body-temperatures', map);

      if (baseResponse.status == 'success') {
        //showToast('Record added successfully');
        clearAllFeilds();
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  bool toastDisplay = true;
  bool validationToastDisplay = false;

  clearAllFeilds() {
    if (toastDisplay) {
      _scrollController.animateTo(0.0,
          duration: Duration(seconds: 2), curve: Curves.ease);
      showSuccessToast('Record Updated Successfully!', context);
      toastDisplay = false;
    }

    _weightController.text = '';
    _weightController.selection = TextSelection.fromPosition(
      TextPosition(offset: _weightController.text.length),
    );

    _systolicController.text = '';
    _systolicController.selection = TextSelection.fromPosition(
      TextPosition(offset: _systolicController.text.length),
    );

    _diastolicController.text = '';
    _diastolicController.selection = TextSelection.fromPosition(
      TextPosition(offset: _diastolicController.text.length),
    );

    _bloodGlucosecontroller.text = '';
    _bloodGlucosecontroller.selection = TextSelection.fromPosition(
      TextPosition(offset: _bloodGlucosecontroller.text.length),
    );

    _bloodOxygenSaturationController.text = '';
    _bloodOxygenSaturationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _bloodOxygenSaturationController.text.length),
    );

    _patientUserIdController.text = '';
    _patientUserIdController.selection = TextSelection.fromPosition(
      TextPosition(offset: _patientUserIdController.text.length),
    );

    _pulseRateController.text = '';
    _pulseRateController.selection = TextSelection.fromPosition(
      TextPosition(offset: _pulseRateController.text.length),
    );

    _bodyTempratureController.text = '';
    _bodyTempratureController.selection = TextSelection.fromPosition(
      TextPosition(offset: _bodyTempratureController.text.length),
    );
  }
}

