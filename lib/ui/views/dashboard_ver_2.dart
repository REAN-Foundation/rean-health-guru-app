import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paitent/core/constants/Constants.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DashboardTile.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/KnowledgeTopicResponse.dart';
import 'package:paitent/core/models/SearchSymptomAssesmentTempleteResponse.dart';
import 'package:paitent/core/models/TaskSummaryResponse.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/dashboard_summary_model.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:intl/intl.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:paitent/utils/TimeAgo.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  Color widgetBackgroundColor = primaryColor;
  Color widgetBorderColor = primaryColor;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  Gradient widgetBackgroundGradiet = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [primaryLightColor, colorF6F6FF]);
  var dateFormat = DateFormat("yyyy-MM-dd");
  int completedTaskCount = 0;
  int incompleteTaskCount = 0;
  int completedMedicationCount = 0;
  int incompleteMedicationCount = 0;
  Weight weight = null;
  BloodPressure bloodPressure = null;
  BloodSugar bloodSugar = null;
  BloodOxygenSaturation bloodOxygenSaturation = null;
  Pulse pulse = null;
  Temperature temperature = null;
  String unit = 'Kg';
  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();
  String topicId = null;
  String topicName = "";
  String briefInformation = "";
  var emergencyDetailsTextControler = TextEditingController();
  List<MedConsumptions> currentMedicationList = new List<MedConsumptions>();
  DashboardTile emergencyDashboardTile;

  loadSharedPrefs() async {
    try {
      emergencyDashboardTile =
          DashboardTile.fromJson(await _sharedPrefUtils.read("emergency"));
      //debugPrint('Emergency Dashboard Tile ==> ${emergencyDashboardTile.date}');
      setState(() {});
    }on FetchDataException catch(e) {
      print('error caught: $e');
    } /*catch (Excepetion) {
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
        getTaskPlanSummary();
        getMyMedications();
        getMedicationSummary();
        //getLatestBiometrics();
      },
    );
    // TODO: implement initState
    debugPrint('Country Local ==> ${details.alpha2Code}');
    // TODO: implement initState
    if (details.alpha2Code == "US") {
      unit = 'lbs';
    }
    super.initState();
  }

  getTaskPlanSummary() async {
    try {
      TaskSummaryResponse taskSummaryResponse =
          await model.getTaskPlanSummary();
      debugPrint("Task Summary ==> ${taskSummaryResponse.toJson()}");
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
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  getMedicationSummary() async {
    try {
      TaskSummaryResponse taskSummaryResponse = await model
          .getMedicationSummary(dateFormat.format(new DateTime.now()));
      debugPrint("Medication Summary ==> ${taskSummaryResponse.toJson()}");
      if (taskSummaryResponse.status == 'success') {
        completedMedicationCount = taskSummaryResponse.data.summary.taken + taskSummaryResponse.data.summary.missed;
        incompleteMedicationCount = taskSummaryResponse.data.summary.unknown +
            taskSummaryResponse.data.summary.overdue +
            taskSummaryResponse.data.summary.upcoming;
        setState(() {});
        //showToast(startCarePlanResponse.message);
      } else {
        //showToast(startCarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  getLatestBiometrics() async {
    try {
      TaskSummaryResponse taskSummaryResponse =
          await model.getLatestBiometrics();
      debugPrint("Vitals Summary ==> ${taskSummaryResponse.toJson()}");
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
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
                howAreYouFeelingToday(),
                incompleteMedicationCount > 0 ? myMedication() : Container(),
                myBiometrics(),
                energency(),
                knowledgeTree(),
                myTasks(),
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

  Widget howAreYouFeelingToday() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: new BorderRadius.only(
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
                  Text('How are you feeling today?',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                  InkWell(
                    onTap: () {
                      recordHowAreYouFeeling(0);
                      //Navigator.pushNamed(context, RoutePaths.Symptoms);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.meh,
                          color: Colors.deepPurple,
                          size: 48,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Same',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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
                        Icon(
                          FontAwesomeIcons.sadTear,
                          color: Colors.deepOrange,
                          size: 48,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Worse',
                            style: TextStyle(
                                color: Colors.deepOrange,
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
        decoration: new BoxDecoration(
            color: widgetBackgroundColor,
            border: Border.all(color: widgetBorderColor),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
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
                        showToast("Coming Soon...");
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
                        showToast("Coming Soon...");
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
                        showToast("Coming Soon...");
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
                        showToast("Coming Soon...");
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
          decoration: new BoxDecoration(
              color: widgetBackgroundColor,
              border: Border.all(color: widgetBorderColor),
              borderRadius: new BorderRadius.all(Radius.circular(8.0))),
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
                                          new AlwaysStoppedAnimation<Color>(
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
                                          new AlwaysStoppedAnimation<Color>(
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
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: new BorderRadius.only(
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
                          fontWeight: FontWeight.w500,
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
                  Semantics(
                    label: 'my_medication_yes',
                    child: InkWell(
                      onTap: () {
                        markAllMedicationAsTaken();
                      },
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.My_Medications);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: Colors.deepOrange,
                            size: 36,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('No',
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
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

  Widget energency() {
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
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: new BorderRadius.only(
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
                          fontWeight: FontWeight.w500,
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
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat')),
                        ],
                      ),
                    ),
                  ),*/

                  discription != ''
                      ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(discription,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat')),

                            Semantics(
                              label: 'edit_emergency_text',
                              child: IconButton(
                                icon: Icon(Icons.edit , size: 24, color: primaryColor,),
                                onPressed: () {
                                  _emergencyDetailDialog(true);
                                },
                              ),
                            ),

                          ],
                        ),
                      )
                      : Semantics(
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
                                  color: Colors.deepOrange,
                                  size: 36,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Yes',
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
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
        decoration: new BoxDecoration(
            color: widgetBackgroundColor,
            border: Border.all(color: widgetBorderColor),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
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
                        decoration: new BoxDecoration(
                            color: Colors.orange,
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(16.0))),
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
                        decoration: new BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(16.0))),
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: new BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0))),
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
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(8),
              child: model.busy
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
                              text: " " + briefInformation.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
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
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: new BorderRadius.only(
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
                              fontWeight: FontWeight.w500,
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            RoutePaths.Biometric_Weight_Vitals_Care_Plan);
                      },
                      child: Container(
                        height: 96,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              height: 56,
                              width: 56,
                              decoration: new BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(color: Colors.deepPurple),
                                  borderRadius: new BorderRadius.all(
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            RoutePaths
                                .Biometric_Blood_Presure_Vitals_Care_Plan);
                      },
                      child: Container(
                        height: 96,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              height: 56,
                              width: 56,
                              decoration: new BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(color: Colors.deepPurple),
                                  borderRadius: new BorderRadius.all(
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            RoutePaths
                                .Biometric_Blood_Glucose_Vitals_Care_Plan);
                      },
                      child: Container(
                        height: 96,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              height: 56,
                              width: 56,
                              decoration: new BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(color: Colors.deepPurple),
                                  borderRadius: new BorderRadius.all(
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            RoutePaths.Biometric_Pulse_Vitals_Care_Plan);
                      },
                      child: Container(
                        height: 96,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 12),
                              height: 56,
                              width: 56,
                              decoration: new BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(color: Colors.deepPurple),
                                  borderRadius: new BorderRadius.all(
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
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _emergencyDetailDialog(bool isEdit) async {

    if(isEdit) {
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
            child: new TextField(
              controller: emergencyDetailsTextControler,
              autofocus: true,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                  color: Colors.black),
              decoration: new InputDecoration(
                  labelStyle: TextStyle(fontSize: 16),
                  labelText: 'Enter emergency details', hintText: ''),
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                emergencyDetailsTextControler.clear();
              }),
          new FlatButton(
              child: const Text('Submit'),
              onPressed: () {
                if (emergencyDetailsTextControler.text.isEmpty) {
                  showToast('Please enter emergency details');
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
      KnowledgeTopicResponse knowledgeTopicResponse =
          await model.getTodaysKnowledgeTopic();
      debugPrint(
          "Today Knowledge Topic ==> ${knowledgeTopicResponse.toJson()}");
      if (knowledgeTopicResponse.status == 'success') {
        KnowledgeTopic topic =
            knowledgeTopicResponse.data.knowledgeTopic.elementAt(0);
        topicId = topic.id;
        topicName = topic.topicName;
        briefInformation = topic.briefInformation;
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  addMedicalEmergencyEvent(String emergencyBreif) async {
    try {
      var map = new Map<String, String>();
      map["PatientUserId"] = patientUserId;
      map["Details"] = emergencyBreif;
      map["DateOfEmergency"] = dateFormat.format(new DateTime.now());

      BaseResponse baseResponse = await model.addMedicalEmergencyEvent(map);
      debugPrint("Base Response ==> ${baseResponse.toJson()}");
      if (baseResponse.status == 'success') {
        _sharedPrefUtils.save(
            'emergency',
            DashboardTile(new DateTime.now(), 'emergency', emergencyBreif)
                .toJson());
        showToast('Emergency details saved successfully');
        loadSharedPrefs();
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  getMyMedications() async {
    try {
      currentMedicationList.clear();
      GetMyMedicationsResponse getMyMedicationsResponse =
          await model.getMyMedications(dateFormat.format(new DateTime.now()));
      debugPrint("Medication ==> ${getMyMedicationsResponse.toJson()}");
      if (getMyMedicationsResponse.status == 'success') {
        debugPrint("Medication Length ==> ${getMyMedicationsResponse.data.medConsumptions.length}");
        if(getMyMedicationsResponse.data.medConsumptions.length != 0) {
          currentMedicationList
              .addAll(getMyMedicationsResponse.data.medConsumptions);
        }
      } else {
        showToast(getMyMedicationsResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  markAllMedicationAsTaken() async {
    try {
      print(currentMedicationList.length);
      var medicationIds = new List<String>();
      for (var item in currentMedicationList) {
        //print(item.timeScheduleEnd.toString() +'  '+ DateTime.now().toString() +'  '+DateTime.now().isAfter(item.timeScheduleEnd).toString());
        if (DateTime.now().isAfter(item.timeScheduleStart)) {
          medicationIds.add(item.id);
          print(item.id);
        }
      }

      if (medicationIds.length > 0) {
        var body = new Map<String, dynamic>();
        body["ids"] = medicationIds;

        BaseResponse baseResponse = await model.markAllMedicationsAsTaken(body);
        debugPrint("Medication ==> ${baseResponse.toJson()}");
        if (baseResponse.status == 'success') {
          //progressDialog.hide();
          showToast(baseResponse.message);
          getMyMedications();
        } else {
          showToast(baseResponse.message);
          //progressDialog.hide();
          showToast(baseResponse.message);
        }
      }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  recordHowAreYouFeeling(int feeling) async {
    try {


        var body = new Map<String, dynamic>();
        body['PatientUserId'] = patientUserId;
        body['Feeling'] = feeling;
        body['RecordDate'] = dateFormat.format(new DateTime.now());
        body['Comments'] = '';
        body['SymptomAssessmentId'] = null;

        BaseResponse baseResponse =
        await model.recordHowAreYouFeeling(body);
        debugPrint("Medication ==> ${baseResponse.toJson()}");
        if (baseResponse.status == 'success') {
          //progressDialog.hide();
          //showToast(baseResponse.message);
          if(feeling == 1){
            showToast('Good to hear that');
          }else if(feeling == 0) {
            showToast('Please follow your medications');
          }else if(feeling == -1) {
            getSymptomAssesmentTemplete();
          }
        } else {
          showToast(baseResponse.error);
          //progressDialog.hide();
         // showToast(baseResponse.message);
        }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  getSymptomAssesmentTemplete() async {
    try {
      SearchSymptomAssesmentTempleteResponse
          searchSymptomAssesmentTempleteResponse =
          await model.searchSymptomAssesmentTemplete('heart');
      debugPrint(
          "Search Symptom Assesment Templete Response ==> ${searchSymptomAssesmentTempleteResponse.toJson()}");
      if (searchSymptomAssesmentTempleteResponse.status == 'success') {
        Navigator.pushNamed(context, RoutePaths.Symptoms,
            arguments: searchSymptomAssesmentTempleteResponse
                .data.assessmentTemplates
                .elementAt(0)
                .id);
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }
}