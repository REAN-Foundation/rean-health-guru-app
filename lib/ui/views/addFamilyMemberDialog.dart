
import 'dart:convert';
import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'base_widget.dart';

class AddFamilyMemberDialog extends StatefulWidget {
  Function _submitButtonListner;


  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddFamilyMemberDialog(
      {Key key,
      @required Function submitButtonListner})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<AddFamilyMemberDialog> {

  var model = PatientCarePlanViewModel();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  var _firstNameFocus = FocusNode();
  var _lastNameFocus = FocusNode();
  var _mobileNumberFocus = FocusNode();
  var _descriptionFocus = FocusNode();
  String profileImage = "";
  String profileImagePath = "";
  String selectedGender = "Male";

  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();
  String mobileNumber = "";
  String countryCode = '';


  @override
  void initState() {
    // TODO: implement initState

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientCarePlanViewModel>(
        model: model,
        builder: (context, model, child) => Container(
             /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
              child: addOrEditNurseDialog(context),
            ));
  }

  addOrEditNurseDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //_profileIcon(),
                  _entryFirstNameField("First Name"),
                  _entryLastNameField('Last Name'),
                  _entryMobileNoField('Phone'),
                  _entryDecriptionNameField('Relation'),
                  _genderWidget(),
                  const SizedBox(height: 16,),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        debugPrint('${mobileNumber}');
        if(_firstNameController.text == ""){
          showToast("Enter first name");
        }else if(_lastNameController.text == ""){
          showToast("Enter last name");
        }else if(mobileNumber == "" || mobileNumber.length != 10){
          showToast("Enter mobile number");
        }else if(_descriptionController.text == "" ){
          showToast("Enter relation");
        }else if(selectedGender == ""){
          showToast("Select gender");
        }else{
          widget._submitButtonListner(_firstNameController.text, _lastNameController.text, mobileNumber, selectedGender, _descriptionController.text);
        }
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      child: Text(
        '      Add       ',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textColor: Colors.white,
      color: primaryColor,
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
          ToggleSwitch(
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
          )

        ],
      ),
    );
  }

  Widget _profileIcon(){
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(
            height: 88,
            width: 88,
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 48,
                  backgroundColor: primaryLightColor,
                  child: CircleAvatar(
                      radius: 48,
                      backgroundImage:   profileImage == "" ? AssetImage('res/images/profile_placeholder.png') : new NetworkImage(profileImage)),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell( onTap: (){//getImage();
                     }, child: SizedBox( height: 32, width: 32, child: new Image.asset('res/images/ic_camera.png'))),
                )
              ],
            ),
          ),
        ],
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: TextFormField(
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: TextFormField(
                obscureText: isPassword,
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _lastNameFocus, _mobileNumberFocus);
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

  Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: primaryColor, width: 1),
                  color: Colors.white),
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
                          _fieldFocusChange(context, _mobileNumberFocus, _descriptionFocus);
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
                onInputChanged: (PhoneNumber number) {
                  mobileNumber = number.parseNumber();
                  debugPrint(number.parseNumber());
                  if (mobileNumber.length == 10) {
                    if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _descriptionFocus);
                    }
                    //_fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                  }
                  if (mobileNumber != number.parseNumber()) {
                  } else {
                    //dismissOtpWidget();
                  }
                },
                keyboardAction: TextInputAction.done,
                focusNode: _mobileNumberFocus,
                *//*textStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black26),*//*
                textFieldController: _mobileNumberController,
                isEnabled: true,
                formatInput: true,
                ignoreBlank: true,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                },
                selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                initialValue: PhoneNumber(isoCode: details.alpha2Code),
                inputDecoration: InputDecoration(
                  //filled: true,
                  //fillColor: Color(0xFFFFFFFF),

                  //hintText: 'Mobile Number',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Colors.white),
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
          ),
        ],
      ),
    );
  }

  Widget _entryDecriptionNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: TextFormField(
                obscureText: isPassword,
                controller: _descriptionController,
                focusNode: _descriptionFocus,
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
/*
  File _image;
  final picker = ImagePicker();
  List<String> listFiles = new List();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //https://pub.dev/packages/image_cropper
    setState(() {
      _image = File(pickedFile.path);
      debugPrint(pickedFile.path);
    });

    uploadProfilePicture(pickedFile.path);
  }*/

  uploadProfilePicture(String filePath) async {

    try {
      var map = new Map<String, String>();
      map["enc"] = "multipart/form-data";
      map["Authorization"] = 'Bearer '+auth;

      var postUri = Uri.parse("https://hca-bff-dev.services.tikme.app/resources/upload/");
      var request = new http.MultipartRequest("POST", postUri);
      request.headers.addAll(map);
      request.files.add(new http.MultipartFile.fromBytes('name', await File.fromUri(Uri.parse(filePath)).readAsBytes()));
      //request.fields['isPublicprofile'] = "true";

      request.send().then((response) async {
        if (response.statusCode == 200){
          print("Uploaded!");
          final respStr = await response.stream.bytesToString();
          debugPrint("Uploded "+respStr);
          UploadImageResponse uploadResponse = UploadImageResponse.fromJson(json.decode(respStr));
          if(uploadResponse.status == "success"){
            profileImagePath = uploadResponse.data.details.elementAt(0).url;
            profileImage = uploadResponse.data.details.elementAt(0).url;
            showToast(uploadResponse.message);
          }else{
            showToast('Opps, something wents wrong!');
          }

        }else{
          print("Upload Faild !");
        }
      });// debugPrint("3");

    } catch (CustomException) {
      debugPrint("4");
      showToast(CustomException.toString());
      debugPrint("Error "+CustomException.toString());
    }
  }
}
