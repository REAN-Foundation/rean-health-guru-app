
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class SuccessfullySetupCarePlanView extends StatefulWidget {
  @override
  _SuccessfullySetupCarePlanViewState createState() =>
      _SuccessfullySetupCarePlanViewState();
}

class _SuccessfullySetupCarePlanViewState
    extends State<SuccessfullySetupCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');

  GetCarePlanEnrollmentForPatient? startCarePlanResponse;

  /*loadSharedPrefrance() async {
    try {
      startCarePlanResponse = StartCarePlanResponse.fromJson(await _sharedPrefUtils.read("CarePlan"));
      debugPrint("AHA Care Plan id ${startCarePlanResponse.data.carePlan.id.toString()}");
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }*/

  @override
  void initState() {
    //loadSharedPrefrance();
    startCarePlanResponse = carePlanEnrollmentForPatientGlobe;
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
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
                  .elementAt(0)
                  .enrollmentId
                  .toString(),
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
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
          body: MergeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Semantics(
                      label: 'setup a plan ID',
                      readOnly: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Plan ID: ' +
                                carePlanEnrollmentForPatientGlobe!
                                    .data!.patientEnrollments!
                                    .elementAt(0)
                                    .enrollmentId
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primaryColor),
                          ),
                          Image.asset(
                            'res/images/ic_check_blue_circle.png',
                            width: 80,
                            height: 80,
                          ),
                          Text(
                            'Done!',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textBlack,
                                fontSize: 16),
                          ),
                          Text(
                            'You have successfully set up your\n' +
                                carePlanEnrollmentForPatientGlobe!
                                    .data!.patientEnrollments!
                                    .elementAt(0)
                                    .enrollmentId
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textBlack,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            startCarePlanResponse!.message!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: textBlack,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: colorF6F6FF,
                  ),
                  child: Center(
                    child: Text(
                      "Let's get familiar with your plan",
                      style: TextStyle(
                          color: textBlack, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'return to home view',
                        button: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return HomeView(0);
                            }), (Route<dynamic> route) => false);

                            /*AssortedViewConfigs assortedViewConfigs =  new AssortedViewConfigs();
                               assortedViewConfigs.toShow = "0";
                               assortedViewConfigs.testToshow = "1";
                               assortedViewConfigs.isNextButtonVisible = true;

                                Navigator.pushNamed(
                                    context, RoutePaths.Learn_More_Care_Plan,
                                    arguments: assortedViewConfigs);
                                assrotedUICount = 1;*/
                          },
                          child: Container(
                            height: 40,
                            width: 160,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: primaryColor, width: 1),
                              color: primaryColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                Text(
                                  'Done',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
