
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/assesment_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class AssessmentStartCarePlanView extends StatefulWidget {
  Next? next;

  AssessmentStartCarePlanView(nextQue) {
    next = nextQue;
  }

  @override
  _AssessmentStartCarePlanViewState createState() =>
      _AssessmentStartCarePlanViewState();
}

class _AssessmentStartCarePlanViewState
    extends State<AssessmentStartCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'ONE';

  // Group Value for Radio Button.
  int id = 1;

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
              'Assessment',
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
    return SingleChildScrollView(
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
                widget.next!.title!,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.left,
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
                    Navigator.pop(context, true);
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
                      child: Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
                    Navigator.pop(context, false);
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
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
              'How much water do you drink during the day?',
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
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
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = '3 to 5 litres';
                    id = 1;
                  });
                },
              ),
              Text(
                '3 to 5 litres',
                style: TextStyle(fontSize: 17.0),
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
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = 'less than 3 litres';
                    id = 2;
                  });
                },
              ),
              Text(
                'less than 3 litres',
                style: TextStyle(fontSize: 17.0),
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
                onChanged: (dynamic val) {
                  setState(() {
                    radioButtonItem = '5 litres or more';
                    id = 3;
                  });
                },
              ),
              Text(
                '5 litres or more',
                style: TextStyle(fontSize: 17.0),
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

}
