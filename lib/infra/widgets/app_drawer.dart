import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/common/health_device/models/terra_session_id.dart';
import '../networking/custom_exception.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _sharedPrefUtils = SharedPrefUtils();
  String name = '';
  String? mobileNumber = '';
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );
  String profileImage = '';
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  String? _baseUrl = '';
  String imageResourceId = '';
  ProgressDialog? progressDialog;
  late BuildContext buildContext;

  loadSharedPrefs() async {
    try {
      final Patient patient =
      Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      //debugPrint(user.toJson().toString());
      setState(() {
        name = patient.user!.person!.firstName! +
            ' ' +
            patient.user!.person!.lastName!;

        mobileNumber = patient.user!.person!.phone;
        imageResourceId = patient.user!.person!.imageResourceId ?? '';
        profileImage = imageResourceId != ''
            ? apiProvider!.getBaseUrl()! +
            '/file-resources/' +
            imageResourceId +
            '/download'
            : '';
      });
      _baseUrl = apiProvider!.getBaseUrl();
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    //checkForUpdate();
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    loadSharedPrefs();
    return Drawer(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        semanticContainer: false,
        elevation: 0,
        child: Container(
          color: colorF6F6FF,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _createHeader(),
              _menuItems(),
              _footer(),

              /* _createDrawerItem(
                  icon: Icons.note,
                  text: 'Notes',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, RoutePaths.notes)),
              Divider(),
              _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
              _createDrawerItem(icon: Icons.face, text: 'Authors'),
              _createDrawerItem(
                  icon: Icons.account_box, text: 'Flutter Documentation'),
              _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
              Divider(),
              _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),*/
              /* ListTile(
                title: Text('0.0.1'),
                onTap: () {},
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItems() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_edit_profile_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.Edit_Profile);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_medical_profile_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.My_Medical_Profile);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Medical Profile',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, RoutePaths.My_Vitals);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Vital',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),*/
          /*InkWell(
                onTap:(){
                  Navigator.popAndPushNamed(context, RoutePaths.My_Vitals_By_Device_Framework);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Health Kit", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_my_medication_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.My_Medications, arguments: 0);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Medications',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*if (Platform.isIOS) ...[*/
          Visibility(
            visible: false,
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_my_activity_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.My_Activity);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Activity',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //],
          /*InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, RoutePaths.My_Nutrition,
                      arguments: '');
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Nutrition',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),*/
          Visibility(
            visible: RemoteConfigValues.carePlanCode.isNotEmpty,
            /*visible: getBaseUrl()!.contains('aha-api-uat') ||
                getBaseUrl()!.contains('reancare-api-dev') ||
                getAppName() == 'Heart & Stroke Helper™ ',*/
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  if (carePlanEnrollmentForPatientGlobe == null) {
                    Navigator.popAndPushNamed(
                        context, RoutePaths.Select_Care_Plan);
                    FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_select_health_journey_button_click');
                  } else {
                    FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_view_health_journey_status_button_click');
                    Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                  }
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Health Journey',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_achievement_button_click');
                Navigator.popAndPushNamed(
                    context, RoutePaths.ACHIEVEMENT);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Hero(
                      tag: 'header',
                      child: Text(
                        'Achievements',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*InkWell(
                onTap: (){
                  //Navigator.popAndPushNamed(context, RoutePaths.Set_Goals_Care_Plan);
                  Navigator.popAndPushNamed(context, RoutePaths.Self_Reflection_For_Goals_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Self Reflection", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/
          /*InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.Quiz_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Quiz", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.Assessment_Start_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Assessment", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Care Plan", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/

          Visibility(
            visible: RemoteConfigValues.healthDeviceConnectionVisibility,
            child: InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, RoutePaths.Connect_Health_Device);
                //progressDialog!.show(max: 100, msg: 'Loading...');
                //generateSeesionId();
                //initTerraWebView('https://widget.tryterra.co/session/ca5757dc-8297-4d8c-b1d8-c246239ac705');
                //initTerraFunctionState();
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 40,),
                    Text("Connect Health Device", style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: getAppName() != 'Heart & Stroke Helper™ ',
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_about_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.ABOUT_REAN_CARE);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        getAppType() == 'AHA' ? 'About Us' : 'About REAN',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_contact_us_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.CONTACT_US);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Contact Us',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: getAppType() == 'AHA',
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_support_network_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.SUPPORT_NETWORK);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Support Network',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
          ),
        ],
      ),
    ));
  }

  Future<dynamic> generateSeesionId() async {
    Map<String, String>? headers = <String, String>{};
    headers['x-api-key'] = dotenv.env['TERRA_API_KEY'].toString();
    headers['Dev-Id'] = dotenv.env['TERRA_DEVELOPER_ID'].toString();
    headers['Content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    /*if(dotenv.env['TERRA_API_KEY'].toString().isNotEmpty && dotenv.env['TERRA_DEVELOPER_ID'].toString().isNotEmpty){
      showToast('Terra Keys Imported', buildContext);
    }*/


    Map<String, String>? body = <String, String>{};
    body['reference_id'] = patientUserId.toString();
    body['providers'] = 'GARMIN,WITHINGS,FITBIT,OURA,WAHOO,PELOTON,ZWIFT,TRAININGPEAKS,FREESTYLELIBRE,DEXCOM,COROS,HUAWEI,OMRON,RENPHO,POLAR,SUUNTO,EIGHT,CONCEPT2,WHOOP,IFIT,TEMPO,CRONOMETER,FATSECRET,NUTRACHECK,UNDERARMOUR';
    body['language'] = 'en';

    debugPrint('Base Url ==> POST https://api.tryterra.co/v2/auth/generateWidgetSession');
    debugPrint('Request Body ==> ${json.encode(body).toString()}');
    debugPrint('Headers ==> ${json.encode(headers).toString()}');

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse('https://api.tryterra.co/v2/auth/generateWidgetSession'),
          body: json.encode(body), headers: headers)
          .timeout(const Duration(seconds: 40));
      /*if(progressDialog!.isOpen()) {
        progressDialog!.close();
      }
      progressDialog!.close();*/
      debugPrint('Terra Response Body ==> ${response.body}');
      debugPrint('Terra Response Code ==> ${response.statusCode}');
      responseJson = json.decode(response.body.toString());
      TerraSessionId sessionId = TerraSessionId.fromJson(responseJson);

      if(response.statusCode == 201) {
        debugPrint('Terra Session URL ==> ${sessionId.url}');
        initTerraWebView(sessionId.url.toString());
      }else{
        showToast(sessionId.message.toString(), buildContext);
        //showToast('Opps, something wents wrong!\nPlease try again', context);
      }
    } on SocketException {
      showToast('SocketException', buildContext);
      throw FetchDataException('No Internet connection');
    } on TimeoutException catch (_) {
      // A timeout occurred.
      showToast('TimeoutException', buildContext);
      throw FetchDataException('No Internet connection');
    } on Exception catch (e) {
      showToast(e.toString(), buildContext);
      print("throwing new error");
      throw Exception("Error on server");
    }
    return responseJson;
  }

  initTerraWebView(String url) async {
    Navigator.pop(context);
    if (await canLaunchUrl(Uri.parse(url))) {
    await tabs.launch(url,
      customTabsOption: tabs.CustomTabsOption(
        toolbarColor: primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: tabs.CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: tabs.SafariViewControllerOption(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: false,
        entersReaderIfAvailable: false,
        dismissButtonStyle: tabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
    } else {
    showToast('Could not launch $url', context);
    //throw 'Could not launch $url';
    }
  }

/*  Future<void> initTerraFunctionState() async {
    bool initialised = false;
    bool connected = false;
    bool daily = false;
    String testText;
    Connection c = Connection.appleHealth;
    // Function messages may fail, so we use a try/catch Exception.
    // We also handle the message potentially returning null.
    // USE YOUR OWN CATCH BLOCKS
    // HAVING ALL FUNCTIONS IN THE SAME CATCH IS NOT A GOOD IDEA
    try {
      DateTime now = DateTime.now().toUtc();
      DateTime lastMidnight = DateTime(now.year, now.month, now.day);
      initialised = await TerraFlutter.initTerra('rean-healthguru-dev-8sCumnMOFl', patientUserId!) ??
          false;
      print('Intialised ==> $initialised');
      connected = await TerraFlutter.initConnection(c, '2849e1b68e0b9843cbd53e5bc1cf1c599310f14f04a565cd956fb5c77acad7cd', false, []) ??
          false;

      testText = await TerraFlutter.getUserId(c) ?? "";
      print('TerraUserId ==> $testText');
      daily = await TerraFlutter.getDaily(
          c, lastMidnight, now) ??
          false;
      *//*daily = await TerraFlutter.getAthlete(c) ?? false;
      daily = await TerraFlutter.getMenstruation(
          c, DateTime(2022, 9, 25), DateTime(2022, 9, 30)) ??
          false;
      daily = await TerraFlutter.getNutrition(
          c, DateTime(2022, 7, 25), DateTime(2022, 7, 26)) ??
          false;
      daily = await TerraFlutter.getSleep(
          c, now.subtract(Duration(days: 1)), now) ??
          false;
      daily = await TerraFlutter.getActivity(
          c, DateTime(2022, 7, 25), DateTime(2022, 7, 26)) ??
          false;*//*
    } on Exception catch (e) {
      print('error caught: $e');
      testText = "Some exception went wrong";
      initialised = false;
      connected = false;
      daily = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


    setState(() {
      debugPrint(
          'Daily Data :\nInitialised ==> $initialised \nConnected ==> $connected \nDaily ==> $daily');
    });
    if (!mounted)
      return;
  }

  AppUpdateInfo? _updateInfo;
  //bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showToast(e.toString(), context);
    });
  }

  immediateUpdate() {



    if(_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError((e){
        showToast(e.toString(), context);
      });
    }
  }
  */


  Widget _footer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_logout_button_click');
              _logoutConfirmation();
            },
            child: Container(
              color: primaryColor,
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Semantics(
          child: Container(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                Text(
                  'Version ' +
                      (_baseUrl!.contains('dev')
                          ? 'Dev_'
                          : _baseUrl!.contains('uat')
                              ? 'Alpha_'
                              : '') +
                      _packageInfo.version,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _logoutConfirmation() {
    /*showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(4.0),
          subtitle: Text(
            '\nAre you sure you want to logout?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
                color: Colors.black),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              carePlanEnrollmentForPatientGlobe = null;
              _sharedPrefUtils.save('CarePlan', null);
              _sharedPrefUtils.saveBoolean('login', null);
              _sharedPrefUtils.clearAll();
              chatList.clear();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginWithOTPView();
              }), (Route<dynamic> route) => false);
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );*/
    //Navigator.pop(context);
    ConfirmationBottomSheet(
        context: context,
        height: 180,
        onPositiveButtonClickListner: () {
          dailyCheckInDate = '';
          debugPrint('Positive Button Click');
          carePlanEnrollmentForPatientGlobe = null;
          _sharedPrefUtils.save('CarePlan', null);
          _sharedPrefUtils.saveBoolean('login', null);
          _sharedPrefUtils.clearAll();
          chatList.clear();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return LoginWithOTPView();
          }), (Route<dynamic> route) => false);
        },
        onNegativeButtonClickListner: () {
          //debugPrint('Negative Button Click');
        },
        question: 'Are you sure you want to logout?',
        tittle: 'Alert!');
  }

  Widget _createHeader() {
    return /*DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/drawer_header_background.png'))),
        child:*/
      Container(
        padding: const EdgeInsets.all(16.0),

        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 88,
              width: 88,
              child: Stack(
                children: <Widget>[
                  /*CircleAvatar(
                      radius: 88,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 88,
                          backgroundImage:  profileImage == "" ? AssetImage('res/images/profile_placeholder.png') : new NetworkImage(profileImage)),
                    ),*/
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: (profileImage == ''
                            ? AssetImage('res/images/profile_placeholder.png')
                            : CachedNetworkImageProvider(profileImage))
                        as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  /*Align(
                      alignment: Alignment.topRight,
                      child: InkWell( onTap: (){ }, child: SizedBox( height: 32, width: 32, child: new Image.asset('res/images/ic_camera.png'))),
                    )*/
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Semantics(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
                semanticsLabel: 'Name ' + name,
              ),
            ),
            SizedBox(
              height: 4,
            ),

            Text(
              mobileNumber!,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: textBlack),
              semanticsLabel: "Phone: " +
                  mobileNumber!
                      .replaceAllMapped(RegExp(r".{1}"),
                          (match) => "${match.group(0)} "),
            ),
          ],
        ),

        // )
      );
  }
}