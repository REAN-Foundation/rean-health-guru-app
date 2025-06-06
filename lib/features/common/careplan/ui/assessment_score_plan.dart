import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient/features/common/careplan/models/AssessmentScore.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/features/misc/ui/pdf_viewer.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
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
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  late ProgressDialog progressDialog;
  AssessmentScore? assessmentScore;
  String score = '0';
  String displayScore = '0';
  String? _api_key = '';
  String reportUrl = '';

  getAssessmentScore() async {
    try {
      assessmentScore =
          await model.getAssessmentScore(widget.taskId.toString());

      if (assessmentScore!.status == 'success') {
        displayScore = double.parse(assessmentScore!.data!.score!.overallSummaryScore!.toStringAsFixed(2)).roundToDouble().toString();
        score = assessmentScore!.data!.score!.overallSummaryScore!.toStringAsFixed(2);
        debugPrint('Assessment Score ==> $score');
        debugPrint('Assessment Display Score ==> $displayScore');
        debugPrint('Assessment ReportURL ==> ${assessmentScore!.data!.reportURL}');
        reportUrl = assessmentScore!.data!.reportURL.toString();

      } else {
        if(Navigator.canPop(context)){
          showToast(assessmentScore!.message.toString(),context);
          Navigator.pop(context);
        }
      }
      setState(() {
      });
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  @override
  void initState() {
    _api_key = dotenv.env['Patient_API_KEY'];
    progressDialog = ProgressDialog(context: context);
    getAssessmentScore();
    super.initState();
  }

  Widget _getRadialGauge() {
    return Semantics(
        label: 'Assessment Score ',
        //value: score,
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
                      child: Text(double.parse(displayScore).toStringAsFixed(0),
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
        child: PopScope(
          onPopInvokedWithResult: _onWillPop,
          child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
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
                          : Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 30,),
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
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text(
                                        'Scores are scaled 0-100, where 0 denotes the lowest reportable health status and 100 the highest.',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Your sense of well-being and satisfaction with medical care. Higher score means better quality of life.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Montserrat",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10.0)),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(builder: (context) {
                                                  return HomeView(1);
                                                }), (Route<dynamic> route) => false);
                                              },
                                              child: Container(
                                                height: 48,
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
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                progressDialog.show(
                                                    max: 100, msg: 'Loading...', barrierDismissible: false);
                                                 createFileOfPdfUrl(reportUrl, 'assessment_score.pdf')
                                                  /*.then((f) {
                                                progressDialog.close();
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PDFScreen(f.path)));
                                              })*/;
                                              },
                                              child: Container(
                                                height: 48,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(6.0),
                                                    border: Border.all(
                                                        color: primaryColor, width: 1),
                                                    color: Colors.white),
                                                child: Center(
                                                  child: Text(
                                                    'View report',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: primaryColor,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      height: 20,
                                    ),
                                  ],
                                ),
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

    Future<void> createFileOfPdfUrl(String url, String? fileName) async {

    //debugPrint('Base Url ==> ${url}');
    //final url = "http://africau.edu/images/default/sample.pdf";
    //final url = "https://www.lalpathlabs.com/SampleReports/Z614.pdf";
    //final filename = url.substring(url.lastIndexOf("/") + 1);
    final map = <String, String>{};
    //map["enc"] = "multipart/form-data";
    map['Authorization'] = 'Bearer ' + auth!;

    final request = await HttpClient().getUrl(Uri.parse(url));
    request.headers.add('Authorization', 'Bearer ' + auth!);
    request.headers.add('x-api-key', _api_key!);
    final response = await request.close();

    debugPrint('Base Url ==> ${request.uri}');
    debugPrint('Headers ==> ${request.headers.toString()}');
    debugPrint('Response Status ==> ${response.statusCode}');
    File file;
    if(response.statusCode == 200) {
      final bytes = await consolidateHttpClientResponseBytes(response);
      final String dir = (await getApplicationDocumentsDirectory()).path;
      file = File('$dir/$fileName');
      await file.writeAsBytes(bytes);
      progressDialog.close();
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  PDFScreen(file.path, '')));
    }else{
      progressDialog.close();
      showToast('Unable to view report, Please try again later.', context);
    }
  }

  Future<bool> _onWillPop(bool didPop, Object? result) async {
     Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
     return true;
  }

}
