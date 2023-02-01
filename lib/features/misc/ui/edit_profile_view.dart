import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/delete_my_account.dart';
import 'package:patient/features/misc/models/file_upload_public_resource_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/features/misc/view_models/login_view_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/login_header.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:status_alert/status_alert.dart';

import 'base_widget.dart';
import 'login_with_otp_view.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();

  final TextEditingController _mobileNumberController = TextEditingController();

  //final TextEditingController _emergencyMobileNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? profileImagePath = '';
  final ImagePicker _picker = ImagePicker();
  String? mobileNumber = '';

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _mobileNumberFocus = FocusNode();

  //final _emergencyMobileNumberFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _countryFocus = FocusNode();

  final _postalFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _sharedPrefUtils = SharedPrefUtils();
  String? selectedGender = '';
  String dob = '';
  String unformatedDOB = '';
  String userId = '';
  String? auth = '';
  String addresses = '';
  late ProgressDialog progressDialog;
  String fullName = '';
  var dateFormat = DateFormat('MMM dd, yyyy');
  late Patient patient;
  bool deleteApiCall = false;

  //String profileImage = "";
  String emergencymobileNumber = '';
  bool isEditable = false;

  String countryCode = '';
  String? imageResourceId = '';
  var _api_key;

  final List<String> radioItemsForGender = ['Female', 'Intersex', 'Male'];
  final List<String> radioItemsForMiratalStatus = [ 'Single', 'Married', 'Divorced', 'Widowed'];
  final List<String> radioItemsForRace = [ 'American Indian/Alaskan Native', 'Asian', 'Black/African American', 'Native Hawaiian or Other Pacific Islander', 'White' ];
  final List<String> radioItemsForEthnicity = [ 'Hispanic/Latino', 'Not Hispanic/Latino', 'Prefer not to say' ];
  String _maritalStatusValue = '';
  String _countryValue = '';
  List<String> countryList = [];
  String _raceValue = '';
  String _ethnicityValue = '';
  String _surviourOrCaregiverValue = '';
  String _liveAloneValue = '';
  String workPriorToStrokeValue = '';

  @override
  void initState() {
    debugPrint('TimeZone ==> ${DateTime.now().timeZoneOffset}');
    _api_key = dotenv.env['Patient_API_KEY'];
    progressDialog = ProgressDialog(context: context);
    super.initState();
    loadSharedPrefs();
    loadCountries();
  }

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      patient = Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      debugPrint(patient.toJson().toString());

      dob = dateFormat.format(patient.user!.person!.birthDate!);
      unformatedDOB = patient.user!.person!.birthDate!.toIso8601String();
      _maritalStatusValue =
          patient.healthProfile!.maritalStatus.toString() == 'null'
              ? ''
              : patient.healthProfile!.maritalStatus.toString();
      if(!radioItemsForMiratalStatus.contains(_maritalStatusValue)){
        _maritalStatusValue = '';
      }
      if (patient.user!.person!.addresses!.isNotEmpty) {
        _countryValue = patient.user!.person!.addresses!
                    .elementAt(0)
                    .country
                    .toString() ==
                'null'
            ? ''
            : patient.user!.person!.addresses!.elementAt(0).country.toString();
      }
      //debugPrint('Marital Status ==> ${patient.user!.person!.maritalStatus.toString()}');
      userId = user.data!.user!.id.toString();
      auth = user.data!.accessToken;

      fullName = patient.user!.person!.firstName! +
          ' ' +
          patient.user!.person!.lastName!;
      mobileNumber = patient.user!.person!.phone;

      _firstNameController.text = patient.user!.person!.firstName!;
      _firstNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _firstNameController.text.length),
      );

      _lastNameController.text = patient.user!.person!.lastName!;
      _lastNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _lastNameController.text.length),
      );

      _mobileNumberController.text = patient.user!.person!.phone!;
      _mobileNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _mobileNumberController.text.length),
      );

      debugPrint("DOB ==> $dob");
      debugPrint("selectedGender ==> ${patient.user!.person!.gender}");
      selectedGender = patient.user!.person!.gender;

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
      try {
        _emailController.text = patient.user!.person!.email!;
      } catch (e) {
        debugPrint('Error ==> ${e.toString()}');
      }
      // _emergencyMobileNumberController.text = patient.user.person;

      imageResourceId = patient.user!.person!.imageResourceId ?? '';
      profileImagePath = imageResourceId != ''
          ? apiProvider!.getBaseUrl()! +
              '/file-resources/' +
              imageResourceId! +
              '/download'
          : '';

      _ethnicityValue = patient.healthProfile!.ethnicity ?? '';
      if(!radioItemsForEthnicity.contains(_ethnicityValue)){
        _ethnicityValue = '';
      }
      _raceValue = patient.healthProfile!.race ?? '';
      if(!radioItemsForRace.contains(_raceValue)){
        _raceValue = '';
      }
      _surviourOrCaregiverValue = patient.healthProfile!.strokeSurvivorOrCaregiver ?? '';
      _liveAloneValue = patient.healthProfile!.livingAlone == null ? '' : patient.healthProfile!.livingAlone!  ? 'Yes' : 'No';
      workPriorToStrokeValue = patient.healthProfile!.workedPriorToStroke == null ? '' : patient.healthProfile!.workedPriorToStroke!  ? 'Yes' : 'No';
      debugPrint('Race = $_raceValue \nEthinicity = $_ethnicityValue \nStroke Survivor Or Caregiver = $_surviourOrCaregiverValue \nLive Alone Value = $_liveAloneValue \nWork Prior To Stroke Value = $workPriorToStrokeValue');
      setState(() {
        debugPrint(patientGender);
        selectedGender = patientGender;
      });
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      showToast(e.toString(), context);
    }

    try {
      _cityController.text =
          patient.user!.person!.addresses!.elementAt(0).city!;
      _addressController.text =
          patient.user!.person!.addresses!.elementAt(0).addressLine!;
      _countryController.text =
          patient.user!.person!.addresses!.elementAt(0).country!;
      _postalCodeController.text =
          patient.user!.person!.addresses!.elementAt(0).postalCode!;
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
    //showDeleteDialog();
    //showDeleteAlert("Success","Patient records deleted successfully!");
  }

  loadCountries() {
    for (int i = 0; i < countries.length; i++) {
      countryList.add(countries.elementAt(i)['name']);
    }
    debugPrint('Country Count ==> ${countryList.length}');
  }

  void overFlowHandleClick(String value) {
    switch (value) {
      case 'Delete Account':
        _accountDeleteConfirmation();
        break;
    }
  }

  Widget _delete() {
    return Container(
      height: 300,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 24.0, bottom: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              const SizedBox(
                height: 24,
              ),
              RichText(
                text: TextSpan(
                  text:
                      'I understand that this will permanently delete my account, and this information cannot be recovered ever again.\n\nI understand that I will permanently lose access to all my data, with my account.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: textGrey,
                  ),
                  children: <TextSpan>[],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              deleteApiCall
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Semantics(
                            button: true,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 48,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                ),
                                child: Center(
                            child: Text(
                              'No',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: Semantics(
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                                deleteAccount();
                              },
                        child: Container(
                          height: 48,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: primaryColor, width: 1),
                              color: primaryColor),
                          child: Center(
                            child: Text(
                              'Yes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _accountDeleteConfirmation() {
    showDialog(
        barrierDismissible: false,
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
            '\n \n \n',
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
              deleteAccount();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );
  }

  deleteAccount() async {
    try {
      progressDialog.show(max: 100, msg: 'Deleting your account...');
      deleteApiCall = true;
      setState(() {});
      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth!;

      var respose = await apiProvider!.delete('/patients/$userId', header: map);

      final DeleteMyAccount deleteMyAccount = DeleteMyAccount.fromJson(respose);

      if (deleteMyAccount.status == 'success') {
        progressDialog.close();
        showDeleteDialog();
        carePlanEnrollmentForPatientGlobe = null;
        _sharedPrefUtils.save('CarePlan', null);
        _sharedPrefUtils.saveBoolean('login', null);
        _sharedPrefUtils.clearAll();
        chatList.clear();
      } else {
        progressDialog.close();
        showToast(deleteMyAccount.message!, context);
      }
      deleteApiCall = false;
      setState(() {});
    } on FetchDataException catch (e) {
      deleteApiCall = false;
      setState(() {});
      debugPrint('error caught: $e');
      showToast(e.toString(), context);
    }
  }

  showDeleteDialog() {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Card(
        elevation: 0.0,
        semanticContainer: false,
        child: Container(
          height: 300.0,
          width: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Semantics(
                label: 'Account successfully deleted',
                image: true,
                child: Image.asset(
                  'res/images/successfully.png',
                  width: 120,
                  height: 120,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Success',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Your account is getting deleted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginWithOTPView();
      }), (Route<dynamic> route) => false);
    });
  }

  showDeleteAlert(String title, String subtitle) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 5),
      title: title,
      subtitle: subtitle,
      dismissOnBackgroundTap: false,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      configuration: IconConfiguration(
          icon: Icons.check_circle_outline, color: primaryColor),
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginWithOTPView();
      }), (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel?>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: LoginHeader(
        mobileNumberController: _mobileNumberController,
        passwordController: _passwordController,
      ),
      builder: (context, model, child) => Container(
        child: WillPopScope(
          onWillPop: () async {
            if (isEditable) {
              final result = await _onBackPressed();
              return result;
            } else {
              Navigator.of(context).pop();
              return true;
            }
          },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              backgroundColor: Colors.white,
              title: Text(
                isEditable ? 'Edit Profile' : 'View Profile',
                semanticsLabel: isEditable ? 'Edit Profile' : 'View Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              iconTheme: IconThemeData(color: Colors.black),
                  /*actions: [
                if (!isEditable)
                  PopupMenuButton<String>(
                    onSelected: overFlowHandleClick,
                    itemBuilder: (BuildContext context) {
                      return {'Delete Account'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList();
                    },
                  ),
              ],*/
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
                      visible: !isEditable,
                      child: _deleteButton(),
                    ),
                    Visibility(
                      visible: isEditable,
                      child: model!.busy
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
                    label: 'Edit profile',
                    button: true,
                    child: FloatingActionButton(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      tooltip: 'Edit profile',
                      mini: false,
                      onPressed: () {
                        isEditable = true;
                        setState(() {});
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

  Widget _maritalStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Marital Status',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border:
                                Border.all(color: Color(0XFF909CAC), width: 0.80),
                            color: Colors.white),
                        child: Semantics(
                          label: 'Marital Status',
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _maritalStatusValue == ''
                                ? null
                                : _maritalStatusValue,
                            items: <String>[
                              'Single',
                              'Married',
                              'Divorced',
                              'Widowed'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text('Choose an option'),
                            onChanged: (data) {
                              debugPrint(data);
                              setState(() {
                                _maritalStatusValue = data.toString();
                              });
                              setState(() {});
                            },
                          ),
                        )),
                  ),
                ],
              )
            : Semantics(
                label: 'Marital Status ' + _maritalStatusValue.toString(),
                readOnly: true,
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
                    child: ExcludeSemantics(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _maritalStatusValue.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: textGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _race() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Race',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Race',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _raceValue == '' ? null : _raceValue,
                    items: radioItemsForRace.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _raceValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
            : Semantics(
          label: 'Race ' + _raceValue.toString(),
          readOnly: true,
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
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _raceValue.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ehinicity() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ethnicity',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Ethnicity',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _ethnicityValue == '' ? null : _ethnicityValue,
                    items: radioItemsForEthnicity.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _ethnicityValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
            : Semantics(
          label: 'Ethnicity ' + _ethnicityValue.toString(),
          readOnly: true,
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
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _ethnicityValue.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _strokeSurviourOrCaregiver() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Are you a stroke survivor or caregiver?',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Are you a stroke survivor or caregiver?',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _surviourOrCaregiverValue == '' ? null : _surviourOrCaregiverValue,
                    items: <String>[
                      'Survivor',
                      'Caregiver'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _surviourOrCaregiverValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
            : Semantics(
          label: 'Are you a stroke survivor or caregiver?' + _surviourOrCaregiverValue.toString(),
          readOnly: true,
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
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _surviourOrCaregiverValue.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _liveAlone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Do you live alone?',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Do you live alone?',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _liveAloneValue == '' ? null : _liveAloneValue,
                    items: <String>[
                      'Yes',
                      'No'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _liveAloneValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
            : Semantics(
          label: 'Do you live alone?' + _liveAloneValue.toString(),
          readOnly: true,
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
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _liveAloneValue.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _workPriorToStroke() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Did you work prior to your stroke?',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Did you work prior to your stroke?',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: workPriorToStrokeValue == '' ? null : workPriorToStrokeValue,
                    items: <String>[
                      'Yes',
                      'No'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        workPriorToStrokeValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        )
            : Semantics(
          label: 'Did you work prior to your stroke?' + workPriorToStrokeValue.toString(),
          readOnly: true,
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
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        workPriorToStrokeValue.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String?> getSuggestions(String query) {
    final List<String?> matches = [];
    matches.addAll(countryList);
    matches.retainWhere((s) => s!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget _country() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Country',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        isEditable
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border:
                                Border.all(color: Color(0XFF909CAC), width: 0.80),
                            color: Colors.white),
                        child: Semantics(
                          label: 'Country',
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _countryController,
                              onChanged: (text) {
                                debugPrint(text);
                                //_getDrugsByName();
                              },
                              /*decoration: InputDecoration(
                                                labelText: 'City'
                                            )*/
                            ),
                            suggestionsCallback: (pattern) {
                              return getSuggestions(pattern);
                            },
                            itemBuilder: (context, dynamic suggestion) {
                              return Card(
                                margin: EdgeInsets.zero,
                                semanticContainer: false,
                                elevation: 0.0,
                                child: ListTile(
                                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  title: Text(
                                    suggestion,
                                    semanticsLabel: suggestion,
                                  ),
                                ),
                              );
                            },
                            transitionBuilder: (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (dynamic suggestion) {
                              debugPrint(suggestion);
                              _countryController.text = suggestion;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a country';
                              } else {
                                return '';
                              }
                            },
                            onSaved: (value) {
                              debugPrint(value);
                            },
                          ),
                          /*DropdownButton<String>(
                            isExpanded: true,
                            value: _countryValue == '' ? null : _countryValue,
                            items: countryList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text('Choose an option'),
                            onChanged: (data) {
                              debugPrint(data);
                              setState(() {
                                _countryValue = data.toString();
                              });
                              setState(() {});
                            },
                          ),*/
                        )),
                  ),
                ],
              )
            : Semantics(
                label: 'Country ' + _countryValue.toString(),
                readOnly: true,
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
                    child: ExcludeSemantics(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _countryValue.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: textGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  _deleteButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {
          showMaterialModalBottomSheet(
              isDismissible: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              context: context,
              builder: (context) => _delete());
        },
        icon: Icon(
          Icons.delete_rounded,
          size: 32,
          color: primaryColor,
        ),
        label: Text(
          "Delete My Account",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: primaryColor),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    /*return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Semantics(
          child: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          header: true,
          readOnly: true,
        ),
        content: Text('Are you sure you want to discard the changes?'),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    ).then((value) => value as bool);*/

    return showMaterialModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) => Container(
              height: 180,
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Alert!',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Are you sure you want to discard the changes?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: textGrey,
                          ),
                          children: <TextSpan>[],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Semantics(
                              button: true,
                              label: 'No',
                              child: ExcludeSemantics(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(
                                    height: 48,
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: Border.all(
                                            color: primaryColor, width: 1),
                                        color: Colors.white),
                                    child: Center(
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Semantics(
                              button: true,
                              label: 'Yes',
                              child: ExcludeSemantics(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Container(
                                    height: 48,
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: Border.all(
                                            color: primaryColor, width: 1),
                                        color: primaryColor),
                                    child: Center(
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )).then((value) => value as bool);
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
      Map<String, String>? map = <String, String>{};
      map['enc'] = 'multipart/form-data';
      map['Authorization'] = 'Bearer ' + auth!;
      map['x-api-key'] = _api_key;

      final postUri = Uri.parse(_baseUrl + '/file-resources/upload/');
      final request = http.MultipartRequest('POST', postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      request.fields['IsPublicResource'] = 'true';

      debugPrint('Base Url ==> MultiPart ${request.url}');
      debugPrint('Request Body ==> ${json.encode(request.fields).toString()}');
      debugPrint('Headers ==> ${json.encode(request.headers).toString()}');

      request.send().then((response) async {
        if (response.statusCode == 201) {
          debugPrint('Uploaded!');
          final respStr = await response.stream.bytesToString();
          debugPrint('Uploded ' + respStr);
          final FileUploadPublicResourceResponse uploadResponse =
          FileUploadPublicResourceResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == 'success') {
            profileImagePath =
                uploadResponse.data!.fileResources!.elementAt(0).url;
            imageResourceId =
                uploadResponse.data!.fileResources!.elementAt(0).id;
            //profileImage = uploadResponse.data.details.elementAt(0).url;
            showSuccessToast('Profile picture uploaded successfully!', context);
            setState(() {
              debugPrint(
                  'File Public URL ==> ${uploadResponse.data!.fileResources!.elementAt(0).url}');
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

  Widget _profileIcon() {
    debugPrint('Profile Pic ==> $profileImagePath');
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 74,
              width: 74,
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
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: (profileImagePath == ''
                            ? AssetImage('res/images/profile_placeholder.png')
                            : NetworkImage(
                                profileImagePath!)) as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Visibility(
                      visible: isEditable,
                      child: Semantics(
                        label: 'Add profile picture',
                        button: true,
                        child: InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              showMaterialModalBottomSheet(
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0)),
                                  ),
                                  context: context,
                                  builder: (context) => _uploadImageSelector());
                              //getFile();
                            },
                            child: Image.asset(
                              'res/images/ic_camera.png',
                              height: 32,
                              width: 32,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          /*SizedBox(
            height: 8,
          ),
          Text(fullName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          SizedBox(
            height: 4,
          ),
          Text(mobileNumber!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: primaryColor)),*/
        ],
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
                color: textGrey,
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
                  enabled: false,
                  style: TextStyle(
                    color: textGrey,
                  ),
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
                color: textGrey,
                width: 1.0,
              ),
            ),
            child: Semantics(
              label: 'Last Name ' + _lastNameController.text.toString(),
              child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: isPassword,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  keyboardType: TextInputType.name,
                  enabled: false,
                  style: TextStyle(
                    color: textGrey,
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
            ),
          )
        ],
      ),
    );
  }

  Widget _entryLocalityField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
            child: Semantics(
              label: 'City ' + _cityController.text.toString(),
              textField: isEditable,
              child: ExcludeSemantics(
                child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: isPassword,
                    controller: _cityController,
                    focusNode: _cityFocus,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 1,
                    enabled: isEditable,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _cityFocus, _countryFocus);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true)),
              ),
            ),
          )
        ],
      ),
    );
  }

  /*Widget _entryCountryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
            child: Semantics(
              label: 'Country ' + _countryController.text.toString(),
              textField: isEditable,
              child: ExcludeSemantics(
                child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: isPassword,
                    controller: _countryController,
                    focusNode: _countryFocus,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 1,
                    enabled: isEditable,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _countryFocus, _postalFocus);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true)),
              ),
            ),
          )
        ],
      ),
    );
  }*/

  Widget _entryPostalField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
            child: Semantics(
              label: 'Postal Code ' +
                  _postalCodeController.text.toString().replaceAllMapped(
                      RegExp(r".{1}"), (match) => "${match.group(0)} "),
              textField: isEditable,
              child: ExcludeSemantics(
                child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: isPassword,
                    controller: _postalCodeController,
                    focusNode: _postalFocus,
                    keyboardType: TextInputType.number,
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryAddressField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
            child: Semantics(
              label: 'Address ' + _addressController.text.toString(),
              textField: isEditable,
              child: ExcludeSemantics(
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
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _entryEmailField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
            child: Semantics(
              label: "Email " + _emailController.text.toString(),
              textField: isEditable,
              child: ExcludeSemantics(
                child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _emailFocus, _addressFocus);
                    },
                    enabled: isEditable,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
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
                          fontWeight: FontWeight.normal, fontSize: 16, color: textGrey,),
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
                        style: TextStyle(color: textGrey,),
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
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: textGrey),
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Semantics(
                label:
                'Mobile number ' + _mobileNumberController.text.toString(),
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
                      color: textGrey,
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        filled: false)),
              ),
            ),

            /*IntlPhoneField(
                */ /*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*/ /*
                readOnly: true,
                style: TextStyle(fontSize: 16, color: textGrey),
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
                  debugPrint(phone.number);
                  mobileNumber = phone.number;
                  countryCode = phone.countryCode;
                  */ /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/ /*
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

  /* Widget _entryEmergencyMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
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
                  */ /*Row(
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
              )*/ /*

                  */ /* InternationalPhoneNumberInput(
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
              )*/ /*

                  IntlPhoneField(
                */ /*decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),*/ /*
                style: TextStyle(fontSize: 16, color: Colors.black),
                autoValidate: true,
                enabled: isEditable,
                focusNode: _emergencyMobileNumberFocus,
                decoration: InputDecoration(
                    counterText: '',
                    hintText: 'mobile_number',
                    hintStyle: TextStyle(color: Colors.transparent),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true),
                initialCountryCode: getCurrentLocale(),
                controller: _emergencyMobileNumberController,
                textInputAction: TextInputAction.next,
                onSubmitted: (term) {
                  _fieldFocusChange(
                      context, _emergencyMobileNumberFocus, _addressFocus);
                },
                onChanged: (phone) {
                  debugPrint(phone.countryCode);
                  debugPrint(phone.number);
                  mobileNumber = phone.number;
                  countryCode = phone.countryCode;
                  */ /*if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                    }*/ /*
                },
              )

              */ /*InternationalPhoneNumberInput
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
          ),*/ /*
              ),
        ],
      ),
    );
  }*/

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

  Widget _submitButton(model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(
                      primaryLightColor),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(
                      primaryColor),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(24),
                          side: BorderSide(
                              color: primaryColor)))),
              child: Text('Save',
                  semanticsLabel: 'Save Profile',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                if (_emailController.text.toString() != '' &&
                    !_emailController.text.toString().isValidEmail()) {
                  showToast('Please enter valid email', context);
                }
                /*else if () {
                  showToast('Please enter valid email', context);
                } else if (_addressController.text.toString().trim() == '') {
                  showToast('Please enter address', context);
                } else if (_cityController.text.toString().trim() == '') {
                  showToast('Please enter city', context);
                } else if (_countryController.text.toString().trim() == '') {
                  showToast('Please enter country', context);
                }*/
                /*else if (_postalCodeController.text.toString() == '') {
                  showToast('Please enter postal code', context);
                } */
                else {
                  progressDialog.show(max: 100, msg: 'Loading...');

                  final map = <String, dynamic>{};
                  map['Gender'] = selectedGender;
                  map['BirthDate'] = DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(unformatedDOB));
                  map['FirstName'] = _firstNameController.text;
                  map['MiddleName'] = _middleNameController.text;
                  map['LastName'] = _lastNameController.text;
                  map['MaritalStatus'] = _maritalStatusValue;
                  map['Ethnicity'] = _ethnicityValue;
                  map['StrokeSurvivorOrCaregiver'] = _surviourOrCaregiverValue == '' ? null : _surviourOrCaregiverValue;
                  map['LivingAlone'] = _liveAloneValue == '' ? null : _liveAloneValue == 'Yes' ? true : false;
                  map['WorkedPriorToStroke'] = workPriorToStrokeValue == '' ? null : workPriorToStrokeValue == 'Yes' ? true : false;
                  map['Race'] = _raceValue;
                  final address = <String, String?>{};
                  address['AddressLine'] = _addressController.text.trim();
                  address['City'] = _cityController.text.trim();
                  address['Country'] = _countryController.text.trim();
                  address['PostalCode'] = _postalCodeController.text.isEmpty
                      ? null
                      : _postalCodeController.text.trim();
                  map['Address'] = address;

                  //map['Locality'] = _cityController.text;
                  //map['Address'] = _addressController.text;
                  map['ImageResourceId'] =
                      imageResourceId == '' ? null : imageResourceId;
                  //map['EmergencyContactNumber'] =
                  //  _emergencyMobileNumberController.text;
                  if (_emailController.text != '') {
                    map['Email'] = _emailController.text;
                  }else{
                    map['Email'] = null;
                  }
                  //map['LocationCoords_Longitude'] = null;
                  //map['LocationCoords_Lattitude'] = null;

                  try {
                    final BaseResponse updateProfileSuccess = await model
                        .updateProfile(map, userId, 'Bearer ' + auth!);

                    if (updateProfileSuccess.status == 'success') {
                      progressDialog.close();
                      showSuccessToast('Patient profile details updated successfully!', context);
                      /* if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }*/

                      getPatientDetails(model, auth!, userId);
                      //Navigator.pushNamed(context, RoutePaths.Home);
                    } else {
                      progressDialog.close();
                      showToast(updateProfileSuccess.message!, context);
                    }
                  } on FetchDataException catch (e) {
                    debugPrint("3");
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
      model.setBusy(true);
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
        debugPrint(doctorListApiResponse.data!.patient!.user!.person!
            .toJson()
            .toString());
        await _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data!.patient!.toJson());
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(0);
        }), (Route<dynamic> route) => false);
        model.setBusy(false);
      } else {
        showToast(doctorListApiResponse.message!, context);
        model.setBusy(false);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
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

  /*RadioGroup<String>.builder(
                      items: radioItemsForGender,
                      groupValue: selectedGender.toString(),
                      horizontalAlignment: MainAxisAlignment.start,
                      onChanged: (item) {
                        debugPrint(item);
                        selectedGender = item;
                        setState(() {});
                      },
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                        textPosition: RadioButtonTextPosition.right,
                      ),
                    ),*/

  Widget _genderWidget() {
    debugPrint('Gender: $selectedGender');
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sex',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          isEditable
              ? Semantics(
            label: selectedGender,
                  child: AbsorbPointer(
                    absorbing: !isEditable,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                          color: Colors.white),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedGender == ''
                            ? null
                            : selectedGender,
                        items: radioItemsForGender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text('Choose an option'),
                        onChanged: (data) {
                          debugPrint(data);
                          setState(() {
                            selectedGender = data.toString();
                          });
                          setState(() {});
                        },
                      ),
                    )
                  ),
                )
              : Semantics(
            label: 'Sex ' + selectedGender.toString(),
                  readOnly: true,
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
                      child: ExcludeSemantics(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                selectedGender.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: textGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _dateOfBirthField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
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
            label: 'Date Of Birth ' + dob,
            readOnly: true,
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
                child: ExcludeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dob,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: textGrey),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFeildWidget() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: _entryFirstNameField('First Name')),
            SizedBox(
              width: 8,
            ),
            Expanded(flex: 1, child: _entryLastNameField('Last Name')),
          ],
        ),
        _genderWidget(),
        SizedBox(
          height: 8,
        ),
        _dateOfBirthField('Date Of Birth'),
        SizedBox(
          height: 8,
        ),
        _entryMobileNoField('Mobile Number'),
        SizedBox(
          height: 8,
        ),
        _maritalStatus(),
        SizedBox(
          height: 8,
        ),
        _entryEmailField('Email'),
        SizedBox(
          height: 8,
        ),
        _race(),
        SizedBox(
          height: 16,
        ),
        _ehinicity(),
        SizedBox(
          height: 16,
        ),
        _strokeSurviourOrCaregiver(),
        SizedBox(
          height: 16,
        ),
        _liveAlone(),
        SizedBox(
          height: 16,
        ),
        _workPriorToStroke(),
        SizedBox(
          height: 8,
        ),
        //_entryBloodGroupField("Blood Group"),
        //_entryEmergencyMobileNoField('Emergency Contact Number'),
        SizedBox(
          height: 8,
        ),
        _entryAddressField('Address'),
        SizedBox(
          height: 8,
        ),
        _entryLocalityField('City'),
        SizedBox(
          height: 8,
        ),
        _country(),
        /* Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child:
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: ,//_entryCountryField('Country'),
            ),
          ],
        ),*/
        SizedBox(
          height: 8,
        ),
        _entryPostalField('Postal Code'),
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

  Widget _uploadImageSelector() {
    return Container(
      height: 160,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: 'Camera',
              button: true,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
                child: ExcludeSemantics(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Camera\n   ',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Gallery',
              button: true,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
                child: ExcludeSemantics(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Gallery\n   ',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*if (profileImagePath != '') ...[
              Semantics(
                label: 'removeProfileImage',
                child: InkWell(
                  onTap: () {
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
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            border: Border.all(
                              color: primaryColor,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Remove\nPhoto',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],*/
          ],
        ),
      ),
    );
  }

  openGallery() async {
    //getFile();
    final picture = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    final File file = File(picture!.path);
    debugPrint(picture.path);
    final String fileName = file.path.split('/').last;
    debugPrint('File Name ==> $fileName');
    uploadProfilePicture(file);
  }

  openCamera() async {
    final picture = await _picker.pickImage(
      source: ImageSource.camera,
    );
    final File file = File(picture!.path);
    debugPrint(picture.path);
    final String fileName = file.path.split('/').last;
    debugPrint('File Name ==> $fileName');
    uploadProfilePicture(file);
  }
}
