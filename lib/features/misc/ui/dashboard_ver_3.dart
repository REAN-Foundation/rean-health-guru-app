
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_web_wiew;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/medication/models/get_my_medications_response.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/models/knowledge_topic_response.dart';
import 'package:patient/features/misc/models/search_symptom_assessment_templete_response.dart';
import 'package:patient/features/misc/models/task_summary_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/view_models/dashboard_summary_model.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_outlined_screen.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class DashBoardVer3View extends StatefulWidget {
  late Function positionToChangeNavigationBar;

  DashBoardVer3View({Key? key, required Function positionToChangeNavigationBar})
      : super(key: key) {
    this.positionToChangeNavigationBar = positionToChangeNavigationBar;
  }

  @override
  _DashBoardVer3ViewState createState() => _DashBoardVer3ViewState();
}

class _DashBoardVer3ViewState extends State<DashBoardVer3View>
    with WidgetsBindingObserver {
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
  int? completedTaskCount = 0;
  int? incompleteTaskCount = 0;
  int completedMedicationCount = 0;
  int incompleteMedicationCount = 0;
  late ProgressDialog progressDialog;

/*  Weight weight;
  BloodPressure bloodPressure;
  BloodSugar bloodSugar;
  BloodOxygenSaturation bloodOxygenSaturation;
  Pulse pulse;
  Temperature temperature;*/
  String unit = 'Kg';
  String? topicId;
  String? topicName = '';
  String? briefInformation = '';
  var emergencyDetailsTextControler = TextEditingController();
  List<Schedules> currentMedicationList = <Schedules>[];
  DashboardTile? emergencyDashboardTile;

  loadSharedPrefs() async {
    try {
      setKnowdledgeLinkLastViewDate(dateFormat.format(DateTime.now()));

      setState(() {});
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
    /*catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }*/
  }

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
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
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      getMyMedications();
      debugPrint('Dashboard ==> Homesceen');
    }
  }

  getTaskPlanSummary() async {
    try {
      final TaskSummaryResponse taskSummaryResponse =
          await model.getTaskPlanSummary();
      debugPrint('Task Summary ==> ${taskSummaryResponse.toJson()}');
      if (taskSummaryResponse.status == 'success') {
        completedTaskCount =
            taskSummaryResponse.data!.summary!.completedTaskCount;
        incompleteTaskCount =
            taskSummaryResponse.data!.summary!.incompleteTaskCount;
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
        in response.data!.medicationSchedulesForDay!.schedules!) {
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
        completedMedicationCount = taskSummaryResponse.data!.summary!.taken! +
            taskSummaryResponse.data!.summary!.missed!;
        incompleteMedicationCount =
            taskSummaryResponse.data!.summary!.unknown! +
                taskSummaryResponse.data!.summary!.overdue! +
                taskSummaryResponse.data!.summary!.upcoming!;
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
    return BaseWidget<DashboardSummaryModel?>(
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

                for (int i = 0 ; i < RemoteConfigValues.homeScreenTile.length ; i++)...[
                  if(RemoteConfigValues.homeScreenTile[i] == 'Medications')
                    myMedication(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Nutrition')
                    myNutrition(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Physical Activity')
                    myActivity(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Mental Well-Being')
                    myStress(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Vitals')
                    myBiometrics(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Symptoms')
                    howAreYoursymptoms(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Lab Values')
                    mylipidProfile(),
                  if(RemoteConfigValues.homeScreenTile[i] == 'Knowledge')
                    knowledgeTree(),
                ],
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
                  SizedBox(
                    width: 8,
                  ),
                  ImageIcon(
                    AssetImage('res/images/ic_symptoms.png'),
                    size: 28,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Symptoms',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                  Expanded(
                    child: InfoOutlinedScreen(
                      tittle: 'Symptoms Information',
                      description:
                      'Symptom management can help a person track how they are feeling day-to-day to notice changes over time. ',
                      height: 200,
                      infoIconcolor: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 16,)
                ],
              ),
            ),
            Container(
              height: 108,
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: 'Symptom is Better',
                        button: true,
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'symptoms_better_button_click');
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
                                  color: Color(0XFF007E1A),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Better',
                                    style: TextStyle(
                                        color: Color(0XFF007E1A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'Symptom is Same',
                        button: true,
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'symptoms_same_button_click');
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
                                  color: textGrey,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Same',
                                    style: TextStyle(
                                        color: textGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'Symptom is Worse',
                        button: true,
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              progressDialog.show(max: 100, msg: 'Loading...');
                              FirebaseAnalytics.instance.logEvent(name: 'symptoms_worse_button_click');
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
                                  color: Color(0XFFC10E21),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Worse',
                                    style: TextStyle(
                                        color: Color(0XFFC10E21),
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
                  /*Positioned(
                    bottom: 0,
                    right: 0,
                    child: InfoOutlinedScreen(
                      tittle: 'Symptoms Information',
                      description:
                          'Symptom management can help a person track how they are feeling day-to-day to notice changes over time. ',
                      height: 200,
                      infoIconcolor: Colors.grey,
                    ),
                  )*/
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                                color: Color(0XFF007E1A),
                                border: Border.all(color: Colors.white),
                                borderRadius: new BorderRadius.all(Radius.circular(16.0))),*/
                          child: Center(
                            child: model.busy
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                                          color: Color(0XFF007E1A)),
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
                      Text('Medications',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Medication Information',
                        description:
                        'Taking medications as directed by your health care professional gives you the best opportunity to manage your chronic condition and maintain the best possible health for yourself.',
                        height: 220,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      Semantics(
                        label: 'Add medication',
                        child: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 32,
                              color: iconColor,
                            ),
                            onPressed: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_medication_button_click');
                              Navigator.pushNamed(
                                  context, RoutePaths.ADD_MY_MEDICATION, arguments: 'Dashboard');
                            }),
                      )
                    ],
                  ),

                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child:
                  /*model.busy
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : */
                  Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Have you taken your medications today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
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
                                  FirebaseAnalytics.instance.logEvent(name: 'medication_yes_button_click');
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
                                      color: Color(0XFF007E1A),
                                      size: 36,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Yes',
                                        style: TextStyle(
                                            color: Color(0XFF007E1A),
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
                                FirebaseAnalytics.instance.logEvent(name: 'medication_no_button_click');
                                Navigator.pushNamed(
                                    context, RoutePaths.My_Medications, arguments: 0);
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
                    ],
                  ),
                ],
              ),
            ),
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Nutrition Information',
                        description:
                        'A healthy diet and lifestyle are the keys to preventing and managing heart disease. Track your overall healthy eating pattern to keep your heart healthy such as eating whole foods, lots of fruits and vegetables, lean protein, nuts, seeds, and cooking in non-tropical oils.',
                        height: 260,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 32,
                            color: iconColor,
                            semanticLabel: 'Add Nutrition',
                          ),
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'add_nutrition_button_click');
                            Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                                arguments: '');
                          }),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Were most of your food choices healthy today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Semantics(
                            label: 'Yes, most of my food choices were healthy today.',
                            button: true,
                            child: InkWell(
                              onTap: () {
                                FirebaseAnalytics.instance.logEvent(name: 'nutrition_yes_button_click');
                                recordMyCaloriesConsumed(true);
                              },
                              child: ExcludeSemantics(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.thumb_up,
                                      color: Color(0XFF007E1A),
                                      size: 36,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Yes',
                                        style: TextStyle(
                                            color: Color(0XFF007E1A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Semantics(
                            label: 'No, most of my food choices were not healthy today.',
                            button: true,
                            child: InkWell(
                              onTap: () {
                                FirebaseAnalytics.instance.logEvent(name: 'nutrition_no_button_click');
                                Navigator.pushNamed(context, RoutePaths.My_Nutrition,
                                    arguments: '');
                                recordMyCaloriesConsumed(false);
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emergency() {
    String? discription = '';

    if (emergencyDashboardTile != null) {
      //debugPrint('Emergency ==> ${emergencyDashboardTile.date.difference(DateTime.now()).inDays}');
      if (emergencyDashboardTile!.date!.difference(DateTime.now()).inDays ==
          0) {
        discription = emergencyDashboardTile!.discription;
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
                    FontAwesomeIcons.kitMedical,
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
                          Icon(FontAwesomeIcons.home, color: Color(0XFF007E1A), size: 40,),
                          SizedBox(height: 6,),
                          Text('No I am good!',
                              style: TextStyle(
                                  color: Color(0XFF007E1A),
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
                          Text(discription!,
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
                              FontAwesomeIcons.truckMedical,
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
                            color: Color(0XFF007E1A),
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
                  Text('Knowledge',
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
              child: getAppType() == 'AHA' &&
                      knowledgeLinkDisplayedDate !=
                          dateFormat.format(DateTime.now())
                  ? InkWell(
                      onTap: () async {
                        final String url =
                            'https://supportnetwork.heart.org/s/';
                        initWebView(url);
                  // if (await canLaunchUrl(Uri.parse(url))) {
                  //   await launchUrl(Uri.parse(url));
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Visit: ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'https://supportnetwork.heart.org/s/',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
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
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: topicName.toString(),
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                          Linkify(
                onOpen: (link) async {
                  initWebView(link.url);
                },
                options: LinkifyOptions(humanize: false),
                text: briefInformation.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Montserrat'),
                linkStyle: TextStyle(color: hyperLinkTextColor),
              ),
                        ],
                      ),
              /*RichText(
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
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),*/
            ),
          ],
        ),
      ),
    );
  }

  initWebView(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await custom_web_wiew.launch(url,
        customTabsOption: custom_web_wiew.CustomTabsOption(
          toolbarColor: primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: custom_web_wiew.CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: custom_web_wiew.SafariViewControllerOption(
          preferredBarTintColor: primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: false,
          entersReaderIfAvailable: false,
          dismissButtonStyle: custom_web_wiew.SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Vitals Information',
                        description:
                        'An important aspect of lowering risk of cardiovascular disease, also called coronary artery disease (CAD) also known as https://www.heart.org/en/health-topics/consumer-healthcare/what-is-cardiovascular-disease/coronary-artery-disease, is managing health behaviors and risk factors, such as nutrition, physical activity, tobacco product usage, body mass index (BMI), weight, blood pressure, total cholesterol or blood glucose (blood sugar).',
                        height: 340,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 32,
                            color: iconColor,
                            semanticLabel: 'Add Vitals',
                          ),
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'add_vitals_button_click');
                            Navigator.pushNamed(context, RoutePaths.My_Vitals);
                          }),
                    ],
                  )
                ],
              ),
            ),
            Container(
                height: 148,
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(RemoteConfigValues.vitalScreenTile.contains('Weight'))
                        Semantics(
                          label: 'Add Weight',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_weight_button_click');
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_body_weight.png'),
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
                        if(RemoteConfigValues.vitalScreenTile.contains('Blood Pressure'))
                        Semantics(
                          label: "Add Blood Pressure",
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_blood_pressure_button_click');
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_blood_pressure.png'),
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
                        if(RemoteConfigValues.vitalScreenTile.contains('Blood Glucose'))
                        Semantics(
                          label: 'Add Blood Glucose',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_blood_glucose_button_click');
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
                                          border:
                                              Border.all(color: primaryColor),
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
                        if(RemoteConfigValues.vitalScreenTile.contains('Pulse Rate'))
                        Semantics(
                          label: 'Add Pulse',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_pulse_button_click');
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
                                          border:
                                              Border.all(color: primaryColor),
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
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget mylipidProfile() {
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
                        AssetImage('res/images/ic_lab_management.png'),
                        size: 24,
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Lab Values',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Lab Values Information',
                        description:
                        'Cholesterol circulates in the blood. As the amount of cholesterol in your blood increases, so does the risk to your health. High cholesterol contributes to a higher risk of cardiovascular diseases, such as heart disease and stroke. That’s why it’s important to have your cholesterol tested, so you can know your levels and track them here. ',
                        height: 288,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 32,
                            color: iconColor,
                            semanticLabel: 'Add Lab records',
                          ),
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'add_lab_records_button_click');
                            Navigator.pushNamed(context, RoutePaths.Lipid_Profile);
                          }),
                    ],
                  )
                ],
              ),
            ),
            Container(
                height: 140,
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Add total cholestrol',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_total_cholesterol_button_click');
                              Navigator.pushNamed(context,
                                  RoutePaths.Lipid_Profile_Total_Cholesterol);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_total_cholesterol.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Total\nCholesterol',
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
                          label: 'Add LDL',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_ldl_button_click');
                              Navigator.pushNamed(
                                  context, RoutePaths.Lipid_Profile_LDL);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage('res/images/ic_ldl.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('LDL',
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
                          label: "Add HDL",
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_hdl_button_click');
                              Navigator.pushNamed(
                                  context, RoutePaths.Lipid_Profile_HDL);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage('res/images/ic_hdl.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('HDL',
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
                          label: 'Add triglycerides',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'add_triglycerides_button_click');
                              Navigator.pushNamed(context,
                                  RoutePaths.Lipid_Profile_Triglyceroid);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_triglycerides.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Triglycerides',
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
                        /*Semantics(
                          label: 'Add A1C Level',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.Lipid_Profile_A1CLevel);
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
                                        AssetImage(
                                            'res/images/ic_a1c_level.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('A1C Level',
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
                        ),*/
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget myNutritionOld() {
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                      InfoScreen(
                        tittle: 'Nutrition Information',
                        description:
                            'Aim for an overall healthy eating pattern to keep your heart healthy such as eating whole foods, lots of fruits and vegetables, lean protein, nuts, seeds, and cooking in non-tropical oils.',
                        height: 220,
                        infoIconcolor: Colors.white,
                      ),
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
                      label: 'Add Snack',
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
                                    AssetImage('res/images/ic_snack.png'),
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
                      Text('Physical Activity',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Physical Activity Information',
                        description:
                        'Get at least 150 minutes per week of moderate-intensity aerobic activity or 75 minutes per week of vigorous aerobic activity (or a combination of both), preferably spread throughout the week. Physical activity relieves stress, improves mood, gives you energy, helps with sleep and can lower your risk of chronic disease, including dementia and depression.',
                        height: 288,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                          padding: EdgeInsets.only(left: 6, bottom: 8, right: 16),
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.add_circle,
                            size: 32,
                            color: iconColor,
                            semanticLabel: 'Add physical activity',
                          ),
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'add_physical_activity_button_click');
                            Navigator.pushNamed(
                                context, RoutePaths.My_Activity_Trends,
                                arguments: 0);
                          }),
                    ],
                  )
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: "Stand",
                          button: true,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.My_Activity_Trends,
                                  arguments: 1);
                            },
                            child: Container(
                              height: 96,
                              child: ExcludeSemantics(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          border:
                                              Border.all(color: primaryColor),
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
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'Steps',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.My_Activity_Trends,
                                  arguments: 1);
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
                                          border:
                                              Border.all(color: primaryColor),
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
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'Exercise',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePaths.My_Activity_Trends,
                                  arguments: 1);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_exercise.png'),
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
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        */
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Did you add movement to your day today?',
                            style: TextStyle(
                                color: textBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat')),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Semantics(
                              label: 'Yes, I had movement today.',
                              button: true,
                              child: InkWell(
                                onTap: () {
                                  FirebaseAnalytics.instance.logEvent(name: 'physical_activity_yes_button_click');
                                  recordMyPhysicalActivity(true);
                                  Navigator.pushNamed(
                                      context, RoutePaths.My_Activity_Trends,
                                      arguments: 0);
                                },
                                child: ExcludeSemantics(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.thumb_up,
                                        color: Color(0XFF007E1A),
                                        size: 36,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Yes',
                                          style: TextStyle(
                                              color: Color(0XFF007E1A),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: 'No, I don\'t had any movement today.',
                              button: true,
                              child: InkWell(
                                onTap: () {
                                  FirebaseAnalytics.instance.logEvent(name: 'physical_activity_no_button_click');
                                  recordMyPhysicalActivity(false);
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
                      ],
                    ),
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
                      Text('Mental Well-Being',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InfoOutlinedScreen(
                        tittle: 'Mental Well-Being Information',
                        description:
                        'Practicing meditation or mindfulness may help you manage stress and high blood pressure. It also may help you sleep better, feel more balanced and connected and possibly lower your risk of heart disease.',
                        height: 240,
                        infoIconcolor: Colors.grey,
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 32,
                            color: iconColor,
                            semanticLabel: 'Add mental well-being record'
                          ),
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'add_mental_well_being_button_click');
                            Navigator.pushNamed(context, RoutePaths.My_Activity_Mindfullness,
                                arguments: 0);
                          }),
                    ],
                  )
                ],
              ),
            ),
            Container(
                color: primaryLightColor,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Sleep',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              /*Navigator.pushNamed(
                                  context, RoutePaths.MY_STRESS);*/
                              FirebaseAnalytics.instance.logEvent(name: 'mental_well_being_sleep_button_click');
                              Navigator.pushNamed(context, RoutePaths.My_Activity_Mindfullness,
                                  arguments: 1);
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
                                          border:
                                              Border.all(color: primaryColor),
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
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: "Mindfulness",
                          button: true,
                          child: InkWell(
                            onTap: () {
                             /* Navigator.pushNamed(
                                  context, RoutePaths.MY_STRESS);*/
                              FirebaseAnalytics.instance.logEvent(name: 'mental_well_being_mindfulness_button_click');
                              Navigator.pushNamed(context, RoutePaths.My_Activity_Mindfullness,
                                  arguments: 1);
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
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/ic_medication.png'),
                                        size: 32,
                                        color: iconColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Mindfulness',
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
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _emergencyDetailDialog(bool isEdit) async {
    if (isEdit) {
      emergencyDetailsTextControler.text = emergencyDashboardTile!.discription!;
      emergencyDetailsTextControler.selection = TextSelection.fromPosition(
        TextPosition(offset: emergencyDetailsTextControler.text.length),
      );
    }
    showDialog(
        barrierDismissible: false,
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
        topicId = knowledgeTopicResponse.data!.knowledgeNugget!.id;
        topicName = knowledgeTopicResponse.data!.knowledgeNugget!.topicName;
        briefInformation =
            knowledgeTopicResponse.data!.knowledgeNugget!.briefInformation;
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
      final map = <String, String?>{};
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
        showSuccessToast('Emergency details saved successfully!', context);
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
            'Medication Length ==> ${getMyMedicationsResponse.data!.medicationSchedulesForDay!.schedules!.length}');
        if (getMyMedicationsResponse
            .data!.medicationSchedulesForDay!.schedules!.isNotEmpty) {
          currentMedicationList.addAll(getMyMedicationsResponse
              .data!.medicationSchedulesForDay!.schedules!);
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
      final medicationIds = <String?>[];
      for (final item in currentMedicationList) {
        //debugPrint(item.timeScheduleEnd.toString() +'  '+ DateTime.now().toString() +'  '+DateTime.now().isAfter(DateTime.parse(item.timeScheduleEnd)).toString());
        if (DateTime.now().isAfter(item.timeScheduleStart!) &&
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
          //progressDialog.close();
          showSuccessToast(baseResponse.message!, context);
          getMyMedications();
        } else {
          showToast(baseResponse.message!, context);
          //progressDialog.close();
          showToast(baseResponse.message!, context);
        }
      } else {
        showToast('You have taken all the medication till now.', context);
      }
    } catch (CustomException) {
      //progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  recordMyCaloriesConsumed(bool ateHealthyFood) async {
    try {
      var list = ['GenericNutrition'];

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['FoodTypes'] = list;
      map['UserResponse'] = ateHealthyFood;

      final BaseResponse baseResponse =
          await model.recordMyCaloriesConsumed(map);
      if (baseResponse.status == 'success') {
        if(ateHealthyFood) {
          showSuccessToast('Yes, most of my food choices were healthy today.', context);
        }else{
          //showSuccessToast('No, most of my food choices were not healthy today.', context);
        }
      } else {}
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }

  recordMyPhysicalActivity(bool haveYouDoneWithPhysicalActivity) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['PhysicalActivityQuestionAns'] = haveYouDoneWithPhysicalActivity;

      final BaseResponse baseResponse =
      await model.recordMyPhysicalHealth(map);
      if (baseResponse.status == 'success') {
        if(haveYouDoneWithPhysicalActivity) {
          //showToast('Yes, I had movement today.', context);
        }else{
          showSuccessToast('Okay, try to add movement to your day it will help you to stay healthy.', context);
        }
      } else {}
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
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

        //showToast(baseResponse.message, context);
        if (feeling == 1) {
          showSuccessToast('Good to hear that', context);
        } else if (feeling == 0) {
          showSuccessToast('Please follow your medications', context);
        } else if (feeling == -1) {
          getSymptomAssesmentTemplete();
        }
      } else {
        progressDialog.close();
        showToast(baseResponse.error!, context);
        //progressDialog.close();
        // showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      progressDialog.close();
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
        progressDialog.close();
        Navigator.pushNamed(context, RoutePaths.Symptoms,
            arguments: searchSymptomAssesmentTempleteResponse
                .data!.symptomAssessmentTemplates!.items!
                .elementAt(0)
                .id);
        setState(() {});
      } else {
        progressDialog.close();
        //showToast(knowledgeTopicResponse.message);
      }
    } on FetchDataException catch (e) {
      progressDialog.close();
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }
}
