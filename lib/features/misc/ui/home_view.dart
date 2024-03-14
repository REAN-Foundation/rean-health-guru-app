import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_web_wiew;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/achievement/models/how_to_earn_badges.dart';
import 'package:patient/features/common/activity/models/GetRecords.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/models/get_weekly_care_plan_status.dart';
import 'package:patient/features/common/daily_check_in/ui/how_are_you_feeling.dart';
import 'package:patient/features/common/emergency/ui/emergency_contact.dart';
import 'package:patient/features/misc/models/awards_user_details.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/dashboard_ver_3.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/features/misc/ui/my_reports_upload.dart';
import 'package:patient/features/misc/ui/update_your_city_location.dart';
import 'package:patient/features/misc/view_models/common_config_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/services/NotificationHandler.dart';
import 'package:patient/infra/services/update_checker.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/coach_mark_utilities.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/get_all_configurations.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/get_vitals_data.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_constant.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/app_drawer_v2.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/activity/models/movements_tracking.dart';
import '../../common/careplan/ui/careplan_task.dart';
import '../../common/vitals/models/get_my_vitals_history.dart';
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
  loc.Location location =  loc.Location();
  late bool serviceEnabled;
  late loc.PermissionStatus permissionGranted;
  late loc.LocationData locationData;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String? name = '';
  int _currentNav = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pathPDF = '';
  var model = CommonConfigModel();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey key = GlobalKey();
  GetHealthData? healthData;
  GetVitalsData? vitalsData;
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
  late AndroidDeviceInfo androidInfo;
  late IosDeviceInfo iosInfo;
  late UserData user;
  late Patient patient;
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  _HomeViewState(int screenPosition) {
    _currentNav = screenPosition;
  }

  loadSharedPrefs() async {
    try {
       user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
       patient =
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
        _sharedPrefUtils.saveBoolean('login1.8.167', null);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return LoginWithOTPView();
        }), (Route<dynamic> route) => false);
      }*/

      //if(!isCoachMarkDisplayed) {

      //}

      await FirebaseAnalytics.instance.setUserId(id: patientUserId);
      await FirebaseAnalytics.instance.setUserProperty(name: 'name', value: name);
      await FirebaseAnalytics.instance.setUserProperty(name: 'app_name', value: getAppName());
      await FirebaseAnalytics.instance.setUserProperty(name: 'user_gender', value: patientGender);


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

  loadAllHistoryData(){
    Timer(Duration(seconds: 4), () {
      getSleepHistory();
      getVitalsHistory();
      getStepHistory();
      howToEarnBadgesDescription();
      getAwardsSystemUserDetails();
    });
  }

  getVitalsHistory() async {
    try {
      final GetMyVitalsHistory getMyVitalsHistory =
      await model.getMyVitalsHistory('body-heights');
      if (getMyVitalsHistory.status == 'success') {
        if (getMyVitalsHistory.data!.bodyHeightRecords!.items!.isNotEmpty) {
          _sharedPrefUtils.saveDouble('height', double.parse(getMyVitalsHistory.data!.bodyHeightRecords!.items!.elementAt(0).bodyHeight.toString()));
        }
      } else {
        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getSleepHistory() async {
    try {
      DateTime startDate = dateFormat.parse(DateTime.now().toIso8601String());
      final GetRecords records =
      await model.getMySleepHistory(startDate.toString());
      if (records.status == 'success') {
        if (records.data!.sleepRecords!.items!.isNotEmpty) {
          _sharedPrefUtils.save(
              'sleepTime', MovementsTracking(startDate, records.data!.sleepRecords!.items!.elementAt(0).sleepDuration, '').toJson());
          //_sharedPrefUtils.save('sleepTime', double.parse(getMyVitalsHistory.data!.bodyHeightRecords!.items!.elementAt(0).bodyHeight.toString()));
        }
      } else {
        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getStepHistory() async {
    try {
      DateTime startDate = dateFormat.parse(DateTime.now().toIso8601String());
      final GetRecords records =
      await model.getMyStepHistory(startDate.toString());
      if (records.status == 'success') {
        if (records.data!.stepRecords!.items!.isNotEmpty) {
          _sharedPrefUtils.save(
              'stepCount', MovementsTracking(startDate, int.parse(records.data!.stepRecords!.items!.elementAt(0).stepCount.toString()), '').toJson());
          //_sharedPrefUtils.save('sleepTime', double.parse(getMyVitalsHistory.data!.bodyHeightRecords!.items!.elementAt(0).bodyHeight.toString()));
        }
      } else {
        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getAwardsSystemUserDetails() async {
    try {
      final AwardsUserDetails awardsUserDetails =
      await model.getAwardsSytstemUserDetails();
      if (awardsUserDetails.status == 'success') {
        debugPrint('Awards System Id ==> ${awardsUserDetails.data!.id.toString()}');
        setAwardsSystemId(awardsUserDetails.data!.id.toString());
      } else {
        if(awardsUserDetails.message == 'Cannot read properties of null (reading \'ReferenceId\')'){
          createAwardsSystemParticipent();
        }
        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  createAwardsSystemParticipent() async {
    try {

      final body = <String, String>{};
      body['ClientId'] = dotenv.env['AWARD_CLIENT_ID'].toString();
      body['ReferenceId'] = patientUserId.toString();
      body['FirstName'] = user.data!.user!.person!.firstName.toString();
      body['LastName'] = user.data!.user!.person!.lastName.toString();
      body['Gender'] = user.data!.user!.person!.gender.toString();
      body['BirthDate'] = dateFormat.format(patient.user!.person!.birthDate!);
      body['CountryCode'] = '+91';
      body['Phone'] = user.data!.user!.person!.phone.toString();
      body['OnboardingDate'] = dateFormat.format(DateTime.now());


      final BaseResponse response =
      await model.createAwardParticipent(body);
      if (response.status == 'success') {
        debugPrint('Awards System Id ==> ${response.message}');
        getAwardsSystemUserDetails();
      } else {

        //showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }


  howToEarnBadgesDescription() async {
    try {
      final HowToEarnBadges earnBadges =
      await model.howToEarnAwardsDescription();
      if (earnBadges.status == 'success') {
        debugPrint('How To Earn Badges ==> ${earnBadges.toJson().toString()}');
        _sharedPrefUtils.save('how_to_earn_badges', earnBadges.toJson());
      } else {
        showToast(earnBadges.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getCarePlan() async {
    try {
      final GetCarePlanEnrollmentForPatient carePlanEnrollmentForPatient =
          await model.getCarePlan(true);
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
            RemoteConfigValues.hospitalSystemVisibility = true;
            debugPrint('CarePlan ==> Stroke');
            _sharedPrefUtils.save('Sponsor', 'The HCA Healthcare Foundation is proud to be a national supporter of the American Stroke Association’s Together to End Stroke™');
          }else if(carePlanEnrollmentForPatient
              .data!.patientEnrollments!
              .elementAt(0).planCode == 'Cholesterol'){
            RemoteConfigValues.hospitalSystemVisibility = true;
            debugPrint('CarePlan ==> Cholesterol');
            _sharedPrefUtils.save('Sponsor', 'Novartis is a proud supporter of the American Heart Association’s Integrated ASCVD Management Initiative.');
          }else if(carePlanEnrollmentForPatient
              .data!.patientEnrollments!
              .elementAt(0).planCode == 'HFMotivator'){
            RemoteConfigValues.hospitalSystemVisibility = true;
            debugPrint('CarePlan ==> HFMotivator');
            _sharedPrefUtils.save('Sponsor', 'The American Heart Association\'s National Heart Failure Initiative, IMPLEMENT-HF, is made possible with funding by founding sponsor, Novartis, and national sponsor, Boehringer Ingelheim and Eli Lilly and Company.');
          }

        }else{
          _sharedPrefUtils.save(
              'CarePlan', null);
          //RemoteConfigValues.hospitalSystemVisibility = true;
          _sharedPrefUtils.save('Sponsor', '');
          carePlanEnrollmentForPatientGlobe = null;
        }
        //showToast(startCarePlanResponse.message);
      } else {
        if(carePlanEnrollmentForPatient.message.toString() == 'Forbidden user access'){
          showToast('Your session has expired, please login', context);
          dailyCheckInDate = '';
          carePlanEnrollmentForPatientGlobe = null;
          _sharedPrefUtils.save('CarePlan', null);
          _sharedPrefUtils.saveBoolean('login1.8.167', null);
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

  getLocation() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    locationData =  await location.getLocation();
    findOutCityFromGeoCord(
        locationData.latitude!.toDouble(), locationData.longitude!.toDouble());
    /*location.onLocationChanged.listen((loc.LocationData currentLocation) {
      debugPrint(
          'Latitude = ${currentLocation.latitude} Longitude = ${currentLocation.longitude}');

    });*/
  }

  findOutCityFromGeoCord(double lat, double long) async {
    //final coordinates = new Coordinates(latitude: lat, longitude: long);
    //final Address addresses = await  geoCode.reverseGeocoding(longitude: long, latitude: lat);
    //first = addresses;0
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    debugPrint("Name: = ${placemarks.elementAt(0).name} City: = ${placemarks.elementAt(0).locality}");
    currentCity = placemarks.elementAt(0).locality.toString();
    //showToastMsg("Name: = ${placemarks.elementAt(0).name} City: = ${placemarks.elementAt(0).locality}", context);
  }

  String currentCity = "";

  checkforUpdatedCity(){
    if(patient.user!.person!.addresses!.elementAt(0).city! != currentCity){
      showMaterialModalBottomSheet(
          isDismissible: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (context) => UpdateYourCityLocation(currentCity)).then((value) => getPatientDetails());
    }
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
      //Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  getDeviceData() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    }

    if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;

      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
    }
  }

  userDiviceData() async {
    try {
      //ApiProvider apiProvider = new ApiProvider();

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth!;

      final body = <String, dynamic>{};
      body['Token'] = await _sharedPrefUtils.read('fcmToken');
      body['UserId'] = patientUserId;
      if (Platform.isAndroid) {
        body['DeviceName'] = androidInfo.brand! + ' ' + androidInfo.model!;
        body['DeviceId'] = androidInfo.id;
        body['OSType'] = 'Android';
        body['OSVersion'] = androidInfo.version.release;
      }
      if (Platform.isIOS) {
        body['DeviceName'] = iosInfo.model;
        body['DeviceId'] = iosInfo.identifierForVendor;
        body['OSType'] = 'iOS';
        body['OSVersion'] = Platform.operatingSystemVersion;
      }
      body['AppName'] = getAppName();
      body['AppVersion'] = _packageInfo.version;

      final response = await apiProvider!
          .post('/user-device-details', header: map, body: body);

      final BaseResponse baseResponse = BaseResponse.fromJson(response);

      if (baseResponse.status == 'success') {
      } else {
        //showToast(baseResponse.message, context);
      }
    } on FetchDataException catch (e) {
      showToast('Opps! Something went wrong, Please try again', context);
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
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
    if(RemoteConfigValues.carePlanCode.isNotEmpty) {
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
        checkforUpdatedCity();
        /*debugPrint('Daily Check-In');
        Future.delayed(
            const Duration(seconds: 2), () => showDailyCheckIn());*/
      }
    }else{
      checkforUpdatedCity();
      /*Future.delayed(
          const Duration(seconds: 2), () => showDailyCheckIn());*/
    }
  }

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets,
        onCoachMartkFinish: () {
          FirebaseAnalytics.instance.logEvent(name: 'app_tutorial_finish_button_click');
          _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
          Future.delayed(
              const Duration(seconds: 2), () => healthJourneyCheck());
      debugPrint('Coach Mark Finish');
    }, onCoachMartkSkip: () {
          FirebaseAnalytics.instance.logEvent(name: 'app_tutorial_skip_button_click');
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

  Future<void> _initDeviceLocal() async {
    if (getCurrentLocale() == '') {
      final Locale countryLocale =
          await (Devicelocale.currentAsLocale as FutureOr<Locale>);
      setCurrentLocale(countryLocale.countryCode!.toUpperCase());
      debugPrint(
          'Country Local ==> ${countryLocale.countryCode!.toUpperCase()}');
    }
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      debugPrint("Notification initialMessage ==> ${initialMessage.data.toString()}");
      if(pushNotificationAlreadyNavigated){
      _handleMessage(initialMessage);
      pushNotificationAlreadyNavigated = true;
      }
    }else{
      debugPrint("Notification onMessage ==> $initialMessage");
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    //FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a notification
      debugPrint("Notification onMessageOpenedApp ==> ${message.data.toString()}");
      pushNotificationAlreadyNavigated = false;
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    String routeName = message.data['type']; // Careplan registration reminder
    if (routeName != null) {

      switch (routeName) {
        case "Careplan registration reminder":
          debugPrint("<================== Careplan registration reminder Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          Navigator.pushNamed(
              context, RoutePaths.Select_Care_Plan, arguments: 0);
          break;
        case "Upcoming medication":
          debugPrint("<================== Upcoming medication Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          Navigator.pushNamed(context, RoutePaths.My_Medications, arguments: 0);
          break;
        case "Health report created":
          debugPrint("<================== Health report created Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          setState(() {
            _currentNav = 2;
          });
          break;
        case "Daily Task":
          debugPrint("<================== Daily Task Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          setState(() {
            _currentNav = 1;
          });
          break;
        case "Achievement received":
          debugPrint("<================== Achievement received Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          Navigator.pushNamed(context, RoutePaths.ACHIEVEMENT, arguments: 0);
          break;
        case "Alert Blood Pressure":
          debugPrint("<================== Alert Blood Pressure Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          Navigator.pushNamed(context, RoutePaths.ADD_BLOOD_PRESURE_GOALS, arguments: 0);
          break;
        case "Web":
          debugPrint("<================== Web Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          _launchURL(message.data['url']);
          break;
        case "Reminder":
          debugPrint("<================== Web Notification Received ==============================>");
          debugPrint("Notification Type ===> $routeName");
          reminderAlert(message);
          break;
      }
      // Use Navigator to navigate to the specified screen
      // Navigator.pushNamed(context, routeName);
    }
  }

  /*reminderAlert(RemoteMessage message){
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        width: 300.0,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(16.0),
              child: Center(child: Text('Reminder', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w700),)),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView( scrollDirection: Axis.vertical, child: Text(message.notification!.title.toString(), style: TextStyle(color: textBlack, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left,)),
            )),
            Center(
              child: ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              },
                  child: Text('Got It!', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),)),
            ),
            SizedBox(height: 16,)
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }*/

  reminderAlert(RemoteMessage message){
    FirebaseAnalytics.instance.logEvent(name: 'remainder_popup_displayed');
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
          height: 280.0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                ),
                child: Center(
                  child: Container(
                    height: 80,
                    child: ExcludeSemantics(
                      child: Image.asset(
                        'res/images/ic_drawer_remainder.png',
                        color: primaryColor,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(16.0),
                child: Center(child: Text('Reminder', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w700),)),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView( scrollDirection: Axis.vertical, child: Text(message.notification!.title.toString(), style: TextStyle(color: textBlack, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left,)),
              )),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Cancel health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'cancel_health_journey_button_click');
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
                    ),*/
                    Semantics(
                      button: true,
                      label: 'Got It',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            FirebaseAnalytics.instance.logEvent(name: 'remainder_got_it_button_click');
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 48,
                            width: 160,
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
                                'Got It!',
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

  _launchURL(String url) async {
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

  @override
  void initState() {
    setupInteractedMessage();
    // Initialize the NotificationHandler
    NotificationHandler().initialize();
    vitalsData = GetIt.instance<GetVitalsData>();
    getDeviceData();
    loadAllHistoryData();
    getCarePlanSubscribe();
    _initPackageInfo();
    _initDeviceLocal();
    getDailyCheckInDate();
    loadSharedPrefs();
    //Future.delayed(const Duration(seconds: 4), () => getLocation());
    getLocation();
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
    debugPrint('HomeScreen ==> $state');
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      if (Platform.isIOS) {
        vitalsData!.fetchData();
      }
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
    FirebaseAnalytics.instance.logEvent(name: 'health_journey_popup_displayed');
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
          height: 248.0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                ),
                child: Center(
                  child: Container(
                    height: 80,
                    child: ExcludeSemantics(
                      child: Image.asset(
                        'res/images/ic_hf_care_plan.png',
                        color: primaryColor,
                        width: 80,
                        height: 80,
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
              Padding(padding: EdgeInsets.only(top: 32.0)),
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
                              FirebaseAnalytics.instance.logEvent(name: 'cancel_health_journey_button_click');
                              Navigator.pop(context);
                              //Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
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
                              FirebaseAnalytics.instance.logEvent(name: 'start_health_journey_button_click');
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
        loadSharedPrefs();
        userDiviceData();
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
    if(apiResponse.message! == "Forbidden user access" || apiResponse.message! == "Forebidden user access" || apiResponse.message! == "Forbidden user access: jwt expired"){
      showToast('Your session has expired, please login', context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return LoginWithOTPView();
          }), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    setAppBuildContext(context);
    UpdateChecker(context);
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
        FirebaseAnalytics.instance.logEvent(name: 'navigation_home_button_click');
        screen = DashBoardVer3View(
          positionToChangeNavigationBar: (int tabPosition) {
            debugPrint('Tapped Tab $tabPosition');
            _selectedTab(tabPosition);
          },
        );
        break;
      case 1:
        FirebaseAnalytics.instance.logEvent(name: 'navigation_task_button_click');
        screen = CarePlanTasksView();
        break;
      case 2:
        FirebaseAnalytics.instance.logEvent(name: 'navigation_upload_report_button_click');
        screen = MyReportsView();
        break;
      /*case 3:
        screen = ViewMyAppointment();
        break;*/
      case 3:
        FirebaseAnalytics.instance.logEvent(name: 'navigation_emergency_button_click');
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
                    AssetImage('res/images/ic_badges.png'),
                    size: 32,
                    color: primaryColor,
                    semanticLabel: 'Achievements',
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.ACHIEVEMENT);
                  },
                ),
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
          drawer: AppDrawerV2(),
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
                    label: 'daily tasks',
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
