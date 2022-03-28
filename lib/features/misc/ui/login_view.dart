import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paitent/features/misc/models/PatientApiDetails.dart';
import 'package:paitent/features/misc/models/user_data.dart';
import 'package:paitent/features/misc/ui/home_view.dart';
import 'package:paitent/features/misc/ui/signup_view.dart';
import 'package:paitent/features/misc/view_models/login_view_model.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:paitent/infra/widgets/bezierContainer.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  String mobileNumber = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String countryCode = '';

  //String _fcmToken;

  @override
  void initState() {
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
              backgroundColor: colorF6F6FF,
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -height * .15,
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
                            SizedBox(height: 50),
                            _emailPasswordWidget(),
                            SizedBox(height: 20),
                            if (model.busy)
                              CircularProgressIndicator()
                            else
                              _submitButton(model),
                            /*Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ),*/
                            //_divider(),
                            //_facebookButton(),
                            SizedBox(height: height * .099),
                            _createAccountLabel(),
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


  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: 'password',
            child: TextFormField(
                obscureText: isPassword,
                controller: _passwordController,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {},
                maxLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child:
                  /* Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                child: Text(
                  "+91",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
              ),
              Expanded(
                child: Semantics(
                  label:'mobileNumber',
                  child: TextFormField(
                      controller: _mobileNumberController,
                      focusNode: _mobileNumberFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              )
            ],
          )*/

                  /*InternationalPhoneNumberInput(
            onInputChanged:
                (PhoneNumber number) {
              mobileNumber = number
                  .parseNumber();
              debugPrint(number
                  .parseNumber());
              if(mobileNumber.length == 10){
                _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
              }

              if (mobileNumber !=
                  number
                      .parseNumber()) {
              } else {
                //dismissOtpWidget();
              }
            },
            keyboardAction:
            TextInputAction.next,
            focusNode: _mobileNumberFocus,
            textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            textFieldController: _mobileNumberController,
            isEnabled: true,
            formatInput: true,
            ignoreBlank: true,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
            },
            selectorConfig: SelectorConfig(
                selectorType:
                PhoneInputSelectorType
                    .BOTTOM_SHEET),
            initialValue: PhoneNumber(
                isoCode: details.alpha2Code),
            inputDecoration:
            InputDecoration(
              //filled: true,
              //fillColor: Color(0xFFFFFFFF),

              //hintText: 'Mobile Number',
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius
                        .circular(
                        10.0)),
                borderSide:
                BorderSide(
                    color: Colors
                        .white),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius
                        .circular(
                        10.0)),
                borderSide:
                BorderSide(
                    color: Colors
                        .white),
              ),
            ),
          )*/
                  IntlPhoneField(
                /*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*/
                    keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
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
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp('[\\,|\\+|\\-|\\a-zA-Z]|\\ ')),
                ],
                onChanged: (phone) {
                      debugPrint(phone.countryCode);
                      debugPrint(phone.number);
                      mobileNumber = phone.number;
                      countryCode = phone.countryCode;
                      /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/
                    },
              )),
        ],
      ),
    );
  }

  Widget _submitButton(model) {
    return Semantics(
      label: 'loginButton',
      child: InkWell(
        onTap: () async {
          debugPrint('mobile = $mobileNumber');
          debugPrint('Password = ${_passwordController.text}');

          if (mobileNumber.length != 10) {
            showToast('Please enter valid mobile number', context);
          } else if (_passwordController.text.toString() == '') {
            showToast('Please enter password', context);
          } else {
            final map = <String, String>{};
            map['PhoneNumber'] = mobileNumber;
            map['Password'] = _passwordController.text;
            map['Email'] = null;
            try {
              final UserData loginSuccess = await model.login(map);

              if (loginSuccess.status == 'success') {
                _sharedPrefUtils.save('user', loginSuccess.toJson());
                //_sharedPrefUtils.saveBoolean("login1.8", true);
                getPatientDetails(model, loginSuccess.data.accessToken,
                    loginSuccess.data.user.id);
                //debugPrint(loginSuccess.data.user.firstName);
                /*Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                      return HomeView();
                    }), (Route<dynamic> route) => false);*/
              } else {
                showToast(loginSuccess.message, context);
              }
            } catch (CustomException) {
              model.setBusy(false);
              showToast(CustomException.toString(), context);
              debugPrint(CustomException.toString());
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 52,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [primaryLightColor, primaryColor])),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
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
        _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data.patient.toJson());
        _sharedPrefUtils.saveBoolean('login1.8', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        showToast(doctorListApiResponse.message, context);
        model.setBusy(false);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
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
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'REAN',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
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
              text: 'C',
              style: TextStyle(color: primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: 'are',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryMobileNoField('Mobile Number'),
        _entryField('Password', isPassword: true),
      ],
    );
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
