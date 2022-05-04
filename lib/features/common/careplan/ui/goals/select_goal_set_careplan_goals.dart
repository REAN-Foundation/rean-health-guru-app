import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/get_goal_priorities.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SelectGoalsForCarePlanView extends StatefulWidget {
  @override
  _SelectGoalsForCarePlanViewState createState() =>
      _SelectGoalsForCarePlanViewState();
}

class _SelectGoalsForCarePlanViewState
    extends State<SelectGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int id = 10;
  int id1 = 10;
  String radioButtonItem = 'ONE';
  String radioButtonItem1 = '';
  late GetGoalPriorities _getBiometricGoalPriorities;
  late GetGoalPriorities _getBehavioralGoalPriorities;
  ProgressDialog? progressDialog;
  List<CheckBoxModel> biometricGoalList = <CheckBoxModel>[];
  List<CheckBoxModel> behaviouralGoalList = <CheckBoxModel>[];

  @override
  void initState() {
    model.setBusy(true);
    getBiometricGoal();
    super.initState();
  }

  getBiometricGoal() async {
    try {
      _getBiometricGoalPriorities = await model.getBiometricGoal(
          carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
              .elementAt(0)
              .enrollmentId
              .toString());

      if (_getBiometricGoalPriorities.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_getBiometricGoalPriorities.toJson()}');

        for (int i = 0;
            i < _getBiometricGoalPriorities.data!.goals!.length;
            i++) {
          biometricGoalList.add(CheckBoxModel(
              _getBiometricGoalPriorities.data!.goals!.elementAt(i), false));
        }

        getBehavioralGoal();
      } else {
        showToast(_getBiometricGoalPriorities.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  getBehavioralGoal() async {
    try {
      _getBehavioralGoalPriorities = await model.getBehavioralGoal(
          carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
              .elementAt(0)
              .enrollmentId
              .toString());

      if (_getBehavioralGoalPriorities.status == 'success') {
        debugPrint(
            'AHA Care Plan ==> ${_getBehavioralGoalPriorities.toJson()}');
        for (int i = 0;
            i < _getBehavioralGoalPriorities.data!.goals!.length;
            i++) {
          behaviouralGoalList.add(CheckBoxModel(
              _getBehavioralGoalPriorities.data!.goals!.elementAt(i), false));
        }
      } else {
        showToast(_getBehavioralGoalPriorities.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Set Care Plan Goals',
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: model!.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        currentScreenCount(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "You can add your time-bound measurable goals around Life's Simple 7 as defined by the American Heart Association.",
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        biometricGoal(),
                        const SizedBox(
                          height: 16,
                        ),
                        behaviouralGoal(),
                        const SizedBox(
                          height: 32,
                        ),
                        submitButton(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget currentScreenCount() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                    width: 0, color: primaryColor, style: BorderStyle.solid)),
            child: Center(
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Set Priorities',
            style: TextStyle(
                color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget biometricGoal() {
    debugPrint('Biometric Goals Count = ${biometricGoalList.length}');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 230,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biometric Goals',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: biometricGoalList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                      value: biometricGoalList[index].isCheck,
                      title: Text(biometricGoalList[index].title),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? val) {
                        biometricGoalItemChange(val, index);
                      });
                }),
          ),
        ],
      ),
    );
  }

  void biometricGoalItemChange(bool? val, int index) {
    setState(() {
      biometricGoalList[index].isCheck = val;
    });
  }

  Widget behaviouralGoal() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Behavioral Goals',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: behaviouralGoalList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                          value: behaviouralGoalList[index].isCheck,
                          title: Text(behaviouralGoalList[index].title),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? val) {
                            behaviouralGoalItemChange(val, index);
                          });
                    }),
              ),
            ]));
  }

  void behaviouralGoalItemChange(bool? val, int index) {
    setState(() {
      behaviouralGoalList[index].isCheck = val;
    });
  }

  Widget submitButton() {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () {
              goalPlanScreenStack.clear();
              for (int i = 0; i < biometricGoalList.length; i++) {
                if (biometricGoalList.elementAt(i).isCheck!) {
                  goalPlanScreenStack.add(biometricGoalList.elementAt(i).title);
                }
              }

              for (int i = 0; i < behaviouralGoalList.length; i++) {
                if (behaviouralGoalList.elementAt(i).isCheck!) {
                  goalPlanScreenStack
                      .add(behaviouralGoalList.elementAt(i).title);
                }
              }

              goalPlanScreenStack.remove('Medication Adherence');
              goalPlanScreenStack.remove('Nutrition');
              navigateToScreen();
              //Navigator.pushNamed(context, RoutePaths.Determine_Action_For_Care_Plan);
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
                color: primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: primaryColor,
                    size: 16,
                  ),
                  Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
  }

  navigateToScreen() {
    debugPrint('Set Goals Plan Stack ==> ${goalPlanScreenStack.length}');
    if (goalPlanScreenStack.elementAt(0) == 'Blood Pressure') {
      Navigator.pushNamed(context, RoutePaths.ADD_BLOOD_PRESURE_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Blood Sugar') {
      Navigator.pushNamed(context, RoutePaths.ADD_GLUCOSE_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Weight') {
      Navigator.pushNamed(context, RoutePaths.ADD_WEIGHT_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Physical Activity') {
      Navigator.pushNamed(context, RoutePaths.ADD_PHYSICAL_ACTIVITY_GOALS);
    } else if (goalPlanScreenStack.elementAt(0) == 'Quit Smoking') {
      Navigator.pushNamed(context, RoutePaths.ADD_QUIT_SMOKING_GOALS);
    }
  }
}

class CheckBoxModel {
  String title;
  bool? isCheck;

  CheckBoxModel(this.title, this.isCheck);
}
