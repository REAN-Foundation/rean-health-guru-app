import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/create_profile_view.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/widgets/bezierContainer.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:provider/provider.dart';
//ignore: must_be_immutable
class OTPScreenView extends StatefulWidget {
  String mobileNumber = '';

  OTPScreenView(this.mobileNumber);

  @override
  _OTPScreenViewState createState() => _OTPScreenViewState();
}

class _OTPScreenViewState extends State<OTPScreenView> {
  String mobileNumber = '';
  String otp = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //String _fcmToken = '';
  bool loginOTP = false;
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  @override
  void initState() {
    mobileNumber = widget.mobileNumber;
    debugPrint('Mobile ==> ${widget.mobileNumber}');
    firebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkItenetConnection();
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      builder: (context, model, child) => Container(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: colorF6F6FF,
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -height * .20,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer()),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: height * .2),
                            //_title(),
                            SizedBox(height: 16),
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
                            //SizedBox(height: 30),
                            //_emailPasswordWidget(),
                            _textFeild(model),
                            SizedBox(height: 40),
                            if (model.busy)
                              CircularProgressIndicator()
                            else
                              _submitOTPButton(model),
                            /* model.busy
                              ? CircularProgressIndicator()
                              :_submitButton(model),*/
                            /*Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),*/
                            //_divider(),
                            //_facebookButton(),
                            //SizedBox(height: height * .099),
                            //_createAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -height * .30,
                        right: MediaQuery.of(context).size.width * .35,
                        child: Transform.rotate(
                            angle: 160, child: BezierContainer())),
                    //Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ))),
    );
  }

  Widget _textFeild(LoginViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ' Enter 6 digit OTP',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '  OTP has been sent to your mobile number\n  ' +
                (dummyNumberList.contains(mobileNumber)
                    ? mobileNumber
                    : countryCodeGlobe + '-' + mobileNumber),
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(
            height: 8,
          ),
          OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (loginOTP)
                SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator())
              else
                InkWell(
                  onTap: () {
                    generateOTPForExistingUser(model);
                  },
                  child: Text(
                    'Resend OTP?',
                    style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w700),
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
      label: 'getOTP',
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

              if (widget.mobileNumber.length != 10) {
                showToast('Please enter valid mobile number', context);
              } else if (otp.toString() == '') {
                showToast('Please enter otp', context);
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
      body['PhoneNumber'] = countryCodeGlobe + '-' + mobileNumber;
      body['Purpose'] = 'Login';

      final response =
          await apiProvider.post('/user/generate-otp', header: map, body: body);

      final BaseResponse doctorListApiResponse =
          BaseResponse.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        model.setBusy(false);
      } else {
        model.setBusy(false);
        showToast(doctorListApiResponse.error, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  loginWithOTP(LoginViewModel model) async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';

      debugPrint('Mobile = $mobileNumber');
      debugPrint('OTP = $otp');

      final body = <String, dynamic>{};
      body['Phone'] = dummyNumberList.contains(mobileNumber)
          ? mobileNumber
          : countryCodeGlobe + '-' + mobileNumber;
      body['Otp'] = otp;
      body['LoginRoleId'] = 2;

      final response = await apiProvider.post('/users/login-with-otp',
          header: map, body: body);
      debugPrint(response.toString());
      final UserData userData = UserData.fromJson(response);
      if (userData.status == 'success') {
        _sharedPrefUtils.save('user', userData.toJson());
        if (userData.data.isProfileComplete) {
          /* _sharedPrefUtils.saveBoolean("login1.2", true);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView(0);
              }), (Route<dynamic> route) => false);*/

          getPatientDetails(
              model, userData.data.accessToken, userData.data.user.id);
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return CreateProfile();
          }), (Route<dynamic> route) => false);
          model.setBusy(false);
        }
      } else {
        showToast(userData.message, context);
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

  getPatientDetails(LoginViewModel model, String auth, String userId) async {
    try {
      //ApiProvider apiProvider = new ApiProvider();

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth;

      final response =
          await apiProvider.get('/patients/' + userId, header: map);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        showToast('Welcome to REAN HealthGuru', context);
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data.patient.toJson());
        _sharedPrefUtils.saveBoolean('login1.2', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        model.setBusy(false);
        showToast(doctorListApiResponse.message, context);
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
    _fcm.getToken().then((String token) async {
      assert(token != null);
      debugPrint('Push Messaging token: $token');
      debugPrint(token);
      //_fcmToken = token;
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
