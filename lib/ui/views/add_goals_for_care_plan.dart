import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/addNewGoals/add_blood_presure_goals_for_care_plan.dart';
import 'package:paitent/ui/views/addNewGoals/add_glucose_level_goals_for_care_plan.dart';
import 'package:paitent/ui/views/base_widget.dart';

import 'addNewGoals/add_cholesterol_goals_for_care_plan.dart';
import 'addNewGoals/add_nutrition_goals_for_care_plan.dart';
import 'addNewGoals/add_physical_activity_goals_for_care_plan.dart';
import 'addNewGoals/add_quit_smoking_goals_for_care_plan.dart';
import 'addNewGoals/add_weight_goals_for_care_plan.dart';

class AddGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddGoalsForCarePlanViewState createState() =>
      _AddGoalsForCarePlanViewState();
}

class _AddGoalsForCarePlanViewState extends State<AddGoalsForCarePlanView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedGoal = 'Blood Pressure';

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (selectedGoal) {
      case 'Blood Pressure':
        screen = AddBloodPresureeGoalsForCarePlanView();
        break;
      case 'Cholesterol':
        screen = AddCholesterolGoalsForCarePlanView();
        break;
      case 'Physical Activity':
        screen = AddPhysicalActivityGoalsForCarePlanView();
        break;
      case 'Quit Smoking':
        screen = AddQuitSmokingGoalsForCarePlanView();
        break;
      case 'Glucose Level':
        screen = AddGlucoseLevelGoalsForCarePlanView();
        break;
      case 'Nutrition':
        screen = AddNutritionGoalsForCarePlanView();
        break;
      case 'Weight':
        screen = AddWeightGoalsForCarePlanView();
        break;
    }

    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Semantics(
              label: 'add new goals for care plan',
              readOnly: true,
              child: Text(
                'Add New Goals',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w600),
              ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  selectGoalForCarePlanDropDown(),
                  Container(
                    child: screen,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectGoalForCarePlanDropDown() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Select and set goal',
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: colorF6F6FF),
            child: Semantics(
              hint: 'Drop down button',
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  'Select Care Plan',
                  style: TextStyle(
                      color: textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Blood Pressure',
                    child: Text(
                      'Blood Pressure',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Cholesterol',
                    child: Text(
                      'Cholesterol',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Physical Activity',
                    child: Text(
                      'Physical Activity',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Quit Smoking',
                    child: Text(
                      'Quit Smoking',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Glucose Level',
                    child: Text(
                      'Glucose Level',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Nutrition',
                    child: Text(
                      'Nutrition',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Weight',
                    child: Text(
                      'Weight',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGoal = value;
                  });
                },
                value: selectedGoal == '' ? null : selectedGoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
