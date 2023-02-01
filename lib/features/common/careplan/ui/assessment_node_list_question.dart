
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/assesment_response.dart';
import 'package:patient/features/common/careplan/models/start_assessment_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

//ignore: must_be_immutable
class AssessmentNodeListQuestionView extends StatefulWidget {
  Next? assesment;

  AssessmentNodeListQuestionView(assesmentC) {
    assesment = assesmentC;
  }

  @override
  _AssessmentNodeListQuestionViewState createState() =>
      _AssessmentNodeListQuestionViewState();
}

class _AssessmentNodeListQuestionViewState
    extends State<AssessmentNodeListQuestionView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Default Radio Button Selected Item When App Questions.

  Map<String, bool> numbers = {
    'Chest pain, or pain in your jaw,\nshoulder or arm': false,
    'New or worsening shortness of\nbreath': false,
    'Dizziness or lightheadedness or\nloss of consciousness': false,
    'Pain in your legs when you walk': false,
    'Extreme fatigue': false,
    'Dry or frequent hacking cough': false,
  };

  var nodeAnswer = <int>[];

  @override
  void initState() {
    for (int i = 0; i < widget.assesment!.childrenQuestions!.length; i++) {
      nodeAnswer.insert(i, 0);
    }

    super.initState();
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
                      child: quizQuestionOne(),
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

  Widget quizQuestionOne() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.assesment!.title.toString(),
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: widget.assesment!.childrenQuestions!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _makeAQuestionBlock(
                        widget.assesment!.childrenQuestions!.elementAt(index),
                        index);
                  }),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Semantics(
            label: 'Next',
            button: true,
            child: ExcludeSemantics(
              child: InkWell(
                onTap: () {
                  //Navigator.pushNamed(context, RoutePaths.Assessment_Question_Two_Care_Plan);
                  bool vaildation = false;
                  for (int i = 0;
                      i < widget.assesment!.childrenQuestions!.length;
                      i++) {
                    if (nodeAnswer[i] == 0) {
                      vaildation = true;
                    }
                  }

                  if (vaildation) {
                    showToast('Please answer all the question.', context);
                  } else {
                    debugPrint('Node List ==> ${nodeAnswer.length}');
                    Navigator.pop(context, nodeAnswer);
                  }
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
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _makeAQuestionBlock(ChildrenQuestions childrenQuestions, int index) {
    var childAnswer = <Answer>[];
    for (int i = 0; i < childrenQuestions.options!.length; i++) {
      childAnswer.add(Answer(
          childrenQuestions.options!.elementAt(i).sequence as int,
          childrenQuestions.options!.elementAt(i).text.toString()));
    }

    // Default Radio Button Item
    //String radioItem = '';

    // Group Value for Radio Button.
    int id = 1;

    return Card(
      elevation: 0,
      semanticContainer: false,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text(
                  String.fromCharCode(97 + index).toString() + '. ',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                ),*/
                Expanded(
                  child: Text(
                    childrenQuestions.title.toString(),
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childAnswer
                    .map((data) => RadioListTile(
                          title: Text(data.text),
                          groupValue: nodeAnswer[index],
                          value: data.index,
                          onChanged: (dynamic val) {
                            setState(() {
                              //radioItem = data.text;
                              id = data.index;
                              /*for(int i = 0 ; i < nodeAnswer.length ; i++){
                        if(nodeAnswer.elementAt(i) == index){
                          nodeAnswer.remove(i);
                        }
                      }*/
                              nodeAnswer.insert(index, id);

                              debugPrint(
                                  'Select Answer ==>  $id  Node List Answer ==> ${nodeAnswer[index]}');
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
