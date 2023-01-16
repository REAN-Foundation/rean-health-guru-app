import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as date;
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/models/get_weekly_care_plan_status.dart';
import 'package:patient/features/common/chat_bot/models/faq_chat_model_pojo.dart';
import 'package:patient/features/common/medication/models/my_current_medication.dart' as med;
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:phone_number/phone_number.dart';

GetCarePlanEnrollmentForPatient? carePlanEnrollmentForPatientGlobe;
GetWeeklyCarePlanStatus? weeklyCarePlanStatusGlobe;
List<String> goalPlanScreenStack = <String>[];
/*StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponseGlobe;

void setStartTaskOfAHACarePlanResponse(StartTaskOfAHACarePlanResponse response) {
  _startTaskOfAHACarePlanResponseGlobe = response;
}

StartTaskOfAHACarePlanResponse getStartTaskOfAHACarePlanResponse() {
  return _startTaskOfAHACarePlanResponseGlobe;
}*/

bool _isLogin = false;
String? _baseUrl = '';
late UserTask _task;
String? countryCodeGlobe = '';
var dummyNumberList = <String>[];
bool isDummyNumber = false;
String? _currentLocale = '';
String _appName = '';
String _appType = '';
String _appFlavour = '';
String _sponsor = '';
dynamic _roleId = '';
final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
String knowledgeLinkDisplayedDate = '';
String dailyCheckInDate = '';
var chatList = <FAQChatModelPojo>[];
var dateFormatGraphStandard = date.DateFormat('MMM dd, yyyy');
PhoneNumberUtil plugin = PhoneNumberUtil();
String dailyMood = '';
String dailyFeeling = '';
List<String> dailyEnergyLevels = [];
List<String> createdGoalsIds = [];
var healthSystemGlobe;
var healthSystemHospitalGlobe;
med.Items? globeMedication;

setUpDummyNumbers() {
  dummyNumberList.add('1231231231');
  dummyNumberList.add('1234567890');
  dummyNumberList.add('1231231232');
  dummyNumberList.add('1231231233');
  dummyNumberList.add('1231231234');
  dummyNumberList.add('1231231235');
  dummyNumberList.add('1231231236');
  dummyNumberList.add('1231231237');
  dummyNumberList.add('1231231238');
  dummyNumberList.add('1231231239');
  dummyNumberList.add('1231231240');
  dummyNumberList.add('1231231241');
  dummyNumberList.add('1231231242');
  dummyNumberList.add('1231231243');
  dummyNumberList.add('1231231244');
  dummyNumberList.add('1231231245');
  dummyNumberList.add('1231231246');
  dummyNumberList.add('1231231247');
  dummyNumberList.add('1231231248');
  dummyNumberList.add('1231231249');
  dummyNumberList.add('1231231250');
  dummyNumberList.add('1231231251');
  dummyNumberList.add('1231231252');
  dummyNumberList.add('1231231253');
  dummyNumberList.add('1231231254');
  dummyNumberList.add('1231231255');
  dummyNumberList.add('1231231256');
  dummyNumberList.add('1231231257');
  dummyNumberList.add('1231231258');
  dummyNumberList.add('1231231259');
  dummyNumberList.add('1231231260');
  dummyNumberList.add('1231231261');
  dummyNumberList.add('1231231262');
  dummyNumberList.add('1231231263');
  dummyNumberList.add('1231231264');
  dummyNumberList.add('1231231265');
  dummyNumberList.add('1231231266');
  dummyNumberList.add('1231231267');
  dummyNumberList.add('1231231268');
  dummyNumberList.add('1231231269');
  dummyNumberList.add('1231231270');
  dummyNumberList.add('1231231271');
  dummyNumberList.add('1231231272');
  dummyNumberList.add('1231231273');
  dummyNumberList.add('1231231274');
  dummyNumberList.add('1231231275');
  dummyNumberList.add('1231231276');
  dummyNumberList.add('1231231277');
  dummyNumberList.add('1231231278');
  dummyNumberList.add('1231231279');
  dummyNumberList.add('1231231280');
  dummyNumberList.add('1231231281');
  dummyNumberList.add('1231231282');
  dummyNumberList.add('1231231283');
  dummyNumberList.add('1231231284');
  dummyNumberList.add('1231231285');
  dummyNumberList.add('1231231286');
  dummyNumberList.add('1231231287');
  dummyNumberList.add('1231231289');
  dummyNumberList.add('1231231289');
  dummyNumberList.add('1231231290');
  dummyNumberList.add('1231231291');
  dummyNumberList.add('1231231292');
  dummyNumberList.add('1231231293');
  dummyNumberList.add('1231231294');
  dummyNumberList.add('1231231295');
  dummyNumberList.add('1231231296');
  dummyNumberList.add('1231231297');
  dummyNumberList.add('1231231298');
  dummyNumberList.add('1231231299');
  dummyNumberList.add('1231231200');
  dummyNumberList.add('6123612361');
  dummyNumberList.add('5512355123');
  dummyNumberList.add('1234567890');
  dummyNumberList.add('123456789');
}

