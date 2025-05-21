import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AppDrawerV2 extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawerV2> {
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
      width: MediaQuery.of(context).size.width-100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(24.0), bottomRight: Radius.circular(24.0)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(24.0), bottomRight: Radius.circular(24.0)),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        semanticContainer: false,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(24.0), bottomRight: Radius.circular(24.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createHeader(),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(thickness: 0.2, color: textGrey,),
              ),
              SizedBox(height: 16,),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      ExcludeSemantics(
                        child: ImageIcon(
                          AssetImage('res/images/ic_drawer_profile.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),
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
                      ExcludeSemantics(
                        child: ImageIcon(
                          AssetImage('res/images/ic_drawer_medical_profile.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Medical Profile',
                        style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),
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
                              color: textBlack, fontWeight: FontWeight.w700),
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
                        Text("Health Kit", style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
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
                      ExcludeSemantics(
                        child: ImageIcon(
                          AssetImage('res/images/ic_drawer_medication.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Medications',
                        style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),
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
                        ImageIcon(
                          AssetImage('res/images/ic_drawer_profile.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Activity',
                          style: TextStyle(
                              color: textBlack, fontWeight: FontWeight.w700),
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
                              color: textBlack, fontWeight: FontWeight.w700),
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
                        ExcludeSemantics(
                          child: ImageIcon(
                            AssetImage('res/images/ic_drawer_health_journey.png'),
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Health Journey',
                          style: TextStyle(
                              color: textBlack, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Semantics(
                button: true,
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
                        ExcludeSemantics(
                          child: ImageIcon(
                            AssetImage('res/images/ic_drawer_achivement.png'),
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Hero(
                          tag: 'header',
                          child: Text(
                            'Achievements',
                            style: TextStyle(
                                color: textBlack, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
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
                        Text("Self Reflection", style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
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
                        Text("Quiz", style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
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
                        Text("Assessment", style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
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
                        Text("Care Plan", style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                ),*/

            Visibility(
              visible: RemoteConfigValues.healthDeviceConnectionVisibility,
              child: Semantics(
                button: true,
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
                        /*SizedBox(
                          width: 4,
                        ),*/
                        ExcludeSemantics(
                          child: ImageIcon(
                            AssetImage('res/images/ic_drawer_connect_health_device.png'),
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Connect Health Device", style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: RemoteConfigValues.remainderVisibility,
              child: Semantics(
                button: true,
                child: InkWell(
                  onTap: () {
                    FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_remainder_button_click');
                    Navigator.popAndPushNamed(context, RoutePaths.Remainder);
                  },
                  child: Container(
                    height: 48,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ExcludeSemantics(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: ImageIcon(
                                AssetImage('res/images/ic_drawer_remainder.png'),
                                size: 40,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Reminders',
                          style: TextStyle(
                              color: textBlack, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
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
                        ExcludeSemantics(
                          child: ImageIcon(
                            AssetImage('res/images/ic_drawer_about_us.png'),
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          getAppType() == 'AHA' ? 'About Us' : 'About REAN',
                          style: TextStyle(
                              color: textBlack, fontWeight: FontWeight.w700),
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
                      ExcludeSemantics(
                        child: ImageIcon(
                          AssetImage('res/images/ic_drawer_contact_us.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Contact Us',
                        style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),
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
                        ExcludeSemantics(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: ImageIcon(
                                AssetImage('res/images/ic_support_network.png'),
                                size: 34,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Support Network',
                          style: TextStyle(
                              color: textBlack, fontWeight: FontWeight.w700),
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
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_logout_button_click');
                  _logoutConfirmation();
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ExcludeSemantics(
                        child: ImageIcon(
                          AssetImage('res/images/ic_drawer_logout.png'),
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                            color: textBlack, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    ));
  }


  Widget _footer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          label: 'Version ' +
              (_baseUrl!.contains('dev')
                  ? 'Dev_'
                  : _baseUrl!.contains('uat')
                  ? 'Alpha_'
                  : '') +
              _packageInfo.version,
          child: ExcludeSemantics(
            child: Container(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'V ' +
                        (_baseUrl!.contains('dev')
                            ? 'Dev_'
                            : _baseUrl!.contains('uat')
                                ? 'Alpha_'
                                : '') +
                        _packageInfo.version,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: textBlack),
                  ),
                ],
              ),
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
              _sharedPrefUtils.saveBoolean('login1.8.167', null);
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
          _sharedPrefUtils.saveBoolean('login1.8.167', null);
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
    return Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 32,),
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 68.0,
              height: 68.0,
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
                  width: 1.0,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textBlack),
                    semanticsLabel: 'Name ' + name,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    mobileNumber!,
                    style: TextStyle(
                        fontSize: 12, color: textGrey),
                    semanticsLabel: "Phone: " +
                        mobileNumber!
                            .replaceAllMapped(RegExp(r".{1}"),
                                (match) => "${match.group(0)} "),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}