import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/models/get_weekly_care_plan_status.dart';
import 'package:patient/features/common/daily_check_in/ui/how_are_you_feeling.dart';
import 'package:patient/features/common/emergency/ui/emergency_contact.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/features/misc/ui/my_reports_upload.dart';
import 'package:patient/features/misc/view_models/common_config_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/coach_mark_utilities.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/get_all_configurations.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_constant.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/app_drawer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../common/careplan/ui/careplan_task.dart';
import 'base_widget.dart';
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

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  /*Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<Address> addresses;
  Address first;*/
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String? name = '';
  int _currentNav = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pathPDF = '';
  var model = CommonConfigModel();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey key = GlobalKey();
  GetHealthData? healthData;
  String profileImage = '';
  var dateFormat = DateFormat('yyyy-MM-dd');
  final GlobalKey _keyNavigation_drawer = GlobalKey();
  final GlobalKey _keyMyTasks = GlobalKey();
  final GlobalKey _keyUploadReports = GlobalKey();
  final GlobalKey _keyEmergencyContacts = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  CoachMarkUtilites coackMarkUtilites = CoachMarkUtilites();
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
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
      auth = user.data!.accessToken;

      patientUserId = patient.user!.id;
      patientGender = patient.user!.person!.gender;
      //debugPrint('Address ==> ${patient.user.person.addresses.elementAt(0).city}');
      //debugPrint(user.toJson().toString());
      final dynamic roleId = await _sharedPrefUtils.read('roleId');
      setRoleId(roleId);
      /* */
      setState(() {
        debugPrint('FirstName ==> ${patient.user!.person!.firstName}');
        name = patient.user!.person!.firstName;
        imageResourceId = patient.user!.person!.imageResourceId ?? '';
        profileImage = imageResourceId != ''
            ? apiProvider!.getBaseUrl()! +
                '/file-resources/' +
                imageResourceId +
                '/download'
            : '';
      });

      healthSystemGlobe =  patient.healthSystem?.toString();
      healthSystemHospitalGlobe = patient.associatedHospital?.toString();

      debugPrint('Health System Globe ==> ${patient.healthSystem.toString()}');
      debugPrint('Health System Hospital Globe ==> ${patient.associatedHospital.toString()}');

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
        carePlanEnrollmentForPatientGlobe =
            GetCarePlanEnrollmentForPatient.fromJson(
                await _sharedPrefUtils.read('CarePlan'));
        //debugPrint("CarePlan ==> ${startCarePlanResponseGlob.data.carePlan.carePlanCode}");
      }
      if (_sharedPrefUtils.read('CarePlanWeekly') == null) {
      } else {
        weeklyCarePlanStatusGlobe = GetWeeklyCarePlanStatus.fromJson(
            await _sharedPrefUtils.read('CarePlanWeekly'));
        //debugPrint("CarePlan ==> ${startCarePlanResponseGlob.data.carePlan.carePlanCode}");
      }
      Timer(Duration(seconds: 2), () {
        getPatientDetails();
        getCarePlan();
      });
      Future.delayed(
        Duration(seconds: 4),
        () => GetAllConfigrations(),
      );
    } catch (Excepetion) {
      Timer(Duration(seconds: 2), () {
        getPatientDetails();
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
      final GetCarePlanEnrollmentForPatient carePlanEnrollmentForPatient =
          await model.getCarePlan();
      debugPrint(
          'Registered Care Plan ==> ${carePlanEnrollmentForPatient.toJson()}');
      if (carePlanEnrollmentForPatient.status == 'success') {
        if (carePlanEnrollmentForPatient.data!.patientEnrollments!.isNotEmpty) {
          debugPrint('Care Plan');
          carePlanEnrollmentForPatientGlobe = carePlanEnrollmentForPatient;
          _sharedPrefUtils.save(
              'CarePlan', carePlanEnrollmentForPatient.toJson());
          getCarePlanWeeklyStatus(carePlanEnrollmentForPatient
              .data!.patientEnrollments!
              .elementAt(0)
              .id
              .toString());

          if(carePlanEnrollmentForPatient
              .data!.patientEnrollments!
              .elementAt(0).planCode == 'Stroke'){
            debugPrint('CarePlan ==> Stroke');
            _sharedPrefUtils.save('Sponsor', 'The HCA Healthcare Foundation is proud to be a national supporter of the American Stroke Association’s Together to End Stroke™');
          }else if(carePlanEnrollmentForPatient
              .data!.patientEnrollments!
              .elementAt(0).planCode == 'Cholesterol'){
            debugPrint('CarePlan ==> Cholesterol');
            _sharedPrefUtils.save('Sponsor', 'Novartis is a proud supporter of the American Heart Association’s');
          }

        }
        //showToast(startCarePlanResponse.message);
      } else {
        if(carePlanEnrollmentForPatient.message.toString() == 'Forbidden user access'){
          showToast('Your session has expired, please login', context);
          dailyCheckInDate = '';
          carePlanEnrollmentForPatientGlobe = null;
          _sharedPrefUtils.save('CarePlan', null);
          _sharedPrefUtils.saveBoolean('login', null);
          _sharedPrefUtils.clearAll();
          chatList.clear();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return LoginWithOTPView();
              }), (Route<dynamic> route) => false);
        }
        //showToast(startCarePlanResponse.message);
      }


    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  getCarePlanWeeklyStatus(String carePlanId) async {
    try {
      final GetWeeklyCarePlanStatus weeklyCarePlanStatus =
          await model.getCarePlanWeeklyStatus(carePlanId);
      debugPrint('Weekly Care Plan ==> ${weeklyCarePlanStatus.toJson()}');
      if (weeklyCarePlanStatus.status == 'success') {
        weeklyCarePlanStatusGlobe = weeklyCarePlanStatus;
        _sharedPrefUtils.save('CarePlanWeekly', weeklyCarePlanStatus.toJson());
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
    } else {
      /*GetIt.instance.registerSingleton<GetHealthData>(GetHealthData());
      healthData = GetIt.instance<GetHealthData>();*/
      Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
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

  healthJourneyCheck(){
    if(getAppFlavour() != 'HF Helper') {
      if (carePlanEnrollmentForPatientGlobe == null) {
        /*if(getBaseUrl()!.contains('aha-api-uat') ||
          getBaseUrl()!.contains('reancare-api-dev') ||
          getAppName() == 'Heart & Stroke Helper™ ') {*/
        debugPrint('Health Journey');
        Future.delayed(
            const Duration(seconds: 2), () => showHealthJourneyDialog());
        /* }else{
        debugPrint('Daily Check-In');
        Future.delayed(
            const Duration(seconds: 2), () => showDailyCheckIn());
      }*/
      } else {
        debugPrint('Daily Check-In');
        Future.delayed(
            const Duration(seconds: 2), () => showDailyCheckIn());
      }
    }else{
      Future.delayed(
          const Duration(seconds: 2), () => showDailyCheckIn());
    }
  }

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets,
        onCoachMartkFinish: () {
          _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
          Future.delayed(
              const Duration(seconds: 2), () => healthJourneyCheck());
      debugPrint('Coach Mark Finish');
    }, onCoachMartkSkip: () {
          _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
          Future.delayed(
              const Duration(seconds: 1), () => healthJourneyCheck());
      debugPrint('Coach Mark Skip');
    }, onCoachMartkClickTarget: (target) {
      debugPrint('Coach Mark target click');
    }, onCoachMartkClickOverlay: () {
      debugPrint('Coach Mark overlay click');
    }).show(context: context);
  }

  void initTargets() {
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyNavigation_drawer,
        (targets.length + 1).toString(),
        'Navigation Menu',
        'Update your profile and medical information.',
        CoachMarkContentPosition.bottom,
        ShapeLightFocus.Circle));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyMyTasks,
        (targets.length + 1).toString(),
        'My Tasks',
        'Keep a watch on your daily tasks.',
        CoachMarkContentPosition.top,
        ShapeLightFocus.Circle));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyUploadReports,
        (targets.length + 1).toString(),
        'Upload Medical Records',
        'Upload all your medical records here.',
        CoachMarkContentPosition.top,
        ShapeLightFocus.Circle));
    //targets.add(GetTargetFocus.getTargetFocus(_keyViewAppointments, (targets.length + 1).toString(), 'Appointments List', 'View all your Appointments here.', CoachMarkContentPosition.top));
    targets.add(coackMarkUtilites.getTargetFocus(
        _keyEmergencyContacts,
        (targets.length + 1).toString(),
        'Emergency Contacts',
        'Add your emergency contacts here.',
        CoachMarkContentPosition.top,
        ShapeLightFocus.Circle));
  }

  Future<void> _initPackageInfo() async {
    if (getCurrentLocale() == '') {
      final Locale countryLocale =
          await (Devicelocale.currentAsLocale as FutureOr<Locale>);
      setCurrentLocale(countryLocale.countryCode!.toUpperCase());
      debugPrint(
          'Country Local ==> ${countryLocale.countryCode!.toUpperCase()}');
    }
  }

  @override
  void initState() {
    getCarePlanSubscribe();
    _initPackageInfo();
    getDailyCheckInDate();
    loadSharedPrefs();
    //Future.delayed(const Duration(seconds: 4), () => getLocation());
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_layout);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('HomeScreen ==> Launch screen 111');
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      debugPrint('HomeScreen ==> Launch screen');
    }
  }

  showDailyCheckIn() {
    debugPrint('Inside Daily Check In');
    healthData = GetIt.instance<GetHealthData>();
    if (dailyCheckInDate != dateFormat.format(DateTime.now()) || dailyCheckInDate == '') {
      debugPrint('Inside Daily Check Inside Date');
      showMaterialModalBottomSheet(
          isDismissible: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (context) => HowAreYouFeelingToday());
    }
  }

  showHealthJourneyDialog() {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24),
      //this right here
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        semanticContainer: false,
        child: Container(
          height: 340.0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                ),
                child: Center(
                  child: Container(
                    height: 160,
                    child: ExcludeSemantics(
                      child: Image.asset(
                        getAppType() == 'AHA' ? 'res/images/ic_health_journey.png' : 'res/images/ic_health_journey_blue.png',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Text(
                'Start your health journey here',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Cancel health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Get Started health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              if (carePlanEnrollmentForPatientGlobe == null) {
                                Navigator.popAndPushNamed(
                                    context, RoutePaths.Select_Care_Plan);
                              } else {
                                Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                              }
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                  color: primaryColor),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => sucsessDialog);
  }

  getPatientDetails() async {
    try {

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth!;

      final response =
      await apiProvider!.get('/patients/' + patientUserId!, header: map);

      final PatientApiDetails apiResponse =
      PatientApiDetails.fromJson(response);

      if (apiResponse.status == 'success') {
        debugPrint("Patient User Details ==> ${apiResponse.data!.patient!.user!.person!
            .toJson()
            .toString()}");
        await _sharedPrefUtils.save(
            'patientDetails', apiResponse.data!.patient!.toJson());
      } else {
        autoLogOut(apiResponse);
        model.setBusy(false);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  autoLogOut(PatientApiDetails apiResponse){
    //debugPrint('apiResponse.message ==> ${apiResponse.message}');
    if(apiResponse.message! == "Forbidden user access" || apiResponse.message! == "Forebidden user access"){
      showToast('Your session has expired, please login', getAppBuildContext());
      //showToast("Test Message 1", context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return LoginWithOTPView();
          }), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    setAppBuildContext(context);
    //UserData data = UserData.fromJson(_sharedPrefUtils.read("user"));
    //debugPrint(_sharedPrefUtils.read("user"));

    Widget screen = DashBoardVer2View(
      positionToChangeNavigationBar: (int tabPosition) {
        debugPrint('Tapped Tab $tabPosition');
        _selectedTab(tabPosition);
      },
    );
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

    return BaseWidget<CommonConfigModel?>(
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
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              title: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              leading: InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
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
                    label: 'Navigation Drawer',
                    child: Container(
                      key: _keyNavigation_drawer,
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: (profileImage == ''
                              ? AssetImage('res/images/profile_placeholder.png')
                              : CachedNetworkImageProvider(
                                  profileImage)) as ImageProvider<Object>,
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
                  position: BadgePosition.topEnd(top: 4, end: 4),
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
                      showSuccessDialog();
                    },
                  ),
                ),*/
                IconButton(
                  icon: ImageIcon(
                    AssetImage('res/images/ic_chat_bot.png'),
                    size: 32,
                    color: primaryColor,
                    semanticLabel: 'FAQ',
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
                    selected: true,
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
                    key: _keyMyTasks,
                    label: 'daily task',
                    selected: true,
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
                    key: _keyUploadReports,
                    label: 'medical record',
                    selected: true,
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
                      key: _keyEmergencyContacts,
                      label: 'emergency contact',
                      selected: true,
                      child: Icon(
                        FontAwesomeIcons.truckMedical,
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
