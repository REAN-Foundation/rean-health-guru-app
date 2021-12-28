import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DashboardTile.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/KnowledgeTopicResponse.dart';
import 'package:paitent/core/models/SearchSymptomAssesmentTempleteResponse.dart';
import 'package:paitent/core/models/TaskSummaryResponse.dart';
import 'package:paitent/core/viewmodels/views/dashboard_summary_model.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class DashBoardVer2View extends StatefulWidget {
  Function positionToChangeNavigationBar;

  DashBoardVer2View({Key key, @required Function positionToChangeNavigationBar})
      : super(key: key) {
    this.positionToChangeNavigationBar = positionToChangeNavigationBar;
  }

  @override
  _DashBoardVer2ViewState createState() => _DashBoardVer2ViewState();
}

class _DashBoardVer2ViewState extends State<DashBoardVer2View> {
  var model = DashboardSummaryModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  Color widgetBackgroundColor = primaryColor;
  Color widgetBorderColor = primaryColor;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  Gradient widgetBackgroundGradiet = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [primaryLightColor, colorF6F6FF]);
  var dateFormat = DateFormat('yyyy-MM-dd');
  int completedTaskCount = 0;
  int incompleteTaskCount = 0;
  int completedMedicationCount = 0;
  int incompleteMedicationCount = 0;
