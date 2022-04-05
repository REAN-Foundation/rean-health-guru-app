import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/careplan/models/GetAHACarePlansResponse.dart';
import 'package:paitent/features/common/careplan/view_models/patients_care_plan.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';

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
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Select Care Plan',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.black),
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
          body: model.busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    headerText(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            selectCarePlanDropDown(),
                            if (selectedCarePlan == '')
                              Container()
                            else
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
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: colorF6F6FF),
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

  Widget descriptionOfCarePlan() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 4,
          ),
          /* Text("dfbbd", style: TextStyle(
              color: textBlack, fontSize: 16, fontFamily: 'Montserrat', fontWeight: FontWeight.w200,),),*/
          RichText(
            text: TextSpan(
              text: carePlanTypes.description,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w200,
                color: textBlack,
              ),
              children: <TextSpan>[
                /*TextSpan(
                    text: 'https://www.heart.org',
                    style: TextStyle( fontWeight: FontWeight.w200, color: Colors.lightBlueAccent, fontFamily: 'Montserrat', decoration: TextDecoration.underline,),
                recognizer: new TapGestureRecognizer()..onTap = () => _urlLauncher('https://www.heart.org'),),
                TextSpan(
                    text: ') to improve your cardiovascular health if you have experienced heart attack, heart failure, angioplasty or heart surgery.',
                    style: TextStyle( fontWeight: FontWeight.w200, color: textBlack, fontFamily: 'Montserrat')),*/
              ],
            ),
          ),
        ],
      ),
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

  Widget registerFooter() {
    return Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorF6F6FF,
        ),
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
                width: 160,
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
