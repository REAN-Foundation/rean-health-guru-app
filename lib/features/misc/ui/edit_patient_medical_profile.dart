
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/activity/ui/add_height_cm_dialog.dart';
import 'package:patient/features/common/activity/ui/add_height_ft_n_Inch_dialog.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_medical_profile_pojo.dart';
import 'package:patient/features/misc/view_models/patients_observation.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'base_widget.dart';

//ignore: must_be_immutable
class EditPatientMedicalProfileView extends StatefulWidget {
  HealthProfile? healthProfile;

  EditPatientMedicalProfileView(HealthProfile mProfiles) {
    healthProfile = mProfiles;
  }

  @override
  _EditPatientMedicalProfileViewState createState() =>
      _EditPatientMedicalProfileViewState();
}

class _EditPatientMedicalProfileViewState
    extends State<EditPatientMedicalProfileView> {
  final List<String> radioItems = [
    'Yes',
    'No',
  ];

  final List<String> maritalStatusItems = [
    'Married',
    'Single',
  ];

  var model = PatientObservationsViewModel();

  final _heightInFeetController = TextEditingController();

  final TextEditingController _majorAilmentController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _procedureHistoryController =
      TextEditingController();

  late ProgressDialog progressDialog;

  final _majorAilmentFocus = FocusNode();
  final _ocupationFocus = FocusNode();

  final _obstetricHistoryFocus = FocusNode();

  var isDiabetic = '';
  var hasHeartAilment = '';
  var sedentaryLifestyle;
  var isSmoker = '';
  var isDrinker = '';
  var isBloodPressure = '';
  var isHighCholesterol = '';
  var isAtrialfibrillation = '';
  /*  String _ethnicityValue = '';
  String _raceValue = '';*/

  String maritalStatus = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  int height = 0;

  late var heightArray;
  int heightInFt = 0;
  int heightInInch = 0;
  String heightInDouble = '0.0';
  late var heightArry;
  String _bloodgroupValue = '';
  String selectedUnit = '';

  String _typeOfStrokeValue = '';





  @override
  void initState() {
    setData();
    loadSharedPref();
    super.initState();
  }

  loadSharedPref() async {
    var heightStored = await _sharedPrefUtils.readDouble('height');
    debugPrint('Height Stored ==> $heightStored');
    height = heightStored.toInt();

    if (height != 0.0) {
      //double heightInFeet = Conversion.cmToFeet(height);
      conversion();
    }
  }

  conversion() {
    if (height != 0.0) {
      debugPrint('Conversion Height in cms => $height');
      heightInDouble = Conversion.cmToFeet(height.toInt());
      debugPrint('Conversion Height in ft & inch => $heightInDouble');
      if(heightInDouble == '0.12'){
        heightInDouble = '1.0';
      }
      heightArry = heightInDouble.toString().split('.');
      heightInFt = int.parse(heightArry[0]);
      heightInInch = int.parse(heightArry[1]);

      if(heightInInch == 12){
        heightInFt = heightInFt + 1;
        heightInInch = 0;
        heightInDouble = heightInFt.toString()+'.0';
      }

      debugPrint('Conversion Height => $heightInFt ft $heightInInch inch');

      if (getCurrentLocale() == 'US') {
        _heightInFeetController.text =
            heightInDouble.toString().replaceAll('.', " ft ")+' inch';
        _heightInFeetController.selection = TextSelection.fromPosition(
          TextPosition(offset: _heightInFeetController.text.length),
        );
      } else {
        _heightInFeetController.text = height.toString() + ' cm';
        _heightInFeetController.selection = TextSelection.fromPosition(
          TextPosition(offset: _heightInFeetController.text.length),
        );
      }
      setState(() {});
    }
  }

  setData() {
    _majorAilmentController.text = widget.healthProfile!.majorAilment ?? '';
    _majorAilmentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _majorAilmentController.text.length),
    );

    _ocupationController.text = widget.healthProfile!.occupation ?? '';
    _ocupationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ocupationController.text.length),
    );

    if(widget.healthProfile!.isDiabetic != null)
    isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);

    if(widget.healthProfile!.isSmoker != null)
    isSmoker = yesOrNo(widget.healthProfile!.isSmoker!);

    if(widget.healthProfile!.hasHeartAilment != null)
    hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);

    _procedureHistoryController.text =
        widget.healthProfile!.procedureHistory ?? '';
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

