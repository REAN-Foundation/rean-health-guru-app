import 'package:flutter/material.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'addNewGoals/select_goal_set_care_plan_goals.dart';

// ignore: must_be_immutable
class StatusPastCheckTask extends StatefulWidget {
  Task task;

  StatusPastCheckTask(Task task) {
    this.task = task;
  }

  @override
  _statusPastCheckTaskViewState createState() =>
      _statusPastCheckTaskViewState();
}

class _statusPastCheckTaskViewState extends State<StatusPastCheckTask> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CheckBoxModel> statusList = <CheckBoxModel>[];

  ProgressDialog progressDialog;

  var questionTextControler = TextEditingController();

  @override
  void initState() {
    statusList.add(CheckBoxModel(
        'Have you seen your physician for a scheduled visit ?', false));
    statusList.add(CheckBoxModel(
        'Have you seen your physician for a unscheduled visit ?', false));
    statusList.add(CheckBoxModel('Had a change in your medications ?', false));
    statusList.add(CheckBoxModel('Had a new or worsening symptom ?', false));
    statusList
        .add(CheckBoxModel('Had you been given a new diagnosis ?', false));
    statusList
        .add(CheckBoxModel('Required emergency medical attention ?', false));
    statusList.add(CheckBoxModel(
        'Required hospitalization for heart related reason ?', false));
    statusList
        .add(CheckBoxModel('Had a heart related surgicalprocedure ?', false));
    super.initState();
  }

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
              'Care Plan Status',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
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
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  questionText(),
                  Container(
                    height: MediaQuery.of(context).size.height - 360,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: statusList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                              value: statusList[index].isCheck,
                              title: Text(statusList[index].title),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool val) {
                                itemChange(val, index);
                              });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _makeQuestion6(),
                  ),
                  submitButton(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      statusList[index].isCheck = val;
    });
  }

  Widget submitButton() {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Semantics(
            label: 'update weekly reflection plan',
            child: InkWell(
              onTap: () {
                updateWeeklyReflection();
              },
              child: Container(
                height: 40,
                width: 160,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: primaryColor, width: 1),
                  color: Colors.deepPurple,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Done',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _makeQuestion6() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Additional details',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Semantics(
            label: 'according to question add comments',
            enabled: true,
            child: Container(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    obscureText: false,
                    controller: questionTextControler,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    onFieldSubmitted: (term) {},
                    decoration: InputDecoration(
                        hintText: 'Add your comments here...',
                        hintMaxLines: 4,
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionText() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'In the past 4 weeks',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  updateWeeklyReflection() async {
    try {
      progressDialog.show();
      final map = <String, dynamic>{};
      map['ScheduledVisitToDoctor'] = statusList.elementAt(0).isCheck;
      map['UnscheduledVisitToDoctor'] = statusList.elementAt(1).isCheck;
      map['ChangeInMedications'] = statusList.elementAt(2).isCheck;
      map['NewOrWorseningSymptom'] = statusList.elementAt(3).isCheck;
      map['NewDiagnosis'] = statusList.elementAt(4).isCheck;
      map['RequiredHospitalization'] = statusList.elementAt(5).isCheck;
      map['ReadyToProceedFurther'] = statusList.elementAt(6).isCheck;
      map['HeartRelatedSurgicalProcedure'] = statusList.elementAt(7).isCheck;
      map['AdditionalDetails'] = questionTextControler.text;

      final BaseResponse baseResponse = await model.updateWeeklyReflection(
          startCarePlanResponseGlob.data.carePlan.id.toString(),
          widget.task.details.id,
          map);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pop(context);
      } else {
        showToast(baseResponse.message, context);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
