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

class EditPatientMedicalProfileView extends StatefulWidget {
  MedicalProfiles medicalProfiles;

  EditPatientMedicalProfileView(@required MedicalProfiles mProfiles) {
    this.medicalProfiles = mProfiles;
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
    GroupItem(title: 'Unmarried'),
  ];

  var model = PatientObservationsViewModel();
  final TextEditingController _majorComplaintController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _surgicalHistoryController =
      TextEditingController();
  final TextEditingController _obstetricHistoryController =
      TextEditingController();

  ProgressDialog progressDialog;

  GroupItem _selected;

  var _majorComplaintFocus = FocusNode();
  var _bloodGroupFocus = FocusNode();
  var _ocupationFocus = FocusNode();
  var _nationalityFocus = FocusNode();
  var _surgicalHistoryFocus = FocusNode();
  var _obstetricHistoryFocus = FocusNode();

  var isDiabetic;
  var hasHeartAilment;
  var isVegetarian;
  var isVegan;
  var sedentaryLifestyle;
  var isSmoker;
  var isDrinker;
  String maritalStatus;

  @override
  void initState() {
    // TODO: implement initState
    setData();
    super.initState();
  }

  setData() {
    _majorComplaintController.text = widget.medicalProfiles.majorAilment;
    _majorComplaintController.selection = TextSelection.fromPosition(
      TextPosition(offset: _majorComplaintController.text.length),
    );

    _bloodGroupController.text = widget.medicalProfiles.bloodGroup;
    _bloodGroupController.selection = TextSelection.fromPosition(
      TextPosition(offset: _bloodGroupController.text.length),
    );

    _ocupationController.text = widget.medicalProfiles.occupation;
    _ocupationController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ocupationController.text.length),
    );

    _nationalityController.text = widget.medicalProfiles.nationality;
    _nationalityController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nationalityController.text.length),
    );

    _surgicalHistoryController.text = widget.medicalProfiles.surgicalHistory;
    _surgicalHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _surgicalHistoryController.text.length),
    );

    _obstetricHistoryController.text = widget.medicalProfiles.obstetricHistory;
    _obstetricHistoryController.selection = TextSelection.fromPosition(
      TextPosition(offset: _obstetricHistoryController.text.length),
    );

    isDiabetic = yesOrNo(widget.medicalProfiles.isDiabetic);
    hasHeartAilment = yesOrNo(widget.medicalProfiles.hasHeartAilment);
    isVegetarian = yesOrNo(widget.medicalProfiles.isVegetarian);
    isVegan = yesOrNo(widget.medicalProfiles.isVegan);
    sedentaryLifestyle = yesOrNo(widget.medicalProfiles.sedentaryLifestyle);
    isSmoker = yesOrNo(widget.medicalProfiles.isSmoker);
    isDrinker = yesOrNo(widget.medicalProfiles.isSmoker);
    maritalStatus = widget.medicalProfiles.maritalStatus;
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
  }

  GroupItem showSelectedItemForYesOrNo(String text) {
    for (int i = 0; i < radioItems.length; i++) {
      if (text == radioItems[i].title) {
        return radioItems[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    // TODO: implement build
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
                iconTheme: new IconThemeData(color: Colors.black),
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
                      _textFeilds("Major Complaint", _majorComplaintController,
                          _majorComplaintFocus, _bloodGroupFocus),
                      _sizedBoxHeight(),
                      _textFeilds("Blood Group", _bloodGroupController,
                          _bloodGroupFocus, _ocupationFocus),
                      _sizedBoxHeight(),
                      _textFeilds("Occupation", _ocupationController,
                          _ocupationFocus, _nationalityFocus),
                      _sizedBoxHeight(),
                      _textFeilds("Nationality", _nationalityController,
                          _nationalityFocus, _surgicalHistoryFocus),
                      _sizedBoxHeight(),
                      _textFeilds(
                          "Surgical history",
                          _surgicalHistoryController,
                          _surgicalHistoryFocus,
                          _obstetricHistoryFocus),
                      _sizedBoxHeight(),
                      _textFeilds(
                          "Obstetric history",
                          _obstetricHistoryController,
                          _obstetricHistoryFocus,
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
                          print(item.title);
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
                          print(item.title);
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
                          print(item.title);
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
                    print(item.title);
                  },
                ),*/
                      Text('Is vegetarian?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isVegetarian),
                        onSelected: (item) {
                          print(item.title);
                          isVegetarian = item.title;
                        },
                      ),
                      Text('Is vegan?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isVegan),
                        onSelected: (item) {
                          print(item.title);
                          isVegan = item.title;
                        },
                      ),
                      Text('Is smoker?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isSmoker),
                        onSelected: (item) {
                          print(item.title);
                          isSmoker = item.title;
                        },
                      ),
                      Text('Is Alcoholic?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: textBlack)),
                      RadioGroup(
                        items: radioItems,
                        selected: showSelectedItemForYesOrNo(isDrinker),
                        onSelected: (item) {
                          print(item.title);
                          isDrinker = item.title;
                        },
                      ),
                      /*Text('Substance abuse',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: textBlack)),

                RadioGroup(
                  items: radioItems,
                  onSelected: (item) {
                    print(item.title);
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
                            child: RaisedButton(
                              onPressed: () {
                                _updatePatientMedicalProfile();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0))),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              textColor: Colors.white,
                              splashColor: Colors.red,
                              color: primaryColor,
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
            : "";
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
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['MajorAilment'] = _majorComplaintController.text;
      data['Comorbidities'] = '';
      data['BloodGroup'] = _bloodGroupController.text;
      data['IsDiabetic'] = this.isDiabetic == 'Yes';
      data['HasHeartAilment'] = this.hasHeartAilment == 'Yes';
      data['IsVegetarian'] = this.isVegetarian == 'Yes';
      data['IsVegan'] = this.isVegan == 'Yes';
      data['SedentaryLifestyle'] = this.sedentaryLifestyle == 'Yes';
      data['IsSmoker'] = this.isSmoker == 'Yes';
      data['SmokingSeverity'] = 1;
      data['SmokingSince'] = null;
      data['IsDrinker'] = this.isDrinker == 'Yes';
      data['DrinkingSeverity'] = 1;
      data['DrinkingSince'] = null;
      data['Ethnicity'] = null;
      data['Nationality'] = this._nationalityController.text;
      data['Occupation'] = this._ocupationController.text;
      data['MaritalStatus'] = this.maritalStatus;
      data['SurgicalHistory'] = this._surgicalHistoryController.text;
      data['ObstetricHistory'] = this._obstetricHistoryController.text;

      BaseResponse baseResponse = await model.updatePatientMedicalProfile(
          widget.medicalProfiles.id, data);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pop(context);
        showToast('Medical Profile updated successfully.', context);
      } else {
        showToast(baseResponse.message, context);
        progressDialog.hide();
      }
    } catch (CustomException) {
      progressDialog.hide();
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
