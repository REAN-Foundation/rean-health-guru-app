
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/nutrition/models/alcohol_consumption.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_medical_profile_pojo.dart';
import 'package:patient/features/misc/view_models/patients_observation.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';

import 'base_widget.dart';

class PatientMedicalProfileView extends StatefulWidget {
  @override
  _PatientMedicalProfileViewState createState() =>
      _PatientMedicalProfileViewState();
}

class _PatientMedicalProfileViewState extends State<PatientMedicalProfileView> {
  HealthProfile? healthProfile;

  var model = PatientObservationsViewModel();
  final TextEditingController _majorAilmentController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _procedureHistoryController =
      TextEditingController();

  /*final TextEditingController _ethnicityController =
  TextEditingController();*/

  String mobileNumber = '';
  Color buttonColor = primaryLightColor;
  final _majorAilmentFocus = FocusNode();
  final _ocupationFocus = FocusNode();
  final _nationalityFocus = FocusNode();
  final _procedureHistoryFocus = FocusNode();
  DateTime? startDate;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  double weight = 0;
  double height = 0;
  String heightInFeet = '0';

  int heightInFt = 0;
  int heightInInch = 0;
  late var heightArry;

  int alcoholIntakeInMililitre = 0;
  AlcoholConsumption? _alcoholConsumption;

  /* final _ethnicityFocus = FocusNode();*/

