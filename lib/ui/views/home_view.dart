import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/common_config_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/emergency_contact.dart';
import 'package:paitent/ui/views/myReportsUpload.dart';
import 'package:paitent/utils/CoachMarkUtilities.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/GetAllConfigrations.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringConstant.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'base_widget.dart';
import 'care_plan_task.dart';
import 'dashboard_ver_2.dart';
import 'login_with_otp_view.dart';
//ignore: must_be_immutable
class HomeView extends StatefulWidget {
  int screenPosition = 0;

  HomeView(int screenPosition) {
    this.screenPosition = screenPosition;
  }

  @override
  _HomeViewState createState() => _HomeViewState(screenPosition);
}

class _HomeViewState extends State<HomeView> {
  /*Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<Address> addresses;
  Address first;*/
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = '';
  int _currentNav = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pathPDF = '';
  var model = CommonConfigModel();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey key = GlobalKey();

  String profileImage = '';

  final GlobalKey _keyNavigation_drawer = GlobalKey();
  final GlobalKey _keyMyTasks = GlobalKey();
  final GlobalKey _keyUploadReports = GlobalKey();
  final GlobalKey _keyEmergencyContacts = GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  CoachMarkUtilites coackMarkUtilites = CoachMarkUtilites();

  _HomeViewState(int screenPosition) {
    _currentNav = screenPosition;
  }

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      auth = user.data.accessToken;
      patientUserId = user.data.user.userId;
      patientGender = patient.gender;
      //debugPrint(user.toJson().toString());

      /* */
      setState(() {
        //debugPrint('Gender ==> ${patient.gender.toString()}');
        name = patient.firstName;
        profileImage = patient.imageURL ?? '';
      });

      if (!user.data.user.verifiedPhoneNumber ||
          user.data.user.verifiedPhoneNumber == null) {
        startCarePlanResponseGlob = null;
        _sharedPrefUtils.save('CarePlan', null);
        _sharedPrefUtils.saveBoolean('login', null);
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

  getCarePlanSubscribe() async {
    try {
      if (_sharedPrefUtils.read('CarePlan') == null) {
      } else {
        startCarePlanResponseGlob = StartCarePlanResponse.fromJson(
            await _sharedPrefUtils.read('CarePlan'));
        //debugPrint("CarePlan ==> ${startCarePlanResponseGlob.data.carePlan.carePlanCode}");
      }
      Timer(Duration(seconds: 3), () {
        getCarePlan();
      });
      Future.delayed(
        Duration(seconds: 4),
        () => GetAllConfigrations(),
      );
    } catch (Excepetion) {
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
      final StartCarePlanResponse startCarePlanResponse =
          await model.getCarePlan();
      debugPrint('Registered Care Plan ==> ${startCarePlanResponse.toJson()}');
      if (startCarePlanResponse.status == 'success') {
        if (startCarePlanResponse.data.carePlan != null) {
          debugPrint('Care Plan');
          _sharedPrefUtils.save('CarePlan', startCarePlanResponse.toJson());
          startCarePlanResponseGlob = startCarePlanResponse;
        }
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

  void getLocation() {
    /*_serviceEnabled = await location.serviceEnabled();
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
    });*/
  }

  void findOutCityFromGeoCord(double lat, double long) {
    /*final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    debugPrint("${first.featureName} : ${first.locality}");*/
  }

  void _selectedTab(int index) {
    debugPrint('Selected Tab $index');
    setState(() {
      _currentNav = index;
    });
  }

  _layout(_) async {
    Future.delayed(Duration(milliseconds: 1000));
    bool isCoachMarkDisplayed = false;

    isCoachMarkDisplayed = await _sharedPrefUtils
        .readBoolean(StringConstant.Is_Home_View_Coach_Mark_Completed);

    debugPrint('isCoachMarkDisplayed ==> $isCoachMarkDisplayed');
    if (!isCoachMarkDisplayed || isCoachMarkDisplayed == null) {
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
        debugPrint("finish");
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
      },
      onSkip: () {
        debugPrint("skip");
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
    )..show();
  }*/

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets,
        onCoachMartkFinish: () {
          _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Finish');
    }, onCoachMartkSkip: () {
      _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Skip');
    }, onCoachMartkClickTarget: (target) {
      debugPrint('Coach Mark target click');
    }, onCoachMartkClickOverlay: () {
      debugPrint('Coach Mark overlay click');
    }).show();
  }

  void initTargets() {
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyNavigation_drawer,
        (targets.length + 1).toString(),
        'Navigation menu',
        'Update your Profile, Add Vitals and Medical information.',
        CoachMarkContentPosition.bottom));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyMyTasks,
        (targets.length + 1).toString(),
        'Daily Tasks',
        'Keep a watch on your Daily Tasks.',
        CoachMarkContentPosition.top));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyUploadReports,
        (targets.length + 1).toString(),
        'Upload Reports',
        'Upload all your reports here.',
        CoachMarkContentPosition.top));
    //targets.add(GetTargetFocus.getTargetFocus(_keyViewAppointments, (targets.length + 1).toString(), 'Appointments List', 'View all your Appointments here.', CoachMarkContentPosition.top));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyEmergencyContacts,
        (targets.length + 1).toString(),
        'Emergency Contacts',
        'Add your Emergency Contacts here.',
        CoachMarkContentPosition.top));
  }

  @override
  void initState() {
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
        screen = DashBoardVer2View(
          positionToChangeNavigationBar: (int tabPosition) {
            debugPrint('Tapped Tab $tabPosition');
            _selectedTab(tabPosition);
          },
        );
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
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              leading: InkWell(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                  child:
                      /*CircleAvatar(
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
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: profileImage == ''
                              ? AssetImage('res/images/profile_placeholder.png')
                              : CachedNetworkImageProvider(profileImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                /*Badge(
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
                ),*/
                IconButton(
                  icon: Icon(
                    Icons.chat,
                    size: 32,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.FAQ_BOT);
                  },
                ),
              ],
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
              ],
            ),
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
                      ? Semantics(
                          label: 'home page',
                          readOnly: true,
                          child: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                  'res/images/ic_home_colored.png')),
                        )
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('res/images/ic_home.png')),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _currentNav == 1
                      ? Semantics(
                          label: 'daily task',
                          readOnly: true,
                          child: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                  'res/images/ic_daily_tasks_colored.png')),
                        )
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            'res/images/ic_daily_tasks.png',
                            key: _keyMyTasks,
                          )),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _currentNav == 2
                      ? Semantics(
                          label: 'upload files',
                          readOnly: true,
                          child: SizedBox(
                              height: 28,
                              width: 28,
                              child: Image.asset(
                                  'res/images/ic_upload_files_colored.png')),
                        )
                      : SizedBox(
                          height: 28,
                          width: 28,
                          child: Image.asset(
                            'res/images/ic_upload_files.png',
                            key: _keyUploadReports,
                          )),
                  label: '',
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
                      ? Semantics(
                          label: 'emergency contact',
                          readOnly: true,
                          child: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset(
                                  'res/images/ic_call_colered.png')),
                        )
                      : SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            'res/images/ic_call.png',
                            key: _keyEmergencyContacts,
                          )),
                  label: '',
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
