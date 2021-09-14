import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/ui/shared/app_colors.dart';

StartCarePlanResponse startCarePlanResponseGlob;
List<String> goalPlanScreenStack = new List<String>();
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
var dummyNumberList = new List<String>();
String _currentLocale = "";

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

setImage(String url) {
  CachedNetworkImage(
    imageUrl:
        "https://lh3.googleusercontent.com/a-/AOh14GhzcCR4O6GwUKtpzxuls_PRvD7mgvcuCrse5l4O1w=s88-c-k-c0x00ffffff-no-rj-mo",
    placeholder: (context, url) => new CircularProgressIndicator(),
    errorWidget: (context, url, error) => new Icon(Icons.error),
  );
}

circularImage() {
  CircleAvatar(
    radius: 48,
    backgroundColor: primaryColor,
    child: CircleAvatar(
        radius: 48,
        backgroundImage: "profileImage" == ""
            ? AssetImage('res/images/profile_placeholder.png')
            : setImage("profileImage")),
  );
}

String calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}
