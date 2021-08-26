import 'package:charts_flutter/flutter.dart' as charts;
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyVitalsHistory.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/core/viewmodels/views/patients_vitals.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SimpleTimeSeriesChart.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';


class EnterAllVitalsView extends StatefulWidget {
  @override
  _EnterAllVitalsViewState createState() => _EnterAllVitalsViewState();
}

class _EnterAllVitalsViewState extends State<EnterAllVitalsView> {

  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat("MMM dd, yyyy");
  var _weightController = new TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  var _bloodGlucosecontroller = new TextEditingController();
  var _bloodOxygenSaturationController = new TextEditingController();
  var _pulseRateController = new TextEditingController();
  var _bodyTempratureController = new TextEditingController();

  var _bodyTempratureFocus = FocusNode();
  var _pulseRateFocus = FocusNode();
  var _bloodOxygenSaturationFocus = FocusNode();
  var _bloodGlucoseFocus = FocusNode();
  var _weightFocus = FocusNode();
  var _systolicFocus = FocusNode();
  var _diastolicFocus = FocusNode();
  ProgressDialog progressDialog;
  String unit = 'Kg';

  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();

  var scrollContainer = new ScrollController();
  ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    debugPrint('Country Local ==> ${details.alpha2Code}');
    // TODO: implement initState
    if(details.alpha2Code == "US"){
      unit = 'lbs';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    // TODO: implement build
    return BaseWidget<PatientVitalsViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child:  Scaffold(
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
                      weightFeilds(),
                      const SizedBox(height: 8,),
                      bloodPresureFeilds(),
                      const SizedBox(height: 8,),
                      bloodGlucoseFeilds(),
                      const SizedBox(height: 8,),
                      bloodOxygenSaturationFeilds(),
                      const SizedBox(height: 8,),
                      pulseRateFeilds(),
                      const SizedBox(height: 8,),
                      bodyTempratureFeilds(),
                      const SizedBox(height: 32,),
                      Align(
                        alignment: Alignment.center,
                        child: model.busy ? SizedBox( width: 32, height: 32, child: CircularProgressIndicator()) :
                        Semantics(
                          label: 'Save',
                          child: InkWell(
                            onTap: (){
                              toastDisplay = true;
                              /*if(_controller.text.toString().isEmpty){
                                showToast('Please enter your pulse');
                              }else{
                                addvitals();
                              }*/
                              if(!_weightController.text.toString().isEmpty) {
                                addWeightVitals();
                              }
                              if(!_systolicController.text.toString().isEmpty && !_diastolicController.text.toString().isEmpty) {
                                addBPVitals();
                              }
                              if(!_bloodGlucosecontroller.text.toString().isEmpty) {
                                addBloodGlucoseVitals();
                              }
                              if(!_bloodOxygenSaturationController.text.toString().isEmpty) {
                                addBloodOxygenSaturationVitals();
                              }
                              if(!_pulseRateController.text.toString().isEmpty) {
                                addPulseVitals();
                              }
                              if(!_bodyTempratureController.text.toString().isEmpty) {
                                addTemperatureVitals();
                              }
                            },
                            child: Container(
                                height: 40,
                                width: 200,
                                padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(color: primaryColor, width: 1),
                                  color: Colors.deepPurple,),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48,),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget weightFeilds(){
    return Card(
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
                SizedBox(width: 8,),
                Text(
                  "Enter your weight",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: unit == "lbs" ? " (lbs) " : " (Kg) ",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Semantics(
                      label: 'weight',
                      child: TextFormField(
                          controller: _weightController,
                          focusNode: _weightFocus,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context,
                                _weightFocus,
                                _systolicFocus);
                          },
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          decoration: InputDecoration(
                              hintText: unit == "lbs" ? "(100 to 200)" : "(50 to 100)",
                              hintStyle: TextStyle(fontSize: 12, ),
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

  Widget bloodPresureFeilds(){
    return Card(
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
                    AssetImage('res/images/ic_blood_presure.png'),
                    size: 24,
                    color: primaryColor,
                  ),
                  SizedBox(width: 8,),
                  Text(
                    "Enter your blood pressure",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Systolic (mmHg)",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Diastolic (mmHg)",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8.0),
                          border: Border.all(
                              color: primaryColor, width: 1),
                          color: Colors.white),
                      child: Semantics(
                        label: 'Systolic',
                        child: TextFormField(
                            inputFormatters: [
                              new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                            ],
                            controller: _systolicController,
                            focusNode: _systolicFocus,
                            maxLines: 1,
                            textInputAction:
                            TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context,
                                  _systolicFocus,
                                  _diastolicFocus);
                            },
                            decoration: InputDecoration(
                                hintText: "(80 to 120)",
                                hintStyle: TextStyle(fontSize: 12, ),
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(8.0),
                          border: Border.all(
                              color: primaryColor, width: 1),
                          color: Colors.white),
                      child: Semantics(
                        label: 'diastolic',
                        child: TextFormField(
                            controller: _diastolicController,
                            focusNode: _diastolicFocus,
                            maxLines: 1,
                            textInputAction:
                            TextInputAction.next,
                            inputFormatters: [
                              new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
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
                                hintStyle: TextStyle(fontSize: 12, ),
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
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " mm Hg ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w500,
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
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 16),
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
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
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
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " mm Hg ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w500,
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
          )
      ),
    );
  }

  Widget bloodGlucoseFeilds(){
    return Card(
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
                SizedBox(width: 8,),
                Text(
                  "Enter your blood glucose",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (mg/dL) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Semantics(
                      label: 'blood_glucose',
                      child: TextFormField(
                          focusNode: _bloodGlucoseFocus,
                          controller: _bloodGlucosecontroller,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _bloodGlucoseFocus, _bloodOxygenSaturationFocus);
                          },
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          decoration: InputDecoration(
                              hintText: "(100 to 125)",
                              hintStyle: TextStyle(fontSize: 12, ),
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

  Widget bloodOxygenSaturationFeilds(){
    return Card(
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
                  AssetImage('res/images/ic_oximeter.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(width: 8,),
                Text(
                  "Enter your blood oxygen saturation",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (%) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Semantics(
                      label: 'blood_oxygen_saturation',
                      child: TextFormField(
                          focusNode: _bloodOxygenSaturationFocus,
                          controller: _bloodOxygenSaturationController,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _bloodOxygenSaturationFocus, _pulseRateFocus);
                          },
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          decoration: InputDecoration(
                              hintText: "(92 to 100)",
                              hintStyle: TextStyle(fontSize: 12, ),
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

  Widget pulseRateFeilds(){
    return Card(
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
                SizedBox(width: 8,),
                Text(
                  "Enter your pulse rate",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (bpm) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Semantics(
                      label: 'pulse_rate',
                      child: TextFormField(
                          focusNode: _pulseRateFocus,
                          controller: _pulseRateController,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _pulseRateFocus, _bodyTempratureFocus);
                          },
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          decoration: InputDecoration(
                              hintText: "(65 to 95)",
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

  Widget bodyTempratureFeilds(){
    return Card(
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
                SizedBox(width: 10,),
                Text(
                  "Enter your body temperature",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (°F) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Semantics(
                      label: 'body_temperature',
                      child: TextFormField(
                          focusNode: _bodyTempratureFocus,
                          controller: _bodyTempratureController,
                          maxLines: 1,
                          textInputAction:
                          TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {

                          },
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                          ],
                          decoration: InputDecoration(
                              hintText: "(95 to 100)",
                              hintStyle: TextStyle(fontSize: 12, ),
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

      if(unit == 'lbs'){
        entertedWeight = entertedWeight / 2.20462;
      }
      var map = new Map<String, dynamic>();
      map['Weight'] = entertedWeight.toString();

      BaseResponse baseResponse  = await model.addMyVitals('weight', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  addBPVitals() async {
    try {
      var map = new Map<String, dynamic>();
      map['SystolicBloodPressure'] = _systolicController.text.toString();
      map['DiastolicBloodPressure'] = _diastolicController.text.toString();

      BaseResponse baseResponse  = await model.addMyVitals('blood-pressure', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  addBloodGlucoseVitals() async {
    try {
      var map = new Map<String, dynamic>();
      map['BloodGlucose'] = _bloodGlucosecontroller.text.toString();

      BaseResponse baseResponse  = await model.addMyVitals('blood-sugar', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  addBloodOxygenSaturationVitals() async {
    try {
      var map = new Map<String, dynamic>();
      map['BloodOxygenSaturation'] = _bloodOxygenSaturationController.text.toString();

      BaseResponse baseResponse  = await model.addMyVitals('blood-oxygen-saturation', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  addPulseVitals() async {
    try {
      var map = new Map<String, dynamic>();
      map['Pulse'] = _pulseRateController.text.toString();

      BaseResponse baseResponse  = await model.addMyVitals('pulse', map);

      if (baseResponse.status == 'success') {
        clearAllFeilds();
      } else {

      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  addTemperatureVitals() async {
    try {
      var map = new Map<String, dynamic>();
      map['Temperature'] = _bodyTempratureController.text.toString();

      BaseResponse baseResponse  = await model.addMyVitals('temperature', map);

      if (baseResponse.status == 'success') {
        //showToast('Record added successfully');
        clearAllFeilds();
      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  bool toastDisplay = true;

  clearAllFeilds(){

    if(toastDisplay){
      _scrollController.animateTo(
          0.0,
          duration: Duration(seconds: 2),
          curve: Curves.ease);
      showToast("Record Updated Successfully");
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