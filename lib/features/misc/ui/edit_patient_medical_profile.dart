import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
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
  final _heightInFeetFocus = FocusNode();

  final TextEditingController _majorAilmentController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _otherConditionsController =
      TextEditingController();
  final TextEditingController _procedureHistoryController =
      TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();

  late ProgressDialog progressDialog;

  final _majorAilmentFocus = FocusNode();
  final _ethnicityFocus = FocusNode();
  final _bloodGroupFocus = FocusNode();
  final _ocupationFocus = FocusNode();
  final _nationalityFocus = FocusNode();

  //final _surgicalHistoryFocus = FocusNode();
  final _obstetricHistoryFocus = FocusNode();
  final _otherConditionsFocus = FocusNode();
  final _procedureHistoryFocus = FocusNode();

  var isDiabetic;
  var hasHeartAilment;
  var sedentaryLifestyle;
  var isSmoker;
  var isDrinker;
  String maritalStatus = '';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  int height = 0;
  late var heightArray;

  int heightInFt = 1;
  int heightInInch = 0;
  String heightInDouble = '0.0';
  late var heightArry;

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
      heightArry = heightInDouble.toString().split('.');
      heightInFt = int.parse(heightArry[0]);
      heightInInch = int.parse(heightArry[1]);
      debugPrint('Conversion Height => $heightInFt ft $heightInInch inch');

      if (getCurrentLocale() == 'US') {
        _heightInFeetController.text =
            heightInDouble.toString().replaceAll('.', "'");
        _heightInFeetController.selection = TextSelection.fromPosition(
          TextPosition(offset: _heightInFeetController.text.length),
        );
      } else {
        _heightInFeetController.text = height.toString();
        _heightInFeetController.selection = TextSelection.fromPosition(
          TextPosition(offset: _heightInFeetController.text.length),
        );
      }
    }
  }

  setData() {
    _majorAilmentController.text = widget.healthProfile!.majorAilment ?? '';
    _majorAilmentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _majorAilmentController.text.length),
    );

    _bloodGroupController.text = widget.healthProfile!.bloodGroup ?? '';
    _bloodGroupController.selection = TextSelection.fromPosition(
      TextPosition(offset: _bloodGroupController.text.length),
    );

    _ocupationController.text = widget.healthProfile!.occupation ?? '';
    _ocupationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ocupationController.text.length),
    );

    _nationalityController.text = widget.healthProfile!.nationality ?? '';
    _nationalityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nationalityController.text.length),
    );

    _procedureHistoryController.text =
        widget.healthProfile!.procedureHistory ?? '';
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

    /* _surgicalHistoryController.text = widget.medicalProfiles.surgicalHistory;
    _surgicalHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _surgicalHistoryController.text.length),
    );*/

    isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);
    hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);
    sedentaryLifestyle = yesOrNo(widget.healthProfile!.sedentaryLifestyle!);
    isSmoker = yesOrNo(widget.healthProfile!.isSmoker!);
    isDrinker = yesOrNo(widget.healthProfile!.isSmoker!);
    maritalStatus = widget.healthProfile!.maritalStatus.toString();
    _otherConditionsController.text =
        widget.healthProfile!.otherConditions ?? '';
    _otherConditionsController.selection = TextSelection.fromPosition(
      TextPosition(offset: _otherConditionsController.text.length),
    );

    _procedureHistoryController.text =
        widget.healthProfile!.procedureHistory ?? '';
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

    _ethnicityController.text = widget.healthProfile!.ethnicity ?? '';
    _ethnicityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ethnicityController.text.length),
    );

    isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);
    hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);
    sedentaryLifestyle = yesOrNo(widget.healthProfile!.sedentaryLifestyle!);
    isSmoker = yesOrNo(widget.healthProfile!.isSmoker!);
    isDrinker = yesOrNo(widget.healthProfile!.isDrinker!);
    maritalStatus = widget.healthProfile!.maritalStatus.toString();
    if (maritalStatus == 'Unknown') {
      maritalStatus = 'Single';
    }
  }

  String yesOrNo(bool flag) {
    return flag ? 'Yes' : 'No';
  }



  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientObservationsViewModel?>(
        model: model,
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
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
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sizedBoxHeight(),
                      _textFeilds('Major Ailment', _majorAilmentController,
                          _majorAilmentFocus, _otherConditionsFocus),
                      _sizedBoxHeight(),
                      _textFeilds(
                          'Other Conditions',
                          _otherConditionsController,
                          _otherConditionsFocus,
                          _ethnicityFocus),
                      _sizedBoxHeight(),
                      _textFeilds('Ethnicity', _ethnicityController,
                          _ethnicityFocus, _bloodGroupFocus),
                      _sizedBoxHeight(),
                      _textFeilds('Blood Group', _bloodGroupController,
                          _bloodGroupFocus, _ocupationFocus),
                      _sizedBoxHeight(),
                      _textFeilds('Occupation', _ocupationController,
                          _ocupationFocus, _nationalityFocus),
                      _sizedBoxHeight(),
                      _textFeilds('Nationality', _nationalityController,
                          _nationalityFocus, _procedureHistoryFocus),
                      _sizedBoxHeight(),
                      _textFeilds(
                          'Procedure History',
                          _procedureHistoryController,
                          _procedureHistoryFocus,
                          _heightInFeetFocus),
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
                      Stack(
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
                      ),
                      /*Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _textFeildsNumber(
                                'Feet',
                                _heightInFeetController,
                                _heightInFeetFocus,
                                _heightInInchesFocus),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: _textFeildsNumber(
                                'Inches',
                                _heightInInchesController,
                                _heightInInchesFocus,
                                _obstetricHistoryFocus),
                          ),
                        ],
                      ),*/
                      _sizedBoxHeight(),
                      Text('Marital Status',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: textBlack)),
                      RadioGroup<String>.builder(
                        items: maritalStatusItems,
                        groupValue: maritalStatus,
                        direction: Axis.horizontal,
                        horizontalAlignment: MainAxisAlignment.start,
                        onChanged: (item) {
                          debugPrint(item);
                          maritalStatus = item.toString();
                          setState(() {});
                        },
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                          textPosition: RadioButtonTextPosition.right,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Diabetic',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: textBlack)),
                      RadioGroup<String>.builder(
                        items: radioItems,
                        groupValue: isDiabetic,
                        direction: Axis.horizontal,
                        horizontalAlignment: MainAxisAlignment.start,
                        onChanged: (item) {
                          debugPrint(item);
                          isDiabetic = item;
                          setState(() {});
                        },
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                          textPosition: RadioButtonTextPosition.right,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Heart Patient',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: textBlack)),
                      RadioGroup<String>.builder(
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
                      ),
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
                      SizedBox(
                        height: 8,
                      ),
                      Text('Is Smoker?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: textBlack)),
                      RadioGroup<String>.builder(
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
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Is Drinker?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: textBlack)),
                      RadioGroup<String>.builder(
                        items: radioItems,
                        groupValue: isDrinker,
                        direction: Axis.horizontal,
                        horizontalAlignment: MainAxisAlignment.start,
                        onChanged: (item) {
                          debugPrint(item);
                          isDrinker = item;
                          setState(() {});
                        },
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                          textPosition: RadioButtonTextPosition.right,
                        ),
                      ),
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
            ));
  }

  Widget _sizedBoxHeight() {
    return const SizedBox(
      height: 24,
    );
  }

  Widget _textFeilds(String hint, TextEditingController editingController,
      FocusNode focusNode, FocusNode nextFocusNode) {
    return TextFormField(
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

  showHeightPickerInFoot(BuildContext context) {
    Picker(
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
        }).showDialog(context);
  }

  showHeightPickerCms(BuildContext context) {
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
  }

  _updatePatientMedicalProfile() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      final Map<String, dynamic> data = <String, dynamic>{};
      data['BloodGroup'] = _bloodGroupController.text.toUpperCase();
      data['MajorAilment'] = _majorAilmentController.text;
      data['OtherConditions'] = _otherConditionsController.text;
      data['IsDiabetic'] = isDiabetic == 'Yes';
      data['HasHeartAilment'] = hasHeartAilment == 'Yes';
      data['MaritalStatus'] = maritalStatus;
      data['Ethnicity'] = _ethnicityController.text;
      data['Nationality'] = _nationalityController.text;
      data['Occupation'] = _ocupationController.text;
      data['SedentaryLifestyle'] = sedentaryLifestyle == 'Yes';
      data['IsSmoker'] = isSmoker == 'Yes';
      data['IsDrinker'] = isDrinker == 'Yes';
      //data['DrinkingSeverity'] = 'medium';
      //data['DrinkingSince'] = null;
      data['ProcedureHistory'] = _procedureHistoryController.text;

      final BaseResponse baseResponse = await model.updatePatientMedicalProfile(
          widget.healthProfile!.id, data);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        Navigator.pop(context);
        Navigator.pop(
          context,
        );
        showToast('Medical Profile updated successfully!', context);
      } else {
        showToast(baseResponse.message!, context);
        progressDialog.close();
      }
    } catch (CustomException) {
      progressDialog.close();
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
