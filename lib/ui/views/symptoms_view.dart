import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetAssesmentTemplateByIdResponse.dart';
import 'package:paitent/core/models/GetMyAssesmentIdResponse.dart';
import 'package:paitent/core/viewmodels/views/dashboard_summary_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/networking/CustomException.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/home_view.dart';
<<<<<<< HEAD
import 'package:paitent/utils/CoachMarkUtilities.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringConstant.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
=======
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
>>>>>>> main

import 'base_widget.dart';

// ignore: must_be_immutable
class SymptomsView extends StatefulWidget {
  String assessmmentId = '';

  SymptomsView(String id) {
    assessmmentId = id;
  }

  @override
  _SymptomsViewState createState() => _SymptomsViewState();
}

class _SymptomsViewState extends State<SymptomsView> {
  var model = DashboardSummaryModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SymptomAssessmentTemplate assessmentTemplate;
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
<<<<<<< HEAD
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
=======
>>>>>>> main

  //List symptomList = new List<SymptomsPojo>();
  var dateFormat = DateFormat('yyyy-MM-dd');
  String myAssesssmentId = '';
<<<<<<< HEAD
  final GlobalKey _keySymptoms = GlobalKey();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  CoachMarkUtilites coackMarkUtilites = CoachMarkUtilites();
=======
>>>>>>> main

  @override
  void initState() {
    //prepareSymptomsList();
    getAssesmentTemplateById();
<<<<<<< HEAD
    initTargets();
=======
>>>>>>> main
    super.initState();
  }

  /*void prepareSymptomsList() {
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_12.png','Sudden weight gain of 2-3 lbs in 24 hours or 5 lbs in a week'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_1.png', 'Chest pain or pain in jaw, shoulder or arm'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_2.png','Shortness of breath'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_3.png','Dizzyness, lightheadedness or loss of conciousness'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_4.png','Extreme Fatigue'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_5.png','Dry or frequent hacking cough'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_6.png','Increased swelling of legs, feet or ankles'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_7.png','Discomfort in abdomen or nausea'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_8.png','Trouble sleeping'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_9.png','Frequent urination'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_10.png','Extreme thirst'));
    symptomList.add(new SymptomsPojo('res/images/ic_symptoms_11.png','Tingling or numbness in feet'));
  }*/

<<<<<<< HEAD
  void initTargets() {
    targets.add(coackMarkUtilites.getTargetFocus(
        _keySymptoms,
        (targets.length + 1).toString(),
        'Symptoms List',
        'swipe right for better or left for worse',
        CoachMarkContentPosition.bottom,
        ShapeLightFocus.RRect));
  }

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets,
        onCoachMartkFinish: () {
      _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Symptoms_View_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Finish');
    }, onCoachMartkSkip: () {
      _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Home_View_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Skip');
    }, onCoachMartkClickTarget: (target) {
      debugPrint('Coach Mark target click');
    }, onCoachMartkClickOverlay: () {
      debugPrint('Coach Mark overlay click');
    }).show();
  }

/*  _layout(_) async {
    Future.delayed(Duration(milliseconds: 1000));
    bool isCoachMarkDisplayed = false;
    isCoachMarkDisplayed = await _sharedPrefUtils
        .readBoolean(StringConstant.Is_Symptoms_View_Coach_Mark_Completed);
    debugPrint('isCoachMarkDisplayed ==> $isCoachMarkDisplayed');
    if (!isCoachMarkDisplayed || isCoachMarkDisplayed == null) {
      Future.delayed(const Duration(seconds: 2), () => showTutorial());
      //showTutorial();
    }
  }*/

