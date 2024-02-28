
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/careplan/models/create_health_priority_response.dart';
import 'package:patient/features/common/careplan/models/get_goal_priorities.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SetPrioritiesGoalsForCarePlanView extends StatefulWidget {
  @override
  _SetPrioritiesGoalsForCarePlanViewState createState() =>
      _SetPrioritiesGoalsForCarePlanViewState();
}

class _SetPrioritiesGoalsForCarePlanViewState
    extends State<SetPrioritiesGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedPrimaryGoal = '';
  String? selectedSecondaryGoal = '';
  List<DropdownMenuItem<String>>? _carePlanMenuItems;
  String selectedCarePlan = '';
  late GetGoalPriorities _getGoalPriorities;
  late ProgressDialog progressDialog;

  @override
  void initState() {
    model.setBusy(true);
    getGoalsPriority();
    super.initState();
  }

  getGoalsPriority() async {
    try {
      _getGoalPriorities = await model.getGoalsPriority(
        carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
            .elementAt(0)
            .enrollmentId
            .toString(),
          carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
              .elementAt(0)
              .planName
              .toString()
      );

      if (_getGoalPriorities.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_getGoalPriorities.toJson()}');

        _carePlanMenuItems = buildDropDownMenuItemsForCarePlan(
            _getGoalPriorities.data!.priorityTypes!);
      } else {
        showToast(_getGoalPriorities.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForCarePlan(
      List<PriorityTypes> list) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < list.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(list.elementAt(i).type.toString()),
        value: list.elementAt(i).type.toString(),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            currentScreenCount(),
            const SizedBox(
              height: 16,
            ),
            priorityDetails(),
            const SizedBox(
              height: 32,
            ),
            submitButton(),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
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
                '1',
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
            'Set Priorities',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget priorityDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select primary and secondary priority focus areas based on your conditions. This will help you in identifying focussed goals and selecting corresponding relevant actions to achieve those goals.',
              style: TextStyle(
                  color: textBlack, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "So Let's start!",
              style: TextStyle(
                  color: textBlack, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Primary*',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
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
                  'Select Primary Priority',
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                items: _carePlanMenuItems,
                onChanged: (value) {
                  setState(() {
                    selectedPrimaryGoal = value;
                  });
                },
                value: selectedPrimaryGoal == '' ? null : selectedPrimaryGoal,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Secondary*',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
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
                  'Select Secondary Priority',
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                items: _carePlanMenuItems,
                onChanged: (value) {
                  setState(() {
                    selectedSecondaryGoal = value;
                  });
                },
                value:
                    selectedSecondaryGoal == '' ? null : selectedSecondaryGoal,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget submitButton() {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () {
              if (selectedPrimaryGoal == '') {
                showToast('Please select primary priority.', context);
              } else if (selectedSecondaryGoal == '') {
                showToast('Please select secondary priority.', context);
              } else if (selectedPrimaryGoal == selectedSecondaryGoal) {
                showToast(
                    'Please select different secondary priority.', context);
              } else {
                setPriorityGoal();
              }

              //Navigator.pushNamed(context, RoutePaths.Select_Goals_Care_Plan);
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

  setPriorityGoal() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      final body = <String, dynamic>{};
      body['HealthPriorityType'] = selectedPrimaryGoal;
      body['IsPrimary'] = true;
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

      final CreateHealthPriorityResponse baseResponse =
          await model.setGoalsPriority(body);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        Navigator.pushNamed(context, RoutePaths.Select_Goals_Care_Plan,
            arguments: baseResponse);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
