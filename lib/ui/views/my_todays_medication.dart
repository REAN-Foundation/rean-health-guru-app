import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CoachMarkUtilities.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringConstant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MyTodaysMedicationView extends StatefulWidget {
  @override
  _MyTodaysMedicationViewState createState() => _MyTodaysMedicationViewState();
}

class _MyTodaysMedicationViewState extends State<MyTodaysMedicationView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //var dateFormatStandard = DateFormat("MMMM dd, yyyy");
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');
  List<Schedules> currentMedicationList = <Schedules>[];
  List<Schedules> morningMedicationList = <Schedules>[];
  List<Schedules> afternoonMedicationList = <Schedules>[];
  List<Schedules> eveningMedicationList = <Schedules>[];
  List<Schedules> nightMedicationList = <Schedules>[];
  ProgressDialog progressDialog;
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  GlobalKey _key;
  var globalKeyName;
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  CoachMarkUtilites coackMarkUtilites = CoachMarkUtilites();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();

  @override
  void initState() {
    getMyMedications();
    super.initState();
  }

  void initTargets() {
    targets.add(coackMarkUtilites.getTargetFocus(
        _key,
        (targets.length + 1).toString(),
        'Medication List',
        'swipe right for not taken or left for taken',
        CoachMarkContentPosition.bottom,
        ShapeLightFocus.RRect));
  }

  void showTutorial() {
    coackMarkUtilites.displayCoachMark(context, targets,
        onCoachMartkFinish: () {
      _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Medication_Remainder_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Finish');
    }, onCoachMartkSkip: () {
      _sharedPrefUtils.saveBoolean(
          StringConstant.Is_Medication_Remainder_Coach_Mark_Completed, true);
      debugPrint('Coach Mark Skip');
    }, onCoachMartkClickTarget: (target) {
      debugPrint('Coach Mark target click');
    }, onCoachMartkClickOverlay: () {
      debugPrint('Coach Mark overlay click');
    }).show();
  }

  _layout(_) async {
    Future.delayed(Duration(milliseconds: 1000));
    bool isCoachMarkDisplayed = false;
    isCoachMarkDisplayed = await _sharedPrefUtils.readBoolean(
        StringConstant.Is_Medication_Remainder_Coach_Mark_Completed);
    debugPrint('isCoachMarkDisplayed ==> $isCoachMarkDisplayed');
    if (!isCoachMarkDisplayed || isCoachMarkDisplayed == null) {
      Future.delayed(const Duration(seconds: 2), () => showTutorial());
      //showTutorial();
    }
  }

  getMyMedications() async {
    try {
      currentMedicationList.clear();
      final GetMyMedicationsResponse getMyMedicationsResponse = await model
          .getMyMedications(dateFormatStandard.format(DateTime.now()));
      debugPrint('Medication ==> ${getMyMedicationsResponse.toJson()}');
      if (getMyMedicationsResponse.status == 'success') {
        debugPrint(
            'Medication Length ==> ${getMyMedicationsResponse.data.medicationSchedulesForDay.schedules.length}');
        if (getMyMedicationsResponse
            .data.medicationSchedulesForDay.schedules.isNotEmpty) {
          currentMedicationList.addAll(getMyMedicationsResponse
              .data.medicationSchedulesForDay.schedules);
          formatMedicationSectionWise(getMyMedicationsResponse
              .data.medicationSchedulesForDay.schedules);
        }
      } else {
        showToast(getMyMedicationsResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  formatMedicationSectionWise(List<Schedules> medications) {
    morningMedicationList.clear();
    afternoonMedicationList.clear();
    eveningMedicationList.clear();
    nightMedicationList.clear();

    _key = GlobalKey(debugLabel: medications.elementAt(0).drugName);
    globalKeyName = medications.elementAt(0).drugName;
    initTargets();

    medications.forEach((currentMedication) {
      if (currentMedication.details
          .toUpperCase()
          .contains('Morning'.toUpperCase())) {
        debugPrint(
            'Medication ==> ${currentMedication.drugName} ${currentMedication.details} ${currentMedication.status}');
        if (currentMedication.status == 'Unknown' ||
            currentMedication.status == 'Upcoming' ||
            currentMedication.status == 'Overdue') {
          morningMedicationList.add(currentMedication);
        }
      } else if (currentMedication.details
          .toUpperCase()
          .contains('Afternoon'.toUpperCase())) {
        if (currentMedication.status == 'Unknown' ||
            currentMedication.status == 'Upcoming' ||
            currentMedication.status == 'Overdue') {
          afternoonMedicationList.add(currentMedication);
        }
      } else if (currentMedication.details
          .toUpperCase()
          .contains('Evening'.toUpperCase())) {
        if (currentMedication.status == 'Unknown' ||
            currentMedication.status == 'Upcoming' ||
            currentMedication.status == 'Overdue') {
          eveningMedicationList.add(currentMedication);
        }
      } else if (currentMedication.details
          .toUpperCase()
          .contains('Night'.toUpperCase())) {
        if (currentMedication.status == 'Unknown' ||
            currentMedication.status == 'Upcoming' ||
            currentMedication.status == 'Overdue') {
          nightMedicationList.add(currentMedication);
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: model.busy
              ? Center(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                )
              : (morningMedicationList.isEmpty &&
                      afternoonMedicationList.isEmpty &&
                      eveningMedicationList.isEmpty &&
              nightMedicationList.isEmpty
                  ? noMedicationFound()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (morningMedicationList.isNotEmpty)
                            medicationTimeWiseSection(
                                'Morning',
                                'res/images/ic_sunrise.png',
                                morningMedicationList)
                          else
                            Container(),
                          const SizedBox(
                            height: 0,
                          ),
                          if (afternoonMedicationList.isNotEmpty)
                            medicationTimeWiseSection(
                                'Afternoon',
                                'res/images/ic_sun.png',
                                afternoonMedicationList)
                          else
                            Container(),
                          const SizedBox(
                            height: 0,
                          ),
                          if (eveningMedicationList.isNotEmpty)
                            medicationTimeWiseSection(
                                'Evening',
                                'res/images/ic_sunset.png',
                                eveningMedicationList)
                          else
                            Container(),
                          const SizedBox(
                            height: 0,
                          ),
                          if (nightMedicationList.isNotEmpty)
                            medicationTimeWiseSection('Night',
                                'res/images/ic_night.png', nightMedicationList)
                          else
                            Container(),
                          SizedBox(
                            height: 48,
                          )
                        ],
                      ),
                    )),
        ),
      ),
    );
  }

  Widget medicationTimeWiseSection(
      String tittle, String imagePath, List<Schedules> medications) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: [
          Container(
            height: 32,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: primaryColor,
              /*borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0)),*/
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Image.asset(imagePath, width: 24, height: 24),
                SizedBox(width: 8),
                Text(tittle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat')),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: colorF6F6FF,
            child: listWidget(medications, tittle),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget noMedicationFound() {
    debugPrint('No Medication');
    return Container(
      child: Center(
        child: Text('No medication for today',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: primaryColor)),
      ),
    );
  }

  Widget listWidget(
    List<Schedules> medications,
    String tittle,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(_layout);
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: ListView.separated(
          itemBuilder: (context, index) =>
              _makeMedicineSwipeCard(context, index, medications, tittle),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 0,
            );
          },
          physics: NeverScrollableScrollPhysics(),
          itemCount: medications.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  bool alreadyAssign = false;

  Widget _makeMedicineSwipeCard(
    BuildContext context,
    int index,
    List<Schedules> medications,
    String tittle,
  ) {
    final Schedules medication = medications.elementAt(index);
    Key _localKey = Key(medication.drugName);

    if (globalKeyName == medication.drugName && !alreadyAssign) {
      _localKey = _key;
      alreadyAssign = true;
    }

    return Dismissible(
      key: _localKey,
      child: ListTile(
        /*leading:SizedBox( height: 40, width: 16, child: CachedNetworkImage(
          imageUrl: symptomTypes.publicImageUrl,
        ),),*/
        title: Semantics(
          label: tittle +
              " " +
              medication.drugName +
              " swipe right for not taken or left for taken",
          child: ExcludeSemantics(
            child: Text(
              '        ' + medication.drugName,
              style: TextStyle(
                  fontSize: 14.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        tileColor: index.isEven ? primaryLightColor : colorF6F6FF,
      ),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          markMedicationsAsTaken(medication.id);
          setState(() {
            if (medication.details.contains('Morning')) {
              morningMedicationList.removeAt(index);
            } else if (medication.details.contains('Afternoon')) {
              afternoonMedicationList.removeAt(index);
            } else if (medication.details.contains('Evening')) {
              eveningMedicationList.removeAt(index);
            } else {
              nightMedicationList.removeAt(index);
            }
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
          markMedicationsAsMissed(medication.id);
          setState(() {
            if (medication.details.contains('Morning')) {
              morningMedicationList.removeAt(index);
            } else if (medication.details.contains('Afternoon')) {
              afternoonMedicationList.removeAt(index);
            } else if (medication.details.contains('Evening')) {
              eveningMedicationList.removeAt(index);
            } else {
              nightMedicationList.removeAt(index);
            }
          });
        }
      },
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            Text(
              ' Taken',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.deepOrange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.close,
              color: Colors.white,
            ),
            Text(
              ' Not Taken',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  markMedicationsAsTaken(String consumptionId) async {
    try {
      //progressDialog.show();
      final BaseResponse baseResponse =
          await model.markMedicationsAsTaken(consumptionId);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        //progressDialog.hide();
        //getMyMedications();
      } else {
        //progressDialog.hide();
        showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  markMedicationsAsMissed(String consumptionId) async {
    try {
      //progressDialog.show();
      final BaseResponse baseResponse =
          await model.markMedicationsAsMissed(consumptionId);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        //progressDialog.hide();
        //getMyMedications();
      } else {
        //progressDialog.hide();
        showToast(baseResponse.message, context);
      }
    } catch (CustomException) {
      //progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
