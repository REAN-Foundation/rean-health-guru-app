
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
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
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

import 'home_view.dart';

class SuccessfullySetupCarePlanView extends StatefulWidget {
  @override
  _SuccessfullySetupCarePlanViewState createState() => _SuccessfullySetupCarePlanViewState();
}

class _SuccessfullySetupCarePlanViewState extends State<SuccessfullySetupCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String dob = "";
  String unformatedDOB = "";
  var dateFormat = DateFormat("dd MMM, yyyy");

  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  StartCarePlanResponse startCarePlanResponse;

  /*loadSharedPrefrance() async {
    try {
      startCarePlanResponse = StartCarePlanResponse.fromJson(await _sharedPrefUtils.read("CarePlan"));
      debugPrint("AHA Care Plan id ${startCarePlanResponse.data.carePlan.id.toString()}");
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }*/

  @override
  void initState()  {
    //loadSharedPrefrance();
    startCarePlanResponse = startCarePlanResponseGlob;
    // TODO: implement initState
    super.initState();
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
                  startCarePlanResponse.data.carePlan.carePlanCode,
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Plan ID: '+startCarePlanResponse.data.carePlan.displayId,
                            style: TextStyle(fontWeight: FontWeight.w700, color: primaryColor),
                          ),
                          Image.asset(
                            'res/images/ic_check_blue_circe.png',
                            width: 80,
                            height: 80,
                          ),
                          Text(
                            'Done!',
                            style: TextStyle(fontWeight: FontWeight.w700, color: textBlack, fontSize: 16),
                          ),
                          Text(
                            'You have successfully set up your\n'+startCarePlanResponse.data.carePlan.carePlanName,
                            style: TextStyle(fontWeight: FontWeight.w700, color: textBlack, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),

                          Text(
                            startCarePlanResponse.message,
                            style: TextStyle(fontWeight: FontWeight.w300, color: textBlack, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),


                        ],
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
                      child: Text("Let's get familiar with your plan",
                        style: TextStyle(color: textBlack, fontWeight: FontWeight.w700),),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [


                        InkWell(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                                  return HomeView( 0 );
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
                            padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(color: primaryColor, width: 1),
                                color: Colors.deepPurple,),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_ios, color: Colors.deepPurple, size: 16,),
                                Text(
                                  'Done',
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
                                ),
                                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                              ],
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
    );
  }


}
