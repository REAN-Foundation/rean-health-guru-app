import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/PatientVitalsPojo.dart';
import 'package:paitent/core/viewmodels/views/patients_observation.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/StringUtility.dart';

import 'base_widget.dart';

class PatientVitalsView extends StatefulWidget {
  @override
  _PatientVitalsViewState createState() => _PatientVitalsViewState();
}

class _PatientVitalsViewState extends State<PatientVitalsView> {
  var model = PatientObservationsViewModel();

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _pulseController = TextEditingController();
  final _bodyOxygenController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _bodyTempController = TextEditingController();
  final _heightFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _pulseFocus = FocusNode();
  final _bodyOxygenFocus = FocusNode();
  final _systolicBPFocus = FocusNode();
  final _diastolicBPFocus = FocusNode();
  final _bodyTempFocus = FocusNode();
  var dateFormatForHeader = DateFormat('dd MMM yyyy');

  List<Vitals> vitals = [];

  @override
  void initState() {
    _getPatientVitals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientObservationsViewModel>(
        model: model,
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                title: Text(
                  'My Vitals',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: model.busy
                      ? Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator()))
                      : vitals.isEmpty
                          ? _noVitalsFound()
                          : _makeVitalsColumn()),
              /*floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.add, color: Colors.white,),
                backgroundColor: primaryColor,
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _addOrEditVitalsDialog(context),
                  );

                }
            )*/
            ));
  }

  Widget _noVitalsFound() {
    return Center(
      child: Text('No Vitals added yet.',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeVitalsColumn() {
    final Vitals vital = vitals.elementAt(0);
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          /*Row(
            children: <Widget>[
              SizedBox(width: 150,
                child: Text('Date of Recording',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: primaryColor)),
              ),
              Text(':',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(width: 8,),
              Text('Today, '+dateFormatForHeader.format(new DateTime.now()),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(height: 24,),*/
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Weight',
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
              Text(vital.weight,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('Kg',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Temperature',
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
              Text(vital.temperature,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('\u2109',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Pulse',
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
              Text(vital.pulse,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('bpm',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Systolic Blood Pressure',
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
              Text(vital.systolicBloodPressure,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('mm of Hg',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Diastolic Blood Pressure',
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
              Text(vital.diastolicBloodPressure,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('mm of Hg',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Text('Blood Oxygen Saturation',
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
              Text(vital.bloodOxygenSaturation,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
              SizedBox(
                width: 8,
              ),
              Text('%',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: textBlack)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  addOrEditVitalsDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
      height: 600,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: colorF6F6FF,
                ),
                onPressed: () {},
              ),
              Expanded(
                flex: 8,
                child: Text(
                  'Add Vitals',
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _entryHeightField('Height (Cm)'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: _entryWeightField('Weight (Kg)'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _entryPulseField('Pulse (bpm)'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: _entryBodyOxygenField(
                                    'Blood Oxygen Saturation (%)'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _entrySystolicBPField(
                                    'Systolic Blood Pressure (mm of Hg)'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: _entryDiastolicBPField(
                                    'Diastolic Blood Pressure (mm of Hg)'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:
                                    _entryBodyTempField('Temperature (\u2109)'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _submitButton(context),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        //_addPatientVital(context);
      },
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(primaryLightColor),
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryColor)))),
      label: Text(
        'Submit',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: Icon(
        Icons.done,
        color: Colors.white,
      ),
    );
  }

  /*Widget _textFeilds(String hint, TextEditingController editingController, FocusNode focusNode, FocusNode nextFocusNode){
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      textAlign: TextAlign.left,
      textInputAction: nextFocusNode == _obstetricHistoryFocus ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (term){
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
  }*/

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    debugPrint('Click 2');
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _entryHeightField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _heightController,
              focusNode: _heightFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                debugPrint('Click 1');
                _fieldFocusChange(context, _heightFocus, _weightFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entryWeightField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _weightController,
              focusNode: _weightFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _weightFocus, _pulseFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entryPulseField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _pulseController,
              focusNode: _pulseFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _pulseFocus, _bodyOxygenFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entryBodyOxygenField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _bodyOxygenController,
              focusNode: _bodyOxygenFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _bodyOxygenFocus, _systolicBPFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entrySystolicBPField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _systolicBPController,
              focusNode: _systolicBPFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _systolicBPFocus, _diastolicBPFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entryDiastolicBPField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _diastolicBPController,
              focusNode: _diastolicBPFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _diastolicBPFocus, _bodyTempFocus);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _entryBodyTempField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: _bodyTempController,
              focusNode: _bodyTempFocus,
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }

  _getPatientVitals() async {
    try {
      final PatientVitalsPojo patientVitalsPojo =
          await model.getPatientVitals('Bearer ' + auth, patientUserId);

      if (patientVitalsPojo.status == 'success') {
        vitals.clear();
        setState(() {
          vitals.addAll(patientVitalsPojo.data.vitals);
        });
      } else {}
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
    }
  }

/*_addPatientVital(BuildContext context) async {
    try {

      var map = new Map<String, String>();
      map["PatientUserId"] = visitInformation.appointments.patientUserId;
      map["VisitId"] = visitInformation.visitInfo.id;
      map["Weight"] = _weightController.text;
      map["Height"] = _heightController.text;
      map["Temperature"] = _bodyTempController.text;
      map["Pulse"] = _pulseController.text;
      map["SystolicBloodPressure"] = _systolicBPController.text;
      map["DiastolicBloodPressure"] = _diastolicBPController.text;
      map["BloodOxygenSaturation"] = _bodyOxygenController.text;

      BaseResponse baseResponse = await model.addPatientVitals('Bearer ' + auth, map);

      if (baseResponse.status == 'success') {
        _getPatientVitals();
      } else {
        showToast("Please try again");
      }
    } catch (CustomException) {
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }
*/
}
