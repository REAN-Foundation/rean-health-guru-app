import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';

// ignore: must_be_immutable
class AddHeightDialog extends StatefulWidget {
  late Function _submitButtonListner;
  double? _height;

  // ignore
  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddHeightDialog(
      {Key? key, required Function submitButtonListner, double? height})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
    _height = height;
  }

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<AddHeightDialog> {
  var model = PatientCarePlanViewModel();
  var doctorSearchList = <Doctors>[];

  String unit = 'Kg';
  late var height;
  final _heightInFeetController = TextEditingController();
  final _heightInInchesController = TextEditingController();
  final _heightInFeetFocus = FocusNode();
  final _heightInInchesFocus = FocusNode();

  @override
  void initState() {
    if (getCurrentLocale() == 'US') {
      unit = 'lbs';
    }

    if (widget._height != 0.0) {
      widget._height = Conversion.cmToFeet(widget._height!);

      height = widget._height.toString().split('.');

      _heightInFeetController.text = height[0].toString();
      _heightInFeetController.selection = TextSelection.fromPosition(
        TextPosition(offset: _heightInFeetController.text.length),
      );
      _heightInInchesController.text = height[1].toString();
      _heightInInchesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _heightInInchesController.text.length),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
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
                'Enter your height',
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              /*RichText(
                text: TextSpan(
                  //text: getCurrentLocale() == 'US' ? ' (Foot) ' : ' (Cm) ',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: textBlack,
                      fontSize: 14),
                ),
              ),*/
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
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Height measures in ',
                    child: TextFormField(
                        controller: _heightInFeetController,
                        focusNode: _heightInFeetFocus,
                        maxLines: 1,
                        maxLength: 2,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _heightInFeetFocus,
                              _heightInInchesFocus);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\.|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Feet',
                            counterText: "",
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
              SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Height measures in ',
                    child: TextFormField(
                        controller: _heightInInchesController,
                        focusNode: _heightInInchesFocus,
                        maxLines: 1,
                        maxLength: 2,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (term) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\.|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Inches',
                            counterText: "",
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
      child: ElevatedButton(
        onPressed: () {
          if (_heightInFeetController.text.trim().isEmpty) {
            showToastMsg("Please enter your height in feet", context);
          } else if (double.parse(_heightInFeetController.text) > 15) {
            showToastMsg("Please enter valid height in feet", context);
          } else if (_heightInInchesController.text.trim().isEmpty) {
            showToastMsg("Please enter your height in inches", context);
          } else if (double.parse(_heightInInchesController.text) > 12) {
            showToastMsg("Please enter valid height in inches", context);
          } else {
            widget._submitButtonListner(Conversion.FeetToCm(double.parse(
                _heightInFeetController.text +
                    '.' +
                    _heightInInchesController.text)));
          }
        },
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(primaryLightColor),
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: primaryColor)))),
        child: Text(
          '      Save       ',
          semanticsLabel: 'Save',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