  loadSharedPref() async {
    height = await _sharedPrefUtils.readDouble('height');

    if (height != 0.0) {
      heightInFeet = Conversion.cmToFeet(height.toInt());
    }

    if(heightInFeet == '0.12'){
      heightInFeet = '1.0';
    }

    heightArry = heightInFeet.toString().split('.');
    heightInFt = int.parse(heightArry[0]);
    heightInInch = int.parse(heightArry[1]);

    if(heightInInch == 12){
      heightInFt = heightInFt + 1;
      heightInInch = 0;
      heightInFeet = heightInFt.toString()+'.0';
    }

    setState(() {});
  }

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    _getPatientMedicalProfile();
    loadSharedPref();
    loadAlcohol();
    super.initState();
  }

  loadAlcohol() async {
    final alcoholIntake = await _sharedPrefUtils.read('alcoholIntake');

    if (alcoholIntake != null) {
      _alcoholConsumption = AlcoholConsumption.fromJson(alcoholIntake);
    }

    if (_alcoholConsumption != null) {
      if (startDate == _alcoholConsumption!.date) {
        alcoholIntakeInMililitre = _alcoholConsumption!.count ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientObservationsViewModel?>(
        model: model,
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              backgroundColor: Colors.white,
              title: Text(
                'Medical Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
                body: model!.busy
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Main Condition',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(': ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    '' +
                                        replaceNull(
                                            healthProfile!.majorAilment),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),
                          /*SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Ethnicity',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(': ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    '' + replaceNull(healthProfile!.ethnicity),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Race',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(': ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    '' + replaceNull(healthProfile!.race),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),*/
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Blood Type',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(':',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Text('' + replaceNull(healthProfile!.bloodGroup),
                                  semanticsLabel: replaceNull(healthProfile!.bloodGroup).contains('+') ? replaceNull(healthProfile!.bloodGroup).replaceAll('+', ' Positive') : replaceNull(healthProfile!.bloodGroup).replaceAll('-', ' Negative') ,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: textBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Occupation',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(':',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    '' + replaceNull(healthProfile!.occupation),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Height',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(': ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    height == 0
                                        ? ''
                                        : getCurrentLocale() == "US" ?  heightInFeet
                                                .toString()
                                                .replaceAll('.', " ft ") +
                                            ' inch': height.toStringAsFixed(0)+' cm',
                                    semanticsLabel: getCurrentLocale() == "US" ?  heightInFeet
                                            .toString()
                                            .replaceAll('.', 'Feet ') +
                                        ' inches': height.toStringAsFixed(0)+' centimeter',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Have you used tobacco products (such as cigarettes, electronic cigarettes, cigars, smokeless tobacco, or hookah) over the past year?',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                height: 8,
                              ),
                              if(healthProfile!.tobaccoQuestionAns != null)
                              Text('' + yesOrNo(healthProfile!.tobaccoQuestionAns!),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: textBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Do you have heart disease, have you had a previous heart attack, stroke or other cardiovascular event?',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              if(healthProfile!.hasHeartAilment != null)
                              Text(
                                  '' + yesOrNo(healthProfile!.hasHeartAilment!),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: textBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 150,
                                child: Text('Type of Stroke',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack)),
                              ),
                              Text(':',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                    '' + replaceNull(healthProfile!.typeOfStroke),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Have you ever been told by your healthcare professional that you have any of the following?',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 180,
                                          child: Text('High Blood Pressure',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: textBlack)),
                                        ),
                                        Text(':',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: textBlack)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(healthProfile!.hasHighBloodPressure == null ? '' : yesOrNo(healthProfile!.hasHighBloodPressure!),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: textBlack)),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 180,
                                          child: Text('High Cholesterol',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: textBlack)),
                                        ),
                                        Text(':',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: textBlack)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(healthProfile!.hasHighCholesterol == null ? '' : yesOrNo(healthProfile!.hasHighCholesterol!),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: textBlack)),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 180,
                                          child: Text('Diabetes',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: textBlack)),
                                        ),
                                        Text(':',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: textBlack)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(healthProfile!.isDiabetic == null ? '' : yesOrNo(healthProfile!.isDiabetic!),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: textBlack)),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 180,
                                          child: Text('Atrial Fibrillation',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: textBlack)),
                                        ),
                                        Text(':',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: textBlack)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(healthProfile!.hasAtrialFibrillation == null ? '' : yesOrNo(healthProfile!.hasAtrialFibrillation!),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: textBlack)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),



                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Alcohol Intake',
                                semanticsLabel: 'Alcohol Intake',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: textBlack),
                              ),
                              InfoScreen(
                                  tittle: 'Alcohol Intake Information',
                                  description:
                                  'One drink is 12 ounces of beer, 4 ounces of wine, 1.5 ounces of 80-proof spirits or 1 ounce of 100-proof spirit.',
                                  height: 200),
                            ],
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              border: Border.all(color: primaryColor, width: 0.80),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          if(alcoholIntakeInMililitre > 0) {
                                            alcoholIntakeInMililitre =
                                                alcoholIntakeInMililitre - 1;
                                            recordMyAlcoholConsumption(
                                                alcoholIntakeInMililitre);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: primaryColor,
                                          semanticLabel: 'Add alcohol intake',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Semantics(
                                    label: alcoholIntakeInMililitre
                                        .toStringAsFixed(0) +
                                        (alcoholIntakeInMililitre > 1
                                            ? 'glasses'
                                            : 'glass'),
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            alcoholIntakeInMililitre.toString(),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            alcoholIntakeInMililitre > 1
                                                ? 'glasses'
                                                : 'glass',
                                            semanticsLabel:
                                            alcoholIntakeInMililitre > 1
                                                ? 'glasses'
                                                : 'glass',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          */ /*Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AddAlcoholConsumptionView(
                                                    submitButtonListner:
                                                        (alcoholConsumed) {
                                                      debugPrint(alcoholConsumed);
                                                      recordMyAlcoholConsumption(
                                                          int.parse(
                                                              alcoholConsumed));
                                                      Navigator.of(context,
                                                          rootNavigator: true)
                                                          .pop();
                                                    },
                                                  ),
                                            ),
                                          );*/ /*

                                          alcoholIntakeInMililitre = alcoholIntakeInMililitre + 1;
                                          recordMyAlcoholConsumption(alcoholIntakeInMililitre);

                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel: 'Add alcohol intake',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),*/
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
            floatingActionButton: model.busy
                ? Container()
                : Semantics(
              label: 'Edit Medical Profile',
                    button: true,
                    child: FloatingActionButton(
                        elevation: 0.0,
                        tooltip: 'Edit Medical Profile',
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        backgroundColor: primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context,
                                  RoutePaths.Patient_EDIT_MEDIACL_PROFILE,
                                  arguments: healthProfile)
                              .then((value) {
                            _getPatientMedicalProfile();
                          });
                        }),
                  )));
  }

  String replaceNull(String? text) {
    debugPrint('Medical Profile ==> $text');
    return text ?? '';
  }

  String yesOrNo(bool flag) {
    return flag == null ? '' : flag ? 'Yes' : 'No';
  }

  _getPatientMedicalProfile() async {
    try {
      final PatientMedicalProfilePojo allergiesPojo = await model
          .getPatientMedicalProfile('Bearer ' + auth!, patientUserId);

      if (allergiesPojo.status == 'success') {
        healthProfile = allergiesPojo.data!.healthProfile;
        loadSharedPref();
      } else {}
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
    }
  }

  recordMyAlcoholConsumption(int alcoholInMililitre) async {
    try {
      recordMyMonitoringFoodConsumtion(
          'Alcohol', 'ml', alcoholInMililitre.toDouble());
      _sharedPrefUtils.save('alcoholIntake',
          AlcoholConsumption(startDate, alcoholIntakeInMililitre, '').toJson());
      showToast("Alcohol intake updated successfully", context);
      setState(() {});
      /* final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Volume'] = waterGlass;
      map['Time'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {
      } else {}*/
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMyMonitoringFoodConsumtion(
      String foodName, String unit, double amount) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['MonitoredFoodComponent'] = foodName;
      map['Unit'] = unit;
      map['Amount'] = amount;

      final BaseResponse baseResponse =
          await model.recordMyMonitoringFoodConsumtion(map);
      if (baseResponse.status == 'success') {
        //showToast(baseResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      //model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }

  medicalProfileDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            Expanded(
              flex: 8,
              child: Text(
                'Medical Profile',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              alignment: Alignment.topRight,
              icon: Icon(Icons.close),
              tooltip: 'Close',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _textFeilds(
                              'Major Ailment',
                              _majorAilmentController,
                              _majorAilmentFocus,
                              _ocupationFocus),
                          _textFeilds('Occupation', _ocupationController,
                              _ocupationFocus, _nationalityFocus),
                          _textFeilds('Nationality', _nationalityController,
                              _nationalityFocus, _procedureHistoryFocus),
                          _textFeilds(
                              'Procedure history',
                              _procedureHistoryController,
                              _procedureHistoryFocus,_procedureHistoryFocus),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _textFeilds(String hint, TextEditingController editingController,
      FocusNode focusNode, FocusNode nextFocusNode) {
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      textInputAction: nextFocusNode == _procedureHistoryController
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, focusNode, nextFocusNode);
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

/* TextField(
  textAlign: TextAlign.left,
  decoration: InputDecoration(
  labelText: "Major Complaint",
  labelStyle: TextStyle(
  color: Colors.grey,
  fontSize: 16,
  ),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  ),
  ),
  TextField(
  textAlign: TextAlign.left,
  decoration: InputDecoration(
  labelText: "Occupation",
  labelStyle: TextStyle(
  color: Colors.grey,
  fontSize: 16,
  ),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  ),
  ),
  TextField(
  textAlign: TextAlign.left,
  decoration: InputDecoration(
  labelText: "Nationality/Ethnicity",
  labelStyle: TextStyle(
  color: Colors.grey,
  fontSize: 16,
  ),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  ),
  ),
  TextField(
  textAlign: TextAlign.left,
  decoration: InputDecoration(
  labelText: "Surgical history",
  labelStyle: TextStyle(
  color: Colors.grey,
  fontSize: 16,
  ),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  ),
  ),
  TextField(
  textAlign: TextAlign.left,
  decoration: InputDecoration(
  labelText: "Obstetric history",
  labelStyle: TextStyle(
  color: Colors.grey,
  fontSize: 16,
  ),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: primaryColor),
  ),
  ),
  ),*/

}
