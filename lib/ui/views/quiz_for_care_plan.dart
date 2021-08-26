
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/my_medication_history.dart';
import 'package:paitent/ui/views/my_medication_prescription.dart';
import 'package:paitent/ui/views/my_medication_refill.dart';
import 'package:paitent/ui/views/my_medication_remainder.dart';
import 'package:intl/intl.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'home_view.dart';

class QuizForCarePlanView extends StatefulWidget {


  @override
  _QuizForCarePlanViewState createState() => _QuizForCarePlanViewState();
}

class _QuizForCarePlanViewState extends State<QuizForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _textController = new TextEditingController();
  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'ONE';
  // Group Value for Radio Button.
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'Quiz',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40,),
                      quizQuestionOne(),
                      SizedBox(height: 20,),
                      quizQuestionTwo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }


  Widget quizQuestionOne(){
    return Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: primaryLightColor, width: 1),
          color: colorF6F6FF,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Do you still feel Angina pain?",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 40,
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.deepPurple,),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ),
                SizedBox(width: 0,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      height: 40,
                      width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.deepPurple,),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ],
            ),
            _entryField()
          ],
        ),
    );

  }

  Widget _entryField() {
    return Container(
      margin: EdgeInsets.all(16.0),
      height: 100,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        child:TextFormField(
            obscureText: false,
            controller: _textController,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: Colors.black54,),
            onFieldSubmitted: (term) {

            },
            decoration: InputDecoration(
                hintText: 'Describe it here...',
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true)),
      ),
    );
  }

  Widget quizQuestionTwo(){
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: primaryLightColor, width: 1),
        color: colorF6F6FF,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "How much water do you drink during the day?",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 1,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = '3 to 5 litres';
                    id = 1;
                  });
                },
              ),
              Text(
                '3 to 5 litres',
                style: new TextStyle(fontSize: 17.0),
              ),
              SizedBox(width: 40,),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 2,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'less than 3 litres';
                    id = 2;
                  });
                },
              ),
              Text(
                'less than 3 litres',
                style: new TextStyle(fontSize: 17.0),
              ),
              SizedBox(width: 40,),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: 3,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = '5 litres or more';
                    id = 3;
                  });
                },
              ),
              Text(
                '5 litres or more',
                style: new TextStyle(fontSize: 17.0),
              ),
              SizedBox(width: 40,),

            ],
          ),
        ],
      ),
    );

  }
}
