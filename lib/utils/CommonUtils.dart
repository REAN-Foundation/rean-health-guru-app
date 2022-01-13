import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/FAQChatModelPojo.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:phone_number/phone_number.dart';

import 'SharedPrefUtils.dart';

StartCarePlanResponse startCarePlanResponseGlob;
List<String> goalPlanScreenStack = <String>[];
/*StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponseGlobe;

void setStartTaskOfAHACarePlanResponse(StartTaskOfAHACarePlanResponse response) {
  _startTaskOfAHACarePlanResponseGlobe = response;
}

StartTaskOfAHACarePlanResponse getStartTaskOfAHACarePlanResponse() {
  return _startTaskOfAHACarePlanResponseGlobe;
}*/

bool _isLogin = false;
String _baseUrl = '';
Task _task;
String countryCodeGlobe = '';
var dummyNumberList = <String>[];
String _currentLocale = '';
String _appName = '';
dynamic _roleId = '';
final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
String knowledgeLinkDisplayedDate = '';
String dailyCheckInDate = '';
var chatList = <FAQChatModelPojo>[];
var dateFormatGraphStandard = DateFormat('MMM dd, yyyy');
PhoneNumberUtil plugin = PhoneNumberUtil();
String dailyMood = '';
String dailyFeeling = '';
List<String> dailyEnergyLevels = [];

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
  dummyNumberList.add('6123612361');
  dummyNumberList.add('5512355123');
  dummyNumberList.add('1234567890');
}

void setTask(Task response) {
  _task = response;
}

Task getTask() {
  return _task;
}

void setRoleId(dynamic roleId) {
  _roleId = roleId;
}

dynamic getRoleId() {
  return _roleId;
}

void setAppType(String name) {
  _appName = name;
}

String getAppType() {
  return _appName;
}

void setSessionFlag(bool loginValue) {
  _isLogin = loginValue;
}

bool getSessionFlag() {
  return _isLogin;
}

void setBaseUrl(String baseUrl) {
  _baseUrl = baseUrl;
}

String getBaseUrl() {
  return _baseUrl;
}

String getCurrentLocale() {
  return _currentLocale;
}

String setCurrentLocale(String locale) {
  _currentLocale = locale;
}

void showToast(String msg, BuildContext context) {
  FocusManager.instance.primaryFocus.unfocus();
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
  FocusManager.instance.primaryFocus.unfocus();
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.SNACKBAR,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

setImage(String url) {
  CachedNetworkImage(
    imageUrl:
        'https://lh3.googleusercontent.com/a-/AOh14GhzcCR4O6GwUKtpzxuls_PRvD7mgvcuCrse5l4O1w=s88-c-k-c0x00ffffff-no-rj-mo',
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
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
