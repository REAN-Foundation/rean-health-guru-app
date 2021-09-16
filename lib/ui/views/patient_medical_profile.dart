import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/PatientMedicalProfilePojo.dart';
import 'package:paitent/core/viewmodels/views/patients_observation.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/StringUtility.dart';

import 'base_widget.dart';

class PatientMedicalProfileView extends StatefulWidget {
  @override
  _PatientMedicalProfileViewState createState() =>
      _PatientMedicalProfileViewState();
}

class _PatientMedicalProfileViewState extends State<PatientMedicalProfileView> {
  MedicalProfiles medicalProfiles;

  var model = PatientObservationsViewModel();
  final TextEditingController _majorComplaintController =
      TextEditingController();
  final TextEditingController _ocupationController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _surgicalHistoryController =
      TextEditingController();
  final TextEditingController _obstetricHistoryController =
      TextEditingController();

  String mobileNumber = '';

  final _majorComplaintFocus = FocusNode();
  final _ocupationFocus = FocusNode();
  final _nationalityFocus = FocusNode();
  final _surgicalHistoryFocus = FocusNode();
  final _obstetricHistoryFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _getPatientMedicalProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientObservationsViewModel>(
        model: model,
        builder: (context, model, child) => MergeSemantics(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    title: Text(
                      'My Medical Profile',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                  ),
                  body: model.busy
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Major Complaint',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(': ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' +
                                            replaceNull(
                                                medicalProfiles.majorAilment),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Blood Group',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' +
                                            replaceNull(
                                                medicalProfiles.bloodGroup),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Diabetic',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' +
                                            yesOrNo(medicalProfiles.isDiabetic),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Heart Patient',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' +
                                            yesOrNo(medicalProfiles
                                                .hasHeartAilment),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Marital Status',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '' +
                                              replaceNull(medicalProfiles
                                                  .maritalStatus),
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
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Occupation',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '' +
                                              replaceNull(
                                                  medicalProfiles.occupation),
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
                                /*Row(
                      children: <Widget>[
                        SizedBox(width: 150,
                          child: Text('Sedentary Occupation',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: textBlack)),
                        ),
                        Text(':',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: textBlack)),
                        SizedBox(width: 8,),
                        Text('No',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: textBlack)),
                      ],
                    ),
                    SizedBox(height: 8,),*/
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Nationality',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '' +
                                              replaceNull(
                                                  medicalProfiles.nationality),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: textBlack)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Is vegetarian?',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' +
                                            yesOrNo(
                                                medicalProfiles.isVegetarian),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Is vegan?',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('' + yesOrNo(medicalProfiles.isVegan),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Is smoker?',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('' + yesOrNo(medicalProfiles.isSmoker),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Is Alcoholic?',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        '' + yesOrNo(medicalProfiles.isDrinker),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                  ],
                                ),
                                /*SizedBox(height: 8,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 150,
                          child: Text('Substance Abuse',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: textBlack)),
                        ),
                        Text(':',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: textBlack)),
                        SizedBox(width: 8,),
                        Text('No',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: textBlack)),
                      ],
                    ),*/
                                SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Surgical History',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '' +
                                              replaceNull(medicalProfiles
                                                  .surgicalHistory),
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
                                  children: <Widget>[
                                    SizedBox(
                                      width: 150,
                                      child: Text('Obstetric History',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: textBlack)),
                                    ),
                                    Text(':',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: textBlack)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '' +
                                              replaceNull(medicalProfiles
                                                  .obstetricHistory),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: textBlack)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  floatingActionButton: model.busy
                      ? Container()
                      : Semantics(
                          label: 'edit_medical_profile',
                    child: FloatingActionButton(
                              elevation: 0.0,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              backgroundColor: primaryColor,
                              onPressed: () {
                                Navigator.pushNamed(context,
                                        RoutePaths.Patient_EDIT_MEDIACL_PROFILE,
                                        arguments: medicalProfiles)
                                    .then((value) {
                                  _getPatientMedicalProfile();
                                });
                              }),
                        )),
            ));
  }

  String replaceNull(String text) {
    debugPrint('Medical Profile ==> $text');
    return text ?? '';
  }

  String yesOrNo(bool flag) {
    return flag ? 'Yes' : 'No';
  }

  _getPatientMedicalProfile() async {
    try {
      final PatientMedicalProfilePojo allergiesPojo =
          await model.getPatientMedicalProfile('Bearer ' + auth, patientUserId);

      if (allergiesPojo.status == 'success') {
        medicalProfiles = allergiesPojo.data.medicalProfiles;
      } else {}
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  Widget _medicalProfileDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: medicalProfileDialog(context),
    );
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
                    fontWeight: FontWeight.bold,
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
                              'Major Complaint',
                              _majorComplaintController,
                              _majorComplaintFocus,
                              _ocupationFocus),
                          _textFeilds('Occupation', _ocupationController,
                              _ocupationFocus, _nationalityFocus),
                          _textFeilds('Nationality', _nationalityController,
                              _nationalityFocus, _surgicalHistoryFocus),
                          _textFeilds(
                              'Surgical history',
                              _surgicalHistoryController,
                              _surgicalHistoryFocus,
                              _obstetricHistoryFocus),
                          _textFeilds(
                              'Obstetric history',
                              _obstetricHistoryController,
                              _obstetricHistoryFocus,
                              _obstetricHistoryFocus),
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
      textInputAction: nextFocusNode == _obstetricHistoryFocus
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
