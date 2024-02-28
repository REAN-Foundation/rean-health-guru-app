
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/create_goal_response.dart';
import 'package:patient/features/common/careplan/models/create_health_priority_response.dart';
import 'package:patient/features/common/careplan/models/get_goals_by_priority.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class SelectGoalsForCarePlanView extends StatefulWidget {
  CreateHealthPriorityResponse? createHealthPriorityResponse;

  SelectGoalsForCarePlanView(this.createHealthPriorityResponse);

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
  late ProgressDialog progressDialog;
  List<Goals> goals = <Goals>[];
  var scrollController = ScrollController();

  @override
  void initState() {
    model.setBusy(true);
    getBiometricGoal();
    super.initState();
  }

  getBiometricGoal() async {
    try {
      GetGoalsByPriority _getGoalsByPriority = await model.getAllGoal(widget
          .createHealthPriorityResponse!.data!.healthPriority!.id
          .toString());

      if (_getGoalsByPriority.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_getGoalsByPriority.toJson()}');
        goals.addAll(_getGoalsByPriority.data!.goals as List<Goals>);
      } else {
        showToast(_getGoalsByPriority.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Goal',
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
                      padding: const EdgeInsets.all(0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: body(),
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

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: model.busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                currentScreenCount(),
                /*const SizedBox(
                height: 16,
              ),
              Text(
                "You can add your time-bound measurable goals around Life's Simple 7 as defined by the American Heart Association.",
                style: TextStyle(
                    color: textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),*/
                const SizedBox(
                  height: 16,
                ),
                behaviouralGoal(),
                const SizedBox(
                  height: 16,
                ),
                submitButton(),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
    );
  }

  Widget currentScreenCount() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: primaryLightColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 32,
            width: 32,
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
                  fontSize: 18,
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
            'Set Goals',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget behaviouralGoal() {
    return Expanded(
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView.builder(
            itemCount: goals.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                  value: goals[index].isChecked,
                  title: Text(goals[index].title.toString()),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? val) {
                    goals[index].isCheck = val;
                    setState(() {});
                    //setPriorityGoal(goals[index]);
                    /*behaviouralGoalItemChange(val, index);*/
                  });
            }),
      ),
    );
  }

  createPriorityGoal(){
    bool isSelected = false;
    goals.forEach((element) {
      if(element.isCheck!){
        setPriorityGoal(element);
        isSelected = true;
      }
    });

    if(isSelected){
      Navigator.pushNamed(
          context, RoutePaths.Determine_Action_For_Care_Plan);
    }else{
      showToast('Please select atleast one goal.', context);
    }

  }

  Widget submitButton() {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () {
              createPriorityGoal();
            },
            child: Container(
              height: 40,
              width: 120,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: primaryColor, width: 1),
                color: primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          );
  }

  setPriorityGoal(Goals goal) async {
    try {
      final body = <String, dynamic>{};
      body['HealthPriorityId'] = widget
          .createHealthPriorityResponse!.data!.healthPriority!.id
          .toString();
      body['Source'] = 'Careplan';
      body['Provider'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .provider
          .toString();
      body['ProviderEnrollmentId'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .enrollmentId
          .toString();
      body['ProviderCareplanCode'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .planCode
          .toString();
      body['ProviderCareplanName'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .planName
          .toString();
      body['PatientUserId'] = patientUserId;
      body['Sequence'] = goal.sequence;
      body['Title'] = goal.title;
      body['GoalAchieved'] = false;
      body['GoalAbandoned'] = false;

      final CreateGoalResponse baseResponse = await model.createGoal(body);

      if (baseResponse.status == 'success') {
        createdGoalsIds.add(baseResponse.data!.goal!.id.toString());
        debugPrint('CreatedGoalsIds size ==> ${createdGoalsIds.length}');
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
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
