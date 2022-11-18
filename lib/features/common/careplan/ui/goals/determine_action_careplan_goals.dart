
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/get_action_plan_list.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';

class DeterminActionPlansForCarePlanView extends StatefulWidget {
  @override
  _DeterminActionPlansForCarePlanViewState createState() =>
      _DeterminActionPlansForCarePlanViewState();
}

class _DeterminActionPlansForCarePlanViewState
    extends State<DeterminActionPlansForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ActionPlans> list = <ActionPlans>[];

  @override
  void initState() {
    model.setBusy(true);
    triggerApiCall();
    super.initState();
  }

  triggerApiCall() {
    for (int i = 0; i < createdGoalsIds.length; i++) {
      getActionOfGoalPlanApi(createdGoalsIds[i]);
    }
  }

  getActionOfGoalPlanApi(String goalIds) async {
    try {
      GetActionPlanList response = await model.getActionOfGoalPlan(goalIds);
      if (response.status == 'success') {
        debugPrint('AHA Care Plan ==> ${response.toJson()}');
        list.addAll(response.data!.actionPlans as List<ActionPlans>);
      } else {
        showToast(response.message!, context);
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
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Set Action for Goals',
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
                '3',
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
            'Determine Your Action Plan',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget behaviouralGoal() {
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
                value: list[index].isChecked,
                title: Text(list[index].title.toString()),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? val) {
                  list[index].isCheck = true;
                  setState(() {});
                  setActionPlan(list[index]);
                  /*behaviouralGoalItemChange(val, index);*/
                });
          }),
    );
  }

  setActionPlan(ActionPlans actionPlans) async {
    try {
      final body = <String, dynamic>{};
      body['Source'] = 'Self';
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
      body['GoalId'] = actionPlans.goalId;
      body['Title'] = actionPlans.title;

      final BaseResponse baseResponse = await model.createActionPlan(body);

      if (baseResponse.status == 'success') {
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  Widget submitButton() {
    return InkWell(
      onTap: () {
        completeMessageTaskOfAHACarePlan();
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Done',
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

  completeMessageTaskOfAHACarePlan() async {
    try {
      final BaseResponse response =
          await model.finishUserTask(getTask().action!.userTaskId.toString());

      if (response.status == 'success') {
        showToast('Task completed successfully!', context);
        assrotedUICount = 0;
        showSuccessDialog();
      } else {
        showToast(response.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  showSuccessDialog() {
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 380.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              label: 'Success image',
              image: true,
              child: Image.asset(
                'res/images/ic_careplan_success_tumbs_up.png',
                width: 200,
                height: 200,
              ),
            ),
            Text(
              'Thank You!',
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
                'Goals setup successfully',
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
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return HomeView(1);
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
                    'Go to my tasks',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
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
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => sucsessDialog);
  }
}
