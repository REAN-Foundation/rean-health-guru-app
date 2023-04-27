import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/lab_management/view_models/patients_lipid_profile.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EnterAllCholesterolValuesView extends StatefulWidget {
  @override
  _EnterAllCholesterolValuesViewState createState() =>
      _EnterAllCholesterolValuesViewState();
}

class _EnterAllCholesterolValuesViewState
    extends State<EnterAllCholesterolValuesView> {
  var model = PatientLipidProfileViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _ldlController = TextEditingController();
  final _lpaController = TextEditingController();
  final _hdlcontroller = TextEditingController();
  final _totalCholesterolController = TextEditingController();
  final _triglyceridesController = TextEditingController();
  final _a1cLevelController = TextEditingController();
  final _ratioController = TextEditingController();
  final _ratioFocus = FocusNode();
  final _a1cLevelFocus = FocusNode();
  final _triglyceridesFocus = FocusNode();
  final _totalCholesterolFocus = FocusNode();
  final _hdlFocus = FocusNode();
  final _ldlFocus = FocusNode();
  final _lpaFocus = FocusNode();
  ProgressDialog? progressDialog;
  var scrollContainer = ScrollController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientLipidProfileViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //const SizedBox(height: 16,),
                  totalCholesterolFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  ldlFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  lpaFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  hdlFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  triglyceridesFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  a1cLevelFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  /*ratioFeilds(),
                  const SizedBox(
                    height: 32,
                  ),*/
                  Align(
                    alignment: Alignment.center,
                    child: model!.busy
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator())
                        : Semantics(
                            label: 'Save',
                            button: true,
                            child: InkWell(
                              onTap: () {
                                FirebaseAnalytics.instance.logEvent(name: 'lab_values_enter_all_values_save_button_click');
                                validate();
                              },
                              child: ExcludeSemantics(
                                child: Container(
                                    height: 40,
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                          color: primaryColor, width: 1),
                                      color: primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ldlFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_ldl.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your LDL',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (mg/dl) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'LDL Information',
                      description:
                          'LDL = BAD: Low-density lipoprotein is known as “bad” cholesterol.',
                      height: 200),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'ldl measures in mg/dl',
                      child: TextFormField(
                          controller: _ldlController,
                          focusNode: _ldlFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _ldlFocus, _hdlFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              /*hintText: unit == 'lbs'
                                  ? '(100 to 200)'
                                  : '(50 to 100)',*/
                              hintStyle: TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget lpaFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_lpa.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your Lp(a)',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (mg/dl) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Lp(a) Information',
                      description:
                      'Lipoprotein(a), like low-density cholesterol (LDL), is a subtype of lipoprotein that can build up in arteries, increasing the risk of a heart attack or stroke. Lp(a) is an independent risk factor for heart disease that is genetically inherited. Talk to your doctor if you should have your Lp(a) measured based on your personal and family history of heart disease.',
                      height: 300),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Lp(a) measures in mg/dl',
                      child: TextFormField(
                          controller: _lpaController,
                          focusNode: _lpaFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _ldlFocus, _hdlFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                            /*hintText: unit == 'lbs'
                                  ? '(100 to 200)'
                                  : '(50 to 100)',*/
                              hintStyle: TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget hdlFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_hdl.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your HDL',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (mg/dl) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'HDL Information',
                      description:
                          'HDL = GOOD: High-density lipoprotein is known as “good” cholesterol.',
                      height: 208),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'HDL measures in mg/dl',
                      child: TextFormField(
                          focusNode: _hdlFocus,
                          controller: _hdlcontroller,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _hdlFocus, _totalCholesterolFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(100 to 125)',
                              hintStyle: TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget totalCholesterolFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_total_cholesterol.png'),
                    size: 24,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Enter your total cholesterol',
                    style: TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  RichText(
                    text: TextSpan(
                      text: ' (mg/dl)',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: textBlack,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  Expanded(
                    child: InfoScreen(
                        tittle: 'Total Cholesterol Information',
                        description:
                            'Your total blood cholesterol is calculated by adding your HDL and LDL cholesterol levels, plus 20% of your triglyceride level. “Normal ranges” are less important than your overall cardiovascular risk. Like HDL and LDL cholesterol levels, your total blood cholesterol level should be considered in context with your other known risk factors. All adults age 20 or older should have their cholesterol (and other traditional risk factors) checked every four to six years. If certain factors put you at high risk, or if you already have heart disease, your doctor may ask you to check it more often. Work with your doctor to determine your risk for cardiovascular disease and stroke and create a plan to reduce your risk.',
                        height: 420),
                  ),
                ],
              ),
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
                      label: 'Total Cholesterol messures in mg/dl ',
                      child: TextFormField(
                          focusNode: _totalCholesterolFocus,
                          controller: _totalCholesterolController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _totalCholesterolFocus,
                                _triglyceridesFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(92 to 100)',
                              hintStyle: TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget triglyceridesFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_triglycerides.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your triglycerides',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' (mg/dl) ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Triglycerides Information',
                      description:
                      'Triglycerides: The most common type of fat in the body.',
                      height: 200),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Triglycerides measures in mg/dl',
                      child: TextFormField(
                          focusNode: _triglyceridesFocus,
                          controller: _triglyceridesController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _triglyceridesFocus, _a1cLevelFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(65 to 95)',
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget a1cLevelFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_a1c_level.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your A1C Level',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' % ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
                  ),
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'A1C Level Information',
                      description: "HbA1C (A1C or glycosylated hemoglobin test). The A1C test can diagnose prediabetes and diabetes. It measures your average blood glucose control for the past two to three months. Blood sugar is measured by the amount of glycosylated hemoglobin (A1C) in your blood. An A1C of 5.7% to 6.4% means that you have prediabetes, and you're at high risk for developing diabetes. Diabetes is diagnosed when the A1C is 6.5% or higher.",
                      height: 320),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'A1C Level measures in %',
                      child: TextFormField(
                          focusNode: _a1cLevelFocus,
                          controller: _a1cLevelController,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _a1cLevelFocus, _ratioFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(65 to 95)',
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ratioFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_ratio.png'),
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your ratio',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                    text: ' % ',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: textBlack,
                        fontSize: 12),
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
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Ratio messures in %',
                      child: TextFormField(
                          focusNode: _ratioFocus,
                          controller: _ratioController,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onFieldSubmitted: (term) {},
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(95 to 100)',
                              hintStyle: TextStyle(
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  validate() {
    bool ifRecordsEnterted = false;
    bool validationToastDisplay = true;

    if (_ldlController.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('LDL', _ldlController.text.toString(), 'mg/dl');
    }

    if (_lpaController.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('Lipoprotein', _lpaController.text.toString(), 'mg/dl');
    }

    if (_hdlcontroller.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('HDL', _hdlcontroller.text.toString(), 'mg/dl');
    }
    if (_totalCholesterolController.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('Total Cholesterol', _totalCholesterolController.text.toString(), 'mg/dl');
    }
    if (_triglyceridesController.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('Triglyceride Level', _triglyceridesController.text.toString(), 'mg/dl');
    }
    if (_ratioController.text.isNotEmpty) {
      ifRecordsEnterted = true;
      validationToastDisplay = false;
      addvitals('Cholesterol Ratio', _ratioController.text.toString(), '%');
    }

    if (_a1cLevelController.text.isNotEmpty) {
      if(isNumeric(_a1cLevelController.text)) {
        ifRecordsEnterted = true;
        validationToastDisplay = false;
        addvitals('A1C Level', _a1cLevelController.text.toString(), '%');
      }else{
        showToast('Please enter valid input', context);
      }

     /* if(isNumeric(_a1cLevelController.text){
        ifRecordsEnterted = true;
        addvitals('A1C Level', _a1cLevelController.text.toString(), '%');
      }else{
      showToast('Please enter valid input', context);
      }*/
    }

    if(validationToastDisplay){
      showToast('Please enter valid input', context);
    }

    if (ifRecordsEnterted) {
      clearAllFeilds();
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  addvitals(String displayName, String value, String unit) async {
    try {
      //progressDialog!.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['TypeName'] = 'Cholesterol';
      map['DisplayName'] = displayName;
      map['PrimaryValue'] = value;
      map['PatientUserId'] = patientUserId;
      map['Unit'] = unit;
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse = await model.addlipidProfile(map);

      if (baseResponse.status == 'success') {
        //progressDialog!.close();
        //showToast(baseResponse.message!, context);
        model.setBusy(false);
      } else {
        //progressDialog!.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      //progressDialog!.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  /*addvitals() async {
    try {
      progressDialog!.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      if (_ldlController.text.toString().isNotEmpty)
        map['LDL'] = _ldlController.text.toString();
      if (_hdlcontroller.text.toString().isNotEmpty)
        map['HDL'] = _hdlcontroller.text.toString();
      if (_totalCholesterolController.text.toString().isNotEmpty)
        map['TotalCholesterol'] = _totalCholesterolController.text.toString();
      if (_triglyceridesController.text.toString().isNotEmpty)
        map['TriglycerideLevel'] = _triglyceridesController.text.toString();
      if (_a1cLevelController.text.toString().isNotEmpty)
        map['A1CLevel'] = _a1cLevelController.text.toString();
      if (_ratioController.text.toString().isNotEmpty)
        map['Ratio'] = _ratioController.text.toString();
      map['PatientUserId'] = "";
      map['Unit'] = "mg/dl";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse = await model.addMylipidProfile(map);

      if (baseResponse.status == 'success') {
        showToast(baseResponse.message!, context);
        progressDialog!.close();
        clearAllFeilds();
        //Navigator.pop(context);
      } else {
        progressDialog!.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog!.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }*/

  bool toastDisplay = true;

  clearAllFeilds() {
    //if (toastDisplay) {
    _scrollController.animateTo(0.0,
        duration: Duration(seconds: 2), curve: Curves.ease);
    showSuccessToast('Record Created Successfully!', context);
      //toastDisplay = false;
    //}

    _ldlController.text = '';
    _ldlController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ldlController.text.length),
    );

    _lpaController.text = '';
    _lpaController.selection = TextSelection.fromPosition(
      TextPosition(offset: _lpaController.text.length),
    );

    _hdlcontroller.text = '';
    _hdlcontroller.selection = TextSelection.fromPosition(
      TextPosition(offset: _hdlcontroller.text.length),
    );

    _totalCholesterolController.text = '';
    _totalCholesterolController.selection = TextSelection.fromPosition(
      TextPosition(offset: _totalCholesterolController.text.length),
    );

    _triglyceridesController.text = '';
    _triglyceridesController.selection = TextSelection.fromPosition(
      TextPosition(offset: _triglyceridesController.text.length),
    );

    _a1cLevelController.text = '';
    _a1cLevelController.selection = TextSelection.fromPosition(
      TextPosition(offset: _a1cLevelController.text.length),
    );

    _ratioController.text = '';
    _ratioController.selection = TextSelection.fromPosition(
      TextPosition(offset: _ratioController.text.length),
    );
  }
}
