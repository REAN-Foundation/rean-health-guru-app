
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

  final TextEditingController _majorAilmentController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _procedureHistoryController =
      TextEditingController();

  late ProgressDialog progressDialog;

  final _majorAilmentFocus = FocusNode();
  final _ocupationFocus = FocusNode();

  final _obstetricHistoryFocus = FocusNode();

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
  String _ethnicityValue = '';
  String _raceValue = '';
  String _bloodgroupValue = '';

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

    isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);
    isSmoker = yesOrNo(widget.healthProfile!.isSmoker!);
    hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);

    _procedureHistoryController.text =
        widget.healthProfile!.procedureHistory ?? '';
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

    _ethnicityValue = widget.healthProfile!.ethnicity ?? '';
    _raceValue = widget.healthProfile!.race ?? '';
    _bloodgroupValue = widget.healthProfile!.bloodGroup ?? '';

    isDiabetic = yesOrNo(widget.healthProfile!.isDiabetic!);
    hasHeartAilment = yesOrNo(widget.healthProfile!.hasHeartAilment!);
    sedentaryLifestyle = yesOrNo(widget.healthProfile!.sedentaryLifestyle!);
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
                      _textFeilds('Main Condition', _majorAilmentController,
                          _majorAilmentFocus, _obstetricHistoryFocus),
                      _sizedBoxHeight(),
                      /*_textFeilds(
                          'Other Conditions',
                          _otherConditionsController,
                          _otherConditionsFocus,
                          _ethnicityFocus),
                      _sizedBoxHeight(),*/
                      _ethnicity(),
                      _sizedBoxHeight(),
                      _race(),
                      _sizedBoxHeight(),
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
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'Have you used tobacco products (such as cigarettes, electronic cigarettes, cigars, smokeless tobacco, or hookah) over the past year?',
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

  Widget _ethnicity() {
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
  }

  Widget _bloodGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Blood Group',
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
                  label: 'Blood Group',
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
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Select Blood Group'),
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
                      textInputAction: focusNode == _obstetricHistoryFocus
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onFieldSubmitted: (term) {
                        focusNode != _obstetricHistoryFocus
                            ? _fieldFocusChange(
                                context, focusNode, nextFocusNode)
                            : '  ';
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
      data['BloodGroup'] = _bloodgroupValue;
      data['MajorAilment'] = _majorAilmentController.text;
      data['IsDiabetic'] = isDiabetic == 'Yes';
      data['IsSmoker'] = isSmoker == 'Yes';
      data['HasHeartAilment'] = hasHeartAilment == 'Yes';
      data['Ethnicity'] = _ethnicityValue;
      data['Race'] = _raceValue;
      data['Occupation'] = _ocupationController.text;

      final BaseResponse baseResponse = await model.updatePatientMedicalProfile(
          widget.healthProfile!.id, data);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        //Navigator.popUntil(context, ModalRoute.withName(RoutePaths.My_Medical_Profile));
        Navigator.pop(context, true);
        //if (Platform.isAndroid) {
          Navigator.pop(context);
        //}
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
