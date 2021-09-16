import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/CheckUserExistOrNotResonse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/views/signup_view.dart';
import 'package:paitent/ui/widgets/bezierContainer.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class LoginWithOTPView extends StatefulWidget {
  @override
  _LoginWithOTPViewState createState() => _LoginWithOTPViewState();
}

class _LoginWithOTPViewState extends State<LoginWithOTPView> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _mobileNumberFocus = FocusNode();
  final _passwordFocus = FocusNode();
  String mobileNumber = '';
  String countryCode = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String _fcmToken = '';
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  @override
  void initState() {
    // TODO: implement initState
    permissionDialog();
    //if(apiProvider.getBaseUrl().contains('dev')) {
    setUpDummyNumbers();
    //}
    firebase();
    super.initState();
  }

  permissionDialog() async {
    if (Platform.isAndroid) {
      /*debugPrint("Android Device");
      final permissionStatus = Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        showToast(
            'activityRecognition permission required to fetch your steps count');
        return;
      }*/
    }
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
                            _title(),
                            Semantics(
                                label: 'Mobile number',
                                readOnly: true,
                                child: SizedBox(height: 100)),
                            //_emailPasswordWidget(),
                            _textFeild('Mobile Number'),
                            SizedBox(height: 40),
                            if (model.busy)
                              CircularProgressIndicator()
                            else
                              _getOTPButton(model),
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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _textFeild(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '  ' + title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: IntlPhoneField(
                  /*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*/
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  autoValidate: true,
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: 'mobile_number',
                      hintStyle: TextStyle(color: Colors.transparent),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true),
                  initialCountryCode: getCurrentLocale(),
                  onChanged: (phone) {
                    debugPrint(phone.countryCode);
                    print(phone.number);
                    mobileNumber = phone.number;
                    countryCode = phone.countryCode;
                    /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _getOTPButton(LoginViewModel model) {
    return Semantics(
      label: 'getOTP',
      button: true,
      hint: 'press to get OTP',
      child: SizedBox(
        width: 160,
        height: 40,
        child: ElevatedButton(
          child: Text('Get OTP', style: TextStyle(fontSize: 14)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      side: BorderSide(color: Colors.deepPurple)))),
          onPressed: () {
            if (mobileNumber.length == 10) {
              countryCodeGlobe = countryCode;
              model.setBusy(true);
              if (dummyNumberList.contains(mobileNumber)) {
                Navigator.pushNamed(context, RoutePaths.OTP_Screen,
                    arguments: mobileNumber);
                model.setBusy(false);
              } else {
                checkUserExistsOrNot(model);
              }
            } else {
              debugPrint('Please enter valid number');
              showToast('Please enter valid number', context);
            }
          },
        ),
      ),
    );
  }

  checkUserExistsOrNot(LoginViewModel model) async {
    try {
      debugPrint('Mobile = $mobileNumber');

      final response =
          await apiProvider.get('/user/exists?phone=' + mobileNumber);

      final CheckUserExistOrNotResonse checkUserExistOrNotResonse =
          CheckUserExistOrNotResonse.fromJson(response);

      if (checkUserExistOrNotResonse.status == 'success') {
        if (checkUserExistOrNotResonse.data.exists.result) {
          generateOTPForExistingUser(model);
        } else {
          generateOTP(model);
        }
      } else {
        model.setBusy(false);
        showToast(checkUserExistOrNotResonse.error, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      print('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  generateOTPForExistingUser(LoginViewModel model) async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';

      debugPrint('Mobile = $mobileNumber');

      final body = <String, dynamic>{};
      body['PhoneNumber'] = countryCode + '-' + mobileNumber;
      body['Purpose'] = 'Login';

      final response =
          await apiProvider.post('/user/generate-otp', header: map, body: body);

      final BaseResponse doctorListApiResponse =
          BaseResponse.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        Navigator.pushNamed(context, RoutePaths.OTP_Screen,
            arguments: mobileNumber);
        model.setBusy(false);
      } else {
        model.setBusy(false);
        showToast(doctorListApiResponse.error, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      print('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  generateOTP(LoginViewModel model) async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';

      debugPrint('Mobile = $mobileNumber');

      final body = <String, dynamic>{};
      body['PhoneNumber'] = countryCode + '-' + mobileNumber;
      body['GenerateLoginOTP'] = true;

      final response =
          await apiProvider.post('/patient', header: map, body: body);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);
      if (doctorListApiResponse.status == 'success') {
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data.patient.toJson());
        Navigator.pushNamed(context, RoutePaths.OTP_Screen,
            arguments: mobileNumber);
        model.setBusy(false);
      } else {
        model.setBusy(false);
        showToast(doctorListApiResponse.error, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      print('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  getPatientDetails(LoginViewModel model, String auth, String userId) async {
    try {
      //ApiProvider apiProvider = new ApiProvider();

      final ApiProvider apiProvider = GetIt.instance<ApiProvider>();

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth;

      final response = await apiProvider.get('/patient/' + userId, header: map);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data.patient.toJson());
        _sharedPrefUtils.saveBoolean('login1.2', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        debugPrint('Its API Failuar');
        model.setBusy(false);
        showToast(doctorListApiResponse.error, context);
      }
    } on FetchDataException catch (e) {
      showToast('Opps! Something went wrong, Please try again', context);
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint(e.toString());
    }
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  _clearFeilds() {
    _mobileNumberController.clear();
    _passwordController.clear();
    setState(() {});
  }

  Widget _createAccountLabel() {
    return GestureDetector(
      onTap: () {
        _clearFeilds();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpView()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return MergeSemantics(
      child: Semantics(
        label: 'App name',
        readOnly: true,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'REAN',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
              children: [
                TextSpan(
                  text: ' ',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: 'H',
                  style: TextStyle(color: primaryColor, fontSize: 30),
                ),
                TextSpan(
                  text: 'ealth',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: 'G',
                  style: TextStyle(color: primaryColor, fontSize: 30),
                ),
                TextSpan(
                  text: 'uru',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ]),
        ),
      ),
    );
  }

  void checkItenetConnection() async {
    try {
      final result = await InternetAddress.lookup('tikme.co');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void firebase() {
    _fcm.getToken().then((String token) async {
      assert(token != null);
      print('Push Messaging token: $token');
      debugPrint(token);
      _fcmToken = token;
      _sharedPrefUtils.save('fcmToken', token);
    });

/*    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(" On Message "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("  On Launch "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("  On Resume "),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
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
