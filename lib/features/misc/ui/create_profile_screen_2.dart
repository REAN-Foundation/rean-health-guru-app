import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/health_journey_registration.dart';
import 'package:patient/features/misc/view_models/login_view_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateProfileScreen2 extends StatefulWidget {
  @override
  _CreateProfileScreen2State createState() => _CreateProfileScreen2State();
}

class _CreateProfileScreen2State extends State<CreateProfileScreen2> {

  final List<String> radioItemsForRace = [ 'White', 'Black/African American', 'American Indian/Alaskan Native', 'Asian Indian', 'Chinese', 'Filipino', 'Japanese', 'Korean', 'Vietnamese', 'Hawaiian', 'Guamanian', 'Samoan', 'Native Hawaiian or Other Pacific Islander', 'Prefer not to say' ];
  final List<String> radioItemsForEthnicity = [ 'Hispanic', 'Latino', 'Non Hispanic', 'Hispanic and Latino', 'Prefer not to say' ];
  String _raceValue = '';
  String _ethnicityValue = '';
  final _sharedPrefUtils = SharedPrefUtils();
  late ProgressDialog progressDialog;
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();


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
      auth = user.data!.accessToken;
      patientUserId = user.data!.user!.id.toString();

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
        debugPrint('Patient UserId ==> $patientUserId');
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
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
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
                  SizedBox(height: 16),
                  pageNumber(),
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

  Widget pageNumber(){
    return Container(
      height: 40,
      /*decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
        ),
      ),*/
      child: Stack(
        children: [
          Positioned(top: 20,child: SizedBox(width: MediaQuery.of(context).size.width, height: 1, child: Container(color: Colors.black,),)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(child: Text("1", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),)),
                ),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(child: Text("2", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),)),
                ),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(child: Text("3", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),)),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

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
              child: Text('Continue',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              onPressed: () async {
                FirebaseAnalytics.instance.logEvent(name: 'continue_profile_button_click');
                if (_raceValue.trim() == '') {
                  showToast('Please choose your race', context);
                } else if (_ethnicityValue.trim() == '') {
                  showToast('Please choose your ethnicity', context);
                }  else {
                  progressDialog.show(max: 100, msg: 'Loading...');
                  final map = <String, String>{};

                  map['Ethnicity'] = _ethnicityValue;
                  map['Race'] = _raceValue;

                  try {
                    final BaseResponse updateProfileSuccess = await model
                        .updateProfile(map, patientUserId.toString(), 'Bearer ' + auth!);

                    if (updateProfileSuccess.status == 'success') {

                      model.setBusy(true);
                      getPatientDetails(model, auth!, patientUserId.toString());
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
        _sharedPrefUtils.saveBoolean('login1.8.167', true);
        await _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data!.patient!.toJson());
        _sharedPrefUtils.saveBoolean('login1.8.167', true);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HealthJourneyRegistrationView();
            }), (Route<dynamic> route) => false);
        /* if(getAppName() == 'Heart & Stroke Helper™ ') {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return Welcome();
              }), (Route<dynamic> route) => false);
        }else{
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return HomeView(0);
              }), (Route<dynamic> route) => false);
        }*/
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

  _textFeildWidget() {
    return Column(
      children: [
        _race(),
        _ethnicity(),
      ],
    );
  }

  Widget _race() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "What is your race?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
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
        ],
      ),
    );
  }


  Widget _ethnicity() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "What is your ethnicity?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
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
        ],
      ),
    );
  }


}