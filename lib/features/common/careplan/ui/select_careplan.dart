import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/features/common/careplan/models/check_careplan_eligibility.dart';
import 'package:patient/features/common/careplan/models/enroll_care_clan_response.dart';
import 'package:patient/features/common/careplan/models/get_aha_careplans_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
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
  AvailablePlans? carePlanTypes;
  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  String startDate = '';
  bool? carePlanEligibility = false;
  String? carePlanEligibilityMsg = '';
  String? decription = '';

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
        debugPrint('AHA Health Journey ==> ${_ahaCarePlansResponse.toJson()}');

        _carePlanMenuItems = buildDropDownMenuItemsForCarePlan(
            _ahaCarePlansResponse.data!.availablePlans!);
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
      List<AvailablePlans> list) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < list.length; i++) {
      debugPrint('App Name ==> ${getAppName()}');
      debugPrint(
          'Plan Code ==> ${list.elementAt(i).code == 'CholesterolMini'}');

      if (getAppFlavour() == 'Heart & Stroke Helper™ ' &&
          list.elementAt(i).code == 'Cholesterol') {
        items.add(DropdownMenuItem(
          child: Text(list.elementAt(i).displayName!),
          value: list.elementAt(i).displayName,
        ));
      } else if (getAppFlavour() == 'Heart & Stroke Helper™ ' &&
          list.elementAt(i).code == 'Stroke') {
        items.add(DropdownMenuItem(
          child: Text(list.elementAt(i).displayName!),
          value: list.elementAt(i).displayName,
        ));
      } else if (getAppFlavour() == 'HF Helper' &&
          list.elementAt(i).code == 'HeartFailure') {
        items.add(DropdownMenuItem(
          child: Text(list.elementAt(i).displayName!),
          value: list.elementAt(i).displayName,
        ));
      } else if (getAppFlavour() == 'AHA-UAT' ||
          getAppFlavour() == 'RHG-UAT' ||
          getAppFlavour() == 'RHG-Dev' ||
          getAppFlavour() == 'REAN HealthGuru') {
        items.add(DropdownMenuItem(
          child: Text(list.elementAt(i).displayName!),
          value: list.elementAt(i).displayName,
        ));
      }
    }

    debugPrint('List Length ${items.length}');

    return items;
  }

  getCarePlanDetails() {
    for (int i = 0;
        i < _ahaCarePlansResponse.data!.availablePlans!.length;
        i++) {
      if (selectedCarePlan ==
          _ahaCarePlansResponse.data!.availablePlans!
              .elementAt(i)
              .displayName) {
        carePlanTypes =
            _ahaCarePlansResponse.data!.availablePlans!.elementAt(i);
        decription = _ahaCarePlansResponse.data!.availablePlans!
            .elementAt(i)
            .description;
      }
    }
    _checkCareplanEligibility(carePlanTypes!.code.toString());
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
              'Select Health Journey',
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
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Semantics(
                                            label: 'Health Journey image',
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
                                          //checkElegibility(),
                                          /* if (selectedCarePlan == '')
                                            Container()
                                          else*/
                                          decription != ''
                                              ? descriptionOfCarePlan()
                                              : Container(),
                                          //eligibilityOfCarePlan(),
                                          //recomandationForCarePlan(),
                                        ],
                                      ),
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
          'You do not have any registered Health Journey.',
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
            'Select Health Journey',
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
                'Select Health Journey',
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
          /*Text(
            selectedCarePlan == '' ? '' : carePlanTypes.displayName!,
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w300),
          ),*/
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
          Semantics(
            label: 'Select start date ' + dob,
            child: GestureDetector(
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
        child: Semantics(
          label: 'Check Eligibility',
          button: true,
          child: ExcludeSemantics(
            child: GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    context: context,
                    builder: (context) => eligibilityOfCarePlan());
              },
              child: Text(
                'Check Eligibility',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget descriptionOfCarePlan() {
    debugPrint('Discription ${decription.toString()}');
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
                    text: decription.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textGrey,
                    ),
                    /*children: <TextSpan>[
                      TextSpan(
                        text: '(https://www.heart.org)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
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
                    ],*/
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
    return Card(
      semanticContainer: false,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          side: BorderSide(width: 0, color: Colors.white)),
      margin: EdgeInsets.zero,
      child: Container(
        height: 400,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Check Eligibility',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    text:
                        'People of all ages with heart conditions can benefit from a cardiac rehab program. You may benefit if you have or have experienced a:',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textGrey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n\n\n• heart attack (myocardial infarction)',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: textGrey,
                        ),
                      ),
                      TextSpan(
                          text:
                              '\n• heart condition, such as coronary artery disease (CAD), angina or heart failure',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: textGrey,
                          )),
                      TextSpan(
                          text:
                              '\n• heart procedure or surgery, including coronary artery bypass graft (CABG) surgery, percutaneous coronary intervention (PCI, including coronary or balloon angioplasty and stenting), valve replacement, a pacemaker or implantable cardioverter defibrillator (ICD)',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: textGrey,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Okay',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width - 40,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                color: primaryColor),
                            child: Center(
                              child: Text(
                                'Okay',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
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

/*  _launchURL(String _url) async {
    if (!await launch(_url)) {
    } else {
      throw 'Could not launch $_url';
    }
  }*/

  Widget registerFooter() {
    return Container(
        height: carePlanEligibilityMsg != '' ? 120 : 82,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            carePlanEligibilityMsg != '' || carePlanEligibilityMsg != null
                ? Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    options: LinkifyOptions(humanize: false),
                    text: carePlanEligibilityMsg.toString(),
                    maxLines: 2,
                    style: TextStyle(color: Colors.red),
                    linkStyle: TextStyle(color: Colors.lightBlueAccent),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Semantics(
              label: 'Register',
              button: true,
              child: ExcludeSemantics(
                child: InkWell(
                  onTap: () {
                    if (selectedCarePlan == '') {
                      showToast('Please select Health Journey', context);
                    } else if (startDate == '') {
                      showToast('Please select start date', context);
                    } else if (carePlanEligibility!) {
                      startCarePlan();
                    } else {
                      //showToast(carePlanEligibilityMsg.toString(), context);
                    }
                  },
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width - 32,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
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
              ),
            ),
          ],
        ));
  }

  startCarePlan() async {
    try {
      model.setBusy(true);
      final map = <String, String?>{};
      map['Provider'] = carePlanTypes!.provider;
      map['PlanCode'] = carePlanTypes!.code;
      map['StartDate'] = startDate;

      final EnrollCarePlanResponse response = await model.startCarePlan(map);
      debugPrint('Registered Health Journey ==> ${response.toJson()}');
      if (response.status == 'success') {
        showSuccessDialog();
        //showToast(response.message!, context);
      } else {
        showToast(response.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _checkCareplanEligibility(String code) async {
    try {
      final CheckCareplanEligibility response =
          await model.checkCarePlanEligibility(code);
      debugPrint('Eligibility of Health Journey ==> ${response.toJson()}');
      if (response.status == 'success') {
        carePlanEligibility = response.data!.eligibility!.eligible;
        if (response.data!.eligibility!.reason != null) {
          carePlanEligibilityMsg = response.data!.eligibility!.reason;
        }
        // if (!carePlanEligibility!) {
        //showToast(carePlanEligibilityMsg.toString(), context);
        //}
      } else {
        showToast(response.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  showSuccessDialog() {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Card(
        elevation: 0.0,
        semanticContainer: false,
        child: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Semantics(
                label: 'Health Journey image',
                image: true,
                child: Image.asset(
                  'res/images/ic_careplan_success_tick.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Text(
                'Congratulations!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'You have successfully registered with\n' +
                      carePlanTypes!.displayName.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Semantics(
                button: true,
                label: 'Home',
                child: ExcludeSemantics(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeView(0);
                      }), (Route<dynamic> route) => false);
                    },
                    child: Container(
                      height: 48,
                      width: 260,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: primaryColor),
                      child: Center(
                        child: Text(
                          'Home',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);
  }
}
