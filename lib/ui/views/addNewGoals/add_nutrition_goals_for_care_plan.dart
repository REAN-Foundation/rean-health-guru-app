import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

class AddNutritionGoalsForCarePlanView extends StatefulWidget {
  @override
  _AddNutritionGoalsForCarePlanViewState createState() =>
      _AddNutritionGoalsForCarePlanViewState();
}

class _AddNutritionGoalsForCarePlanViewState
    extends State<AddNutritionGoalsForCarePlanView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedGoal = '';

  final TextEditingController _goalController = TextEditingController();

  final _goalFocus = FocusNode();
  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');

  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientMedicationViewModel>(
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  addGoals(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addGoals() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Eating healthy doesn’t have to mean dieting or giving up all the foods you love. Learn how to ditch the junk, give your body the nutrient-dense fuel it needs, and love every minute of it!',
            style: TextStyle(
                color: textBlack, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){

                },
                child: Container(
                  width: 120,
                  height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.white),
                  child:  Center(
                    child: Text(
                      'View more >>',
                      style: TextStyle(fontWeight: FontWeight.w700, color: primaryColor, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'I Will Avoid Processed Foods',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
              Switch(
                value: switch1,
                onChanged: (value) {
                  setState(() {
                    switch1 = value;
                    print(switch1);
                  });
                },
                activeTrackColor: primaryLightColor,
                activeColor: primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'I Will Avoid Added Sugar',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
              Switch(
                value: switch2,
                onChanged: (value) {
                  setState(() {
                    switch2 = value;
                    print(switch2);
                  });
                },
                activeTrackColor: primaryLightColor,
                activeColor: primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'I Will Avoid Added Salt',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
              Switch(
                value: switch3,
                onChanged: (value) {
                  setState(() {
                    switch3 = value;
                    print(switch3);
                  });
                },
                activeTrackColor: primaryLightColor,
                activeColor: primaryColor,
              ),
            ],
          ),
          RichText(
            text: TextSpan(
                text: 'My Own Custom Nutrition / Dietary Goal',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: '  ',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.italic)),
                ]),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: TextFormField(
                controller: _goalController,
                focusNode: _goalFocus,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                onFieldSubmitted: (term) {},
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
                text: '* I will take boiled greens and fish twice a week.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                      text: '  ',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.italic)),
                ]),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.pushNamed(context, RoutePaths.Home);
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
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
