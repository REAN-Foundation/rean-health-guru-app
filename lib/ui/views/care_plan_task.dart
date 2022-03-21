import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/UserTaskResponse.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/infra/networking/CustomException.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class CarePlanTasksView extends StatefulWidget {
  @override
  _CarePlanTasksViewState createState() => _CarePlanTasksViewState();
}

class _CarePlanTasksViewState extends State<CarePlanTasksView>
    with WidgetsBindingObserver {
  var model = PatientCarePlanViewModel();
  var dateFormat = DateFormat('MMM dd - hh:mm a');
  var dateQueryFormat = DateFormat('yyyy-MM-dd');
  GetTaskOfAHACarePlanResponse _carePlanTaskResponse;
  UserTaskResponse userTaskResponse;
  List<Task> tasks = <Task>[];
  List<Items> tasksList = <Items>[];
  bool isSubscribe = false;
  ProgressDialog progressDialog;
  bool isUpCommingSelected = true;
  String query = 'pending';
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);

  getAHACarePlanSummary() async {
    try {
      //_carePlanTaskResponse = await model.getTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), query);
      _carePlanTaskResponse = await model.getTaskOfPaitent(query);

      if (_carePlanTaskResponse.status == 'success') {
        tasks.clear();
        tasks.addAll(_carePlanTaskResponse.data.tasks);
        debugPrint('AHA Care Plan ==> ${_carePlanTaskResponse.toJson()}');
        debugPrint(
            'AHA Care Plan Task Count ==> ${_carePlanTaskResponse.data.tasks.length}');
      } else {
        tasks.clear();
        showToast(_carePlanTaskResponse.message, context);
      }
    } on FetchDataException catch (e) {
      tasks.clear();
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
    try {
      //_carePlanTaskResponse = await model.getTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), query);
      userTaskResponse = await model.getUserTasks(
          query,
          dateQueryFormat.format(DateTime.now()),
          dateQueryFormat.format(DateTime.now()));

      if (userTaskResponse.status == 'success') {
        tasksList.clear();
        //tasksList.addAll(userTaskResponse.data.userTasks.items);
        _sortUserTask(userTaskResponse.data.userTasks.items);
        debugPrint('User Tasks ==> ${userTaskResponse.toJson()}');
        debugPrint(
            'User Tasks Count ==> ${userTaskResponse.data.userTasks.items.length}');
      } else {
        tasksList.clear();
        showToast(userTaskResponse.message, context);
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

  _sortUserTask(List<Items> tasks) {
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
    progressDialog = ProgressDialog(context);
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
    return BaseWidget<PatientCarePlanViewModel>(
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
                      'Tasks ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Semantics(
                      label: 'taskCount',
                      child: Text(
                        tasks.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: colorF6F6FF,
                height: 40,
                child: Row(
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
                            child: Center(
                              child: Text(
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
                            child: Center(
                              child: Text(
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
                      child: model.busy
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

//isSubscribe ?  model.busy ? Center(child: CircularProgressIndicator(),) : tasks.length == 0 ? noTaskFound() : listWidget() : noDoctorFound(),
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
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView.separated(
          itemBuilder: (context, index) => _makeMedicineCard(context, index),
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

/*  Widget _createToDos(BuildContext context, int index) {
    final Task task = tasks.elementAt(index);

    return task.categoryName == 'Care-plan-task'
        ? _makeTaskCard(context, index)
        : task.categoryName == 'Medication-consumption-task'
            ? _makeMedicineCard(context, index)
            : task.categoryName == 'Appointment-task'
                ? _makeUpcommingAppointmentCard(context, index)
                : Container();
  }*/

/*  Widget _makeTaskCard(BuildContext context, int index) {
    final Task task = tasks.elementAt(index);
    //debugPrint('Category Name ==> ${task.categoryName} && Task Tittle ==> ${task.details.mainTitle}');
    return InkWell(
      onTap: () {
        debugPrint('Task Type ==> ${task.type}');
        if (task.finished) {
          debugPrint('Task ID ==> ${task.id}');
          _taskNavigator(task);
          //showToast('Task completed already');
        } else {
          startAHACarePlanSummary(task);
        }
      },
      child: MergeSemantics(
        child: Semantics(
          label: task.details.mainTitle,
          child: Container(
            key: Key(task.details.type),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryLightColor),
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
                          child: ExcludeSemantics(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                //ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                                //SizedBox(width: 4,),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 200,
                                  child: Text(task.details.mainTitle,
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
                        ),
                        Expanded(
                          flex: 4,
                          child: ExcludeSemantics(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    dateFormat.format(
                                        task.scheduledStartTime.toLocal()),
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
                        ),
                      ],
                    ),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(task.details.subTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200,
                                        color: textBlack)),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(task.details.description,
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
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  task.finished
                                      ? Icons.check
                                      : Icons.chevron_right,
                                  size: 32,
                                  color: task.finished
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            )
                            */ /*Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(task.finished ? Icons.check : Icons.chevron_right, size: 32, color: task.finished ? Colors.green : Colors.grey,),
                             */ /* */ /* SizedBox(height: 4,),
                              Text(
                                'Start',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),
                              ),*/ /* */ /*
                            ],
                          ),*/ /*
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

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
                                DateTime.parse(task.scheduledStartTime)
                                    .toLocal()),
                            semanticsLabel: dateFormat.format(
                                DateTime.parse(task.scheduledStartTime)
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
                            Text(task.task,
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
                                          DateTime.parse(task.scheduledEndTime)
                                              .toLocal()),
                                  semanticsLabel: 'Consume before : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.scheduledEndTime)
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
                                          DateTime.parse(task.finishedAt)
                                              .toLocal()),
                                  semanticsLabel: 'Consumed at : ' +
                                      dateFormat.format(
                                          DateTime.parse(task.finishedAt)
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
                    if (!task.action.isTaken && !task.action.isMissed) ...[
                      Visibility(
                        visible: !(DateTime.parse(task.action.timeScheduleStart)
                                .toLocal())
                            .isAfter(DateTime.now()),
                        child: Expanded(
                          flex: 2,
                          child: Semantics(
                            button: true,
                            label: 'Mark as Taken',
                            child: InkWell(
                              onTap: () {
                                markMedicationsAsTaken(task.actionId);
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
                    if (task.action.isTaken) ...[
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
                    if (task.action.isMissed) ...[
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

  markMedicationsAsTaken(String consumptionId) async {
    try {
      progressDialog.show();
      final BaseResponse baseResponse =
          await model.markMedicationsAsTaken(consumptionId);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        progressDialog.hide();
        triggerApiCall();
      } else {
        progressDialog.hide();
        showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      progressDialog.hide();
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
                            'res/images/ic_appoinment_confirmed.png')),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  startAHACarePlanSummary(Task task) async {
    try {
      progressDialog.show();
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.startTaskOfAHACarePlan(
              startCarePlanResponseGlob.data.carePlan.id.toString(),
              task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        progressDialog.hide();
        //debugPrint(_startTaskOfAHACarePlanResponse.data.task.details.carePlanId.toString());
        _taskNavigator(task);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        progressDialog.hide();
        showToast(_startTaskOfAHACarePlanResponse.message, context);
      }
    } on FetchDataException catch (e) {
      tasks.clear();
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _taskNavigator(Task task) {
    //setStartTaskOfAHACarePlanResponse(_startTaskOfAHACarePlanResponse);
    setTask(task);
    debugPrint('Task Type ==> ${task.details.type}');
    switch (task.details.type) {
      case 'Message':
        assrotedUICount = 3;
        final AssortedViewConfigs newAssortedViewConfigs =
            AssortedViewConfigs();
        newAssortedViewConfigs.toShow = '1';
        newAssortedViewConfigs.testToshow = '2';
        newAssortedViewConfigs.isNextButtonVisible = false;
        newAssortedViewConfigs.header = task.details.mainTitle;
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
          Navigator.pushNamed(context, RoutePaths.Assessment_Navigator,
                  arguments: task)
              .then((value) {
            getUserTask();
            //showToast('Task completed successfully');
          });
        } else {
          showToast('Task is already completed', context);
        }
        //Navigator.pushNamed(context, RoutePaths.Assessment_Start_Care_Plan);
        break;
      case 'Link':
        _launchURL(task.details.url.replaceAll(' ', '%20')).then((value) {
          getUserTask();
          //showToast('Task completed successfully');
        });
        if (!task.finished) {
          completeMessageTaskOfAHACarePlan(task);
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
        Navigator.pushNamed(context, RoutePaths.Challenge_Care_Plan,
                arguments: task)
            .then((value) {
          getUserTask();
          //showToast('Task completed successfully');
        });
        break;
      case 'Goal':
        if (!task.finished) {
          Navigator.pushNamed(
                  context, RoutePaths.Set_Prority_For_Goals_Care_Plan)
              .then((value) {
            getUserTask();
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
        newAssortedViewConfigs.header = task.details.mainTitle;
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
        newAssortedViewConfigs.header = task.details.mainTitle;
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
        debugPrint('URL ==> ${task.details.url.replaceAll(' ', '%20')}');
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
        _launchURL(task.details.url.replaceAll(' ', '%20')).then((value) {
          getUserTask();
          //showToast('Task completed successfully');
        });
        //}
        if (!task.finished) {
          completeMessageTaskOfAHACarePlan(task);
        }
        break;
      case 'Infographics':
        debugPrint('URL ==> ${task.details.url.replaceAll(' ', '%20')}');
        _launchURL(task.details.url.replaceAll(' ', '%20')).then((value) {
          getUserTask();
          //showToast('Task completed successfully');
        });
        if (!task.finished) {
          completeMessageTaskOfAHACarePlan(task);
        }
        break;
      case 'Animation':
        debugPrint('URL ==> ${task.details.url.replaceAll(' ', '%20')}');
        _launchURL(task.details.url.replaceAll(' ', '%20')).then((value) {
          getUserTask();
          //showToast('Task completed successfully');
        });
        if (!task.finished) {
          completeMessageTaskOfAHACarePlan(task);
        }
        break;
    }
  }

  completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.stopTaskOfAHACarePlan(
              startCarePlanResponseGlob.data.carePlan.id.toString(),
              task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;

        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
  }
}
