
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/AnswerAssesmentResponse.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/StartAssesmentResponse.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/BiomatricAssignmentTask.dart';
import 'package:paitent/ui/views/assessment_question_for_care_plan.dart';
import 'package:paitent/ui/views/assessment_start_for_care_plan.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:intl/intl.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_view.dart';

class AssesmentTaskNavigatorView extends StatefulWidget {

 /* StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse;

  AssesmentTaskNavigatorView(StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponseC){
    this._startTaskOfAHACarePlanResponse = _startTaskOfAHACarePlanResponseC;
  }*/

  Task task;

  AssesmentTaskNavigatorView(@required Task task){
    this.task = task;
  }

  @override
  _AssesmentTaskNavigatorViewState createState() => _AssesmentTaskNavigatorViewState();
}

class _AssesmentTaskNavigatorViewState extends State<AssesmentTaskNavigatorView> {

  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLastQuestion = false;

  StartAssesmentResponse _startAssesmentResponse;
  Assessmment assessmment;
  ProgressDialog progressDialog;
  var dateFormat = DateFormat("yyyy-MM-dd");
  var timeFormat = DateFormat("HH:mm:ss");

  @override
  void initState() {

    progressDialog  = new ProgressDialog(context);
    startAssesmentResponse();
    debugPrint(widget.task.details.carePlanId.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog  = new ProgressDialog(context);
    // TODO: implement build
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
              'Assessment',
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
          //body: Center(child: Container(height: 40, width: 40, child: CircularProgressIndicator(),),),
        ),
      )
    );
  }

  startAssesmentResponse() async {
    try {
      debugPrint('Assesment 1');
      progressDialog.show();
      var map = new Map<String, String>();

      _startAssesmentResponse = await model.startAssesmentResponse(widget.task.details.carePlanId.toString(),
          widget.task.details.id);

      if (_startAssesmentResponse.status == 'success') {
        progressDialog.hide();
        navigateScreen(_startAssesmentResponse.data.assessmment);
        debugPrint("AHA Assesment Care Plan Task ==> ${_startAssesmentResponse.toJson()}");
        this.assessmment = _startAssesmentResponse.data.assessmment;
      } else {
        Navigator.pop(context);
        progressDialog.hide();
        showToast(_startAssesmentResponse.message);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint(e.toString());
    }
  }

  navigateScreen(Assessmment assessmment){
    progressDialog.hide();
    if(assessmment.isBiometric){
      //showToast('Biometric Task');
      assignmentTask(assessmment);
    }else {
      switch (assessmment.question.questionType) {
        case "menuQuestion":
          menuQuestion(assessmment);
          break;
        case "yesNoQuestion":
          yesNoQuestion(assessmment);
          break;
        case "okStatement":
          showMaterialModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (context) => _positiveFeedBack(assessmment));
          break;
        case "statement":
          showMaterialModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (context) => _positiveFeedBack(assessmment));
          break;
      }
    }
  }

  void assignmentTask(Assessmment assessmment) async {
    var id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => BiomatricAssignmentTask(assessmment)),
    );
    if(id == null){
      Navigator.pop(context);
      showToast("Please complete assessment from start");
    }else {
      assesmentNextQuestion(id, assessmment);
    }
  }

  void menuQuestion(Assessmment assessmment) async {
    var id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => AssessmentQuestionCarePlanView(assessmment)),
    );
    debugPrint("Question Index ==> ${id}");
    /*if(this.assessmment.question.isLastQuestion){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return HomeView( 1 );
          }), (Route<dynamic> route) => false);
    }else {*/
      if(id == null){
        Navigator.pop(context);
        showToast("Please complete assessment from start");
      }else {
        nextQuestion(id);
      }
    //}
  }

  void yesNoQuestion(Assessmment assessmment) async {
    var id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => AssessmentStartCarePlanView(assessmment)),
    );
    debugPrint("Question Index ==> ${id}");
    /*if(this.assessmment.question.isLastQuestion){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return HomeView( 1 );
          }), (Route<dynamic> route) => false);
    }else {*/
    if(id == null){
      Navigator.pop(context);
      showToast("Please complete assessment from start");
    }else {
      nextQuestion(id);
    }
    //}
  }

  assesmentNextQuestion(var value, Assessmment assessmment) async {
    try {
      progressDialog  = new ProgressDialog(context);
      progressDialog.show();
      var map = new Map<String, dynamic>();
      map['BiometricValue'] = value;
      map['MeasuredOn'] = dateFormat.format(new DateTime.now().toUtc())+'T'+timeFormat.format(new DateTime.now().toUtc())+'.000Z';


      AnswerAssesmentResponse _answerAssesmentResponse  = await model.addBiometricAssignmentTask(startCarePlanResponseGlob.data.carePlan.id.toString(), assessmment.taskId, assessmment.qnAId, map);

      if (_answerAssesmentResponse.status == 'success') {
        progressDialog.hide();
        if(isLastQuestion) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView( 1 );
              }), (Route<dynamic> route) => false);
          debugPrint('Last Question');
        }else{
          progressDialog.hide();
          navigateScreen(_answerAssesmentResponse.data.assessmment);
          debugPrint('No Question');
        }
        if(_answerAssesmentResponse.data.assessmment.question != null) {
          isLastQuestion =
              _answerAssesmentResponse.data.assessmment.question.isLastQuestion;
        }

        debugPrint("AHA Start Care Plan ==> ${_answerAssesmentResponse.toJson()}");
        assessmment = _answerAssesmentResponse.data.assessmment;
      } else {
        progressDialog.hide();
        showToast(_answerAssesmentResponse.message);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  nextQuestion(int index) async {
    try {
      progressDialog  = new ProgressDialog(context);
      progressDialog.show();
      var map = new Map<String, dynamic>();
      var answerIndices = new List<int>();
      answerIndices.add(index);
      map['AnswerIndices'] = answerIndices;
      map['AnswerText'] = "";

      AnswerAssesmentResponse _answerAssesmentResponse  = await model.answerAssesmentResponse(widget.task.details.carePlanId.toString(),
          widget.task.details.id, assessmment.qnAId, map);

      if (_answerAssesmentResponse.status == 'success') {
          progressDialog.hide();
          if(isLastQuestion) {
            completeMessageTaskOfAHACarePlan(widget.task);
            /*Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView( 1 );
              }), (Route<dynamic> route) => false);*/
          debugPrint('Last Question');
        }else{
            progressDialog.hide();
          navigateScreen(_answerAssesmentResponse.data.assessmment);
          debugPrint('No Question');
        }
        isLastQuestion = _answerAssesmentResponse.data.assessmment.question.isLastQuestion;

        debugPrint("AHA Start Care Plan ==> ${_answerAssesmentResponse.toJson()}");
        assessmment = _answerAssesmentResponse.data.assessmment;
      } else {
        progressDialog.hide();
        showToast(_answerAssesmentResponse.message);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      progressDialog.show();
      StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse = await model.stopTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        progressDialog.hide();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HomeView( 1 );
            }), (Route<dynamic> route) => false);
        debugPrint("AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}");
      } else {
        progressDialog.hide();
        showToast(_startTaskOfAHACarePlanResponse.message);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }

  Widget _positiveFeedBack(Assessmment assessmment){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: colorF6F6FF,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16,),
            Icon(FontAwesomeIcons.solidThumbsUp, size: 64, color: Colors.green,),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                assessmment.question.questionText,
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: (){
                  if(assessmment.question.questionType == "statement"){
                    completeMessageTaskOfAHACarePlan(widget.task);
                    /*Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 1 );
                        }), (Route<dynamic> route) => false);*/
                  }else {
                    Navigator.pop(context);
                    nextQuestion(0);
                  }
                  //Navigator.pushNamed(context, RoutePaths.Assessment_Final_Care_Plan);
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
                        "Ok",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}