/*  Weight weight;
  BloodPressure bloodPressure;
  BloodSugar bloodSugar;
  BloodOxygenSaturation bloodOxygenSaturation;
  Pulse pulse;
  Temperature temperature;*/
  String unit = 'Kg';
  String topicId;
  String topicName = '';
  String briefInformation = '';
  var emergencyDetailsTextControler = TextEditingController();
  List<Schedules> currentMedicationList = <Schedules>[];
  DashboardTile emergencyDashboardTile;

  loadSharedPrefs() async {
    try {
      setKnowdledgeLinkLastViewDate(dateFormat.format(DateTime.now()));

      setState(() {});
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
    /*catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }*/
  }

  @override
  void initState() {
    loadSharedPrefs();
    model.setBusy(true);
    Future.delayed(
      Duration(seconds: 4),
      () {
        getTodaysKnowledgeTopic();
        //getTaskPlanSummary();
        getMyMedications();
        //getMedicationSummary();
        //getLatestBiometrics();
      },
    );
    debugPrint('Country Local ==> ${getCurrentLocale()}');
    if (getCurrentLocale() == 'US') {
      unit = 'lbs';
    }
    super.initState();
  }

  getTaskPlanSummary() async {
    try {
      final TaskSummaryResponse taskSummaryResponse =
          await model.getTaskPlanSummary();
      debugPrint('Task Summary ==> ${taskSummaryResponse.toJson()}');
      if (taskSummaryResponse.status == 'success') {
        completedTaskCount =
            taskSummaryResponse.data.summary.completedTaskCount;
        incompleteTaskCount =
            taskSummaryResponse.data.summary.incompleteTaskCount;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  sortMyMedication(GetMyMedicationsResponse response) {
    for (final medSummary
        in response.data.medicationSchedulesForDay.schedules) {
      if (medSummary.status == 'Unknown' ||
          medSummary.status == 'Upcoming' ||
          medSummary.status == 'Overdue') {
        incompleteMedicationCount = incompleteMedicationCount + 1;
      }

      if (medSummary.status == 'Taken') {
        completedMedicationCount = completedMedicationCount + 1;
      }
    }
    setState(() {});
  }

  getMedicationSummary() async {
    try {
      final TaskSummaryResponse taskSummaryResponse =
          await model.getMedicationSummary(dateFormat.format(DateTime.now()));
      debugPrint('Medication Summary ==> ${taskSummaryResponse.toJson()}');
      if (taskSummaryResponse.status == 'success') {
        completedMedicationCount = taskSummaryResponse.data.summary.taken +
            taskSummaryResponse.data.summary.missed;
        incompleteMedicationCount = taskSummaryResponse.data.summary.unknown +
            taskSummaryResponse.data.summary.overdue +
            taskSummaryResponse.data.summary.upcoming;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      setState(() {});
      showToast(e.toString(), context);
    }
  }

/*
  getLatestBiometrics() async {
    try {
      final TaskSummaryResponse taskSummaryResponse =
          await model.getLatestBiometrics();
      debugPrint('Vitals Summary ==> ${taskSummaryResponse.toJson()}');
      if (taskSummaryResponse.status == 'success') {
        pulse = taskSummaryResponse.data.summary.pulse;
        bloodPressure = taskSummaryResponse.data.summary.bloodPressure;
        bloodSugar = taskSummaryResponse.data.summary.bloodSugar;
        temperature = taskSummaryResponse.data.summary.temperature;
        weight = taskSummaryResponse.data.summary.weight;
        bloodOxygenSaturation =
            taskSummaryResponse.data.summary.bloodOxygenSaturation;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DashboardSummaryModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                howAreYoursymptoms(),
                //if (incompleteMedicationCount > 0)
                myMedication(),
                // else
                //   Container(),
                myBiometrics(),
                myNutrition(),
                //myActivity(),
                //myStress(),
                knowledgeTree(),
                //myTasks(),
                //searchNearMe(),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget howAreYoursymptoms() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*SizedBox(width: 8,),
                  ImageIcon(
                    AssetImage('res/images/ic_tree.png'),
                    size: 28,
                    color: iconColor,
                  ),*/
                  SizedBox(
                    width: 8,
                  ),
                  Text('How are your symptoms? ',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      recordHowAreYouFeeling(1);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage('res/images/ic_better_emoji.png'),
                          size: 48,
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Better',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      recordHowAreYouFeeling(0);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage('res/images/ic_same_emoji.png'),
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Same',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      recordHowAreYouFeeling(-1);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage('res/images/ic_worse_emoji.png'),
                          size: 48,
                          color: Colors.red.shade700,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Worse',
                            style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchNearMe() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: widgetBackgroundColor,
            border: Border.all(color: widgetBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search Near Me',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat')),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.Doctor_Appoinment);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_doctor_colored.png'),
                              size: 32,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Doctor',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.Lab_Appoinment);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_lab_colored.png'),
                              size: 32,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Lab',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToast('Coming Soon...', context);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_pharmacy_colored.png'),
                              size: 28,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Pharmacy',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showToast('Coming Soon...', context);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_ambulance.png'),
                              size: 28,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Ambulance',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToast('Coming Soon...', context);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_nurse.png'),
                              size: 32,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Nurse',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showToast('Coming Soon...', context);
                      },
                      child: Container(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('res/images/ic_dietician.png'),
                              size: 28,
                              color: iconColor,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Dietitian',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget myTasks() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: InkWell(
        onTap: () {
          widget.positionToChangeNavigationBar(1);
        },
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: widgetBackgroundColor,
              border: Border.all(color: widgetBorderColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('res/images/ic_daily_tasks_colored.png'),
                      size: 24,
                      color: iconColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('My Tasks',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          /*height: 32,
                            width: 32,
                            decoration: new BoxDecoration(
                                color: Colors.orange,
                                border: Border.all(color: Colors.white),
                                borderRadius: new BorderRadius.all(Radius.circular(16.0))),*/
                          child: Center(
                            child: model.busy
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          iconColor),
                                    ))
                                : Semantics(
                                    label: 'pendingTask',
                                    child: Text(
                                      incompleteTaskCount.toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          color: Colors.orange),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Pending',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: textColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          /*height: 32,
                            width: 32,
                            decoration: new BoxDecoration(
                                color: Colors.green,
                                border: Border.all(color: Colors.white),
                                borderRadius: new BorderRadius.all(Radius.circular(16.0))),*/
                          child: Center(
                            child: model.busy
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          iconColor),
                                    ))
                                : Semantics(
                                    label: 'completedTask',
                                    child: Text(
                                      completedTaskCount.toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          color: Colors.green),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myMedication() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_pharmacy_colored.png'),
                        size: 24,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Did you take your medications?',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Semantics(
                    label: 'Add medication',
                    child: IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 32,
                          color: iconColor,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutePaths.ADD_MY_MEDICATION);
                        }),
                  )
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Yes I have taken my medications',
                    button: true,
                    child: InkWell(
                      onTap: () {
                        if (currentMedicationList.isEmpty) {
                          showToast(
                              'Your medication list is empty. Please add your medications.',
                              context);
                        } else {
                          markAllMedicationAsTaken();
                        }
                      },
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                              size: 36,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Yes',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'No I haven\'t taken my medications',
                    button: true,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.My_Medications);
                      },
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color: primaryColor,
                              size: 36,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text('No',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat')),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emergency() {
    String discription = '';

    if (emergencyDashboardTile != null) {
      //debugPrint('Emergency ==> ${emergencyDashboardTile.date.difference(DateTime.now()).inDays}');
      if (emergencyDashboardTile.date.difference(DateTime.now()).inDays == 0) {
        discription = emergencyDashboardTile.discription;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  /*ImageIcon(
                    AssetImage('res/images/ic_pharmacy_colored.png'),
                    size: 24,
                    color: iconColor,
                  ),*/
                  Icon(
                    FontAwesomeIcons.firstAid,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Did you have an emergency?',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.home, color: Colors.green, size: 40,),
                          SizedBox(height: 6,),
                          Text('No I am good!',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat')),
                        ],
                      ),
                    ),
                  ),*/

                  if (discription != '')
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(discription,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat')),
                              Semantics(
                                label: 'edit_emergency_text',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                size: 24,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                _emergencyDetailDialog(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Semantics(
                      label: 'emergency_yes',
                      child: InkWell(
                        onTap: () {
                          _emergencyDetailDialog(false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.ambulance,
                              color: primaryColor,
                              size: 36,
                            ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Yes',
                                    style: TextStyle(
                                        color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myActivites() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: widgetBackgroundColor,
            border: Border.all(color: widgetBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_run,
                    //AssetImage('res/images/ic_daily_tasks_colored.png'),
                    size: 24,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('My Activites',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: textColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Pending',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: textColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: textColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Completed',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: textColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget knowledgeTree() {
    debugPrint('knowledgeLinkDisplayedDate ==> $knowledgeLinkDisplayedDate ');
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  ImageIcon(
                    AssetImage('res/images/ic_tree.png'),
                    size: 28,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Knowledge Tree',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(8),
              child: getAppType() == 'AHA' &&
                  knowledgeLinkDisplayedDate !=
                      dateFormat.format(DateTime.now())
                  ? InkWell(
                onTap: () async {
                  final String url =
                      'https://supportnetwork.heart.org/s/';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Visit: ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'https://supportnetwork.heart.org/s/',
                        style: TextStyle(
                          color: Colors.blue,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                      )
                    ],
                  ),
                ),
              )
                  : model.busy
                  ? Center(
                  child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator()))
                  : RichText(
                text: TextSpan(
                  text: topicName.toString(),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' ' + briefInformation.toString(),
                        style: TextStyle(
                            fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display My Biometric

  Widget myBiometrics() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_heart_biometric.png'),
                        size: 24,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Vitals',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: iconColor,
                        semanticLabel: 'Add Vitals',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.My_Vitals);
                      })
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Add Weight',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              RoutePaths.Biometric_Weight_Vitals_Care_Plan);
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_body_weight.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Weight',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: "Add Blood Pressure",
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Blood_Presure_Vitals_Care_Plan);
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage(
                                        'res/images/ic_blood_presure.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Blood\nPressure',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Add Blood Glucose',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Blood_Glucose_Vitals_Care_Plan);
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage(
                                        'res/images/ic_blood_glucose.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Blood\nGlucose',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Add Pulse',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              RoutePaths.Biometric_Pulse_Vitals_Care_Plan);
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 12),
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_pulse.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Pulse',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget myNutrition() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_nutrition.png'),
                        size: 32,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Nutrition',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: iconColor,
                        semanticLabel: 'Add Nutrition',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                            arguments: '');
                      })
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Add Breakfast',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'breakfast');
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_breakfast.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Breakfast',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: "Add Lunch",
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'lunch');
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_lunch.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Lunch',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Add Dinner',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'dinner');
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_dinner.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Dinner',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Add Snacks',
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'snack');
                        },
                        child: Container(
                          height: 96,
                          child: ExcludeSemantics(
                            child: Column(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: ImageIcon(
                                    AssetImage('res/images/ic_snacks.png'),
                                    size: 32,
                                    color: iconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Snack',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget myActivity() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_activity.png'),
                        size: 32,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Activity',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: iconColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.My_Activity,
                            arguments: '');
                      })
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: "Stand",
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Activity);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage(
                                      'res/images/ic_stand_activity.png'),
                                  size: 24,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Stand',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Steps',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Activity);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_steps.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Steps',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Exercise',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Activity);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_exercise.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Exercise',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*Semantics(
                      label: 'Snacks',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'snacks');
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_snacks.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Snack',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget myStress() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ImageIcon(
                        AssetImage('res/images/ic_stress.png'),
                        size: 32,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Stress',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  /*IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: iconColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.My_Activity,
                            arguments: '');
                      })*/
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Sleep',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.MySleepData);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_sleep.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Sleep',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: "Meditation",
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.Meditation);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_medication.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Meditation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*Semantics(
                      label: 'Exercise',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Activity);
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_exercise.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Exercise',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                    /*Semantics(
                      label: 'Snacks',
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                              arguments: 'snacks');
                        },
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_snacks.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Snack',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _emergencyDetailDialog(bool isEdit) async {
    if (isEdit) {
      emergencyDetailsTextControler.text = emergencyDashboardTile.discription;
      emergencyDetailsTextControler.selection = TextSelection.fromPosition(
        TextPosition(offset: emergencyDetailsTextControler.text.length),
      );
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Semantics(
            label: 'updateEmergencyText',
            child: TextField(
              controller: emergencyDetailsTextControler,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                  color: Colors.black),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  labelText: 'Enter emergency details',
                  hintText: ''),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                emergencyDetailsTextControler.clear();
              }),
          TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (emergencyDetailsTextControler.text.isEmpty) {
                  showToast('Please enter emergency details', context);
                } else {
                  addMedicalEmergencyEvent(emergencyDetailsTextControler.text);
                  Navigator.of(context, rootNavigator: true).pop();
                  emergencyDetailsTextControler.clear();
                }
              })
        ],
      ),
    );
  }

  getTodaysKnowledgeTopic() async {
    try {
      final KnowledgeTopicResponse knowledgeTopicResponse =
          await model.getTodaysKnowledgeTopic();
      debugPrint(
          'Today Knowledge Topic ==> ${knowledgeTopicResponse.toJson()}');
      if (knowledgeTopicResponse.status == 'success') {
        //final Items topic =
         //knowledgeTopicResponse.data.knowledgeNuggetRecords.items.elementAt(0);
        topicId = knowledgeTopicResponse.data.knowledgeNugget.id;
        topicName = knowledgeTopicResponse.data.knowledgeNugget.topicName;
        briefInformation = knowledgeTopicResponse.data.knowledgeNugget.briefInformation;
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  addMedicalEmergencyEvent(String emergencyBreif) async {
    try {
      final map = <String, String>{};
      map['PatientUserId'] = patientUserId;
      map['Details'] = emergencyBreif;
      map['EmergencyDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
          await model.addMedicalEmergencyEvent(map);
      debugPrint('Base Response ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        _sharedPrefUtils.save(
            'emergency',
            DashboardTile(DateTime.now(), 'emergency', emergencyBreif)
                .toJson());
        showToast('Emergency details saved successfully!', context);
        loadSharedPrefs();
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  getMyMedications() async {
    try {
      currentMedicationList.clear();
      final GetMyMedicationsResponse getMyMedicationsResponse =
          await model.getMyMedications(dateFormat.format(DateTime.now()));
      debugPrint('Medication ==> ${getMyMedicationsResponse.toJson()}');
      if (getMyMedicationsResponse.status == 'success') {
        debugPrint(
            'Medication Length ==> ${getMyMedicationsResponse.data.medicationSchedulesForDay.schedules.length}');
        if (getMyMedicationsResponse
            .data.medicationSchedulesForDay.schedules.isNotEmpty) {
          currentMedicationList.addAll(getMyMedicationsResponse
              .data.medicationSchedulesForDay.schedules);
          sortMyMedication(getMyMedicationsResponse);
        }
      } else {
        //showToast(getMyMedicationsResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  markAllMedicationAsTaken() async {
    try {
      debugPrint(currentMedicationList.length.toString());
      final medicationIds = <String>[];
      for (final item in currentMedicationList) {
        //debugPrint(item.timeScheduleEnd.toString() +'  '+ DateTime.now().toString() +'  '+DateTime.now().isAfter(DateTime.parse(item.timeScheduleEnd)).toString());
        if (DateTime.now().isAfter(item.timeScheduleStart) &&
            item.status != 'Taken') {
          medicationIds.add(item.id);
          debugPrint(item.id);
        }
      }

      if (medicationIds.isNotEmpty) {
        final body = <String, dynamic>{};
        body['MedicationConsumptionIds'] = medicationIds;

        final BaseResponse baseResponse =
            await model.markAllMedicationsAsTaken(body);
        debugPrint('Medication ==> ${baseResponse.toJson()}');
        if (baseResponse.status == 'success') {
          //progressDialog.hide();
          showToast(baseResponse.message, context);
          getMyMedications();
        } else {
          showToast(baseResponse.message, context);
          //progressDialog.hide();
          showToast(baseResponse.message, context);
        }
      } else {
        showToast('You have taken all the medication till now.', context);
      }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  recordHowAreYouFeeling(int feeling) async {
    try {
      final body = <String, dynamic>{};
      body['PatientUserId'] = patientUserId;
      body['Feeling'] = feeling;
      body['RecordDate'] = dateFormat.format(DateTime.now());
      body['Comments'] = '';
      body['SymptomAssessmentId'] = '';

      final BaseResponse baseResponse =
          await model.recordHowAreYouFeeling(body);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        //progressDialog.hide();
        //showToast(baseResponse.message, context);
        if (feeling == 1) {
          showToast('Good to hear that', context);
        } else if (feeling == 0) {
          showToast('Please follow your medications', context);
        } else if (feeling == -1) {
          getSymptomAssesmentTemplete();
        }
      } else {
        showToast(baseResponse.error, context);
        //progressDialog.hide();
        // showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  getSymptomAssesmentTemplete() async {
    try {
      final SearchSymptomAssesmentTempleteResponse
          searchSymptomAssesmentTempleteResponse =
          await model.searchSymptomAssesmentTemplete('heart');
      debugPrint(
          'Search Symptom Assesment Templete Response ==> ${searchSymptomAssesmentTempleteResponse.toJson()}');
      if (searchSymptomAssesmentTempleteResponse.status == 'success') {
        Navigator.pushNamed(context, RoutePaths.Symptoms,
            arguments: searchSymptomAssesmentTempleteResponse
                .data.symptomAssessmentTemplates.items
                .elementAt(0)
                .id);
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }
}
