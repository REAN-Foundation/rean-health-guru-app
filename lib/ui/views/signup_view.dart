import 'package:country_codes/country_codes.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/widgets/bezierContainer.dart';
import 'package:paitent/ui/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import 'base_widget.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  var dateFormat = DateFormat("dd-MM-yyyy");

  String mobileNumber = "";

  var _firstNameFocus = FocusNode();
  var _lastNameFocus = FocusNode();
  var _mobileNumberFocus = FocusNode();
  var _passwordFocus = FocusNode();
  var _emailFocus = FocusNode();
  String selectedGender = "Male";
  String selectedDate = "";
  DateTime selectedDateObject;
  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();
  String countryCode = '';


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: LoginHeader(mobileNumberController: _mobileNumberController, passwordController: _passwordController,),
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
                          _textFeildWidget(),
                          SizedBox(height: 20),
                          model.busy
                              ? CircularProgressIndicator()
                              :_submitButton(model),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ))
      ),
    );
  }


  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only( topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 40,),
            ),
            /*Text('Back',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))*/
          ],
        ),
      ),
    );
  }

  Widget _entryFirstNameField(String title,  {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _firstNameController,
                focusNode: _firstNameFocus,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)
            ),
          )
        ],
      ),
    );
  }

  Widget _entryLastNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _lastNameFocus, _emailFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }


  Widget _entryPasswordField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: TextFormField(
                obscureText: isPassword,
                controller: _passwordController,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {

                },
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

  Widget _entryEmailField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: TextFormField(
                obscureText: isPassword,
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {

                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  Widget _dobField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: InkWell(
              onTap:(){
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1940, 1, 1),
                    maxTime: DateTime.now(), onChanged: (date) {
                    }, onConfirm: (date) {
                      print('confirm $date');
                      selectedDateObject = date.toUtc();
                      selectedDate = dateFormat.format(date);
                      _fieldFocusChange(context, _mobileNumberFocus, _mobileNumberFocus);
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.white,
                  child:Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                    selectedDate,
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 24,
                          width: 24,
                          child: new Image.asset(
                              'res/images/ic_calender.png')),
                      const SizedBox(width: 16,),
                    ],
                  ),
              ),
            ),
          ),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: title,
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: /*Row(
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
                    if (mobileNumber != number.parseNumber()) {

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
              /*InternationalPhoneNumberInput
                .withCustomDecoration(
                onInputChanged: (PhoneNumber number) {
                  mobileNumber = number.toString().trim();
                  debugPrint(mobileNumber);

                  if (mobileNumber != number.parseNumber()) {

                  } else {
                    //dismissOtpWidget();
                  }

                },
                textFieldController: _mobileNumberController,
                focusNode: _mobileNumberFocus,
                onSubmit: () {
                  _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                },
                keyboardAction: TextInputAction.next,
                autoValidate: false,
                formatInput: false,
                selectorType:
                PhoneInputSelectorType.BOTTOM_SHEET,
                initialCountry2LetterCode: 'IN',
                inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)
            ),*/
                IntlPhoneField(
                  /*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*/
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  autoValidate: true,
                  decoration: InputDecoration(
                      counterText: "",
                      hintText: 'mobile_number',
                      hintStyle: TextStyle(color: Colors.transparent),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true),
                  initialCountryCode: details.alpha2Code,
                  onChanged: (phone) {
                    debugPrint(phone.countryCode);
                    print(phone.number);
                    mobileNumber = phone.number;
                    countryCode = phone.countryCode;
                    /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/
                  },
                )
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: InternationalPhoneNumberInput
                .withCustomDecoration(
                onInputChanged: (PhoneNumber number) {
                  mobileNumber = number.toString().trim();
                  debugPrint(mobileNumber);

                  if (mobileNumber != number.parseNumber()) {

                  } else {
                    //dismissOtpWidget();
                  }

                },
                textFieldController: _mobileNumberController,
                focusNode: _mobileNumberFocus,
                onSubmit: () {
                  _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                },
                keyboardAction: TextInputAction.next,
                isEnabled: true,
                autoValidate: false,
                formatInput: false,
                selectorType:
                PhoneInputSelectorType.BOTTOM_SHEET,
                initialCountry2LetterCode: 'IN',
                inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _submitButton( model) {
    return Semantics(
      label: 'SignUp',
      child: GestureDetector(
        onTap: () async {

           if (_firstNameController.text == '') {
            showToast("Please enter first name");
          } else if (_lastNameController.text == '') {
            showToast("Please enter last name");
          } else if(validateEmail(_emailController.text)) {
             showToast("Please enter valid email");
           } else if(selectedGender == '') {
             showToast("Please select gender");
           } else if(selectedDate == '') {
             showToast("Please select date of birth");
           } else if (mobileNumber.length != 10) {
             showToast("Please enter valid mobile number");
           } else if (_passwordController.text == '') {
             showToast("Please enter password");
           } else{

               var map = new Map<String, String>();
               map["FirstName"] = _firstNameController.text;
               map["LastName"] = _lastNameController.text;
               map["PhoneNumber"] = mobileNumber;
               map["Password"] = _passwordController.text;
               map["Email"] = _emailController.text;
               map["Prefix"] = "   ";
               map["Gender"] = selectedGender;
               map["BirthDate"] = selectedDateObject.toIso8601String();
               map["TimeZone"] = DateTime.now().timeZoneOffset.toString();

               try {
                 BaseResponse signUpSuccess = await model.signUp(map);

                 if (signUpSuccess.status == 'success') {
                   showAlert("Success",
                       "Please login your account for doctor appointment booking");
                   if (Navigator.canPop(context)) {
                     Navigator.pop(context);
                   }
                   //Navigator.pushNamed(context, RoutePaths.Home);
                 }else{
                   showToast(signUpSuccess.error);
                 }
               } catch (CustomException) {
                 model.setBusy(false);
                 showToast(CustomException.toString());
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
            'SignUp',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));*/
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
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
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
            fontWeight: FontWeight.w700,
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

  Widget _genderWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: 'Gender',
            child: ToggleSwitch(
                minWidth: 90.0,
                cornerRadius: 20,
                activeBgColor: Colors.green,
                activeTextColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveTextColor: Colors.white,
                labels: ['Male', 'Female'],
                icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                activeColors: [Colors.blue, Colors.pink],
                onToggle: (index) {
                  print('switched to: $index');
                  if(index == 0){
                    selectedGender = "Male";
                  }else{
                    selectedGender = "Female";
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  Widget _textFeildWidget() {
    return Column(
      children: <Widget>[
        _entryFirstNameField("First Name"),
        _entryLastNameField("Last Name"),
        _entryEmailField("Email Id"),
        _genderWidget(),
        _dobField("Date of Birth"),
        _entryMobileNoField("Mobile Number"),
      //_entryPasswordField("Password", isPassword: true),
      ],
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showAlert(String title, String subtitle){
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: title,
      subtitle: subtitle,
      configuration: IconConfiguration(icon: Icons.check_circle_outline),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(value))
      return false;
    else
      return true;
  }
}