/*    _ethnicityValue = widget.healthProfile!.ethnicity ?? '';
    _raceValue = widget.healthProfile!.race ?? '';*/
    _bloodgroupValue = widget.healthProfile!.bloodGroup ?? '';

    _typeOfStrokeValue = widget.healthProfile!.typeOfStroke ?? '';

    if( widget.healthProfile!.isDiabetic != null)
      isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);

    if(widget.healthProfile!.hasHighBloodPressure != null) {
      isBloodPressure = yesOrNo(widget.healthProfile!.hasHighBloodPressure!);
    }
    if(widget.healthProfile!.hasHighCholesterol != null) {
      isHighCholesterol = yesOrNo(widget.healthProfile!.hasHighCholesterol!);
    }

    if(widget.healthProfile!.hasAtrialFibrillation != null) {
      isAtrialfibrillation = yesOrNo(widget.healthProfile!.hasAtrialFibrillation!);
    }

    if(widget.healthProfile!.hasHeartAilment != null) {
      hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);
    }
    //debugPrint('Has Heart Ailment ${hasHeartAilment}');
    if(widget.healthProfile!.sedentaryLifestyle != null) {
      sedentaryLifestyle =  yesOrNo(widget.healthProfile!.sedentaryLifestyle!);
    }
  }

  String yesOrNo(bool flag) {
    return flag == null ? '' : flag ? 'Yes' : 'No';
  }



  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientObservationsViewModel?>(
        model: model,
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
                backgroundColor: Colors.white,
                title: Text(
                  'Edit Medical Profile',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // call this method here to hide soft keyboard
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sizedBoxHeight(),
                        _textFeilds('Main Condition', _majorAilmentController,
                            _majorAilmentFocus, _obstetricHistoryFocus),
                        _sizedBoxHeight(),
                        /*_textFeilds(
                            'Other Conditions',
                            _otherConditionsController,
                            _otherConditionsFocus,
                            _ethnicityFocus),
                        _sizedBoxHeight(),*/
                        /*_ethnicity(),
                        _sizedBoxHeight(),
                        _race(),
                        _sizedBoxHeight(),*/
                        _bloodGroup(),
                        _sizedBoxHeight(),
                        _textFeilds('Occupation', _ocupationController,
                            _ocupationFocus, _obstetricHistoryFocus),
                        _sizedBoxHeight(),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('Height*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: textBlack)),
                            ),

                          ],
                        ),*/
                        _heightFeilds(),
                        /*Stack(
                          children: [
                            TextFormField(
                              controller: _heightInFeetController,
                              textAlign: TextAlign.left,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Height',
                                labelStyle: TextStyle(
                                  color: Colors.black,
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
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (getCurrentLocale() == 'US') {
                                            showHeightPickerInFoot(context);
                                          } else {
                                            showHeightPickerCms(context);
                                          }
                                        },
                                        child: Text(
                                          height == 0 ? 'Select' : 'Change',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor),
                                        )),
                                  ],
                                ))
                          ],
                        ),*/
                        _sizedBoxHeight(),
                        Text(
                            'Have you used tobacco products (such as cigarettes, electronic cigarettes, cigars, smokeless tobacco, or hookah) over the past year?',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: textBlack)),
                        SizedBox(height: 8,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                              color: Colors.white),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: isSmoker == '' ? null : isSmoker,
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
                                isSmoker = data.toString();
                              });
                              setState(() {});
                            },
                          ),
                        ),
                        /*RadioGroup<String>.builder(
                          items: radioItems,
                          groupValue: isSmoker,
                          direction: Axis.horizontal,
                          horizontalAlignment: MainAxisAlignment.start,
                          onChanged: (item) {
                            debugPrint(item);
                            isSmoker = item;
                            setState(() {});
                          },
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                            textPosition: RadioButtonTextPosition.right,
                          ),
                        ),*/
                        _sizedBoxHeight(),
                        Text('Do you have heart disease, have you had a previous heart attack, stroke or other cardiovascular event?',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: textBlack)),
                        SizedBox(height: 8,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
                              color: Colors.white),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: hasHeartAilment == '' ? null : hasHeartAilment,
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
                                hasHeartAilment = data.toString();
                              });
                              setState(() {});
                            },
                          ),
                        ),

                        /*RadioGroup<String>.builder(
                          items: radioItems,
                          groupValue: hasHeartAilment,
                          direction: Axis.horizontal,
                          horizontalAlignment: MainAxisAlignment.start,
                          onChanged: (item) {
                            debugPrint(item);
                            hasHeartAilment = item;
                            setState(() {});
                          },
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                            textPosition: RadioButtonTextPosition.right,
                          ),
                        ),*/
                        /*Text('Sedentary Occupation',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: textBlack)),
                  RadioGroup<String>.builder(
                    items: radioItems,
                    onSelected: (item) {
                      debugPrint(item.title);
                    },
                  ),*/
                        _sizedBoxHeight(),
                        _typeOfStroke(),
                        _sizedBoxHeight(),
                        _toldByYourHealthcareProfessional(),


                        SizedBox(
                          width: 24,
                        ),
                        _sizedBoxHeight(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  FirebaseAnalytics.instance.logEvent(name: 'medical_profile_save_button_click');
                                  /*if (_heightInFeetController.text
                                      .trim()
                                      .isEmpty) {
                                    showToast("Please enter your height in feet",
                                        context);
                                  } else if (double.parse(
                                          _heightInFeetController.text) >
                                      15) {
                                    showToast("Please enter valid height in feet",
                                        context);
                                  } else if (_heightInInchesController.text
                                      .trim()
                                      .isEmpty) {
                                    showToast(
                                        "Please enter your height in inches",
                                        context);
                                  } else if (double.parse(
                                          _heightInInchesController.text) >
                                      12) {
                                    showToast(
                                        "Please enter valid height in inches",
                                        context);
                                  } else {
                                    _sharedPrefUtils.saveDouble(
                                        'height',
                                        double.parse(Conversion.FeetToCm(
                                                double.parse(
                                                    _heightInFeetController.text +
                                                        '.' +
                                                        _heightInInchesController
                                                            .text))
                                            .toString()));
                                  }*/
                                  _updatePatientMedicalProfile();
                                },
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
                                child: Text(
                                  'Save',
                                  semanticsLabel: 'Save Medical Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

/*  Widget _ethnicity() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ethnicity',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
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
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Ethnicity',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _ethnicityValue == '' ? null : _ethnicityValue,
                    items: <String>[
                      'Hispanic/Latino',
                      'Not Hispanic/Latino',
                      'Prefer not to say'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Select Ethnicity'),
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
    );
  }

  Widget _race() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Race',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
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
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Race',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _raceValue == '' ? null : _raceValue,
                    items: <String>[
                      'American Indian/Alaskan Native',
                      'Asian',
                      'Black/African American',
                      'Native Hawaiian or Other Pacific Islander',
                      'White'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Select Race'),
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
    );
  }*/

  Widget _typeOfStroke() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type of Stroke',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
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
                  label: 'Type of Stroke',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _typeOfStrokeValue == '' ? null : _typeOfStrokeValue,
                    items: <String>[
                      'Ischemic',
                      'Hemorrhagic',
                      'Transient Ischemic Attack (TIA)',
                      'Unknown'
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
                        _typeOfStrokeValue = data.toString();
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
    );
  }

  Widget _toldByYourHealthcareProfessional() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Have you ever been told by your healthcare professional that you have any of the following?',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              highBloodPressure(),
              SizedBox(height: 8,),
              highCholesterol(),
              SizedBox(height: 8,),
              diabetics(),
              SizedBox(height: 8,),
              atrialFibrillation(),
            ],
          ),
        )
      ],
    );
  }

  Widget highBloodPressure(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('High Blood Pressure',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: textBlack)),
        SizedBox(height: 8,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
              color: Colors.white),
          child: Semantics(
            label: 'High blood pressure ',
            child: DropdownButton<String>(
              isExpanded: true,
              value: isBloodPressure == '' ? null : isBloodPressure,
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
                  isBloodPressure = data.toString();
                });
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget highCholesterol(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 168,
          child: Text('High Cholesterol',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textBlack)),
        ),
        SizedBox(height: 8,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
              color: Colors.white),
          child: Semantics(
            label: 'High cholesterol',
            child: DropdownButton<String>(
              isExpanded: true,
              value: isHighCholesterol == '' ? null : isHighCholesterol,
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
                  isHighCholesterol = data.toString();
                });
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget diabetics(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 168,
          child: Text('Diabetes',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textBlack)),
        ),
        SizedBox(height: 8,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
              color: Colors.white),
          child: Semantics(
            label: 'Diabetes',
            child: DropdownButton<String>(
              isExpanded: true,
              value: isDiabetic == '' ? null : isDiabetic,
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
                  isDiabetic = data.toString();
                });
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget atrialFibrillation(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 168,
          child: Text('Atrial Fibrillation',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: textBlack)),
        ),
        SizedBox(height: 8,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0XFF909CAC), width: 0.80),
              color: Colors.white),
          child: Semantics(
            label: 'Atrial fibrillation',
            child: DropdownButton<String>(
              isExpanded: true,
              value: isAtrialfibrillation == '' ? null : isAtrialfibrillation,
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
                  isAtrialfibrillation = data.toString();
                });
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _bloodGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Blood Type',
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
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
                    border: Border.all(color: primaryColor, width: 0.80),
                    color: Colors.white),
                child: Semantics(
                  label: 'Blood Type',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _bloodgroupValue == '' ? null : _bloodgroupValue,
                    items: <String>[
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          semanticsLabel: value.contains('+') ? value.replaceAll('+', ' Positive') : value.replaceAll('-', ' Negative') ,
                        ),
                      );
                    }).toList(),
                    hint: Text('Choose an option'),
                    onChanged: (data) {
                      debugPrint(data);
                      setState(() {
                        _bloodgroupValue = data.toString();
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
    );
  }

  Widget _sizedBoxHeight() {
    return const SizedBox(
      height: 24,
    );
  }

  Widget _textFeilds(String hint, TextEditingController editingController,
      FocusNode focusNode, FocusNode nextFocusNode) {
    /*return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      textInputAction: focusNode == _obstetricHistoryFocus
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (term) {
        focusNode != _obstetricHistoryFocus
            ? _fieldFocusChange(context, focusNode, nextFocusNode)
            : '  ';
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );*/

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint,
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.white),
                child: Semantics(
                  label: hint,
                  child: TextFormField(
                      controller: editingController,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      enabled: true,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (term) {
                       /* focusNode != _obstetricHistoryFocus
                            ? _fieldFocusChange(
                                context, focusNode, nextFocusNode)
                            : '  ';*/
                      },
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 14, top: 11, right: 0),
                      )),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _heightFeilds() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Height",
            style: TextStyle(
                fontSize: 16.0, color: textBlack, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.white),
                child: Semantics(
                  label: 'height',
                  child: Stack(
                    children: [
                      TextFormField(
                          controller: _heightInFeetController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          readOnly: true,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: primaryColor),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: primaryColor),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 14, top: 11, right: 0),
                          )),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (getCurrentLocale() == 'US') {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return _addHeightInFtnInchDialog(context);
                                          });
                                    } else {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return _addHeightInCmDialog(context);
                                          });
                                    }
                                  },
                                  child: Text(
                                    height == 0 ? 'Select' : 'Change',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  )),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  /* Widget _textFeildsNumber(String hint, TextEditingController editingController,
      FocusNode focusNode, FocusNode nextFocusNode) {
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[\\,|\\+|\\-|\\|\\. ]')),
      ],
      textInputAction: focusNode == _obstetricHistoryFocus
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (term) {
        focusNode != _obstetricHistoryFocus
            ? _fieldFocusChange(context, focusNode, nextFocusNode)
            : '  ';
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.black,
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
  }*/

  /*showHeightPickerInFoot(BuildContext context) {
    debugPrint("Inside US Height 123");
    Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 340,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Biometrics',
                        semanticsLabel: 'Biometrics',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddBMIDetailDialog(
                  submitButtonListner: (double weight, double height) {


                    debugPrint(
                        'Height : $height  Weight: ${weight.roundToDouble()}');
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  height: height,
                  weight: 225,
                ),
              )
            ],
          ),
        ));

    *//*Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 1,
            end: 9,
            initValue: heightInFt,
            suffix: Text('  ft'),
          ),
          NumberPickerColumn(
            begin: 0,
            end: 11,
            initValue: heightInInch,
            suffix: Text('  inch'),
          ),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Center(
            child: Text(
          " Height",
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 18.0),
          textAlign: TextAlign.center,
        )),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var localHeight = Conversion.FeetAndInchToCm(
              picker.getSelectedValues().elementAt(0),
              picker.getSelectedValues().elementAt(1));
          _sharedPrefUtils.saveDouble('height', double.parse(localHeight));
          height = int.parse(localHeight);
          conversion();
          debugPrint('Selected Height ==> $localHeight');
          setState(() {
            showToast('Height record created successfully!', context);
          });
        }).showDialog(context);*//*
  }*/

  Widget _addHeightInFtnInchDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Height',
                        semanticsLabel: 'Height',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddHeightInFtNInchDialog(
                  submitButtonListner: (int heightInFeet, int heightInInches) {
                    FirebaseAnalytics.instance.logEvent(name: 'vitals_height_save_button_click');
                    var localHeight = Conversion.FeetAndInchToCm(
                        heightInFeet,
                        heightInInches);
                    _sharedPrefUtils.saveDouble('height', double.parse(localHeight));
                    height = int.parse(localHeight);
                    addHeight(localHeight.toString());
                    conversion();
                    debugPrint('Selected Height ==> $localHeight');
                    setState(() {
                      showSuccessToast('Height record created successfully!', context);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  heightInFeet: heightInFt,
                  heightInInches: heightInInch,
                ),
              )
            ],
          ),
        ));
  }

  Widget _addHeightInCmDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Height',
                        semanticsLabel: 'Height',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddHeightInCmDialog(
                  submitButtonListner: (int heightInCm) {
                    FirebaseAnalytics.instance.logEvent(name: 'vitals_height_save_button_click');
                    var localHeight =
                    double.parse(heightInCm.toString());
                    _sharedPrefUtils.saveDouble('height', localHeight);
                    height = localHeight.toInt();
                    addHeight(localHeight.toString());
                    conversion();
                    debugPrint('Selected Height ==> $localHeight');
                    setState(() {
                      showSuccessToast('Height record created successfully!', context);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  heightInCm: height.toInt(),
                ),
              )
            ],
          ),
        ));
  }

  /*showHeightPickerCms(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 1,
            end: 250,
            initValue: height.toInt(),
            suffix: Text('  cm'),
          ),
        ]),
        hideHeader: true,
        title: Center(
            child: Text(
          " Height",
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 18.0),
          textAlign: TextAlign.center,
        )),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var localHeight =
              double.parse(picker.getSelectedValues().elementAt(0).toString());
          _sharedPrefUtils.saveDouble('height', localHeight);
          height = localHeight.toInt();
          conversion();
          debugPrint('Selected Height ==> $localHeight');
          setState(() {
            showToast('Height record created successfully!', context);
          });
        }).showDialog(context);
  }*/

  _updatePatientMedicalProfile() async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus?.unfocus();
      _majorAilmentFocus.unfocus();
      _ocupationFocus.unfocus();
      progressDialog.show(max: 100, msg: 'Loading...');
      final Map<String, dynamic> data = <String, dynamic>{};
      data['BloodGroup'] = _bloodgroupValue;
      data['MajorAilment'] = _majorAilmentController.text;
      data['IsDiabetic'] = isDiabetic == '' ? null : isDiabetic == 'Yes' ? true : false;
      data['IsSmoker'] = isSmoker == '' ? null : isSmoker == 'Yes' ? true : false;
      data['HasHeartAilment'] = hasHeartAilment == '' ? null : hasHeartAilment == 'Yes' ? true : false;
      /*data['Ethnicity'] = _ethnicityValue;
      data['Race'] = _raceValue;*/
      data['TypeOfStroke'] = _typeOfStrokeValue == '' ? null : _typeOfStrokeValue;
      data['HasHighBloodPressure'] =  isBloodPressure == '' ? null : isBloodPressure == 'Yes' ? true : false;
      data['HasHighCholesterol'] =  isHighCholesterol == '' ? null : isHighCholesterol == 'Yes' ? true : false;
      data['HasAtrialFibrillation'] =  isAtrialfibrillation == '' ? null : isAtrialfibrillation == 'Yes' ? true : false;
      data['Occupation'] = _ocupationController.text;

      final BaseResponse baseResponse = await model.updatePatientMedicalProfile(
          widget.healthProfile!.id, data);

      if (baseResponse.status == 'success') {
        showSuccessToast('Medical Profile updated successfully!', context);
        //progressDialog.close();
        //FocusScope.of(context).unfocus();
        //Navigator.popUntil(context, ModalRoute.withName(RoutePaths.My_Medical_Profile));
        if(Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
        if(Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
        //Navigator.of(context).pop(true);
       /* Navigator.of(context)
            .popUntil(ModalRoute.withName("mProfile"));*/
        //if (Platform.isAndroid) {
          //Navigator.pop(context);
        //}

      } else {
        showToast(baseResponse.message!, context);
        progressDialog.close();
      }
    } catch (CustomException) {
      progressDialog.close();
      debugPrint('Error ' + CustomException.toString());
    }
  }

  addHeight(String height) async {
    try {

      final map = <String, dynamic>{};
      map['BodyHeight'] = height.toString();
      map['PatientUserId'] = "";
      map['Unit'] = "Cm";

      final BaseResponse baseResponse =
      await model.addMyVitals('body-heights', map);

      if (baseResponse.status == 'success') {

      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

/*  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }*/
}
