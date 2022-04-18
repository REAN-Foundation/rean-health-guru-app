import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/careplan/models/GetAHACarePlansResponse.dart';
import 'package:paitent/features/common/careplan/view_models/patients_care_plan.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectCarePlanView extends StatefulWidget {
  @override
  _SelectCarePlanViewState createState() => _SelectCarePlanViewState();
}

class _SelectCarePlanViewState extends State<SelectCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GetAHACarePlansResponse _ahaCarePlansResponse;
  List<DropdownMenuItem<String>>? _carePlanMenuItems;
  String? selectedCarePlan = '';
  late CarePlanTypes carePlanTypes;
  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  String startDate = '';

  @override
  void initState() {
    model.setBusy(true);
    getAHACarePlans();
    doctorSearchListGlobe.clear();
    parmacySearchListGlobe.clear();
    nurseMemberListGlobe.clear();
    familyMemberListGlobe.clear();

    super.initState();
  }

  getAHACarePlans() async {
    try {
      _ahaCarePlansResponse = await model.getAHACarePlans();

      if (_ahaCarePlansResponse.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_ahaCarePlansResponse.toJson()}');

        _carePlanMenuItems = buildDropDownMenuItemsForCarePlan(
            _ahaCarePlansResponse.data!.carePlanTypes!);
      } else {
        showToast(_ahaCarePlansResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForCarePlan(
      List<CarePlanTypes> list) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < list.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(list.elementAt(i).code!),
        value: list.elementAt(i).code,
      ));
    }
    return items;
  }

  getCarePlanDetails() {
    for (int i = 0;
        i < _ahaCarePlansResponse.data!.carePlanTypes!.length;
        i++) {
      if (selectedCarePlan ==
          _ahaCarePlansResponse.data!.carePlanTypes!.elementAt(i).code) {
        carePlanTypes = _ahaCarePlansResponse.data!.carePlanTypes!.elementAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            brightness: Brightness.dark,
            title: Text(
              'Select Care Plan',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: primaryColor,
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: model!.busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Semantics(
                                          label: 'Care Plan image',
                                          image: true,
                                          child: Image.asset(
                                            'res/images/ic_hf_care_plan.png',
                                            color: primaryColor,
                                            width: 120,
                                            height: 120,
                                          ),
                                        ),
                                        selectCarePlanDropDown(),
                                        startCarePlanDate(),
                                        checkElegibility(),
                                        /* if (selectedCarePlan == '')
                                          Container()
                                        else*/
                                        descriptionOfCarePlan(),
                                        //eligibilityOfCarePlan(),
                                        //recomandationForCarePlan(),
                                      ],
                                    ),
                                  ),
                                ),
                                registerFooter(),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerText() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          'You do not have any registered care plan.',
          style: TextStyle(color: textBlack, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget selectCarePlanDropDown() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Care Plan',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                'Select Care Plan',
                style: TextStyle(
                    color: textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              items:
                  _carePlanMenuItems /*[
                  DropdownMenuItem(
                    value: "Heart Failure - AHAHF ",
                    child: Text(
                      "Heart Failure - AHAHF ",
                      style: TextStyle(
                          color: textBlack, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),

                ]*/
              ,
              onChanged: (value) {
                setState(() {
                  selectedCarePlan = value;
                  getCarePlanDetails();
                });
              },
              value: selectedCarePlan == '' ? null : selectedCarePlan,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            selectedCarePlan == '' ? '' : carePlanTypes.name!,
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget startCarePlanDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Start Date:',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            child: ExcludeSemantics(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 48.0,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Color(0XFF909CAC),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dob,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset('res/images/ic_calender.png')),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now().subtract(Duration(days: 0)),
                  onChanged: (date) {
                debugPrint('change $date');
              }, onConfirm: (date) {
                unformatedDOB = date.toIso8601String();
                setState(() {
                  dob = dateFormat.format(date);
                  startDate =
                      dateFormatStandard.format(date) + 'T00:00:00.000Z';
                });
                debugPrint('confirm $date');
                debugPrint('confirm formated $startDate');
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
          ),
        ],
      ),
    );
  }

  Widget checkElegibility() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            'Check Eligibility',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: primaryColor, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget descriptionOfCarePlan() {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: const Color(0xffcecece).withOpacity(0.5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                /* Text("dfbbd", style: TextStyle(
                    color: textBlack, fontSize: 16, fontFamily: 'Montserrat', fontWeight: FontWeight.w200,),),*/
                RichText(
                  text: TextSpan(
                    text:
                        'Cardiac rehab is a medically supervised programme designed by American Heart ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textGrey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '(https://www.heart.org)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => _launchURL('https://www.heart.org'),
                      ),
                      TextSpan(
                          text:
                              ' to improve your cardiovascular health if you have experienced heart attack, heart failure, angioplasty or heart surgery.',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textGrey,
                              fontSize: 14,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget eligibilityOfCarePlan() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Eligibility',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 4,
          ),
          RichText(
            text: TextSpan(
              text:
                  'People of all ages with heart conditions can benefit from a cardiac rehab program. You may benefit if you have or have experienced a:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w200,
                color: textBlack,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '\n• heart attack (myocardial infarction)',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: textBlack,
                    fontFamily: 'Montserrat',
                  ),
                ),
                TextSpan(
                    text:
                        '\n• heart condition, such as coronary artery disease (CAD), angina or heart failure',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: textBlack,
                        fontFamily: 'Montserrat')),
                TextSpan(
                    text:
                        '\n• heart procedure or surgery, including coronary artery bypass graft (CABG) surgery, percutaneous coronary intervention (PCI, including coronary or balloon angioplasty and stenting), valve replacement, a pacemaker or implantable cardioverter defibrillator (ICD)',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: textBlack,
                        fontFamily: 'Montserrat')),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 120,
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      'View more >>',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget recomandationForCarePlan() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Doctor Recommendation',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Search doctor here',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                    height: 32,
                    width: 32,
                    child: Icon(
                      Icons.search,
                      size: 32,
                      color: primaryColor,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: primaryColor),
                  child: Center(
                    child: Text(
                      'Get Recommendation',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Widget registerFooter() {
    return Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (selectedCarePlan == '') {
                  showToast('Please select care plan', context);
                } else {
                  Navigator.pushNamed(context, RoutePaths.Start_Care_Plan,
                      arguments: selectedCarePlan);
                }
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 32,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: primaryColor),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
