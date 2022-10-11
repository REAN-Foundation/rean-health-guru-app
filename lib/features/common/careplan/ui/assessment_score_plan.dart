import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/features/common/careplan/models/AssessmentScore.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  Widget _getRadialGauge() {
    return Semantics(
        label: 'Assessment Score ',
        value: score,
      child: SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 4500,
          /*title: GaugeTitle(
              text: 'Assessment Score \n',
              textStyle:
              const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),*/
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
              GaugeRange(
                  label: 'Poor',
                  startValue: 0,
                  endValue: 25,
                  color: Colors.red,
                  rangeOffset: -10,
                  startWidth: 20,
                  endWidth: 20),
              GaugeRange(
                  label: 'Fair',
                  startValue: 25,
                  endValue: 50,
                  color: Colors.yellow,
                  rangeOffset: -10,
                  startWidth: 20,
                  endWidth: 20),
              GaugeRange(
                  label: 'Good',
                  startValue: 50,
                  endValue: 75,
                  color: Colors.lightGreen,
                  rangeOffset: -10,
                  startWidth: 20,
                  endWidth: 20),
              GaugeRange(
                  label: 'Excellent',
                  startValue: 75,
                  endValue: 100,
                  color: Colors.green,
                  rangeOffset: -10,
                  startWidth: 20,
                  endWidth: 20)
            ], pointers: <GaugePointer>[
              NeedlePointer(value: double.parse(score))
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text(score,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold))),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ]),
    );
  }

  Widget _getGauge() {
      return _getRadialGauge();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            brightness: Brightness.dark,
            title: Text(
              'Assessment Score',
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
                          : SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: _getGauge(),
                                  ),
                                  /*Semantics(
                                    label: 'Success image',
                                    image: true,
                                    child: Image.asset(
                                      'res/images/ic_careplan_success_tumbs_up.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      'Scores are scaled 0-100, where 0 denotes the lowest reportable health status and 100 the highest.',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      'Your sense of well-being and satisfaction with medical care. Higher score means better quality of life.',
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
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),),
    );
  }

  Future<bool> _onWillPop() async {
     Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
     return true;
  }

}
