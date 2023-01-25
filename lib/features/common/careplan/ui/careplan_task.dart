
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/models/start_task_of_aha_careplan_response.dart';
import 'package:patient/features/common/careplan/models/user_task_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/pdf_viewer.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class CarePlanTasksView extends StatefulWidget {
  @override
  _CarePlanTasksViewState createState() => _CarePlanTasksViewState();
}

class _CarePlanTasksViewState extends State<CarePlanTasksView>
    with WidgetsBindingObserver {
  var model = PatientCarePlanViewModel();
  var dateFormat = DateFormat('MMM dd, hh:mm a');
  var dateFormatOnlyDate = DateFormat('MMM dd');
  var dateQueryFormat = DateFormat('yyyy-MM-dd');
  late UserTaskResponse userTaskResponse;
  List<Items> tasksList = <Items>[];
  bool isSubscribe = false;
  late ProgressDialog progressDialog;
  bool isUpCommingSelected = true;
  String query = 'pending';
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);

  getEducationUserTask() async {
    try {
      var dateTill = DateTime.now();
      //_carePlanTaskResponse = await model.getTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), query);
      userTaskResponse = await model.getUserTasks(
          query,
          carePlanEnrollmentForPatientGlobe != null
              ? dateQueryFormat.format(DateTime.parse(
                  carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                      .elementAt(0)
                      .startAt
                      .toString()))
              : dateQueryFormat.format(dateTill.subtract(Duration(days: 0))),
          dateQueryFormat.format(dateTill.subtract(Duration(days: 1))) +
              '&category=Educational');

      if (userTaskResponse.status == 'success') {
        tasksList.clear();
        //tasksList.addAll(userTaskResponse.data.userTasks.items);
        if (userTaskResponse.data!.userTasks!.items!.isEmpty) {
          getAllUserTask();
        } else {
          _sortUserTask(
              userTaskResponse.data!.userTasks!.items!, 'Educational');
        }

       /* debugPrint('User Educational Tasks ==> ${userTaskResponse.toJson()}');
        debugPrint(
            'User Tasks Educational Count ==> ${userTaskResponse.data!.userTasks!.items!.length}');*/
      } else {
        tasksList.clear();
        showToast(userTaskResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      tasksList.clear();
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  getAllUserTask() async {
    try {
      var dateTill;
      var dateFrom;
      /*if (getBaseUrl()!.contains('aha-api-uat.services') ||
          getAppName() == 'Heart & Stroke Helper™ ') {
        dateTill = DateTime.now();
      } else {*/
      /*if(getBaseUrl()!.contains('reancare-api-dev')){
        dateTill = DateTime.now().add(Duration(days: 91));
      }else{*/
        dateTill = DateTime.now().add(Duration(days: RemoteConfigValues.carePlanTaskDurationInDays));
      //}

      if(carePlanEnrollmentForPatientGlobe != null){
        DateTime startDate = DateTime.parse(
            carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                .elementAt(0)
                .startAt
                .toString());
        if(startDate.isAfter(DateTime.now())){
          dateFrom = dateQueryFormat.format(DateTime.now());
        }else {
          dateFrom = dateQueryFormat.format(startDate);
        }
      }else{
        dateFrom = dateQueryFormat.format(DateTime.now());
      }

      //}
      //_carePlanTaskResponse = await model.getTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), query);
      userTaskResponse = await model.getUserTasks(
          query, dateFrom,
          carePlanEnrollmentForPatientGlobe != null
              ? dateQueryFormat.format(dateTill)
              : dateQueryFormat.format(DateTime.now()));

      if (userTaskResponse.status == 'success') {
        tasksList.clear();
        //tasksList.addAll(userTaskResponse.data.userTasks.items);
        _sortUserTask(userTaskResponse.data!.userTasks!.items!, 'allTask');
        /* debugPrint('User Tasks ==> ${userTaskResponse.toJson()}');
        debugPrint(
            'User Tasks Count ==> ${userTaskResponse.data!.userTasks!.items!.length}');
        debugPrint(
            'User Tasks Action ==> ${userTaskResponse.data!.userTasks!.items!.elementAt(1).action!.patientUserId}');*/
      } else {
        tasksList.clear();
        showToast(userTaskResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      tasksList.clear();
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (Exception e) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }*/
  }

  getUserTask() async {
    /*if (getBaseUrl()!.contains('aha-api-uat.services') ||
        getAppName() == 'Heart & Stroke Helper™ ') {
      getEducationUserTask();
    } else {*/
    getAllUserTask();
    //}
  }

  _sortUserTask(List<Items> tasks, String fromMethod) {
    for (final task in tasks) {
      if (query == 'pending') {
        if (task.status == 'Delayed' ||
            task.status == 'InProgress' ||
            task.status == 'Pending' ||
            task.status == 'Upcoming' ||
            task.status == 'Overdue') {
          tasksList.add(task);
        }
      } else {
        if (task.status == 'Completed' || task.status == 'Cancelled') {
          tasksList.add(task);
        }
      }
    }

    if (fromMethod == 'Educational' && tasksList.length == 1) {
      getAllUserTask();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        triggerApiCall();
        // ...your code goes here...
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    progressDialog = ProgressDialog(context: context);
    //debugPrint("startCarePlanResponseGlob ==> ${startCarePlanResponseGlob}");
    triggerApiCall();
    super.initState();
  }

  triggerApiCall() {
    /*if(startCarePlanResponseGlob == null){
      //debugPrint("Null");
      isSubscribe = false;
    }else {
      isSubscribe = true;*/
    getUserTask();

    //}
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'My Tasks ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    /*Semantics(
                      label: 'taskCount',
                      child: Text(
                        tasksList.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),*/
                  ],
                ),
              ),
              Container(
                color: colorF6F6FF,
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        label: 'To Do 1 of 2',
                        child: InkWell(
                          onTap: () {
                            query = 'pending';
                            getUserTask();
                            isUpCommingSelected = true;
                          },
                          child: ExcludeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "To Do",
                                  style: TextStyle(
                                      color: isUpCommingSelected
                                          ? primaryColor
                                          : textBlack,
                                      fontWeight: isUpCommingSelected
                                          ? FontWeight.w600
                                          : FontWeight.w300,
                                      fontSize: 16),
                                ),
                                isUpCommingSelected
                                    ? SizedBox(
                                  width: 40,
                                  child: Divider(
                                    thickness: 2,
                                    color: primaryColor,
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        label: 'Completed 2 of 2',
                        child: InkWell(
                          onTap: () {
                            query = 'completed';
                            getUserTask();
                            isUpCommingSelected = false;
                          },
                          child: ExcludeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      color: isUpCommingSelected
                                          ? textBlack
                                          : primaryColor,
                                      fontWeight: isUpCommingSelected
                                          ? FontWeight.w300
                                          : FontWeight.w600,
                                      fontSize: 16),
                                ),
                                isUpCommingSelected
                                    ? Container()
                                    : SizedBox(
                                  width: 40,
                                  child: Divider(
                                    thickness: 2,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: model!.busy
                          ? Center(child: CircularProgressIndicator())
                          : tasksList.isEmpty
                              ? noTaskFound()
                              : listWidget())),
            ],
          ),
        ),
      ),
    );
  }

//isSubscribe ?  model!.busy ? Center(child: CircularProgressIndicator(),) : tasks.length == 0 ? noTaskFound() : listWidget() : noDoctorFound(),
  Widget noTaskFound() {
    return Center(
      child: Text('No tasks for today',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget noDoctorFound() {
    return Center(
      child: Text('No AHA plan subscribe yet',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryLightColor)),
    );
  }

  Widget listWidget() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
          itemBuilder: (context, index) => _createToDos(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: tasksList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Widget _createToDos(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);
    debugPrint('Type ==> ${task.actionType}');
    return /*task.task == 'News feed'
        ? Container()
        : */
        task.actionType == 'Careplan'
            ? _makeTaskCard(context, index)
            : task.actionType == 'Medication'
                ? _makeMedicineCard(context, index)
                /*: task.categoryName == 'Appointment-task'
                ? _makeUpcommingAppointmentCard(context, index)*/
                : task.actionType == 'Custom'
                    ? _makeCustomTaskCard(context, index)
                    : Container();
  }

  /*Widget _makeTaskCard(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);
    debugPrint(
        'Category Name ==> ${task.action!.type} && Task Tittle ==> ${task.task}');
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: InkWell(
        onTap: () {
          debugPrint('Task Type ==> ${task.action!.type}');
          if (!task.finished) {
            debugPrint('Task ID ==> ${task.id}');
            getUserTaskDetails(task.action!.userTaskId.toString());
            //_taskNavigator(task);
            //showToast('Task completed already');
          } else {
            getUserTaskDetails(task.action!.userTaskId.toString());
            //startAHACarePlanSummary(task);
          }
        },
        child: MergeSemantics(
          child: Semantics(
            label: task.task,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: ExcludeSemantics(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  //ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                                  //SizedBox(width: 4,),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    child: Text(
                                        task.action!.type.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: ExcludeSemantics(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: colorD6D6D6,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: Divider(
                      color: colorD6D6D6,
                      thickness: 1.5,
                    ),
                  ),
                  ExcludeSemantics(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(task.task ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0,
                                          color: textBlack)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(task.description ?? '',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0XFF909CAC))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            dateFormat.format(DateTime.parse(
                                    task.scheduledStartTime.toString())
                                .toLocal()),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                color: textGrey)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (task.finished) ...[
                              Text("Completed",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xff000000),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  )),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.check_circle,
                                size: 24,
                                color: Colors.green,
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
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
  }*/

  Widget _makeTaskCard(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);

    /*  if(DateTime.parse(task.scheduledEndTime!).isBefore(DateTime.now())) {
      if (task.category!.contains('Educational') && !task.category!.contains('Educational-NewsFeed')) {
        debugPrint('Education task found Category ==> ${task.category}, Date ==> ${task.scheduledStartTime}');
        isPreviousEducationalTaskIsPending = true;
      }
    }*/

    debugPrint(
        'Category Name ==> ${task.action != null ? task.action!.type.toString() : task.category.toString()} && Task Tittle ==> ${task.task}');
    return Semantics(
      hint: task.finished
          ? task.action != null
              ? task.action!.type.toString() + ' task is already completed'
              : task.category.toString() + ' task is already completed'
          : task.action != null
              ? task.action!.type.toString() + ' task double click to activate'
              : task.category.toString() + ' task double click to activate',
      child: InkWell(
        onTap: () {
          debugPrint(
              'Task Type ==> ${task.action != null ? task.action!.type.toString() : task.category.toString()}');
          if (!task.finished) {
            debugPrint('Task ID ==> ${task.id}');
            /*if(DateTime.parse(task.scheduledStartTime!).isBefore(DateTime.now())) {
              getUserTaskDetails(task.id.toString());
            }else if(isPreviousEducationalTaskIsPending && !task.category!.contains('Educational')){
              showToast('Please complete educational task before starting new task', context);
            } else {*/
            getUserTaskDetails(task.id.toString());
            //}
            //_taskNavigator(task);
            //showToast('Task completed already');
          } else {
            getUserTaskDetails(task.id.toString());
            //startAHACarePlanSummary(task);
          }
        },
        child: Card(
          semanticContainer: false,
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: getAppType() == 'AHA'
                        ? Color(0XFFEBE0FF)
                        : primaryLightColor),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorF6F6FF,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              //ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                              //SizedBox(width: 4,),
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Text(
                                    task.action != null
                                        ? task.action!.type.toString()
                                        : task.category.toString(),
                                    semanticsLabel: task.action != null
                                        ? task.action!.type.toString()
                                        : task.category.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  dateFormatOnlyDate.format(DateTime.parse(
                                          task.scheduledStartTime.toString())
                                      .toLocal()),
                                  semanticsLabel: dateFormatOnlyDate.format(
                                      DateTime.parse(task.scheduledStartTime
                                              .toString())
                                          .toLocal()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor)),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(task.task ?? '',
                                  semanticsLabel: task.task ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200,
                                      color: textBlack)),
                              SizedBox(
                                height: 4,
                              ),
                              Text(task.description ?? '',
                                  semanticsLabel: task.description ?? '',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0XFF909CAC))),
                              task.task == 'Quality of Life Questionnaire' && task.finished ?
                              Semantics(
                                button: true,
                                child: Text('Show my score',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        shadows: [
                                          Shadow(
                                              color: Colors.blue,
                                              offset: Offset(0, -5))
                                        ],
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.transparent,
                                        decoration:
                                        TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                        decorationThickness: 1,)),
                              )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                task.finished
                                    ? Icons.check
                                    : Icons.chevron_right,
                                size: 32,
                                color:
                                    task.finished ? Colors.green : Colors.grey,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeMedicineCard(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);
    //debugPrint('Medication Pojo ${task.toJson().toString()}');
    /*if (task.scheduledStartTime == null) {
      return Container();
    }*/
    /* final DateTime startTime =
        DateTime.parse(task.scheduledStartTime).toLocal();
    debugPrint(
        'Medication Taken ==> ${task.status}  && Start Time ==> ${DateTime.now().isAfter(startTime)} ');*/
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: colorF6F6FF,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        ImageIcon(
                          AssetImage('res/images/ic_drug_purpul.png'),
                          size: 16,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Medication',
                            semanticsLabel: 'Medication',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryColor)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            dateFormat.format(
                                DateTime.parse(task.scheduledStartTime!)
                                    .toLocal()),
                            semanticsLabel: dateFormat.format(
                                DateTime.parse(task.scheduledStartTime!)
                                    .toLocal()),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryColor)),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(task.task!,
                                maxLines: 1,
                                semanticsLabel: task.task,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                    color: textBlack)),
                            SizedBox(
                              height: 4,
                            ),
                            if (task.status != 'Completed') ...[
                              Text(
                                  'Consume before : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.scheduledEndTime!)
                                              .toLocal()),
                                  semanticsLabel: 'Consume before : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.scheduledEndTime!)
                                              .toLocal()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0XFF909CAC))),
                            ],
                            if (task.status == 'Completed') ...[
                              Text(
                                  'Consumed at : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.finishedAt!)
                                              .toLocal()),
                                  semanticsLabel: 'Consumed at : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.finishedAt!)
                                              .toLocal()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0XFF909CAC))),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    if (!task.action!.isTaken! && !task.action!.isMissed!) ...[
                      Visibility(
                        visible:
                            !(DateTime.parse(task.action!.timeScheduleStart!)
                                    .toLocal())
                                .isAfter(DateTime.now()),
                        child: Expanded(
                          flex: 2,
                          child: Semantics(
                            button: true,
                            label: 'Mark as Taken',
                            child: InkWell(
                              onTap: () {
                                markMedicationsAsTaken(task.actionId!);
                              },
                              child: ExcludeSemantics(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(4)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Text(
                                        'Mark As\nTaken',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (task.action!.isTaken!) ...[
                      Expanded(
                        flex: 2,
                        child: Semantics(
                          label: 'Taken',
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(4)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.done,
                                  size: 32,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (task.action!.isMissed!) ...[
                      Expanded(
                        flex: 2,
                        child: Semantics(
                          label: 'Missed',
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(4)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.clear,
                                  size: 32,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                    /*Visibility(
                      visible: index != 0 ? true : false,
                      child: Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("Due in 13 hours",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeCustomTaskCard(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);
    return Semantics(
      hint: task.finished
          ? task.action != null
              ? task.action!.type.toString() + ' task is already completed'
              : task.category.toString() + ' task is already completed'
          : task.action != null
              ? task.action!.type.toString() + ' task double click to activate'
              : task.category.toString() + ' task double click to activate',
      child: InkWell(
        onTap: () {
          debugPrint('Task Type ==> ${task.category}');
          if (!task.finished) {
            debugPrint('Task ID ==> ${task.id}');
            getUserTaskDetails(task.id.toString());
            //_taskNavigator(task);
            //showToast('Task completed already');
          } else {
            getUserTaskDetails(task.id.toString());
            //startAHACarePlanSummary(task);
          }
        },
        child: Card(
          elevation: 0.0,
          semanticContainer: false,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: getAppType() == 'AHA'
                        ? Color(0XFFEBE0FF)
                        : primaryLightColor),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: colorF6F6FF,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              //ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                              //SizedBox(width: 4,),
                              Container(
                                width: MediaQuery.of(context).size.width - 200,
                                child: Text(task.category.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  dateFormatOnlyDate.format(DateTime.parse(
                                          task.scheduledStartTime.toString())
                                      .toLocal()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,)),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(task.task ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: textBlack)),
                                  task.task == 'Survey' || task.task == 'Patient Satisfaction Survey'
                                      ? IconButton(
                                          onPressed: () {
                                            showMaterialModalBottomSheet(
                                                isDismissible: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              25.0)),
                                                ),
                                                context: context,
                                                builder: (context) => _info(task.task.toString()));
                                          },
                                          icon: Icon(
                                            Icons.info_outline_rounded,
                                            color: primaryColor,
                                            size: 24,
                                            semanticLabel: 'Survey information',
                                          ))
                                      : Container(),
                                ],
                              ),
                              task.task == 'Quality of Life Questionnaire' && task.finished ?
                              Semantics(
                                button: true,
                                child: Text('Show my score',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: textBlack)),
                              )
                                  : Container(),
                              Text(task.description ?? '',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0XFF909CAC))),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                task.finished
                                    ? Icons.check
                                    : Icons.chevron_right,
                                size: 32,
                                color:
                                    task.finished ? Colors.green : Colors.grey,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*  Widget _makeMedicineCard(BuildContext context, int index) {
    final Items task = tasksList.elementAt(index);
    //debugPrint('Medication Pojo ${task.toJson().toString()}');
    */ /*if (task.scheduledStartTime == null) {
      return Container();
    }*/ /*
    */ /* final DateTime startTime =
        DateTime.parse(task.scheduledStartTime).toLocal();
    debugPrint(
        'Medication Taken ==> ${task.status}  && Start Time ==> ${DateTime.now().isAfter(startTime)} ');*/ /*
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 6.0, bottom: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        //ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                        //SizedBox(width: 4,),
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Text(task.category.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Montserrat",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: Divider(
                  color: colorD6D6D6,
                  thickness: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(task.task!,
                      maxLines: 1,
                      semanticsLabel: task.task,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0,
                          color: textBlack)),
                  SizedBox(
                    height: 4,
                  ),
                  if (task.status != 'Completed') ...[
                    Text(
                        'Consume before : ' +
                            dateFormat.format(
                                DateTime.parse(task.scheduledEndTime!)
                                    .toLocal()),
                        semanticsLabel: 'Consume before : ' +
                            dateFormat.format(
                                DateTime.parse(task.scheduledEndTime!)
                                    .toLocal()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0,
                            color: Color(0XFF909CAC))),
                  ],
                  if (task.status == 'Completed') ...[
                    Text(
                        'Consumed at : ' +
                            dateFormat.format(
                                DateTime.parse(task.finishedAt!).toLocal()),
                        semanticsLabel: 'Consumed at : ' +
                            dateFormat.format(
                                DateTime.parse(task.finishedAt!).toLocal()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0XFF909CAC))),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      dateFormat.format(
                          DateTime.parse(task.scheduledStartTime.toString())
                              .toLocal()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: textGrey)),
                  if (!task.action!.isTaken! && !task.action!.isMissed!) ...[
                    Visibility(
                      visible: !(DateTime.parse(task.action!.timeScheduleStart!)
                              .toLocal())
                          .isAfter(DateTime.now()),
                      child: Semantics(
                        button: true,
                        label: 'Mark as Taken',
                        child: InkWell(
                          onTap: () {
                            markMedicationsAsTaken(task.actionId!);
                          },
                          child: ExcludeSemantics(
                            child: Container(
                              width: 120,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Mark As Taken',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (task.action!.isTaken!) ...[
                    Semantics(
                      label: 'Taken',
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Taken',
                              style: TextStyle(
                                color: textBlack,
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 24,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (task.action!.isMissed!) ...[
                    Semantics(
                      label: 'Missed',
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Missed',
                              style: TextStyle(
                                color: textBlack,
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.cancel,
                              size: 24,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  getUserTaskDetails(String userTaskId) async {
    progressDialog.show(max: 100, msg: 'Loading...');
    try {
      GetUserTaskDetails response = await model.getUserTaskDetails(userTaskId);
      debugPrint('User Tasks Details ==> ${userTaskResponse.toJson()}');
      if (userTaskResponse.status == 'success') {
        if (response.data!.userTask!.actionType == 'Custom') {
          _customTaskNavigator(response.data!.userTask!);
        } else {
          _taskNavigator(response.data!.userTask!);
        }
        progressDialog.close();
      } else {
        tasksList.clear();
        progressDialog.close();
        showToast(userTaskResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      tasksList.clear();
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  /*Widget test(){
    return Column(
      children: [
        if (!task.action!.isTaken! && !task.action!.isMissed!) ...[
          Visibility(
            visible:
            !(DateTime.parse(task.action!.timeScheduleStart!)
                .toLocal())
                .isAfter(DateTime.now()),
            child: Expanded(
              flex: 2,
              child: Semantics(
                button: true,
                label: 'Mark as Taken',
                child: InkWell(
                  onTap: () {
                    markMedicationsAsTaken(task.actionId!);
                  },
                  child: ExcludeSemantics(
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            size: 24,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Text(
                            'Mark As\nTaken',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (task.action!.isTaken!) ...[
          Expanded(
            flex: 2,
            child: Semantics(
              label: 'Taken',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.done,
                      size: 32,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (task.action!.isMissed!) ...[
          Expanded(
            flex: 2,
            child: Semantics(
              label: 'Missed',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.clear,
                      size: 32,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }*/

  markMedicationsAsTaken(String consumptionId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      final BaseResponse baseResponse =
          await model.markMedicationsAsTaken(consumptionId);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        progressDialog.close();
        triggerApiCall();
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (CustomException) {
      progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

/*  Widget _makeUpcommingAppointmentCard(BuildContext context, int index) {
    final Task task = tasks.elementAt(index);
    return InkWell(
      onTap: () {},
      child: MergeSemantics(
        child: Semantics(
          label: task.details.mainTitle,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryLightColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(children: <Widget>[
                  Card(
                    elevation: 0,
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 60,
                                width: 60,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Text(task.details.businessNodeName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor)),
                                  ),
                                  Text(task.details.businessUserName,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0XFF909CAC))),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          dateFormat.format(task
                                              .scheduledStartTime
                                              .toLocal()),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600)),
                                      Text('ID: ' + task.displayId,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300,
                                              color: primaryColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                            'res/images/ic_appointment_confirmed.png')),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  startAHACarePlanSummary(Items task) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.startTaskOfAHACarePlan(
              carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                  .elementAt(0)
                  .enrollmentId
                  .toString(),
              task.id!);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        progressDialog.close();
        //debugPrint(_startTaskOfAHACarePlanResponse.data.task.details.carePlanId.toString());
        //_taskNavigator(task);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        progressDialog.close();
        showToast(_startTaskOfAHACarePlanResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    } catch (CustomException) {
      progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _customTaskNavigator(UserTask task) {
    progressDialog.close();
    setTask(task);
    if (task != null) {
      switch (task.task) {
        case 'Patient Satisfaction Survey':
        case 'Survey':
          _launchURL(task.action!.details!.link!.replaceAll(' ', '%20'))
              .then((value) {
            //getUserTask();
            //showToast('Task completed successfully');
          });
          //}
          if (!task.finished) {
            completeMessageTaskOfAHACarePlan(task.id.toString());
          }
          break;
      }
    }
  }

  _taskNavigator(UserTask task) {
    progressDialog.close();
    //setStartTaskOfAHACarePlanResponse(_startTaskOfAHACarePlanResponse);
    setTask(task);
    if (task != null) {
      debugPrint('Task Type ==> ${task.action!.type}');
      switch (task.action!.type) {
        case 'Message':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '1';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.task;
          newAssortedViewConfigs.task = task;

          Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'Professional':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '1';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.task;
          newAssortedViewConfigs.task = task;

          Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'ActionPlan':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '1';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.action!.type;
          newAssortedViewConfigs.task = task;

          Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'WordBank':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '1';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.action!.type;
          newAssortedViewConfigs.task = task;

          Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'Assessment':
          if (!task.finished) {
            debugPrint("Assessment 1");
            Navigator.pushNamed(context, RoutePaths.Assessment_Navigator,
                    arguments: task)
                .then((value) {
              getUserTask();
              //showToast('Task completed successfully', context);
            });
          } else {
            if(task.action!.assessment!.title == 'Quality of Life Questionnaire') {
              Navigator.pushNamed(
                  context, RoutePaths.Assessment_Score_Navigator,
                  arguments: task.action!.assessment!.id)
                  .then((value) {
                getUserTask();
                //showToast('Task completed successfully', context);
              });
            }else {
              showToast('Task is already completed', context);
            }
          }
          //Navigator.pushNamed(context, RoutePaths.Assessment_Start_Care_Plan);
          break;
        case 'Article':
        case 'Link':
          _launchURL(task.action!.url!.replaceAll(' ', '%20')).then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          if (!task.finished) {
            completeMessageTaskOfAHACarePlan(
                task.action!.userTaskId.toString());
          }
          break;
        case 'Biometrics':
          Navigator.pushNamed(context, RoutePaths.Biometric_Care_Plan_Line,
                  arguments: task)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'Challenge':
          if (!task.finished) {
            Navigator.pushNamed(context, RoutePaths.Challenge_Care_Plan,
                    arguments: task)
                .then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            showToast('Task is already completed', context);
          }
          break;
        case 'Goal':
          if (!task.finished) {
            Navigator.pushNamed(
                    context, RoutePaths.Set_Prority_For_Goals_Care_Plan)
                .then((value) {
              //getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            showToast('Task is already completed', context);
          }
          break;
        case 'Mindful Moment':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '2';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.task;
          newAssortedViewConfigs.task = task;
          Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'Word bank':
          assrotedUICount = 3;
          final AssortedViewConfigs newAssortedViewConfigs =
              AssortedViewConfigs();
          newAssortedViewConfigs.toShow = '2';
          newAssortedViewConfigs.testToshow = '2';
          newAssortedViewConfigs.isNextButtonVisible = false;
          newAssortedViewConfigs.header = task.task;
          newAssortedViewConfigs.task = task;
          Navigator.pushNamed(context, RoutePaths.Word_Of_The_Week_Care_Plan,
                  arguments: newAssortedViewConfigs)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          break;
        case 'Patient Weekly Relection':
          if (!task.finished) {
            Navigator.pushNamed(
                    context, RoutePaths.Self_Reflection_For_Goals_Care_Plan,
                    arguments: task)
                .then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            showToast('Task is already completed', context);
          }
          break;
        case 'Care Plan Status Check':
          if (!task.finished) {
            Navigator.pushNamed(context, RoutePaths.Care_Plan_Status_Check,
                    arguments: task)
                .then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            showToast('Task is already completed', context);
          }
          break;
        case 'Video':
          debugPrint('URL ==> ${task.action!.url!.replaceAll(' ', '%20')}');
          /*if(task.details.url.contains('youtube')){
        assrotedUICount = 3;
        AssortedViewConfigs newAssortedViewConfigs =  new AssortedViewConfigs();
        newAssortedViewConfigs.toShow = "0";
        newAssortedViewConfigs.testToshow = "2";
        newAssortedViewConfigs.isNextButtonVisible = false;
        newAssortedViewConfigs.header = task.details.mainTitle;
        newAssortedViewConfigs.task = task;
        Navigator.pushNamed(
            context, RoutePaths.Video_More_Care_Plan,
            arguments: newAssortedViewConfigs)
            .then((value) {
          getUserTask();
        });
        }else {*/
          _launchURL(task.action!.url!.replaceAll(' ', '%20')).then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          //}
          if (!task.finished) {
            completeMessageTaskOfAHACarePlan(
                task.action!.userTaskId.toString());
          }
          break;
        case 'Infographic':
          debugPrint('URL ==> ${task.action!.url!.replaceAll(' ', '%20')}');
          if (task.action!.url.toString().contains('.jpg') ||
              task.action!.url.toString().contains('.jpeg') ||
              task.action!.url.toString().contains('.png')) {
            assrotedUICount = 3;
            final AssortedViewConfigs newAssortedViewConfigs =
                AssortedViewConfigs();
            newAssortedViewConfigs.toShow = '1';
            newAssortedViewConfigs.testToshow = '2';
            newAssortedViewConfigs.isNextButtonVisible = false;
            newAssortedViewConfigs.header = task.task;
            newAssortedViewConfigs.task = task;

            Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
                    arguments: newAssortedViewConfigs)
                .then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            _launchURL(task.action!.url!.replaceAll(' ', '%20')).then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
            if (!task.finished) {
              completeMessageTaskOfAHACarePlan(
                  task.action!.userTaskId.toString());
            }
          }
          break;
        case 'Animation':
          debugPrint('URL ==> ${task.action!.url!.replaceAll(' ', '%20')}');
          _launchURL(task.action!.url!.replaceAll(' ', '%20')).then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
          if (!task.finished) {
            completeMessageTaskOfAHACarePlan(
                task.action!.userTaskId.toString());
          }
          break;
        case 'Web':
          debugPrint('Web Category ==> ${task.action!.category}');
          if (task.action!.category == 'Educational-NewsFeed') {
            final AssortedViewConfigs newAssortedViewConfigs =
                AssortedViewConfigs();
            newAssortedViewConfigs.toShow = '1';
            newAssortedViewConfigs.testToshow = '2';
            newAssortedViewConfigs.isNextButtonVisible = false;
            newAssortedViewConfigs.header = task.task;
            newAssortedViewConfigs.task = task;

            Navigator.pushNamed(context, RoutePaths.RSS_FEED_LIST,
                    arguments: newAssortedViewConfigs)
                .then((value) {
              //getUserTask();
              //showToast('Task completed successfully');
            });
          } else {
            //Educational-Link
            debugPrint('URL ==> ${task.action!.url!.replaceAll(' ', '%20')}');
            _launchURL(task.action!.url!.replaceAll(' ', '%20')).then((value) {
              getUserTask();
              //showToast('Task completed successfully');
            });
            if (!task.finished) {
              completeMessageTaskOfAHACarePlan(
                  task.action!.userTaskId.toString());
            }
          }
          /*if (!task.finished) {
            completeMessageTaskOfAHACarePlan(task);
          }*/
          break;
      }
    }
  }

  completeMessageTaskOfAHACarePlan(String taskId) async {
    try {
      final BaseResponse _startTaskOfAHACarePlanResponse =
          await model.finishUserTask(taskId);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        showToast('Task completed successfully!', context);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _launchURL(String url) async {
    if(url.contains('.pdf')){
      createFileOfPdfUrl(Uri.parse(url).toString(), 'careplan_pdf')
          .then((f) {
        progressDialog.close();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PDFScreen(f.path,'')));
      });
    }else {
      if (await canLaunchUrl(Uri.parse(url))) {
        await tabs.launch(url);
      } else {
        showToast('Could not launch $url', context);
        //throw 'Could not launch $url';
      }
    }
  }

  Future<File> createFileOfPdfUrl(String url, String? fileName) async {
    //debugPrint('Base Url ==> ${url}');
    //final url = "http://africau.edu/images/default/sample.pdf";
    //final url = "https://www.lalpathlabs.com/SampleReports/Z614.pdf";
    //final filename = url.substring(url.lastIndexOf("/") + 1);
    final map = <String, String>{};
    //map["enc"] = "multipart/form-data";
    map['Authorization'] = 'Bearer ' + auth!;
    progressDialog.show(max: 100, msg: 'Loading...');
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();

    debugPrint('Base Url ==> ${request.uri}');
    debugPrint('Headers ==> ${request.headers.toString()}');

    final bytes = await consolidateHttpClientResponseBytes(response);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget _info(String taskType) {
    return Card(
      semanticContainer: false,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          side: BorderSide(width: 0, color: Colors.white)),
      margin: EdgeInsets.zero,
      child: Container(
        height: 320,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Survey Information',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                ),
                const SizedBox(
                  height: 24,
                ),
                if(taskType == 'Survey')
                  RichText(
                  text: TextSpan(
                    text:
                        'As a part of the American Heart Association’s focus on heart failure, we are asking patients to complete a 5- to 10-minute confidential survey. This will help us better understand how different resources can support patients in managing their heart failure. You will receive a \u002410 e-gift card to thank you for completing the survey. You can earn additional e-gift cards by participating in follow-up surveys. ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textGrey,
                    ),
                    children: <TextSpan>[],
                  ),
                ),
                if(taskType == 'Patient Satisfaction Survey')
                  RichText(
                    text: TextSpan(
                      text:
                      'As part of the American Heart Association’s (AHA) focus on cholesterol, we would like to know what you thought of the Heart & Stroke Helper. To provide an opportunity to hear from you, the AHA’s program study team invites you to complete this 5-10 minute survey. \n\nYou will receive a \u002410 Amazon gift card as a token of appreciation for completing the full survey.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: textGrey,
                      ),
                      children: <TextSpan>[],
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Okay',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width - 32,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                color: primaryColor),
                            child: Center(
                              child: Text(
                                'Okay',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
