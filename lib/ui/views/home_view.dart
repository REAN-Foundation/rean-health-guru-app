import 'dart:async';
import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/common_config_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/views/dashboard.dart';
import 'package:paitent/ui/views/dashboard_ver_1.dart';
import 'package:paitent/ui/views/emergency_contact.dart';
import 'package:paitent/ui/views/myReportsUpload.dart';
import 'package:paitent/ui/views/pdfViewer.dart';
import 'package:paitent/ui/views/search_doctor_list_view.dart';
import 'package:paitent/ui/views/search_lab_list_view.dart';
import 'package:paitent/ui/views/search_pharmacy_list_view.dart';
import 'package:paitent/ui/views/view_my_appoinment.dart';
import 'package:paitent/ui/widgets/fab_bottom_app_bar.dart';
import 'package:paitent/utils/CoachMarkUtilities.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/GetAllConfigrations.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringConstant.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'base_widget.dart';
import 'care_plan_task.dart';
import 'dashboard_ver_2.dart';
import 'edit_profile_view.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

import 'login_with_otp_view.dart';

class HomeView extends StatefulWidget {

  int screenPosition = 0;

  HomeView(int screenPosition){
    this.screenPosition = screenPosition;
  }

  @override
  _HomeViewState createState() => _HomeViewState(screenPosition);
}

