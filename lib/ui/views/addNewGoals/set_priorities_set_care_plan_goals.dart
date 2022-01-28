import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetGoalPriorities.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SetPrioritiesGoalsForCarePlanView extends StatefulWidget {
  @override
  _SetPrioritiesGoalsForCarePlanViewState createState() =>
      _SetPrioritiesGoalsForCarePlanViewState();
}

class _SetPrioritiesGoalsForCarePlanViewState
    extends State<SetPrioritiesGoalsForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedPrimaryGoal = '';
  String selectedSecondaryGoal = '';
  List<DropdownMenuItem<String>> _carePlanMenuItems;
  String selectedCarePlan = '';
  GetGoalPriorities _getGoalPriorities;
  ProgressDialog progressDialog;

  @override
  void initState() {
    model.setBusy(true);
    getGoalsPriority();
    super.initState();
  }

  getGoalsPriority() async {
    try {
      _getGoalPriorities = await model.getGoalsPriority(
          startCarePlanResponseGlob.data.carePlan.id.toString());

      if (_getGoalPriorities.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_getGoalPriorities.toJson()}');

        _carePlanMenuItems =
            buildDropDownMenuItemsForCarePlan(_getGoalPriorities.data.goals);
      } else {
        showToast(_getGoalPriorities.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItemsForCarePlan(
      List<String> list) {
    final List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < list.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(list.elementAt(i)),
        value: list.elementAt(i),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
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
                    height: 48,
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
                '1',
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

  Widget priorityDetails() {
    return Container(
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
                color: textBlack, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "So Let's start!",
            style: TextStyle(
                color: textBlack, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Primary',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
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
                'Select Primary Goal',
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
            'Secondary',
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
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
                'Select Secondary Goal',
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
              value: selectedSecondaryGoal == '' ? null : selectedSecondaryGoal,
            ),
          )
        ],
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
              if (selectedPrimaryGoal == selectedSecondaryGoal) {
                showToast('Please select different secondary goal', context);
              } else {
                setPriorityGoal();
              }

              //Navigator.pushNamed(context, RoutePaths.Select_Goals_Care_Plan);
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

  setPriorityGoal() async {
    try {
      progressDialog.show();
      final map = <String, dynamic>{};
      map['Primary'] = selectedPrimaryGoal;
      map['Secondary'] = selectedSecondaryGoal;

      final body = <String, dynamic>{};
      body['Priorities'] = map;

      final BaseResponse baseResponse = await model.setGoalsPriority(
          startCarePlanResponseGlob.data.carePlan.id.toString(), body);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pushNamed(context, RoutePaths.Select_Goals_Care_Plan);
      } else {
        progressDialog.hide();
        showToast(baseResponse.message, context);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
