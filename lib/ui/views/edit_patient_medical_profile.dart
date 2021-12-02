import 'package:check_radio_group/model/item_group.dart';
import 'package:check_radio_group/radio/radio_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/PatientMedicalProfilePojo.dart';
import 'package:paitent/core/viewmodels/views/patients_observation.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'base_widget.dart';
//ignore: must_be_immutable
class EditPatientMedicalProfileView extends StatefulWidget {
  HealthProfile healthProfile;

  EditPatientMedicalProfileView(HealthProfile mProfiles) {
    healthProfile = mProfiles;
  }

  @override
  _EditPatientMedicalProfileViewState createState() =>
      _EditPatientMedicalProfileViewState();
}

class _EditPatientMedicalProfileViewState
    extends State<EditPatientMedicalProfileView> {
  final List<GroupItem> radioItems = [
    GroupItem(title: 'Yes'),
    GroupItem(title: 'No'),
  ];

  final List<GroupItem> maritalStatusItems = [
    GroupItem(title: 'Married'),
    GroupItem(title: 'Single'),
  ];

  var model = PatientObservationsViewModel();
  final TextEditingController _majorAilmentController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _otherConditionsController = TextEditingController();
  final TextEditingController _procedureHistoryController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();


  ProgressDialog progressDialog;

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
  String maritalStatus;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    _majorAilmentController.text = widget.healthProfile.majorAilment;
    _majorAilmentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _majorAilmentController.text.length),
    );

    _bloodGroupController.text = widget.healthProfile.bloodGroup;
    _bloodGroupController.selection = TextSelection.fromPosition(
      TextPosition(offset: _bloodGroupController.text.length),
    );

    _ocupationController.text = widget.healthProfile.occupation;
    _ocupationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ocupationController.text.length),
    );

    _nationalityController.text = widget.healthProfile.nationality;
    _nationalityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nationalityController.text.length),
    );

    _procedureHistoryController.text = widget.healthProfile.procedureHistory;
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

   /* _surgicalHistoryController.text = widget.medicalProfiles.surgicalHistory;
    _surgicalHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _surgicalHistoryController.text.length),
    );*/

    isDiabetic = yesOrNo(widget.healthProfile.isDiabetic);
    hasHeartAilment = yesOrNo(widget.healthProfile.hasHeartAilment);
    sedentaryLifestyle = yesOrNo(widget.healthProfile.sedentaryLifestyle);
    isSmoker = yesOrNo(widget.healthProfile.isSmoker);
    isDrinker = yesOrNo(widget.healthProfile.isSmoker);
    maritalStatus = widget.healthProfile.maritalStatus;
    _otherConditionsController.text = widget.healthProfile.otherConditions;
    _otherConditionsController.selection = TextSelection.fromPosition(
      TextPosition(offset: _otherConditionsController.text.length),
    );

    _procedureHistoryController.text = widget.healthProfile.procedureHistory;
    _procedureHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _procedureHistoryController.text.length),
    );

    _ethnicityController.text = widget.healthProfile.ethnicity;
    _ethnicityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ethnicityController.text.length),
    );

    isDiabetic = yesOrNo(widget.healthProfile.isDiabetic);
    hasHeartAilment = yesOrNo(widget.healthProfile.hasHeartAilment);
    sedentaryLifestyle = yesOrNo(widget.healthProfile.sedentaryLifestyle);
    isSmoker = yesOrNo(widget.healthProfile.isSmoker);
    isDrinker = yesOrNo(widget.healthProfile.isDrinker);
    maritalStatus = widget.healthProfile.maritalStatus;
  }

  String yesOrNo(bool flag) {
    return flag ? 'Yes' : 'No';
  }

  GroupItem showSelectedItemForMarried(String text) {
    for (int i = 0; i < maritalStatusItems.length; i++) {
      if (text == maritalStatusItems[i].title) {
        return maritalStatusItems[i];
      }
    }
    return maritalStatusItems[0];
  }

  GroupItem showSelectedItemForYesOrNo(String text) {
    for (int i = 0; i < radioItems.length; i++) {
      if (text == radioItems[i].title) {
        return radioItems[i];
      }
    }
    return radioItems[0];
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return BaseWidget<PatientObservationsViewModel>(
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
                      fontWeight: FontWeight.w700),
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
                      SizedBox(
                        width: 24,
                      ),
                      _sizedBoxHeight(),
                      _textFeilds('Major Ailment', _majorAilmentController,
                          _majorAilmentFocus, _otherConditionsFocus),
                      _sizedBoxHeight(),
                      _textFeilds('Other Conditions', _otherConditionsController,
                          _otherConditionsFocus, _ethnicityFocus),
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
                          'Procedure history',
                          _procedureHistoryController,
                          _procedureHistoryFocus,
                          _obstetricHistoryFocus),
                      _sizedBoxHeight(),
                      Text('Marital status',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: maritalStatusItems,
                        selected: showSelectedItemForMarried(maritalStatus),
                        onSelected: (item) {
                          debugPrint(item.title);
                          maritalStatus = item.title;
                        },
                      ),
                      Text('Diabetic',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isDiabetic),
                        onSelected: (item) {
                          debugPrint(item.title);
                          isDiabetic = item.title;
                        },
                      ),
                      Text('Heart Patient',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(hasHeartAilment),
                        onSelected: (item) {
                          debugPrint(item.title);
                          hasHeartAilment = item.title;
                        },
                      ),
                      /*Text('Sedentary Occupation',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: textBlack)),
                RadioGroup(
                  items: radioItems,
                  onSelected: (item) {
                    debugPrint(item.title);
                  },
                ),*/
                      Text('Is smoker?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isSmoker),
                        onSelected: (item) {
                          debugPrint(item.title);
                          isSmoker = item.title;
                        },
                      ),
                      Text('Is Drinker?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isDrinker),
                        onSelected: (item) {
                          debugPrint(item.title);
                          isDrinker = item.title;
                        },
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
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
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

  _updatePatientMedicalProfile() async {
    try {
      progressDialog.show();
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
          widget.healthProfile.id, data);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pop(context);
        showToast('Medical Profile updated successfully!', context);
      } else {
        showToast(baseResponse.message, context);
        progressDialog.hide();
      }
    } catch (CustomException) {
      progressDialog.hide();
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
