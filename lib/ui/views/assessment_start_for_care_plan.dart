import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paitent/core/models/StartAssesmentResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

class AssessmentStartCarePlanView extends StatefulWidget {
  Assessmment assesment;

  AssessmentStartCarePlanView(Assessmment assesmentC) {
    this.assesment = assesmentC;
  }

  @override
  _AssessmentStartCarePlanViewState createState() =>
      _AssessmentStartCarePlanViewState();
}

class _AssessmentStartCarePlanViewState
    extends State<AssessmentStartCarePlanView> {
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
      builder: (context, model, child) => Container(
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
                SizedBox(
                  height: 40,
                ),
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

  Widget quizQuestionOne() {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: colorF6F6FF,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.assesment.question.questionText,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      height: 60,
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      child: Center(
                        child: Icon(FontAwesomeIcons.smile, size: 42, color: primaryColor,),
                      )
                  ),
                ),
                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      height: 60,
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      child: Center(
                        child: Icon(FontAwesomeIcons.sadTear, size: 42, color: primaryColor,),
                      )
                  ),
                ),
              ],
            ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, 0);
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
                          "Yes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
              SizedBox(
                width: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, 1);
                    //Navigator.pushNamed(context, RoutePaths.Assessment_Question_Care_Plan);
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
                          "No",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
            ],
          ),
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
        child: TextFormField(
            obscureText: false,
            controller: _textController,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.black54,
            ),
            onFieldSubmitted: (term) {},
            decoration: InputDecoration(
                hintText: 'Describe it here...',
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true)),
      ),
    );
  }

  Widget quizQuestionTwo() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: primaryLightColor, width: 1),
        color: colorF6F6FF,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "How much water do you drink during the day?",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
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
              SizedBox(
                width: 40,
              ),
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
              SizedBox(
                width: 40,
              ),
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
              SizedBox(
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: colorF6F6FF,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Great!',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Icon(
                FontAwesomeIcons.solidThumbsUp,
                size: 48,
                color: primaryColor,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Let\'s keep it that way !',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
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
                          "Close",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
