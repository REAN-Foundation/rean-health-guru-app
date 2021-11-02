import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DashboardTile.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/KnowledgeTopicResponse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/SearchSymptomAssesmentTempleteResponse.dart';
import 'package:paitent/core/models/TaskSummaryResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/dashboard_summary_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataTasksDisplay.dart';

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
  String name = '';
  String profileImage = '';
  String imageResourceId = '';
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  loadSharedPrefs() async {
    try {
      setKnowdledgeLinkLastViewDate(dateFormat.format(DateTime.now()));
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      auth = user.data.accessToken;

      patientUserId = patient.user.id;
      patientGender = patient.user.person.gender;
      //debugPrint('Address ==> ${patient.user.person.addresses.elementAt(0).city}');
      //debugPrint(user.toJson().toString());
      final dynamic roleId = await _sharedPrefUtils.read('roleId');
      setRoleId(roleId);
      /* */
      setState(() {
        debugPrint('FirstName ==> ${patient.user.person.firstName}');
        name = patient.user.person.firstName;
        imageResourceId = patient.user.person.imageResourceId ?? '';
        profileImage = imageResourceId != ''
            ? apiProvider.getBaseUrl() +
                '/file-resources/' +
                imageResourceId +
                '/download'
            : '';
      });
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              _createProfileData(context),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      howAreYouFeelingToday(),
                      myMedication(),
                      /*if (incompleteMedicationCount > 0)
                        myMedication()
                      else
                        Container(),*/
                      myBiometrics(),
                      //emergency(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _createProfileData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Let\'s check your activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: primaryColor,
                width: 2.0,
              ),
            ),
            child: profileImage == ''
                ? CircleAvatar(
                    backgroundImage:
                        AssetImage('res/images/profile_placeholder.png'),
                    radius: 60)
                : CircleAvatar(
                    child: ClipOval(
                        child: FadeInImage.assetNetwork(
                            placeholder: 'res/images/profile_placeholder.png',
                            image: profileImage,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 120)),
                    radius: 25),
          ),
        ],
      ),
    );
  }

  Widget _createComletedTasks(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(15),
      height: 200,
      width: screenWidth * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(
                Icons.task,
                color: primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Tasks",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
          Text(
            '12',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: textBlack,
            ),
          ),
          Text(
            'Completed Tasks',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createColumnStatistics() {
    return Column(
      children: [
        DataTasksDisplay(
          icon: Icon(
            Icons.check,
            color: Colors.green,
            size: 24,
          ),
          title: 'Medication',
          count: 2,
          text: 'Taken',
        ),
        const SizedBox(height: 20),
        DataTasksDisplay(
          icon: Icon(
            Icons.close,
            color: Colors.red,
            size: 24,
          ),
          title: 'Medication',
          count: 10,
          text: 'Remaining',
        ),
      ],
    );
  }

  Widget howAreYouFeelingToday() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
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
                  Text('How are you feeling today?',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      recordHowAreYouFeeling(1);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: Size(100, 100),
                        enableFeedback: true,
                        onPrimary: primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.smileBeam,
                          color: Colors.green,
                          size: 48,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Better',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      recordHowAreYouFeeling(0);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: Size(100, 100),
                        enableFeedback: true,
                        onPrimary: primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.meh,
                          color: Colors.grey,
                          size: 48,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Same',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat')),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      recordHowAreYouFeeling(-1);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: Size(100, 100),
                        enableFeedback: true,
                        onPrimary: primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.sadTear,
                          color: Colors.red.shade700,
                          size: 48,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Worse',
                            style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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
                        fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w500,
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
                                          fontWeight: FontWeight.w700,
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
                              fontWeight: FontWeight.w500,
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
                                          fontWeight: FontWeight.w700,
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
                              fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageIcon(
                AssetImage('res/images/ic_pharmacy_colored.png'),
                size: 24,
                color: primaryColor,
              ),
              SizedBox(
                width: 12,
              ),
              Text('Medication',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat')),
            ],
          ),
          /*Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _createComletedTasks(context),
                _createColumnStatistics(),
              ],
            ),
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Text('Did you take your medications?',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat')),
              ),
              Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'my_medication_yes',
                        child: ElevatedButton(
                          onPressed: () {
                            markAllMedicationAsTaken();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: Size(80, 80),
                              enableFeedback: true,
                              onPrimary: primaryColor),
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'my_medication_no',
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutePaths.My_Medications);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: Size(80, 80),
                              enableFeedback: true,
                              onPrimary: primaryColor),
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ],
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
                          fontWeight: FontWeight.w500,
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
                                fontWeight: FontWeight.w700,
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
                            fontWeight: FontWeight.w500,
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
                                fontWeight: FontWeight.w700,
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
                            fontWeight: FontWeight.w500,
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
    //debugPrint('knowledgeLinkDisplayedDate ==> ${knowledgeLinkDisplayedDate} ');
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
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
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Knowledge Tree',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
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
                              fontWeight: FontWeight.w200,
                              color: Colors.black,
                              fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'https://supportnetwork.heart.org/s/',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
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
                                fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' ' + briefInformation.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
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
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Vitals',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.My_Vitals);
                      })
                ],
              ),
            ),
          ),
          Container(
              height: 130,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    Semantics(
                      label: 'Weight',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              RoutePaths.Biometric_Weight_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Semantics(
                      label: "Blood Pressure",
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Blood_Presure_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
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
                                  AssetImage('res/images/ic_blood_presure.png'),
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Semantics(
                      label: 'Blood Glucose',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Blood_Glucose_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
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
                                  AssetImage('res/images/ic_blood_glucose.png'),
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Semantics(
                      label: 'Pulse',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,
                              RoutePaths.Biometric_Pulse_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
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
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Semantics(
                      label: 'Blood Oxygen',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Blood_Oxygen_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.0),
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_oximeter.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Blood\nOxygen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Semantics(
                      label: 'Body Temperature',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              RoutePaths
                                  .Biometric_Temperature_Vitals_Care_Plan);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            fixedSize: Size(100, 120),
                            enableFeedback: true,
                            onPrimary: primaryColor),
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.0),
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: ImageIcon(
                                  AssetImage('res/images/ic_thermometer.png'),
                                  size: 32,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Body\nTemperature',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              )),
        ],
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