void setTask(UserTask response) {
  _task = response;
}

UserTask getTask() {
  return _task;
}

void setRoleId(dynamic roleId) {
  _roleId = roleId;
}

dynamic getRoleId() {
  return _roleId;
}

void setSponsor(String name) {
  _sponsor = name;
}

String getSponsor() {
  return _sponsor;
}

void setAppType(String name) {
  _appType = name;
}

String getAppType() {
  return _appType;
}

void setAppFlavour(String appFlavour) {
  _appFlavour = appFlavour;
}

String getAppFlavour() {
  return _appFlavour;
}

void setAppName(String name) {
  _appName = name;
}

String getAppName() {
  return _appName;
}

void setSessionFlag(bool loginValue) {
  _isLogin = loginValue;
}

bool getSessionFlag() {
  return _isLogin;
}

void setBaseUrl(String? baseUrl) {
  _baseUrl = baseUrl;
}

String? getBaseUrl() {
  return _baseUrl;
}

String getCurrentLocale() {
  return _currentLocale.toString();
}

setCurrentLocale(String? locale) {
  _currentLocale = locale;
}

void showToast(String msg, BuildContext context) {
  FocusManager.instance.primaryFocus!.unfocus();
  /*Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );*/
  final snackBar = SnackBar(
    content: Text(msg),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showToastMsg(String msg, BuildContext context) {
  if (Platform.isAndroid) {
    SemanticsService.announce('', TextDirection.ltr);
  } else {
    Future.delayed(const Duration(milliseconds: 500), () {
      SemanticsService.announce(msg, TextDirection.ltr);
    });
  }
  FocusManager.instance.primaryFocus!.unfocus();
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.SNACKBAR,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

void announceText(String text) {
  //SemanticsService.announce('I am saying something', TextDirection.ltr);
  SemanticsService.announce(text, TextDirection.ltr);
}

hideKeyboard(){
  FocusManager.instance.primaryFocus!.unfocus();
}

setImage(String url) {
  CachedNetworkImage(
    imageUrl:
    'https://lh3.googleusercontent.com/a-/AOh14GhzcCR4O6GwUKtpzxuls_PRvD7mgvcuCrse5l4O1w=s88-c-k-c0x00ffffff-no-rj-mo',
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

circularImage() {
  CircleAvatar(
    radius: 48,
    backgroundColor: primaryColor,
    child: CircleAvatar(
        radius: 48,
        backgroundImage: 'profileImage' == ''
            ? AssetImage('res/images/profile_placeholder.png')
            : setImage('profileImage')),
  );
}

String calculateAge(DateTime birthDate) {
  final DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  final int month1 = currentDate.month;
  final int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    final int day1 = currentDate.day;
    final int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString();
}

getKnowdledgeLinkLastViewDate() async {
  try {
    knowledgeLinkDisplayedDate =
    await _sharedPrefUtils.read("knowledgeLinkDisplayedDate");
    debugPrint('knowledgeLinkDisplayedDate ==> $knowledgeLinkDisplayedDate ');
  } catch (Excepetion) {
    // do something
  }
  //return knowledgeLinkDisplayedDate ?? '';
}

setKnowdledgeLinkLastViewDate(String viewedDate) async {
  try {
    _sharedPrefUtils.save("knowledgeLinkDisplayedDate", viewedDate);
  } catch (Excepetion) {
    // do something
  }
  //return knowledgeLinkDisplayedDate ?? '';
}

getDailyCheckInDate() async {
  try {
    dailyCheckInDate = await _sharedPrefUtils.read("dailyCheckInDate");
    debugPrint('dailyCheckInDate ==> $dailyCheckInDate ');
  } catch (Excepetion) {
    // do something

  }
  //return knowledgeLinkDisplayedDate ?? '';
}

setDailyCheckInDate(String viewedDate) async {
  try {
    _sharedPrefUtils.save("dailyCheckInDate", viewedDate);
  } catch (Excepetion) {
    // do something
  }
  //return knowledgeLinkDisplayedDate ?? '';
}

Future<bool> isValidPhoneNumber(String phone, String code) async {
  debugPrint(
      "isValidPhoneNumber ${code + '-' + phone}  == ${await plugin.validate(code + phone, code)}");
  return plugin.validate(code + '-' + phone, code);
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}
