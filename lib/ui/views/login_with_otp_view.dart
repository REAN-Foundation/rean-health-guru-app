import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/CheckUserExistOrNotResonse.dart';
import 'package:paitent/core/models/GetRoleIdResponse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/networking/CustomException.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/infra/widgets/PrimaryLightColorContainer.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class LoginWithOTPView extends StatefulWidget {
  @override
  _LoginWithOTPViewState createState() => _LoginWithOTPViewState();
}

class _LoginWithOTPViewState extends State<LoginWithOTPView> {
  String mobileNumber = '';
  String countryCode = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  //String _fcmToken ="";
  final TextEditingController _mobileNumberController = TextEditingController();
  final _mobileNumberFocus = FocusNode();
  ProgressDialog progressDialog;
  int maxLengthOfPhone = 0;

  @override
  void initState() {
    progressDialog = ProgressDialog(context, isDismissible: false);
    getKnowdledgeLinkLastViewDate();
    permissionDialog();
    //if(apiProvider.getBaseUrl().contains('dev')) {
    setUpDummyNumbers();
    //}
    getRoleIdApi();
    firebase();
    super.initState();
  }

  getRoleIdApi() async {
    try {
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      debugPrint('Mobile = $mobileNumber');

      final response =
          await apiProvider.get('/types/person-roles', header: map);

      final GetRoleIdResponse getRoleIdResponse =
          GetRoleIdResponse.fromJson(response);

      if (getRoleIdResponse.status == 'success') {
        for (int i = 0;
            i < getRoleIdResponse.data.personRoleTypes.length;
            i++) {
          if (getRoleIdResponse.data.personRoleTypes.elementAt(i).roleName ==
              "Patient") {
            _sharedPrefUtils.save('roleId',
                getRoleIdResponse.data.personRoleTypes.elementAt(i).id);
            debugPrint(
                "ROLE ID ==> ${getRoleIdResponse.data.personRoleTypes.elementAt(i).id}");
            setRoleId(getRoleIdResponse.data.personRoleTypes.elementAt(i).id);
          }
        }
      } else {
        setState(() {});
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      setState(() {});
      showToast(e.toString(), context);
    }
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
              backgroundColor: primaryColor,
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -90,
                        right: 40,
                        child: PrimaryLightColorContainer(180)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: loginContent(model),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 60,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              elevation: 8,
                              child: Container(
                                height: 80,
                                width: 80,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: getAppType() == 'AHA'
                                      ? primaryLightColor
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  /*boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(2, 4),
                            blurRadius: 3,
                            spreadRadius: 2)
                      ],*/
                                ),
                                child: getAppType() == 'AHA'
                                    ? Image.asset(
                                        'res/images/aha_logo.png',
                                        semanticLabel:
                                            'American Heart Association logo',
                                      )
                                    : Image.asset(
                                        'res/images/app_logo_tranparent.png',
                                        semanticLabel: 'REAN HealthGuru',
                                        color: primaryColor,
                                      ),
                              ),
                            ),
                            /*    SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Create better together',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Let\’s get started',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    //Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ))),
    );
  }

  Widget loginContent(LoginViewModel model) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      getAppType() == 'AHA'
                          ? 'Powered by\nREAN Foundation (Innovator\'s Network)'
                          : 'Powered by\nREAN Foundation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                          color: primaryColor),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 0,
              child: ExcludeSemantics(
                child: Image.asset(
                  'res/images/grey_login_mask.png',
                  fit: BoxFit.fitWidth,
                  scale: 0.9,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*getAppType() == 'AHA' ? _titleAha() : _title(),*/
                  /*Semantics(
                      label: 'Mobile number',
                      readOnly: true,
                      child: SizedBox(height: 100)),*/
                  //_emailPasswordWidget(),
                  SizedBox(height: 60),
                  Text(
                    'Let\’s get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: primaryColor,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  _textFeild('Enter your phone', model),
                  SizedBox(height: 20),
                  if (model.busy)
                    CircularProgressIndicator()
                  else
                    _getOTPButton(model),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _textFeild(String title, LoginViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'You will receive a 6 digit code for phone number verification ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: textGrey,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: textGrey),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  controller: _mobileNumberController,
                  focusNode: _mobileNumberFocus,
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: 'mobile number',
                      hintStyle: TextStyle(color: Colors.transparent),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true),
                  initialCountryCode: getCurrentLocale(),
                  readOnly: model.busy,
                  onChanged: (phone) {
                    debugPrint(phone.countryCode);
                    debugPrint(phone.number);
                    mobileNumber = phone.number;
                    countryCode = phone.countryCode;
                    debugPrint(
                        'Country max length ==> ${countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']}');
                    maxLengthOfPhone = countries.firstWhere((element) =>
                        element['code'] == phone.countryISOCode)['max_length'];
                    /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/
                  },
                  onCountryChanged: (phone) {
                    _clearFeilds();
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _getOTPButton(LoginViewModel model) {
    return Semantics(
      label: 'Get OTP',
      button: true,
      //hint: 'press to get OTP',
      child: SizedBox(
        width: 360,
        height: 50,
        child: ExcludeSemantics(
          child: ElevatedButton(
            child: Text('Get OTP',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        side: BorderSide(color: primaryColor)))),
            onPressed: () {
              if (mobileNumber.trim().isEmpty) {
                showToast('Please enter phone number', context);
              } else if (mobileNumber.length == maxLengthOfPhone) {
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
      ),
    );
  }

  checkUserExistsOrNot(LoginViewModel model) async {
    try {
      progressDialog.show();
      debugPrint('Mobile = $mobileNumber');

      final response = await apiProvider.get('/users/by-phone/' +
          mobileNumber +
          '/role/' +
          getRoleId().toString());

      final CheckUserExistOrNotResonse checkUserExistOrNotResonse =
          CheckUserExistOrNotResonse.fromJson(response);

      if (checkUserExistOrNotResonse.status == 'success') {
        if (checkUserExistOrNotResonse.message ==
            'User retrieved successfully!') {
          generateOTPForExistingUser(model);
        }
      } else {
        if (checkUserExistOrNotResonse.message == 'User not found.') {
          generateOTP(model);
        } else {
          progressDialog.hide();
          showToast(checkUserExistOrNotResonse.message, context);
        }
        model.setBusy(false);
        //showToast(checkUserExistOrNotResonse.message, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
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
      body['Phone'] = countryCode + '-' + mobileNumber;
      body['Purpose'] = 'Login';
      body['RoleId'] = getRoleId();

      final response = await apiProvider.post('/users/generate-otp',
          header: map, body: body);

      final BaseResponse doctorListApiResponse =
          BaseResponse.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        progressDialog.hide();
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        Navigator.pushNamed(context, RoutePaths.OTP_Screen,
            arguments: mobileNumber);
        _clearFeilds();
        model.setBusy(false);
      } else {
        progressDialog.hide();
        model.setBusy(false);
        showToast(doctorListApiResponse.message, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      progressDialog.hide();
      debugPrint('error caught: $e');
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
      body['Phone'] = countryCode + '-' + mobileNumber;
      body['GenerateLoginOTP'] = true;

      final response =
          await apiProvider.post('/patients', header: map, body: body);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);
      if (doctorListApiResponse.status == 'success') {
        progressDialog.hide();
        showToast(
            'OTP has been successfully sent on your mobile number', context);
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data.patient.toJson());
        Navigator.pushNamed(context, RoutePaths.OTP_Screen,
            arguments: mobileNumber);
        _clearFeilds();
        model.setBusy(false);
      } else {
        progressDialog.hide();
        model.setBusy(false);
        showToast(doctorListApiResponse.message, context);
        setState(() {});
      }
    } on FetchDataException catch (e) {
      progressDialog.hide();
      debugPrint('error caught: $e');
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
        _sharedPrefUtils.saveBoolean('login1.5', true);
        _clearFeilds();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        debugPrint('Its API Failuar');
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

  /*Widget _title() {
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
                fontWeight: FontWeight.w600,
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

  Widget _titleAha() {
    return MergeSemantics(
      child: Semantics(
        //label: 'App name',
        readOnly: true,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'American',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 30,
                fontWeight: FontWeight.w600,
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
                  text: 'eart',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: '\nA',
                  style: TextStyle(color: primaryColor, fontSize: 30),
                ),
                TextSpan(
                  text: 'ssociation',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ]),
        ),
      ),
    );
  }*/

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

  _clearFeilds() {
    progressDialog.hide();
    mobileNumber = '';
    _mobileNumberController.clear();
    setState(() {});
  }

  void firebase() {
    _fcm.getToken().then((String token) async {
      assert(token != null);
      debugPrint('Push Messaging token: $token');
      debugPrint(token);
      //_fcmToken = token;
      _sharedPrefUtils.save('fcmToken', token);
    });

/*    _fcm.configure(
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
