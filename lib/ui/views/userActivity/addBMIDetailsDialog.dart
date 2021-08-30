
import 'dart:convert';
import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/Conversion.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:http/http.dart' as http;


class AddBMIDetailDialog extends StatefulWidget {
  Function _submitButtonListner;
  double _height;
  double _weight;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddBMIDetailDialog(
      {Key key,
      @required Function submitButtonListner, double height, double weight})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
    _height = height;
    _weight = weight;
  }

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<AddBMIDetailDialog> {
  var model = PatientCarePlanViewModel();
  var doctorSearchList = new List<Doctors>();

  String unit = 'Kg';

  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();

  var _weightController = new TextEditingController();
  var _heightController = new TextEditingController();
  var _weightFocus = FocusNode();
  var _heightFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    if(details.alpha2Code == "US"){
      unit = 'lbs';
    }

    if(widget._height != 0.0) {

      if(details.alpha2Code == "US"){
        widget._height = Conversion.cmToFeet(widget._height);
      }

      _heightController.text = widget._height.toString();
      _heightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _heightController.text.length),
      );
    }

    if(widget._weight != 0.0) {

      if(unit == 'lbs'){
        widget._weight = widget._weight * 2.20462;
      }

      _weightController.text = widget._weight.toString();
      _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientCarePlanViewModel>(
        model: model,
        builder: (context, model, child) => Container(
              child: textFeilds(),
            ));
  }

  Widget textFeilds(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Enter your weight",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: unit == "lbs" ? " (lbs) " : " (Kg) ",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(8.0),
                      border: Border.all(
                          color: primaryColor, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'weight',
                    child: TextFormField(
                        controller: _weightController,
                        focusNode: _weightFocus,
                        maxLines: 1,
                        textInputAction:
                        TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context,
                              _weightFocus,
                              _heightFocus);
                        },
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                        ],
                        decoration: InputDecoration(
                            hintText: unit == "lbs" ? "(100 to 200)" : "(50 to 100)",
                            hintStyle: TextStyle(fontSize: 14, ),
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              Text(
                "Enter your height",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: details.alpha2Code == "US" ? " (Foot) " :" (Cm) ",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row (
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(8.0),
                      border: Border.all(
                          color: primaryColor, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'height',
                    child: TextFormField(
                        controller: _heightController,
                        focusNode: _heightFocus,
                        maxLines: 1,
                        textInputAction:
                        TextInputAction.done,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (term) {

                        },
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                        ],
                        decoration: InputDecoration(
                            hintText: details.alpha2Code == "US" ? "(Foot)" :"(Cm)",
                            hintStyle: TextStyle(fontSize: 14, ),
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24,),
          _submitButton(),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          widget._submitButtonListner(unit == 'lbs' ? double.parse(_weightController.text) / 2.20462 :double.parse(_weightController.text), details.alpha2Code == "US" ? Conversion.FeetToCm(double.parse(_heightController.text)) : double.parse(_heightController.text));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        child: Text(
          '      Add       ',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        textColor: Colors.white,
        color: primaryColor,
      ),
    );
  }
}