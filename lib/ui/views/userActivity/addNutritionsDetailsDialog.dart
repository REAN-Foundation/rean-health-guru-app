import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

class AddNutritionDetailsDialog extends StatefulWidget {
  Function _submitButtonListner;
  String _nutritionName;
  double _caloriesConsumed;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddNutritionDetailsDialog({
    Key key,
    @required Function submitButtonListner,
    String nutritionName,
  }) : super(key: key) {
    _submitButtonListner = submitButtonListner;
    _nutritionName = nutritionName;
  }

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<AddNutritionDetailsDialog> {
  var model = PatientCarePlanViewModel();
  var doctorSearchList = new List<Doctors>();

  String unit = 'cal';

  var _nutritionNameController = new TextEditingController();
  var _consumedCaloriesController = new TextEditingController();
  var _nutritionNameFocus = FocusNode();
  var __consumedCaloriesFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
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

  Widget textFeilds() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Enter Name",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: "",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'name',
                    child: TextFormField(
                        controller: _nutritionNameController,
                        focusNode: _nutritionNameFocus,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _nutritionNameFocus,
                              __consumedCaloriesFocus);
                        },
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(
                              new RegExp('[\\,|\\+|\\-]')),
                        ],
                        decoration: InputDecoration(
                            hintText: "ex. Banana",
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                "Calories",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: " (cal)",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'cal',
                    child: TextFormField(
                        controller: _consumedCaloriesController,
                        focusNode: __consumedCaloriesFocus,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (term) {},
                        inputFormatters: [
                          new BlacklistingTextInputFormatter(
                              new RegExp('[\\,|\\+|\\-]')),
                        ],
                        decoration: InputDecoration(
                            hintText: "100",
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
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
          widget._submitButtonListner(
              _nutritionNameController.text.toString(),
              double.parse(_consumedCaloriesController.text),
              widget._nutritionName);
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
