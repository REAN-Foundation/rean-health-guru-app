

import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';


class BiomatricTask extends StatefulWidget {

  Task task;

  BiomatricTask(@required Task task){
    this.task = task;
  }

  @override
  _BiomatricTaskViewState createState() => _BiomatricTaskViewState();
}

class _BiomatricTaskViewState extends State<BiomatricTask> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  var dateFormat = DateFormat("yyyy-MM-dd");
  var timeFormat = DateFormat("hh:mm:ss");

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _fastingController = TextEditingController();

  var _systolicFocus = FocusNode();
  var _diastolicFocus = FocusNode();
  var _weightFocus = FocusNode();
  var _fastingFocus = FocusNode();

  ProgressDialog progressDialog;

  String unit = 'Kg';

  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.task.details.bloodPressureSystolic != null) {
      _systolicController.text =
          widget.task.details.bloodPressureSystolic.toString();
      _systolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _systolicController.text.length),
      );
    }
    if(widget.task.details.bloodPressureDiastolic != null){
      _diastolicController.text =
          widget.task.details.bloodPressureDiastolic.toString();
      _diastolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _diastolicController.text.length),
      );
    }
    if(widget.task.details.weight != null){
      debugPrint('Task Weight ==> ${widget.task.details.weight}');
      _weightController.text =
          widget.task.details.weight.toString();
      _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length),
      );
    }
    if(widget.task.details.bloodGlucose != null){
      _fastingController.text =
          widget.task.details.bloodGlucose.toString();
      _fastingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _fastingController.text.length),
      );
    }

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
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child:  Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'Biometrics',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
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
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      questionText(),
                      const SizedBox(height: 16,),
                      if(widget.task.details.subTitle.contains('weight'))...[
                        weightFeilds(),
                      ] else if(widget.task.details.subTitle.contains('glucose'))...[
                        glucoseFeilds(),
                      ] else if(widget.task.details.subTitle.contains('blood pressure'))...[
                        bloodPresureFeilds(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget questionText() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryLightColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.task.details.subTitle,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget bloodPresureFeilds(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Systolic',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "  mm Hg     ",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle:
                              FontStyle.italic)),
                    ]),
              ),
              Expanded(
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
                      enabled: !widget.task.finished,
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
                      inputFormatters: [
                        new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                      ],
                      decoration: InputDecoration(

                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              )
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Diastolic',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "  mm Hg  ",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle:
                              FontStyle.italic)),
                    ]),
              ),
              Expanded(
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
                      enabled: !widget.task.finished,
                      controller: _diastolicController,
                      focusNode: _diastolicFocus,
                      maxLines: 1,
                      textInputAction:
                      TextInputAction.done,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {
                        /*_fieldFocusChange(
                            context,
                            _diastolicFocus,
                            _weightFocus);*/
                      },
                      inputFormatters: [
                        new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              )
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  if(widget.task.finished){
                    Navigator.of(context).pop();
                  }else {
                    nextQuestion();
                  }
                  //Navigator.of(context).pop();
                  //Navigator.pushNamed(context, RoutePaths.Home);
                },
                child: Container(
                    height: 40,
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.deepPurple,),
                    child: Center(
                      child: Text(
                        !widget.task.finished ? "Save" : "Done",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget weightFeilds(){
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  child: RichText(
                    text: TextSpan(
                        text: 'Weight',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text:  unit == "lbs" ? "    lbs    " : "    Kg    ",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                  FontWeight.w700,
                                  color: primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontStyle:
                                  FontStyle.italic)),
                        ]),
                  ),
                ),
                Expanded(
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
                        enabled: !widget.task.finished,
                        controller: _weightController,
                        focusNode: _weightFocus,
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
                            hintText: unit == "lbs" ? "(100 to 200)" : "(50 to 100)",
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                      if(widget.task.finished){
                        Navigator.of(context).pop();
                      }else {
                        nextQuestion();
                      }
                    //Navigator.of(context).pop();
                    //Navigator.pushNamed(context, RoutePaths.Home);
                  },
                  child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.deepPurple,),
                      child: Center(
                        child: Text(
                          !widget.task.finished ? "Save" : "Done",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget glucoseFeilds(){
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Blood Glucose',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: "  mg / dL     ",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w700,
                                color: primaryColor,
                                fontFamily: 'Montserrat',
                                fontStyle:
                                FontStyle.italic)),
                      ]),
                ),
              ],
            ),
            SizedBox(height: 4,),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(8.0),
                  border: Border.all(
                      color: primaryColor, width: 1),
                  color: Colors.white),
              child: TextFormField(
                  enabled: !widget.task.finished,
                  controller: _fastingController,
                  focusNode: _fastingFocus,
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

                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    if(widget.task.finished){
                      Navigator.of(context).pop();
                    }else {
                      nextQuestion();
                    }
                    //Navigator.of(context).pop();
                    //Navigator.pushNamed(context, RoutePaths.Home);
                  },
                  child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.deepPurple,),
                      child: Center(
                        child: Text(
                          !widget.task.finished ? "Save" : "Done",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  nextQuestion() async {
    try {
      progressDialog.show();
      var map = new Map<String, dynamic>();

      if(widget.task.details.subTitle.contains('weight')) {
        double entertedWeight = double.parse(_weightController.text.toString());
        if(unit == 'lbs'){
          entertedWeight = entertedWeight / 2.20462;
        }
        map['Weight'] = entertedWeight.toString();
      } else if(widget.task.details.subTitle.contains('glucose')) {
        map['BloodGlucose'] = _fastingController.text.toString();
      } else if(widget.task.details.subTitle.contains('blood pressure')){
        map['BloodPressure_Systolic'] = _systolicController.text.toString();
        map['BloodPressure_Diastolic'] = _diastolicController.text.toString();
      }
      map['MeasuredOn'] = dateFormat.format(new DateTime.now())+'T'+timeFormat.format(new DateTime.now())+'.000Z';

      BaseResponse baseResponse  = await model.addBiometricTask(startCarePlanResponseGlob.data.carePlan.id.toString(), widget.task.details.id, map);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView( 1 );
              }), (Route<dynamic> route) => false);
      } else {
        progressDialog.hide();
        showToast(baseResponse.message);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

}