class _HomeViewState extends State<HomeView> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  String name = "";
  List<Address> addresses;
  Address first;
  int _currentNav = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String pathPDF = "";
  var model = CommonConfigModel();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey key = GlobalKey();

  var _searchDoctorListView = SearchDoctorListView();
  var _searchLabListView = SearchLabListView();
  String profileImage = "";
  String _lastSelected = 'TAB: 0';

  GlobalKey _keyNavigation_drawer = new GlobalKey();
  GlobalKey _keyMyTasks = new GlobalKey();
  GlobalKey _keyUploadReports = new GlobalKey();
  GlobalKey _keyViewAppointments = new GlobalKey();
  GlobalKey _keyEmergencyContacts = new GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  CoachMarkUtilites coackMarkUtilites = new CoachMarkUtilites();

  _HomeViewState(int screenPosition){
    this._currentNav = screenPosition;
  }

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      Patient patient = Patient.fromJson(await _sharedPrefUtils.read("patientDetails"));
      auth = user.data.accessToken;
      patientUserId = user.data.user.userId;
      patientGender = patient.gender;
      //debugPrint(user.toJson().toString());

     /* */
      setState(() {
        //debugPrint('Gender ==> ${patient.gender.toString()}');
        name = patient.firstName;
        profileImage = patient.imageURL == null ? "" : patient.imageURL;
      });

      if(!user.data.user.verifiedPhoneNumber || user.data.user.verifiedPhoneNumber == null ){
        startCarePlanResponseGlob = null;
        _sharedPrefUtils.save("CarePlan", null);
        _sharedPrefUtils.saveBoolean("login", null);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return LoginWithOTPView();
            }), (Route<dynamic> route) => false);
      }

      //if(!isCoachMarkDisplayed) {

      //}

    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  getCarePlanSubscribe() async{
    try {
      if (_sharedPrefUtils.read("CarePlan") == null) {

      } else {
        startCarePlanResponseGlob = StartCarePlanResponse.fromJson(
            await _sharedPrefUtils.read("CarePlan"));
        //debugPrint("CarePlan ==> ${startCarePlanResponseGlob.data.carePlan.carePlanCode}");
      }
      Timer(Duration(seconds: 3), () {
        getCarePlan();
      });
      Future.delayed(
        Duration(seconds: 4),
            () => GetAllConfigrations(),
      );
    } catch (Excepetion){
      Timer(Duration(seconds: 3), () {
        getCarePlan();
      });
      Future.delayed(
        Duration(seconds: 4),
            () => GetAllConfigrations(),
      );
    }
  }

  getCarePlan() async {
    try {
      StartCarePlanResponse startCarePlanResponse =
      await model.getCarePlan();
      debugPrint("Registered Care Plan ==> ${startCarePlanResponse.toJson()}");
      if (startCarePlanResponse.status == 'success') {
        if(startCarePlanResponse.data.carePlan != null){
          debugPrint("Care Plan");
          _sharedPrefUtils.save("CarePlan", startCarePlanResponse.toJson());
          startCarePlanResponseGlob = startCarePlanResponse;
        }
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

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      debugPrint(
          'Latitude = ${currentLocation.latitude} Longitude = ${currentLocation.longitude}');
      findOutCityFromGeoCord(
          currentLocation.latitude, currentLocation.longitude);
    });
  }

  void findOutCityFromGeoCord(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    debugPrint("${first.featureName} : ${first.locality}");
  }

  void _selectedTab(int index) {
    print('Selected Tab ${index}');
    setState(() {
      _currentNav = index;
      _lastSelected = 'TAB: $index';
    });
  }


  void _layout(_) async {
    Future.delayed(Duration(milliseconds: 1000));
    bool isCoachMarkDisplayed = false;

    isCoachMarkDisplayed = await _sharedPrefUtils.readBoolean(StringConstant.Is_Home_View_Coach_Mark_Completed);

    debugPrint('isCoachMarkDisplayed ==> ${isCoachMarkDisplayed}');
    if(!isCoachMarkDisplayed || isCoachMarkDisplayed == null) {
      Future.delayed(const Duration(seconds: 2), () => showTutorial());
      //showTutorial();
    }
  }

  /*void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black,
      alignSkip : Alignment.topRight,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }*/

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets, onCoachMartkFinish: (){
      _sharedPrefUtils.saveBoolean(StringConstant.Is_Home_View_Coach_Mark_Completed, true);
      debugPrint("Coach Mark Finish");
    },
    onCoachMartkSkip: (){
      _sharedPrefUtils.saveBoolean(StringConstant.Is_Home_View_Coach_Mark_Completed, true);
      debugPrint("Coach Mark Skip");
    },
    onCoachMartkClickTarget: (target){
      debugPrint("Coach Mark target click");
    },
    onCoachMartkClickOverlay: (){
      debugPrint("Coach Mark overlay click");
    }
    )..show();
  }

  void initTargets() async {
    targets.add(coackMarkUtilites.getTargetFocus(_keyNavigation_drawer, (targets.length + 1).toString(), 'Navigation menu', 'Update your Profile, Add Vitals and Medical information.', CoachMarkContentPosition.bottom));
    targets.add(coackMarkUtilites.getTargetFocus(_keyMyTasks, (targets.length + 1).toString(), 'Daily Tasks', 'Keep a watch on your Daily Tasks.', CoachMarkContentPosition.top));
    targets.add(coackMarkUtilites.getTargetFocus(_keyUploadReports, (targets.length + 1).toString(), 'Upload Reports', 'Upload all your reports here.', CoachMarkContentPosition.top));
    //targets.add(GetTargetFocus.getTargetFocus(_keyViewAppointments, (targets.length + 1).toString(), 'Appointments List', 'View all your Appointments here.', CoachMarkContentPosition.top));
    targets.add(coackMarkUtilites.getTargetFocus(_keyEmergencyContacts, (targets.length + 1).toString(), 'Emergency Contacts', 'Add your Emergency Contacts here.', CoachMarkContentPosition.top));

  }


  @override
  void initState()  {
    //Future.delayed(const Duration(seconds: 4), () => getLocation());
    getCarePlanSubscribe();
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_layout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    //UserData data = UserData.fromJson(_sharedPrefUtils.read("user"));
    //debugPrint(_sharedPrefUtils.read("user"));

    Widget screen;
    switch (_currentNav) {
      case 0:
        screen = DashBoardVer2View(positionToChangeNavigationBar: (int tabPosition){
          print('Tapped Tab ${tabPosition}');
          _selectedTab(tabPosition);
        },);
        break;
      case 1:
        screen = CarePlanTasksView();
        break;
      case 2:
        screen = MyReportsView();
        break;
      /*case 3:
        screen = ViewMyAppointment();
        break;*/
      case 3:
        screen = EmergencyContactView();
        break;
    }

    return BaseWidget<CommonConfigModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: AppBar(
              elevation: 10.0,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: RichText(
                text: TextSpan(
                  text: 'Hi, ',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryColor, fontFamily: 'Montserrat')),
                  ],
                ),
              ),
              iconTheme: new IconThemeData(color: Colors.black),
              leading: InkWell(
                onTap: (){
                  _scaffoldKey.currentState.openDrawer();
                },
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                  child: /*CircleAvatar(
                    radius: 48,
                    backgroundColor: primaryLightColor,
                    child: CircleAvatar(
                        radius: 48,
                        backgroundImage:  profileImage == "" ? AssetImage('res/images/profile_placeholder.png') : new NetworkImage(profileImage)),
                  )*/
                  Semantics(
                    label: 'navigation_drawer',
                    child: Container(
                      key: _keyNavigation_drawer,
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image: profileImage == ""
                              ? AssetImage('res/images/profile_placeholder.png')
                              : new CachedNetworkImageProvider(profileImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.deepPurple,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              /*
              actions: <Widget>[
                Badge(
                  position: BadgePosition.topRight(top: 4, right: 4),
                  animationType: BadgeAnimationType.scale,
                  badgeColor: primaryColor,
                  badgeContent: Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon: new Image.asset("res/images/ic_notification.png"),
                    onPressed: () {
                      debugPrint("Clicked on notification icon");
                    },
                  ),
                ),
              ],
              */
            ),
          ),
          drawer: AppDrawer(),
          body: SizedBox.expand(child: screen),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                ),
              ],),
            child: BottomNavigationBar(
              backgroundColor: primaryColor,
              currentIndex: _currentNav,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              elevation: 8.0,
              items: [
                BottomNavigationBarItem(
                  icon: _currentNav == 0
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              new Image.asset('res/images/ic_home_colored.png'))
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child: new Image.asset('res/images/ic_home.png')),
                  title: Container(height: 10.0),
                ),
                BottomNavigationBarItem(
                  icon: _currentNav == 1
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: new Image.asset(
                              'res/images/ic_daily_tasks_colored.png'))
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child: new Image.asset('res/images/ic_daily_tasks.png', key: _keyMyTasks,)),
                  title: Container(height: 10.0),
                ),
                BottomNavigationBarItem(
                  icon: _currentNav == 2
                      ? SizedBox(
                          height: 28,
                          width: 28,
                          child:
                              new Image.asset('res/images/ic_upload_files_colored.png'))
                      : SizedBox(
                          height: 28,
                          width: 28,
                          child: new Image.asset('res/images/ic_upload_files.png', key: _keyUploadReports,)),
                  title: Container(height: 10.0),
                ),
                /*BottomNavigationBarItem(
                  icon: _currentNav == 3
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: new Image.asset(
                              'res/images/ic_calender_bottom_bar_colored.png'))
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              new Image.asset('res/images/ic_calender_bottom_bar.png', key: _keyViewAppointments,)),
                  title: Container(height: 10.0),
                ),*/
                BottomNavigationBarItem(
                  icon: _currentNav == 3
                      ? SizedBox(
                      height: 24,
                      width: 24,
                      child: new Image.asset(
                          'res/images/ic_call_colered.png'))
                      : SizedBox(
                      height: 24,
                      width: 24,
                      child:
                      new Image.asset('res/images/ic_call.png', key: _keyEmergencyContacts,)),
                  title: Container(height: 10.0),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentNav = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }


}
//right_arrow
