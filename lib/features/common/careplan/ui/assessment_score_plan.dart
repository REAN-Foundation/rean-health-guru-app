import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/features/common/careplan/models/AssessmentScore.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

//ignore: must_be_immutable
class AssessmentScorePlanView extends StatefulWidget {
  String? taskId;

  AssessmentScorePlanView(this.taskId);

  @override
  _AssessmentScorePlanViewState createState() =>
      _AssessmentScorePlanViewState();
}

class _AssessmentScorePlanViewState extends State<AssessmentScorePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AssessmentScore? assessmentScore;
  String score = '';

  getAssessmentScore() async {
    try {
      assessmentScore =
          await model.getAssessmentScore(widget.taskId.toString());

      if (assessmentScore!.status == 'success') {
        debugPrint('Assessment Score ==> ${assessmentScore!.toJson()}');
        score = assessmentScore!.data!.score!.overallSummaryScore!.toStringAsFixed(2);
        setState(() {
        });
      } else {}
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  @override
  void initState() {
    getAssessmentScore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            brightness: Brightness.dark,
            automaticallyImplyLeading: false,
            title: Text(
              '',
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
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: model!.busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                    'You have successfully completed your assessment',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                Text(
                                  'Assessment Score : $score',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
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
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: Border.all(
                                            color: primaryColor, width: 1),
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
