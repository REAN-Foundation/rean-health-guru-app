import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:package_info/package_info.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/create_profile_view.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/features/misc/ui/welcome.dart';
import 'package:patient/features/misc/view_models/login_view_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/widgets/primary_light_color_container.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class OTPScreenView extends StatefulWidget {
  String? mobileNumber = '';

  OTPScreenView(this.mobileNumber);

  @override
  _OTPScreenViewState createState() => _OTPScreenViewState();
}

class _OTPScreenViewState extends State<OTPScreenView> {
  String? mobileNumber = '';
  String otp = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late AndroidDeviceInfo androidInfo;
  late IosDeviceInfo iosInfo;
  String? _fcmToken = '';
  bool loginOTP = false;
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    _initPackageInfo();
    getDeviceData();
    mobileNumber = widget.mobileNumber;
    debugPrint('Mobile ==> ${widget.mobileNumber}');
    firebase();
    super.initState();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

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

  @override
  Widget build(BuildContext context) {
    checkItenetConnection();
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<LoginViewModel?>(
        model: LoginViewModel(authenticationService: Provider.of(context)),
        builder: (context, model, child) => Container(
                child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: primaryColor,
              body: Container(
                height: height,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: -90,
                      right: 40,
                      child: PrimaryLightColorContainer(180)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      Container(
                        height: MediaQuery.of(context).size.height - 100,
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12))),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Semantics(
                                      label: 'mobile verification logo',
                                      image: true,
                                      child: ImageIcon(
                                        AssetImage(
                                            'res/images/mobile_verified.png'),
                                        size: 56,
                                        color: primaryColor,
                                      )),
                                )),
                            _textFeild(model!),
                            SizedBox(height: 40),
                            if (model.busy)
                              CircularProgressIndicator()
                            else
                              _submitOTPButton(model),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                ]),
              ),
            )));
  }

  Widget _backButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          label: 'Back',
          button: true,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                /* boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],*/
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  /*Text('Back',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))*/
                ],
              ),
            ),
          ),
        ),
        /*Semantics(
          header: true,
          child: Text(
            'OTP',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        )*/
      ],
    );
  }

  Widget _textFeild(LoginViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ' Enter 6 digit one-time PIN',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '  One-time PIN has been sent to your \n  mobile number ' +
                (dummyNumberList.contains(mobileNumber)
                    ? mobileNumber!
                    : countryCodeGlobe! + '-' + mobileNumber!),
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
          SizedBox(
            height: 8,
          ),
          OTPTextField(
            controller: otpController,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              otp = pin;
              /* model.setBusy(true);
              loginWithOTP(model);*/
            },
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  Didn’t received OTP?',
                style: TextStyle(fontSize: 14, color: textGrey),
              ),
              if (loginOTP)
                SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator())
              else
                InkWell(
                  onTap: () {
                    generateOTPForExistingUser(model);
                  },
                  child: Semantics(
                    label: 'Resend OTP?',
                    button: true,
                    child: ExcludeSemantics(
                      child: Text(
                        'Resend OTP?',
                        style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _submitOTPButton(LoginViewModel model) {
    return Semantics(
      label: 'Submit',
      button: true,
      child: SizedBox(
        width: 160,
        height: 40,
        child: ElevatedButton(
            child: Text('Submit', style: TextStyle(fontSize: 14)),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        side: BorderSide(color: primaryColor)))),
            onPressed: () async {
              debugPrint('mobile = ${widget.mobileNumber}');
              debugPrint('OTP = $otp');

              /*if (widget.mobileNumber!.length != maxLengthOfPhone) {
                showToast('Please enter valid mobile number', context);
              } else*/
              if (otp.toString() == '') {
                showToast('Please enter one-time PIN', context);
              } else {
                model.setBusy(true);
                loginWithOTP(model);
              }
            }),
      ),
    );
  }

  /*generateOTP(LoginViewModel model) async {
    try {
      setState(() {
        loginOTP = true;
      });
      var map = new Map<String, String>();
      map["Content-Type"] = "application/json";

      debugPrint('Mobile = ${mobileNumber}');

      var body = new Map<String, dynamic>();
      body["PhoneNumber"] = mobileNumber;
      body["GenerateLoginOTP"] = true;

      var response = await apiProvider.post('/patient' , header: map, body: body);

      PatientApiDetails doctorListApiResponse = PatientApiDetails.fromJson(response);
      if (doctorListApiResponse.status == 'success') {
        setState(() {
          loginOTP = false;
        });
        showToast('OTP has been successfully sent on your mobile number');
        _sharedPrefUtils.save("patientDetails", doctorListApiResponse.data.patient.toJson());
      }else{
        showToast(doctorListApiResponse.message);
        model.setBusy(false);
      }
    } on FetchDataException catch(e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }

  }*/

  generateOTPForExistingUser(LoginViewModel model) async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';

      debugPrint('Mobile = $mobileNumber');

      final body = <String, dynamic>{};
      body['Phone'] = countryCodeGlobe! + '-' + mobileNumber!;
      body['Purpose'] = 'Login';
      body['RoleId'] = getRoleId();

      final response = await apiProvider!
          .post('/users/generate-otp', header: map, body: body);

      final BaseResponse doctorListApiResponse =
          BaseResponse.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        showToast(
            'One-time PIN has been successfully sent on your mobile number',
            context);
        otpController.clear();
        otpController.setFocus(0);
        setState(() {});
        //model.setBusy(false);
      } else {
        //model.setBusy(false);
        showToast(doctorListApiResponse.message!, context);
        /*setState(() {});*/
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  userDiviceData(LoginViewModel model, String auth, String? userId) async {
    try {
      //ApiProvider apiProvider = new ApiProvider();

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth;

      final body = <String, dynamic>{};
      body['Token'] = _fcmToken;
      body['UserId'] = userId;
      if (Platform.isAndroid) {
        body['DeviceName'] = androidInfo.brand! + ' ' + androidInfo.model!;
        body['OSType'] = 'Android';
        body['OSVersion'] = androidInfo.version.release;
      }
      if (Platform.isIOS) {
        body['DeviceName'] = iosInfo.model;
        body['OSType'] = 'iOS';
        body['OSVersion'] = Platform.operatingSystemVersion;
      }
      body['AppName'] =
          getAppType() == "AHA" ? getAppType() : "REAN HealthGuru";
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

  loginWithOTP(LoginViewModel model) async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';

      debugPrint('Mobile = $mobileNumber');
      debugPrint('OTP = $otp');

      final body = <String, dynamic>{};
      body['Phone'] = isDummyNumber
          ? mobileNumber
          : countryCodeGlobe! + '-' + mobileNumber!;
      body['Otp'] = otp;
      body['LoginRoleId'] = getRoleId();

      final response = await apiProvider!
          .post('/users/login-with-otp', header: map, body: body);
      debugPrint(response.toString());
      final UserData userData = UserData.fromJson(response);
      if (userData.status == 'success') {
        _sharedPrefUtils.save('user', userData.toJson());
        if (userData.data!.isProfileComplete!) {
          /* _sharedPrefUtils.saveBoolean("login1.8.81", true);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView(0);
              }), (Route<dynamic> route) => false);*/
          getCarePlan(
              model, userData.data!.accessToken!, userData.data!.user!.id!);
          getPatientDetails(
              model, userData.data!.accessToken!, userData.data!.user!.id!);
          userDiviceData(
              model, userData.data!.accessToken!, userData.data!.user!.id);
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return CreateProfile();
          }), (Route<dynamic> route) => false);
          model.setBusy(false);
        }
      } else {
        showToast(userData.message!, context);
        setState(() {});
        model.setBusy(false);
      }
    } on Exception catch (e) {
      showToast('Opps something went worng.', context);
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
    }
  }

 getCarePlan(LoginViewModel model, String auth, String userId) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider!.get(
        '/care-plans/patients/' + userId + '/enrollments',
        header: map);
    // Convert and return
    GetCarePlanEnrollmentForPatient carePlanEnrollmentForPatient =  GetCarePlanEnrollmentForPatient.fromJson(response);

    if (carePlanEnrollmentForPatient.status == 'success') {
      if (carePlanEnrollmentForPatient.data!.patientEnrollments!.isNotEmpty) {
        carePlanEnrollmentForPatientGlobe = carePlanEnrollmentForPatient;
      }
      /*_sharedPrefUtils.save(
          'CarePlan', carePlanEnrollmentForPatient.toJson());*/
    }
  }

  getPatientDetails(LoginViewModel model, String auth, String userId) async {
    try {
      //ApiProvider apiProvider = new ApiProvider();

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth;

      final response =
          await apiProvider!.get('/patients/' + userId, header: map);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        if (getAppType() == 'AHA') {
          if(getAppName() != 'Heart & Stroke Helper™ ') {
            showToast('Welcome to ' + getAppName(), context);
          }
        } else {
          showToast('Welcome to REAN HealthGuru', context);
        }
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data!.patient!.toJson());
        _sharedPrefUtils.saveBoolean('login1.8.81', true);
        if(getAppName() == 'Heart & Stroke Helper™ ') {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return Welcome();
              }), (Route<dynamic> route) => false);
        }else{
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView(0);
              }), (Route<dynamic> route) => false);
        }
        model.setBusy(false);
      } else {
        model.setBusy(false);
        showToast(doctorListApiResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      showToast('Opps! Something went wrong, Please try again', context);
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
    }
  }

  checkItenetConnection() async {
    try {
      final result = await InternetAddress.lookup('tikme.co');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
    }
  }

  void firebase() {
    _fcm.getToken().then((String? token) async {
      assert(token != null);
      debugPrint('Push Messaging token: $token');
      debugPrint(token);
      _fcmToken = token;
      _sharedPrefUtils.save('fcmToken', token);
    });

    /*_fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(" On Message "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint("onLaunch: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("  On Launch "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint("onResume: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("  On Resume "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );*/
  }
}