=======
>>>>>>> main
  @override
  Widget build(BuildContext context) {
    return BaseWidget<DashboardSummaryModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Symptoms',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
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
                  child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Semantics(
                            label: 'swipe right for better or left for worse',
                            readOnly: true,
                            child: Text(
                              'Are symptoms getting Better or Worse?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              listWidget(),
                              SizedBox(
                                height: 8,
                              ),
                              doneButon(),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget doneButon() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () async {
          showToast('Symptoms recorded successfully', context);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeView(0);
          }), (Route<dynamic> route) => false);
        },
        icon: Icon(
          Icons.done,
          color: Colors.white,
          size: 24,
        ),
        label: Semantics(
          label: 'tap when done with symptoms',
          readOnly: true,
          child: Text(
            'Done',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(primaryLightColor),
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: primaryColor)))),
      ),
    );
  }

  Widget listWidget() {
<<<<<<< HEAD
    //WidgetsBinding.instance.addPostFrameCallback(_layout);
=======
>>>>>>> main
    return ListView.separated(
        itemBuilder: (context, index) => _createSymptomsListUI(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 0,
          );
        },
        itemCount: assessmentTemplate.templateSymptomTypes.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  /*ListView generateItemsList() {
    return ListView.builder(
      itemCount: itemsList.length,
      itemBuilder: (context, index) {
        return
      },
    );
  }*/

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              ' Better',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.deepOrange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.close,
              color: Colors.white,
            ),
            Text(
              ' Worse',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _createSymptomsListUI(BuildContext context, int index) {
    final TemplateSymptomTypes symptomTypes =
        assessmentTemplate.templateSymptomTypes.elementAt(index);

    return Dismissible(
<<<<<<< HEAD
      key: index == 1 ? _keySymptoms : Key(symptomTypes.symptom),
=======
      key: Key(symptomTypes.symptom),
>>>>>>> main
      child: InkWell(
          onTap: () {
            debugPrint('${symptomTypes.symptom} clicked');
          },
          child: ListTile(
            leading: SizedBox(
              height: 40,
              width: 40,
              child: CachedNetworkImage(
                imageUrl: apiProvider.getBaseUrl() +
                    '/file-resources/' +
                    symptomTypes.imageResourceId +
                    '/download-by-version-name/1',
              ),
            ),
            title: Text(
              symptomTypes.symptom,
              style: TextStyle(
                  fontSize: 14.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            tileColor: index.isEven ? primaryLightColor : colorF6F6FF,
          )),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          addPatientSymptomsInAssesment(symptomTypes.symptomTypeId, true);
          setState(() {
            assessmentTemplate.templateSymptomTypes.removeAt(index);
          });
          /*final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                      "Are you sure you want to delete ${itemsList[index]}?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        // TODO: Delete the item from DB etc..
                        setState(() {
                          itemsList.removeAt(index);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });*/
          //return res;
        } else {
          addPatientSymptomsInAssesment(symptomTypes.symptomTypeId, true);
          setState(() {
            assessmentTemplate.templateSymptomTypes.removeAt(index);
          });
        }
      },
    );
  }

  getAssesmentTemplateById() async {
    try {
      final GetAssesmentTemplateByIdResponse
          searchSymptomAssesmentTempleteResponse =
          await model.getAssesmentTemplateById(widget.assessmmentId);
      debugPrint(
          'Get Assesment Template By Id Response ==> ${searchSymptomAssesmentTempleteResponse.toJson()}');
      if (searchSymptomAssesmentTempleteResponse.status == 'success') {
        assessmentTemplate = searchSymptomAssesmentTempleteResponse
            .data.symptomAssessmentTemplate;
        debugPrint(
            'Get Assesment Template Symptoms Types Length ==> ${searchSymptomAssesmentTempleteResponse.data.symptomAssessmentTemplate.templateSymptomTypes.length}');
        setState(() {});
        getMyAssesmentId();
      } else {
        //getAssesmentTemplateById();
        showToast(searchSymptomAssesmentTempleteResponse.message, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  getMyAssesmentId() async {
    try {
      final body = <String, dynamic>{};
      body['PatientUserId'] = patientUserId;
      body['AssessmentTemplateId'] = widget.assessmmentId;
      body['AssessmentDate'] = dateFormat.format(DateTime.now());
      body['Title'] = assessmentTemplate.id;

      final GetMyAssesmentIdResponse response =
          await model.getMyAssesmentId(body);
      debugPrint('Get My Assesment Id Response ==> ${response.toJson()}');
      if (response.status == 'success') {
        myAssesssmentId = response.data.symptomAssessment.id;
        setState(() {});
      } else {
        //getAssesmentTemplateById();
        showToast(response.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  addPatientSymptomsInAssesment(String symptomTypeId, bool isPresent) async {
    try {
      final body = <String, dynamic>{};
      body['PatientUserId'] = patientUserId;
      body['AssessmentId'] = myAssesssmentId;
      body['SymptomTypeId'] = symptomTypeId;
      body['IsPresent'] = isPresent;
      body['Severity'] = 1;
      body['Status'] = 1;
      body['Interpretation'] = 1;
      body['Comments'] = '';

      final BaseResponse response =
          await model.addPatientSymptomsInAssesment(body);
      debugPrint('Get My Assesment Id Response ==> ${response.toJson()}');
      if (response.status == 'success') {
        setState(() {});
      } else {
        showToast(response.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}

class SymptomsPojo {
  String imageUrl;
  String text;

  SymptomsPojo(String imageUrl, String text) {
    this.imageUrl = imageUrl;
    this.text = text;
  }
}
