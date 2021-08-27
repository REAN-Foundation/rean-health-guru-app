import 'dart:convert';
import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/widgets/login_header.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'base_widget.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emergencyMobileNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  String profileImagePath = "";
  ImagePicker _picker = new ImagePicker();
  String mobileNumber = "";

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  var _firstNameFocus = FocusNode();
  var _lastNameFocus = FocusNode();
  var _mobileNumberFocus = FocusNode();
  var _emergencyMobileNumberFocus = FocusNode();
  var _emailFocus = FocusNode();
  var _bloodGroupFocus = FocusNode();
  var _cityFocus = FocusNode();
  var _addressFocus = FocusNode();
  var _sharedPrefUtils = new SharedPrefUtils();
  String selectedGender = "";
  String dob = "";
  String unformatedDOB = "";
  String userId = "";
  String auth = "";
  ProgressDialog progressDialog;
  String fullName = "";
  var dateFormat = DateFormat("dd MMM, yyyy");
  Patient patient;
  //String profileImage = "";
  String emergencymobileNumber = "";
  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();
  bool isEditable = false;

  String countryCode = '';

  @override
  void initState() {

    debugPrint('TimeZone ==> ${DateTime.now().timeZoneOffset}');

    super.initState();
    loadSharedPrefs();
  }

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      patient = Patient.fromJson(await _sharedPrefUtils.read("patientDetails"));
      debugPrint(user.toJson().toString());

      dob = dateFormat.format(patient.birthDate);
      unformatedDOB = patient.birthDate.toIso8601String();
      userId = user.data.user.userId.toString();
      auth = user.data.accessToken;

      fullName = patient.firstName + " " + patient.lastName;
      mobileNumber = patient.phoneNumber;

      _firstNameController.text = patient.firstName;
      _firstNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _firstNameController.text.length),
      );

      _lastNameController.text = patient.lastName;
      _lastNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _lastNameController.text.length),
      );

      _mobileNumberController.text = patient.phoneNumber;
      _mobileNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _mobileNumberController.text.length),
      );

      debugPrint(patientGender);
      selectedGender = patientGender;

      /*try {
        debugPrint(await _sharedPrefUtils.readString("bloodGroup"));
        if (await _sharedPrefUtils.readString("bloodGroup") != "") {
          String bloodGroup = await _sharedPrefUtils.readString("bloodGroup");
          _bloodGroupController.text = bloodGroup.replaceAll("\"", "");
          _bloodGroupController.selection = TextSelection.fromPosition(
            TextPosition(offset: _bloodGroupController.text.length),
          );
        }
      }catch(Excepetion){
        debugPrint('Error');
        debugPrint(Excepetion);
      }*/

      _emailController.text = patient.email;
      _emergencyMobileNumberController.text = patient.emergencyContactNumber;

      _cityController.text = patient.locality != null ? patient.locality : "";
      _addressController.text = patient.address != null ? patient.address : "";

      profileImagePath = patient.imageURL == null ? "" : patient.imageURL;

      setState(() {
        debugPrint(patientGender);
        selectedGender = patientGender;
      });
    } on FetchDataException catch(e) {
      print('error caught: $e');
      showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: LoginHeader(
        mobileNumberController: _mobileNumberController,
        passwordController: _passwordController,
      ),
      builder: (context, model, child) => Container(
        child: WillPopScope(
          onWillPop:() async {
            if(isEditable){
              var result = await _onBackPressed();
              return result;
            }else{
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title: Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700),
              ),
              iconTheme: new IconThemeData(color: Colors.black),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /* SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),*/
                    _profileIcon(),
                    _textFeildWidget(),
                    SizedBox(height: 20),
                    Visibility(
                      visible: isEditable,
                      child: model.busy
                          ? CircularProgressIndicator()
                          : _submitButton(model),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: !isEditable,
              child: Semantics(
                label: 'edit_profile',
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  mini: false,
                  onPressed: () {
                    isEditable = true;
                    setState(() {

                    });
                  },
                  child: Icon(Icons.edit),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Alert!'),
        content: new Text('Are you sure you want to discard the changes?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future getFile() async {
    /*FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );*/

    //With parameters:
    FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedMimeTypes: ['image/*'],
      invalidFileNameSymbols: ['/'],
    );

    /*allowedFileExtensions: ['mwfbak'],
    allowedUtiTypes: ['com.sidlatau.example.mwfbak'],*/

    String result;
    try {
      result = await FlutterDocumentPicker.openDocument(params: params);

      if(result != '') {
        File file = File(result);
        debugPrint(result);
        String fileName = file.path.split('/').last;
        print("File Name ==> ${fileName}");
      //file.renameSync(pFile.name);
      uploadProfilePicture(file);
    } else {
      showToast('Opps, something wents wrong!');
    }
    } catch (e) {
      showToast('Please select document');
      print(e);
      result = 'Error: $e';
    }
  }

/* File _image;
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

  uploadProfilePicture(File file) async {
    try {
      String _baseUrl = apiProvider.getBaseUrl();
      var map = new Map<String, String>();
      map["enc"] = "multipart/form-data";
      map["Authorization"] = 'Bearer ' + auth;

      var postUri =
          Uri.parse(_baseUrl+"/resources/upload/");
      var request = new http.MultipartRequest("POST", postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      request.fields['isPublicResource'] = "true";

      request.send().then((response) async {
        if (response.statusCode == 200) {
          print("Uploaded!");
          final respStr = await response.stream.bytesToString();
          debugPrint("Uploded " + respStr);
          UploadImageResponse uploadResponse =
              UploadImageResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == "success") {
            profileImagePath = uploadResponse.data.details.elementAt(0).url;
            //profileImage = uploadResponse.data.details.elementAt(0).url;
            showToast(uploadResponse.message);
            setState(() {
              debugPrint('File Public URL ==> ${uploadResponse.data.details.elementAt(0).url}');
            });
          } else {
            showToast('Opps, something wents wrong!');
          }
        } else {
          print("Upload Faild !");
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      debugPrint("4");
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    }
  }

  Widget _profileIcon() {
    debugPrint('Profile Pic ==> ${profileImagePath}');
    return Container(
      height: 200,
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
                  radius: 48,
                  backgroundColor: primaryLightColor,
                  child: CircleAvatar(
                      radius: 48,
                      backgroundImage: profileImagePath == ""
                          ? AssetImage('res/images/profile_placeholder.png')
                          : new NetworkImage(profileImagePath)),
                ),*/
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: profileImagePath == ""
                          ? AssetImage('res/images/profile_placeholder.png')
                          : new NetworkImage(profileImagePath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.deepPurple,
                      width: 2.0,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: isEditable,
                    child: InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                              ),
                              context: context,
                              builder: (context) => _uploadImageSelector());
                          //getFile();
                        },
                        child: SizedBox(
                            height: 32,
                            width: 32,
                            child: new Image.asset('res/images/ic_camera.png'))),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(fullName,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          Text(mobileNumber,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: primaryColor)),
        ],
      ),
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
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 32,
              ),
            ),
            Text('Back',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryFirstNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _firstNameController,
                focusNode: _firstNameFocus,
                maxLines: 1,
                keyboardType: TextInputType.name,
                enabled: false,
                style: TextStyle(
                  color: Colors.black26,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
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

  Widget _entryBloodGroupField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _bloodGroupController,
                focusNode: _bloodGroupFocus,
                keyboardType: TextInputType.name,
                enabled: true,
                style: TextStyle(
                  color: Colors.black26,
                ),
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _bloodGroupFocus, _emergencyMobileNumberFocus);
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

  Widget _entryLastNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                keyboardType: TextInputType.name,
                enabled: false,
                style: TextStyle(
                  color: Colors.black26,
                ),
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _lastNameFocus, _mobileNumberFocus);
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

  Widget _entryLocalityField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Color(0XFF909CAC),
                width: 1.0,
              ),
            ),
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _cityController,
                focusNode: _cityFocus,
                keyboardType: TextInputType.streetAddress,
                maxLines: 1,
                enabled: isEditable,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _cityFocus, _addressFocus);
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

  Widget _entryAddressField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Color(0XFF909CAC),
                width: 1.0,
              ),
            ),
            child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                obscureText: isPassword,
                controller: _addressController,
                focusNode: _addressFocus,
                keyboardType: TextInputType.streetAddress,
                maxLines: 1,
                enabled: isEditable,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _addressFocus, _cityFocus);
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

  Widget _entryEmailField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Color(0XFF909CAC),
                width: 1.0,
              ),
            ),
            child: TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _emailFocus, _emergencyMobileNumberFocus);
                },
                enabled: isEditable,
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
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.black26,
                  width: 1.0,
                ),
              ),
              child:
                  /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Text(
                      "+91",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black26,),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextFormField(
                        controller: _mobileNumberController,
                        focusNode: _mobileNumberFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        enabled: false,
                        onFieldSubmitted: (term) {
                          */ /*_fieldFocusChange(
                              context, _mobileNumberFocus, _passwordFocus);*/ /*
                        },
                        style: TextStyle(color: Colors.black26,),
                        maxLines: 1,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            filled: false)),
                  )
                ],
              )*/

                  /*InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  mobileNumber = number.parseNumber();
                  debugPrint(number.parseNumber());
                  if (mobileNumber.length == 10) {
                    //_fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                  }
                  if (mobileNumber != number.parseNumber()) {
                  } else {
                    //dismissOtpWidget();
                  }
                },
                keyboardAction: TextInputAction.next,
                focusNode: _mobileNumberFocus,
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black26),
                textFieldController: _mobileNumberController,
                isEnabled: false,
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

                  hintText: 'Mobile Number',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              )*/

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  12.0),
                child: TextFormField(
                      controller: _mobileNumberController,
                      focusNode: _mobileNumberFocus,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      enabled: false,
                      onFieldSubmitted: (term) {
                        /*_fieldFocusChange(
                                        context, _mobileNumberFocus, _passwordFocus);*/
                      },
                      style: TextStyle(
                        color: Colors.black26,
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          filled: false)),
              ),

            /*IntlPhoneField(
                *//*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*//*
                readOnly: true,
                style: TextStyle(fontSize: 16, color: Colors.black26),
                autoValidate: true,
                enabled: false,
                controller: _mobileNumberController,
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
                  *//*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*//*
                },
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
                  fillColor: Color(0xfff3f3f4),
                  filled: true)
          ),*/
              ),
        ],
      ),
    );
  }

  Widget _entryEmergencyMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Color(0XFF909CAC),
                  width: 1.0,
                ),
              ),
              child:
                  /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Text(
                      "+91",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextFormField(
                        controller: _emergencyMobileNumberController,
                        focusNode: _emergencyMobileNumberFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        enabled: true,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _emergencyMobileNumberFocus, _cityFocus);
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            filled: false)),
                  )
                ],
              )*/

                 /* InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  emergencymobileNumber = number.parseNumber();
                  debugPrint(number.parseNumber());
                  if (emergencymobileNumber.length == 10) {
                    _fieldFocusChange(
                        context, _emergencyMobileNumberFocus, _addressFocus);
                  }
                  if (emergencymobileNumber != number.parseNumber()) {
                  } else {
                    //dismissOtpWidget();
                  }
                },
                keyboardAction: TextInputAction.next,
                    spaceBetweenSelectorAndTextField: 0,
                focusNode: _emergencyMobileNumberFocus,
                textStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                textFieldController: _emergencyMobileNumberController,
                isEnabled: isEditable,
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                style: TextStyle(fontSize: 16, color: Colors.black),
                autoValidate: true,
                enabled: isEditable,
                focusNode: _emergencyMobileNumberFocus,
                decoration: InputDecoration(
                    counterText: "",
                    hintText: 'mobile_number',
                    hintStyle: TextStyle(color: Colors.transparent),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true),
                initialCountryCode: details.alpha2Code,
                controller: _emergencyMobileNumberController,
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(
                      context, _emergencyMobileNumberFocus, _addressFocus);
                },
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
                  fillColor: Color(0xfff3f3f4),
                  filled: true)
          ),*/
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
            color: Color(0xfff3f3f4),
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
                    fillColor: Color(0xfff3f3f4),
                    filled: true)
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _submitButton(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          elevation: 4.0,
          color: primaryColor,
          clipBehavior: Clip.antiAlias,
          // Add This
          child: Semantics(
            label : "saveProfile",
            child: MaterialButton(
                minWidth: 200,
                child: new Text('Save',
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                onPressed: () async {
                  if (_emailController.text.toString() == '') {
                    showToast('Please enter email');
                  } else {
                    progressDialog.show();
                    var map = new Map<String, String>();
                    map["Gender"] = selectedGender;
                    map["BirthDate"] = unformatedDOB;
                    map["Locality"] = _cityController.text;
                    map["Address"] = _addressController.text;
                    map["ImageURL"] =
                        profileImagePath == "" ? null : profileImagePath;
                    map["EmergencyContactNumber"] =
                        _emergencyMobileNumberController.text;
                    map["Email"] = _emailController.text;
                    map["LocationCoords_Longitude"] = null;
                    map["LocationCoords_Lattitude"] = null;

                    try {
                      BaseResponse updateProfileSuccess = await model
                          .updateProfile(map, userId, 'Bearer ' + auth);

                      if (updateProfileSuccess.status == 'success') {
                        progressDialog.hide();
                        showToast(updateProfileSuccess.message);
                        /* if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }*/

                        getPatientDetails(model, auth, userId);
                        //Navigator.pushNamed(context, RoutePaths.Home);
                      } else {
                        progressDialog.hide();
                        showToast(updateProfileSuccess.message);
                      }
                    } catch (CustomException) {
                      model.setBusy(false);
                      progressDialog.hide();
                      showToast(CustomException.toString());
                      debugPrint(CustomException.toString());
                    }
                  }
                }),
          ),
        ),
      ],
    );
  }

  getPatientDetails(LoginViewModel model, String auth, String userId) async {
    try {
      model.setBusy(true);
      /*//ApiProvider apiProvider = new ApiProvider();

      ApiProvider apiProvider = GetIt.instance<ApiProvider>();*/

      var map = new Map<String, String>();
      map["Content-Type"] = "application/json";
      map["authorization"] = "Bearer " + auth;

      var response = await apiProvider.get('/patient/' + userId, header: map);

      PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        await _sharedPrefUtils.save(
            "patientDetails", doctorListApiResponse.data.patient.toJson());
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        showToast(doctorListApiResponse.message);
        model.setBusy(false);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }

  /*Widget _submitButton(model) {
    return GestureDetector(
      onTap: () async {
       */ /* if (_firstNameController.text == '') {
          showToast("Please enter first name");
        } else if (_lastNameController.text == '') {
          showToast("Please enter last name");
        } else if (_mobileNumberController.text.toString().length != 10) {
          showToast("Please enter valid mobile number");
        } else if (_passwordController.text == '') {
          showToast("Please enter password");
        } else {*/ /*
          var map = new Map<String, String>();
          map["Gender"] = selectedGender;
          map["BirthDate"] = dob;
          map["Locality"] = _cityController.text;
          map["Address"] = _addressController.text;
          map["ImageURL"] = null;
          map["LocationCoords_Longitude"] = null;
          map["LocationCoords_Lattitude"] = null;

          try {
          BaseResponse updateProfileSuccess = await model.updateProfile(map, userId, 'Bearer '+auth);

          if (updateProfileSuccess.status == 'success') {
            showToast(updateProfileSuccess.message);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            //Navigator.pushNamed(context, RoutePaths.Home);
          } else {
            showToast(updateProfileSuccess.message);
          }
          } catch (CustomException) {
            model.setBusy(false);
            showToast(CustomException.toString());
            debugPrint(CustomException.toString());
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
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Save',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }*/

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
          text: 'H',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ealth',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Care',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  /* Widget _genderWidget(){
    return ToggleSwitch(
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
        });
  }*/

  Widget _genderWidget() {
    debugPrint("Gender: ${selectedGender}");
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
          AbsorbPointer(
            absorbing: !isEditable,
            child: ToggleSwitch(
                initialLabelIndex: patientGender == "Male" ? 0 : patientGender == "Female" ? 1 : 2,
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
                  if (index == 0) {
                    selectedGender = "Male";
                  } else {
                    selectedGender = "Female";
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _dateOfBirthField(String title) {
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
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Color(0XFF909CAC),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dob,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black26),
                      ),
                    ),
                    SizedBox(
                        height: 32,
                        width: 32,
                        child: new ImageIcon(AssetImage('res/images/ic_calender.png'), color: Colors.black12)),
                  ],
                ),
              ),
            ),
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(1940, 1, 1),
                  maxTime: DateTime.now().subtract(Duration(days: 1)), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    unformatedDOB = date.toIso8601String();
                    setState(() {
                      dob = dateFormat.format(date);
                    });
                    print('confirm $date');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
          ),
        ],
      ),
    );
  }

  Widget _textFeildWidget() {
    return Column(
      children: <Widget>[
        _entryFirstNameField("First Name"),
        _entryLastNameField("Last Name"),
        _entryMobileNoField("Mobile Number"),
        _dateOfBirthField("Date Of Birth"),
        _genderWidget(),
        _entryEmailField('Email*'),
        //_entryBloodGroupField("Blood Group"),
        _entryEmergencyMobileNoField("Emergency Contact Number"),
        _entryAddressField("Address"),
        _entryLocalityField("City"),
      ],
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showAlert(String title, String subtitle) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 10),
      title: title,
      subtitle: subtitle,
      configuration: IconConfiguration(icon: Icons.check_circle_outline),
    );
  }

  Widget _uploadImageSelector() {
    return Container(
      height: 160,
      color: Colors.transparent,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius:
          new BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: 'Camera',
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                  openCamera();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.camera_alt, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Camera\n   ', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Gallery',
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                  openGallery();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.image, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Gallery\n   ', style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            if(profileImagePath != '')...[
            Semantics(
              label: 'removeProfileImage',
              child: InkWell(
                onTap: (){
                  profileImagePath = '';
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: new BoxDecoration(
                          color: primaryLightColor,
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: Colors.deepPurple,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.close, color: Colors.deepPurple, size: 24,),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Remove\nPhoto', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ],
        ),
      ),
    );
  }

  openGallery() async {
      getFile();
  }

  openCamera() async {

    var picture = await _picker.getImage(
      source: ImageSource.camera,
    );
    File file = File(picture.path);
    debugPrint(picture.path);
    String fileName = file.path.split('/').last;
    print("File Name ==> ${fileName}");
    uploadProfilePicture(file);
  }

}
