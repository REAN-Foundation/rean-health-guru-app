
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/answer_assessment_response.dart';
import 'package:patient/features/common/careplan/models/assesment_response.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/models/start_assessment_response.dart';
import 'package:patient/features/common/careplan/models/start_task_of_aha_careplan_response.dart';
import 'package:patient/features/common/careplan/ui/add_medication_task_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_multi_choice_question.dart';
import 'package:patient/features/common/careplan/ui/assessment_question_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_start_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/biometric_blood_pressure_task.dart';
import 'package:patient/features/common/careplan/ui/text_task_careplan.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'assessment_node_list_question.dart';

//ignore: must_be_immutable
class AssesmentTaskNavigatorView extends StatefulWidget {
  UserTask? task;

  AssesmentTaskNavigatorView(this.task);

  @override
  _AssesmentTaskNavigatorViewState createState() =>
      _AssesmentTaskNavigatorViewState();
}

class _AssesmentTaskNavigatorViewState
    extends State<AssesmentTaskNavigatorView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? isLastQuestion = false;

  late AssesmentResponse _startAssesmentResponse;
  Next? assessmment;
  late ProgressDialog progressDialog;
  var dateFormat = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('HH:mm:ss');

  @override
  void initState() {
    debugPrint("Assessment ==> 2");
    debugPrint('Assessment Name ==> ${widget.task!.action!.assessment!.title}');
    //progressDialog = ProgressDialog(context: context);
    startAssesmentResponse();
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
                    elevation: 0,
                    backgroundColor: primaryColor,
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                    title: Text(
                      'Assessment',
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
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: primaryColor,
                            height: 0,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      topLeft: Radius.circular(12))),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ));
  }

  startAssesmentResponse() async {
    try {
      debugPrint('Assesment 1');
      //progressDialog.show(max: 100, msg: 'Loading...');

      _startAssesmentResponse = await model.startAssesmentResponse(
          widget.task!.action!.assessment!.id.toString());

      if (_startAssesmentResponse.status == 'success') {
        //progressDialog.close();
        navigateScreen(_startAssesmentResponse.data!.next!);
        debugPrint(
            'AHA Assesment Care Plan Task ==> ${_startAssesmentResponse.toJson()}');
        assessmment = _startAssesmentResponse.data!.next;
      } else {
        debugPrint('Assesment Failure ==> ${_startAssesmentResponse.message}');
        if (_startAssesmentResponse.message.toString() ==
            "Assessment is already in progress.") {
          getNextQuestionAssesmentResponse();
        } else {
          Navigator.pop(context);
          progressDialog.close();
          showToast(_startAssesmentResponse.message!, context);
        }
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
    }
  }

  getNextQuestionAssesmentResponse() async {
    try {
      debugPrint('Assesment 2');
      //progressDialog.show(max: 100, msg: 'Loading...');

      AssesmentResponse response = await model.getNextQuestiontResponse(
          widget.task!.action!.assessment!.id.toString());

      if (response.status == 'success') {
        debugPrint("Inside Success");
        //progressDialog.close();
        navigateScreen(response.data!.next!);
        debugPrint('AHA Assesment Care Plan Task ==> ${response.toJson()}');
        assessmment = response.data!.next;
      } else {
        Navigator.pop(context);
        progressDialog.close();
        showToast(response.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
    }
  }

  navigateScreen(Next questionType) {
    progressDialog.close();
    if (questionType.title!
        .contains('What medications are you currently taking?')) {
      textMedicationQuestion(questionType);
    } else if (questionType.nodeType == 'Node list') {
      nodeListTask(questionType);
    } else if (questionType.expectedResponseType! == 'Biometrics') {
      if(questionType.title!.contains('Please provide your systolic blood pressure (SBP) and diastolic blood pressure (DBP).') ){
        biometricBPQuestion(questionType);
      }
      //showToast('Biometric Task');
      //assignmentTask(assessmment);
    } else if (questionType.expectedResponseType! == 'Text') {
      //showToast('Biometric Task');
      textQuestion(questionType);
    } else if (questionType.expectedResponseType! ==
        'Single Choice Selection') {
      //showToast('Biometric Task');
      menuQuestion(questionType);
    } else if (questionType.expectedResponseType! == 'Multi Choice Selection') {
      //showToast('Biometric Task');
      multiChoiseQuestion(questionType);
    } else if (questionType.expectedResponseType! == 'Boolean') {
      //showToast('Biometric Task');
      yesNoQuestion(questionType);
    } else if (questionType.expectedResponseType! == 'Ok') {
      //showToast('Biometric Task');
      showOkDialog(questionType);
    } else {
      Navigator.pop(context);
      showToast('Opps something went wrong!', context);
    }
  }

  oldCode() {
    /* switch ('Test') {
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
    }*/
  }

  nodeListTask(Next assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AssessmentNodeListQuestionView(assessmment)),
    );

    debugPrint('Hello ==> $id');
    if (id != null) {
      var nodeAnswer = <int>[];

      nodeAnswer.addAll(id);

      bool vaildation = false;

      for (int i = 0; i < assessmment.childrenQuestions!.length; i++) {
        if (nodeAnswer[i] == 0) {
          vaildation = true;
        }
      }

      if (vaildation) {
        Navigator.pop(context);
        showToast('Complete the assessment where you left off', context);
      } else {
        nextQuestionIfListNodeAnswer(nodeAnswer);
      }
    } else {
      Navigator.pop(context);
      showToast('Complete the assessment where you left off', context);
    }
  }

  menuQuestion(Next assessmment) async {
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  multiChoiseQuestion(Next assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AssessmentMultiChoiceQuestionView(assessmment)),
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
  }

  textMedicationQuestion(Next assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddMedicationTaskView(assessmment)),
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  textQuestion(Next assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => TextTaskView(assessmment)),
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  biometricBPQuestion(Next assessmment) async {
    final id = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => BiomatricBloodPressureTask(assessmment)),
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  yesNoQuestion(Next assessmment) async {
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
      showToast('Complete the assessment where you left off', context);
    } else {
      nextQuestion(id);
    }
    //}
  }

  assesmentNextQuestion(var value, Assessmment assessmment) async {
    try {
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
          //navigateScreen(_answerAssesmentResponse.data!.assessmment!);
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

  nextQuestion(var index) async {
    try {
      final map = <String, dynamic>{};
      map['ResponseType'] = assessmment!.expectedResponseType;
      if(assessmment!.expectedResponseType == "Biometrics"){
        var answer = <String, dynamic>{};
        answer["BiometricsType"] = "Blood Pressure";
        answer["ProviderCode"] = "Blood Pressure";
        answer["Value"] = index;
        map["Answer"] = answer;
      }else {
        map['Answer'] = index;
      }
      final AssesmentResponse _answerAssesmentResponse =
          await model.answerAssesmentResponse(
              widget.task!.action!.assessment!.id.toString(),
              assessmment!.id.toString(),
              map);

      if (_answerAssesmentResponse.status == 'success') {
        if (_answerAssesmentResponse.message ==
            'Assessment has completed successfully!') {
          //showToast(_answerAssesmentResponse.message.toString(), context);
          /*if(widget.task!.action!.assessment!.title == 'Quality of Life Questionnaire'){
            Navigator.popAndPushNamed(context, RoutePaths.Assessment_Score_Navigator,
                arguments: widget.task!.action!.assessment!.id);
          }else {*/
            showSuccessDialog();
          //}

        } else if(_answerAssesmentResponse.data!.answerResponse!.messageBeforeNext != null){
          messageBeforeNextDialog(_answerAssesmentResponse.data!.answerResponse!.messageBeforeNext.toString());
        }else {

          getNextQuestionAssesmentResponse();
          debugPrint(
              'AHA Assesment Care Plan Task ==> ${_answerAssesmentResponse.toJson()}');
        }
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

  messageBeforeNextDialog(String message) {


    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        width: MediaQuery.of(context).size.width - 64,
        child: _messageBeforeNext(message),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);
  }

  Widget _messageBeforeNext(String message) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)),
              color: colorF6F6FF,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Message",
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                getNextQuestionAssesmentResponse();
                Navigator.pop(context);
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
                      'Okay',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  nextQuestionIfListNodeAnswer(List<int> index) async {
    try {
      var answer = <ListNodeAnswer>[];
      for (int i = 0; i < assessmment!.childrenQuestions!.length; i++) {
        answer.add(ListNodeAnswer(
            assessmment!.childrenQuestions![i].id.toString(),
            assessmment!.childrenQuestions![i].expectedResponseType.toString(),
            index[i]));
      }

      final map = <String, dynamic>{};
      map['Answers'] = answer;

      final AssesmentResponse _answerAssesmentResponse =
          await model.listNodeAnswerAssesmentResponse(
              assessmment!.assessmentId.toString(),
              assessmment!.id.toString(),
              map);

      if (_answerAssesmentResponse.status == 'success') {
        if (_answerAssesmentResponse.message ==
            'Assessment has completed successfully!') {
          //showToast(_answerAssesmentResponse.message.toString(), context);
            showSuccessDialog();
        } else {
          getNextQuestionAssesmentResponse();
          debugPrint(
              'AHA Assesment Care Plan Task ==> ${_answerAssesmentResponse.toJson()}');
        }
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

  completeMessageTaskOfAHACarePlan(UserTask task) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.stopTaskOfAHACarePlan(
              carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                  .elementAt(0)
                  .enrollmentId
                  .toString(),
              task.action!.userTaskId!);

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

  Widget _positiveFeedBack(Next question) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: colorF6F6FF,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      question.nodeType.toString(),
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
                question.title.toString(),
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
                  nextQuestion('Ok');
                  Navigator.pop(context);
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

  showOkDialog(Next question) {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 300.0,
        width: MediaQuery.of(context).size.width - 64,
        child: _positiveFeedBack(question),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);
  }

  showSuccessDialog() {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Card(
        elevation: 0.0,
        semanticContainer: false,
        child: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ExcludeSemantics(
                child: Semantics(
                  label: 'Success image',
                  image: true,
                  child: Image.asset(
                    'res/images/ic_careplan_success_tumbs_up.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              Text(
                'Thank You!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'You have successfully completed your assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              InkWell(
                onTap: () {
                  if(widget.task!.action!.assessment!.title == 'Quality of Life Questionnaire'){
                      Navigator.popAndPushNamed(context, RoutePaths.Assessment_Score_Navigator,
                      arguments: widget.task!.action!.assessment!.id);
                  }else {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                   /* Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView(1);
                        }), (Route<dynamic> route) => false);*/
                  }
                },
                child: Container(
                  height: 48,
                  width: 260,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: primaryColor),
                  child: Center(
                    child: Text(
                      widget.task!.action!.assessment!.title == 'Quality of Life Questionnaire' ? 'Show my score' :'Go to my tasks',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);
  }
}
