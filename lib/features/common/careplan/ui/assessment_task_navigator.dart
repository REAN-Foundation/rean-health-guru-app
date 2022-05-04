import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/features/common/careplan/models/answer_assessment_response.dart';
import 'package:patient/features/common/careplan/models/get_task_of_aha_careplan_response.dart';
import 'package:patient/features/common/careplan/models/start_assessment_response.dart';
import 'package:patient/features/common/careplan/models/start_task_of_aha_careplan_response.dart';
import 'package:patient/features/common/careplan/ui/assessment_question_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_start_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/biometric_assignment_task.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class AssesmentTaskNavigatorView extends StatefulWidget {
  /* StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse;

  AssesmentTaskNavigatorView(StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponseC){
    this._startTaskOfAHACarePlanResponse = _startTaskOfAHACarePlanResponseC;
  }*/

  Task? task;

  AssesmentTaskNavigatorView(task) {
    this.task = task;
  }

  @override
  _AssesmentTaskNavigatorViewState createState() =>
      _AssesmentTaskNavigatorViewState();
}

class _AssesmentTaskNavigatorViewState
    extends State<AssesmentTaskNavigatorView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? isLastQuestion = false;

  late StartAssesmentResponse _startAssesmentResponse;
  Assessmment? assessmment;
  late ProgressDialog progressDialog;
  var dateFormat = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('HH:mm:ss');

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    startAssesmentResponse();
    debugPrint(widget.task!.details!.carePlanId.toString());
    super.initState();
  }

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
                    'Assessment',
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
                //body: Center(child: Container(height: 40, width: 40, child: CircularProgressIndicator(),),),
              ),
            ));
  }

  startAssesmentResponse() async {
    try {
      debugPrint('Assesment 1');
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');

      _startAssesmentResponse = await model.startAssesmentResponse(
          widget.task!.details!.carePlanId.toString(),
          widget.task!.details!.id!);

      if (_startAssesmentResponse.status == 'success') {
        progressDialog.close();
        navigateScreen(_startAssesmentResponse.data!.assessmment!);
        debugPrint(
            'AHA Assesment Care Plan Task ==> ${_startAssesmentResponse.toJson()}');
        assessmment = _startAssesmentResponse.data!.assessmment;
      } else {
        Navigator.pop(context);
        progressDialog.close();
        showToast(_startAssesmentResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
    }
  }

  navigateScreen(Assessmment assessmment) {
    progressDialog.close();
    if (assessmment.isBiometric!) {
      //showToast('Biometric Task');
      assignmentTask(assessmment);
    } else {
      switch (assessmment.question!.questionType) {
        case 'menuQuestion':
          menuQuestion(assessmment);
          break;
        case 'yesNoQuestion':
          yesNoQuestion(assessmment);
          break;
        case 'okStatement':
          showMaterialModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (context) => _positiveFeedBack(assessmment));
          break;
        case 'statement':
          showMaterialModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: (context) => _positiveFeedBack(assessmment));
          break;
      }
    }
  }

  assignmentTask(Assessmment assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => BiomatricAssignmentTask(assessmment)),
    );
    if (id == null) {
      Navigator.pop(context);
      showToast('Please complete assessment from start', context);
    } else {
      assesmentNextQuestion(id, assessmment);
    }
  }

  menuQuestion(Assessmment assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AssessmentQuestionCarePlanView(assessmment)),
    );
    debugPrint('Question Index ==> $id');
    /*if(this.assessmment.question.isLastQuestion){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return HomeView( 1 );
          }), (Route<dynamic> route) => false);
    }else {*/
    if (id == null) {
      Navigator.pop(context);
      showToast('Please complete assessment from start', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  yesNoQuestion(Assessmment assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AssessmentStartCarePlanView(assessmment)),
    );
    debugPrint('Question Index ==> $id');
    /*if(this.assessmment.question.isLastQuestion){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return HomeView( 1 );
          }), (Route<dynamic> route) => false);
    }else {*/
    if (id == null) {
      Navigator.pop(context);
      showToast('Please complete assessment from start', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  assesmentNextQuestion(var value, Assessmment assessmment) async {
    try {
      progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['BiometricValue'] = value;
      map['MeasuredOn'] = dateFormat.format(DateTime.now().toUtc()) +
          'T' +
          timeFormat.format(DateTime.now().toUtc()) +
          '.000Z';

      final AnswerAssesmentResponse _answerAssesmentResponse =
          await model.addBiometricAssignmentTask(
              carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                  .elementAt(0)
                  .enrollmentId
                  .toString(),
              assessmment.taskId!,
              assessmment.qnAId!,
              map);

      if (_answerAssesmentResponse.status == 'success') {
        progressDialog.close();
        if (isLastQuestion!) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeView(1);
          }), (Route<dynamic> route) => false);
          debugPrint('Last Question');
        } else {
          progressDialog.close();
          navigateScreen(_answerAssesmentResponse.data!.assessmment!);
          debugPrint('No Question');
        }
        if (_answerAssesmentResponse.data!.assessmment!.question != null) {
          isLastQuestion = _answerAssesmentResponse
              .data!.assessmment!.question!.isLastQuestion;
        }

        debugPrint(
            'AHA Start Care Plan ==> ${_answerAssesmentResponse.toJson()}');
        assessmment = _answerAssesmentResponse.data!.assessmment!;
      } else {
        progressDialog.close();
        showToast(_answerAssesmentResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  nextQuestion(int index) async {
    try {
      progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      final answerIndices = <int>[];
      answerIndices.add(index);
      map['AnswerIndices'] = answerIndices;
      map['AnswerText'] = '';

      final AnswerAssesmentResponse _answerAssesmentResponse =
          await model.answerAssesmentResponse(
              widget.task!.details!.carePlanId.toString(),
              widget.task!.details!.id!,
              assessmment!.qnAId!,
              map);

      if (_answerAssesmentResponse.status == 'success') {
        progressDialog.close();
        if (isLastQuestion!) {
          completeMessageTaskOfAHACarePlan(widget.task!);
          /*Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView( 1 );
              }), (Route<dynamic> route) => false);*/
          debugPrint('Last Question');
        } else {
          progressDialog.close();
          navigateScreen(_answerAssesmentResponse.data!.assessmment!);
          debugPrint('No Question');
        }
        isLastQuestion = _answerAssesmentResponse
            .data!.assessmment!.question!.isLastQuestion;

        debugPrint(
            'AHA Start Care Plan ==> ${_answerAssesmentResponse.toJson()}');
        assessmment = _answerAssesmentResponse.data!.assessmment;
      } else {
        progressDialog.close();
        showToast(_answerAssesmentResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.stopTaskOfAHACarePlan(
              carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                  .elementAt(0)
                  .enrollmentId
                  .toString(),
              task.details!.id!);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        progressDialog.close();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        progressDialog.close();
        showToast(_startTaskOfAHACarePlanResponse.message!, context);
      }
    } catch (CustomException) {
      progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  Widget _positiveFeedBack(Assessmment assessmment) {
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
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Icon(
              FontAwesomeIcons.solidThumbsUp,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                assessmment.question!.questionText!,
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  if (assessmment.question!.questionType == 'statement') {
                    completeMessageTaskOfAHACarePlan(widget.task!);
                    /*Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 1 );
                        }), (Route<dynamic> route) => false);*/
                  } else {
                    Navigator.pop(context);
                    nextQuestion(0);
                  }
                  //Navigator.pushNamed(context, RoutePaths.Assessment_Final_Care_Plan);
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
                        'Ok',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
