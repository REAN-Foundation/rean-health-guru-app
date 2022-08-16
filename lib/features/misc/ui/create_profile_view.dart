import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/upload_image_response.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/features/misc/view_models/login_view_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:status_alert/status_alert.dart';

import 'base_widget.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? profileImagePath = '';
  final ImagePicker _picker = ImagePicker();
  String mobileNumber = '';

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _sharedPrefUtils = SharedPrefUtils();
  String selectedGender = '';
  String dob = '';
  String unformatedDOB = '';
  String userId = '';
  String? auth = '';
  late ProgressDialog progressDialog;
  String fullName = '';
  var dateFormat = DateFormat('MMM dd, yyyy');

  final List<String> radioItemsForGender = ['Female', 'Intersex', 'Male'];

  //Patient patient;
  //String profileImage = "";
  String emergencymobileNumber = '';
  bool isEditable = false;

  @override
  void initState() {
    debugPrint('TimeZone ==> ${DateTime.now().timeZoneOffset}');

    super.initState();
    loadSharedPrefs();
  }

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      //patient = Patient.fromJson(await _sharedPrefUtils.read("patientDetails"));
      debugPrint(user.toJson().toString());
      userId = user.data!.user!.id.toString();
      auth = user.data!.accessToken;

      /* fullName = user.data.user.firstName + " " + user.data.user.lastName;
      mobileNumber = user.data.user.phoneNumber;

      _firstNameController.text = user.data.user.firstName;
      _firstNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _firstNameController.text.length),
      );

      _lastNameController.text = user.data.user.lastName;
      _lastNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _lastNameController.text.length),
      );

      _mobileNumberController.text = user.data.user.phoneNumber;
      _mobileNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _mobileNumberController.text.length),
      );

      debugPrint(patient.gender.toString());
      selectedGender = patient.gender.toString();*/

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
        debugPrint(Excepetion.toString());
      }*/

      /*_emailController.text = user.data.user.email;
      _emergencyMobileNumberController.text = patient.emergencyContactNumber;

      _cityController.text = patient.locality != null ? patient.locality : "";
      _addressController.text = patient.address != null ? patient.address : "";

      profileImagePath = patient.imageURL == null ? "" : patient.imageURL;*/

      setState(() {
        debugPrint('Patient UserId ==> $userId');
        //selectedGender = patient.gender.toString();
      });
    } on FetchDataException catch (e) {
      // do something
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<LoginViewModel?>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(
              'Create Profile',
              style: TextStyle(
                  fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40),
                      //_profileIcon(),
                      _textFeildWidget(),
                      SizedBox(height: 20),
                      if (model!.busy)
                    CircularProgressIndicator()
                  else
                    _submitButton(model),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }


  Future getFile() async {
    /*FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );*/

    //With parameters:
    final FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedMimeTypes: ['image/*'],
      invalidFileNameSymbols: ['/'],
    );

    /*allowedFileExtensions: ['mwfbak'],
    allowedUtiTypes: ['com.sidlatau.example.mwfbak'],*/

    String? result;
    try {
      result = await FlutterDocumentPicker.openDocument(params: params);

      if (result != '') {
        final File file = File(result!);
        debugPrint(result);
        final String fileName = file.path.split('/').last;
        debugPrint('File Name ==> $fileName');
        //file.renameSync(pFile.name);
        uploadProfilePicture(file);
      } else {
        showToast('Opps, something wents wrong!', context);
      }
    } catch (e) {
      showToast('Please select document', context);
      debugPrint(e.toString());
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
      final String _baseUrl = apiProvider!.getBaseUrl()!;
      final map = <String, String>{};
      map['enc'] = 'multipart/form-data';
      map['Authorization'] = 'Bearer ' + auth!;

      final postUri = Uri.parse(_baseUrl + '/resources/upload/');
      final request = http.MultipartRequest('POST', postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      request.fields['isPublicResource'] = 'true';

      request.send().then((response) async {
        if (response.statusCode == 200) {
          debugPrint('Uploaded!');
          final respStr = await response.stream.bytesToString();
          debugPrint('Uploded ' + respStr);
          final UploadImageResponse uploadResponse =
          UploadImageResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == 'success') {
            profileImagePath = uploadResponse.data!.details!.elementAt(0).url;
            //profileImage = uploadResponse.data.details.elementAt(0).url;
            showToast(uploadResponse.message!, context);
            setState(() {
              debugPrint(
                  'File Public URL ==> ${uploadResponse.data!.details!.elementAt(0).url}');
            });
          } else {
            showToast('Opps, something wents wrong!', context);
          }
        } else {
          debugPrint('Upload Faild !');
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      debugPrint('4');
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }


  Widget _entryFirstNameField(String title, {bool isPassword = false}) {
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
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
              ),
            ),
            child: Semantics(
              label: 'First Name ' + _firstNameController.text.toString(),
              child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: isPassword,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
            child: Semantics(
              label: 'Last name ' + _lastNameController.text.toString(),
              child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: isPassword,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) {
                    /*_fieldFocusChange(
                        context, _lastNameFocus, _mobileNumberFocus);*/
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          )
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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

  Widget _submitButton(LoginViewModel model) {
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
          child: MaterialButton(
              minWidth: 200,
              child: Text('Save',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                if (_firstNameController.text.toString().trim() == '') {
                  showToast('Please enter First Name', context);
                } else if (_lastNameController.text.toString().trim() == '') {
                  showToast('Please enter Last Name', context);
                } else if (unformatedDOB == '') {
                  showToast('Please select your date of birth', context);
                } else if (selectedGender == '') {
                  showToast('Please select your gender', context);
                } else {
                  progressDialog.show(max: 100, msg: 'Loading...');
                  progressDialog.show(max: 100, msg: 'Loading...');
                  final map = <String, String>{};
                  map['FirstName'] =
                      _firstNameController.text.toString().trim();
                  map['LastName'] = _lastNameController.text.toString().trim();
                  map['BirthDate'] = unformatedDOB;
                  map['Gender'] = selectedGender;
                  map['DefaultTimeZone'] =
                      DateTime.now().timeZoneOffset.toString();

                  try {
                    final BaseResponse updateProfileSuccess = await model
                        .updateProfile(map, userId, 'Bearer ' + auth!);

                    if (updateProfileSuccess.status == 'success') {
                      progressDialog.close();
                      if (getAppType() == 'AHA') {
                        showToast('Welcome to ' + getAppName(), context);
                      } else {
                        showToast('Welcome to REAN HealthGuru', context);
                      }
                      /* if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }*/
                      model.setBusy(true);
                      getPatientDetails(model, auth!, userId);
                      //Navigator.pushNamed(context, RoutePaths.Home);
                    } else {
                      progressDialog.close();
                      showToast(updateProfileSuccess.message!, context);
                    }
                  } on FetchDataException catch (e) {
                    debugPrint('error caught: $e');
                    model.setBusy(false);
                    showToast(e.toString(), context);
                  }
                }
              }),
        ),
      ],
    );
  }

  getPatientDetails(LoginViewModel model, String auth, String userId) async {
    try {
      /*//ApiProvider apiProvider = new ApiProvider();

      ApiProvider apiProvider = GetIt.instance<ApiProvider>();*/

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth;

      final response =
          await apiProvider!.get('/patients/' + userId, header: map);

      final PatientApiDetails doctorListApiResponse =
          PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        _sharedPrefUtils.saveBoolean('login1.8.81', true);
        await _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data!.patient!.toJson());
        _sharedPrefUtils.saveBoolean('login1.8.81', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        showToast(doctorListApiResponse.message!, context);
        model.setBusy(false);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
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
            showToast(CustomException.toString(), context);
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
          debugPrint('switched to: $index');
        });
  }*/

  Widget _genderWidget() {
    debugPrint('Gender: $selectedGender');
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          /*ToggleSwitch(
              minWidth: 120.0,
              cornerRadius: 20,
              initialLabelIndex: 0,
              totalSwitches: 2,
              activeBgColor: [Colors.green],
              inactiveBgColor: Colors.grey,
              labels: ['Male', 'Female', 'Intersex'],
              activeBgColors: [
                [Colors.blue],
                [Colors.pink]
              ],
              onToggle: (index) {
                debugPrint('switched to: $index');
                if (index == 0) {
                  selectedGender = 'Male';
                } else if(index == 1) {
                  selectedGender = 'Female';
                } else {
                  selectedGender = 'Intersex';
                }
              })*/
          RadioGroup<String>.builder(
            items: radioItemsForGender,
            groupValue: selectedGender.toString(),
            direction: Axis.horizontal,
            horizontalAlignment: MainAxisAlignment.start,
            onChanged: (item) {
              debugPrint(item);
              selectedGender = item.toString();
              setState(() {});
            },
            itemBuilder: (item) => RadioButtonBuilder(
              item,
              textPosition: RadioButtonTextPosition.right,
            ),
          ),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Semantics(
            label: 'Date of Birth ' + dob,
            button: true,
            child: GestureDetector(
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
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          height: 32,
                          width: 32,
                          child: ImageIcon(
                              AssetImage('res/images/ic_calender.png'),
                              color: Colors.black12)),
                    ],
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1940, 1, 1),
                    maxTime: DateTime.now().subtract(Duration(days: 1)),
                    onChanged: (date) {
                      debugPrint('change $date');
                    }, onConfirm: (date) {
                      unformatedDOB =
                          date.toIso8601String().replaceAll("T00:00:00.000", "");
                      setState(() {
                        dob = dateFormat.format(date);
                      });
                      debugPrint('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFeildWidget() {
    return Column(
      children: <Widget>[
        _entryFirstNameField('First Name'),
        _entryLastNameField('Last Name'),
        //_entryMobileNoField("Mobile Number"),
        _dateOfBirthField('Date Of Birth'),
        _genderWidget(),
        /* _entryEmailField('Email'),
        //_entryBloodGroupField("Blood Group"),
        _entryEmergencyMobileNoField("Emergency Contact Number"),
        _entryAddressField("Address"),
        _entryLocalityField("City"),*/
      ],
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
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


  openGallery() async {
    getFile();
  }

  openCamera() async {
    final picture = await (_picker.pickImage(
      source: ImageSource.camera,
    ) as FutureOr<XFile>);
    final File file = File(picture.path);
    debugPrint(picture.path);
    final String fileName = file.path.split('/').last;
    debugPrint('File Name ==> $fileName');
    uploadProfilePicture(file);
  }
}
