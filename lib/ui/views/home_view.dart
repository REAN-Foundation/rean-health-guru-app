import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/common_config_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
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
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  String imageResourceId = '';

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

      /*if (!user.data.isProfileComplete ||
          user.data.isProfileComplete == null) {
        startCarePlanResponseGlob = null;
        _sharedPrefUtils.save('CarePlan', null);
        _sharedPrefUtils.saveBoolean('login', null);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return LoginWithOTPView();
        }), (Route<dynamic> route) => false);
      }*/

      //if(!isCoachMarkDisplayed) {

      //}

    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
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
        //getCarePlan();
      });
      Future.delayed(
        Duration(seconds: 4),
        () => GetAllConfigrations(),
      );
    } catch (Excepetion) {
      Timer(Duration(seconds: 3), () {
        //getCarePlan();
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
        'Navigation Menu',
        'Update your profile, add vitals and medical information.',
        CoachMarkContentPosition.bottom));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyMyTasks,
        (targets.length + 1).toString(),
        'Daily Tasks',
        'Keep a watch on your daily tasks.',
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
        'Add your emergency contacts here.',
        CoachMarkContentPosition.top));
  }

  @override
  void initState() {
    loadSharedPrefs();
    //Future.delayed(const Duration(seconds: 4), () => getLocation());
    getCarePlanSubscribe();
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_layout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          color: primaryColor,
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
                  icon: Semantics(
                    label: 'home page',
                    readOnly: true,
                    child: ImageIcon(
                      AssetImage('res/images/ic_home_colored.png'),
                      size: 24,
                      color: _currentNav == 0 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    label: 'daily task',
                    readOnly: true,
                    child: ImageIcon(
                      AssetImage('res/images/ic_daily_tasks_colored.png'),
                      size: 24,
                      color: _currentNav == 1 ? Colors.white : Colors.white54,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    label: 'upload files',
                    readOnly: true,
                    child: ImageIcon(
                      AssetImage('res/images/ic_upload_files_colored.png'),
                      size: 24,
                      color: _currentNav == 2 ? Colors.white : Colors.white54,
                    ),
                  ),
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
                  icon: Semantics(
                      label: 'emergency contact',
                      readOnly: true,
                      child: Icon(
                        FontAwesomeIcons.firstAid,
                        color: _currentNav == 3 ? Colors.white : Colors.white54,
                        size: 20,
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
