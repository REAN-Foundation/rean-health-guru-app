
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/StartAssesmentResponse.dart';
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

class AssessmentQuestionCarePlanView extends StatefulWidget {

  Assessmment assesment;

  AssessmentQuestionCarePlanView(Assessmment assesmentC){
    this.assesment = assesmentC;
  }


  @override
  _AssessmentQuestionCarePlanViewState createState() => _AssessmentQuestionCarePlanViewState();
}

class _AssessmentQuestionCarePlanViewState extends State<AssessmentQuestionCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _textController = new TextEditingController();
  // Default Radio Button Selected Item When App Questions.
  var answers = new List<Answer>();

  Map<String, bool> numbers = {
    'Chest pain, or pain in your jaw,\nshoulder or arm' : false,
    'New or worsening shortness of\nbreath' : false,
    'Dizziness or lightheadedness or\nloss of consciousness' : false,
    'Pain in your legs when you walk' : false,
    'Extreme fatigue' : false,
    'Dry or frequent hacking cough' : false,
  };

  var holder_1 = [];


  getItems(){

    numbers.forEach((key, value) {
      if(value == true)
      {
        holder_1.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(holder_1);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    holder_1.clear();
  }

  processAnswer(){
    for(int i = 0 ; i < widget.assesment.question.answerOptions.length ; i++){
      answers.add(new Answer(i, widget.assesment.question.answerOptions.elementAt(i)));
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processAnswer();
  }

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
                  'Assessment',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    quizQuestionOne(),
                  /*  SizedBox(height: 20,),
                    quizQuestionTwo(),*/
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // Default Radio Button Item
  String radioItem = '';

  // Group Value for Radio Button.
  int id = 1;

  Widget quizQuestionOne(){
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: colorF6F6FF,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.assesment.question.questionText,
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children:
              answers.map((data) => RadioListTile(
                title: Text("${data.text}"),
                groupValue: id,
                value: data.index,
                onChanged: (val) {
                  setState(() {
                    radioItem = data.text ;
                    id = data.index;
                  });
                },
              )).toList(),
            ),
          ),
            SizedBox(height: 32,),
            InkWell(
              onTap: (){
                //Navigator.pushNamed(context, RoutePaths.Assessment_Question_Two_Care_Plan);
                Navigator.pop(context, id);
              },
              child: Container(
                  height: 40,
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: Colors.deepPurple,),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ),
            SizedBox(height: 16,),
          ],
        ),
    );

  }
}