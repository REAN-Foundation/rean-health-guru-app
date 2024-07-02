import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

// ignore: must_be_immutable
class AddHeightInCmDialog extends StatefulWidget {
  late Function _submitButtonListner;
  int? _heightInCm;

  AddHeightInCmDialog(
      {Key? key, required Function submitButtonListner, int? heightInCm})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
    _heightInCm = heightInCm;
  }

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<AddHeightInCmDialog> {
  var model = PatientCarePlanViewModel();
  var doctorSearchList = <Doctors>[];

  String unit = 'Kg';
  late var height;
  final _heightController = TextEditingController();
  final _heightFocus = FocusNode();

  @override
  void initState() {
    if (getCurrentLocale() == 'US') {
      unit = 'lbs';
    }

    if (widget._heightInCm != 0.0) {
      _heightController.text = widget._heightInCm.toString();
      _heightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _heightController.text.length),
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
                        controller: _heightController,
                        focusNode: _heightFocus,
                        maxLines: 1,
                        maxLength: 3,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\.|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Cm',
                            counterText: "",
                            prefixIcon: Padding(padding: EdgeInsets.fromLTRB(12,15, 4, 5),  child: Text("Cm")),
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0,13,0,0),
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

/*  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }*/

  Widget _submitButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          if (_heightController.text.trim().isEmpty) {
            showToastMsg("Please enter your height in cm", context);
          } else if (double.parse(_heightController.text) == 0) {
            showToastMsg("Please enter valid height in cm", context);
          } else if (double.parse(_heightController.text) > 500) {
            showToastMsg("Please enter valid height in cm", context);
          } else {
            widget._submitButtonListner(int.parse(_heightController.text));
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
