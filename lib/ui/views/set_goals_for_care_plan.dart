
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class SetGoalPlanCarePlanView extends StatefulWidget {


  @override
  _SetGoalPlanCarePlanViewState createState() => _SetGoalPlanCarePlanViewState();
}

class _SetGoalPlanCarePlanViewState extends State<SetGoalPlanCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


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
                  'Set Care Plan Goals',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    allGoals(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            //Navigator.of(context).pop();
                            Navigator.pushNamed(context, RoutePaths.Approve_Doctor_Goals_Care_Plan);
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
                                  "Done",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.Add_Goals_Care_Plan);
                },
                child: Icon(Icons.add),
              ),
            ),
          ),
    );
  }


  Widget allGoals(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You can add your time-bound measurable goals around Life's Simple 7 as defined by the American Heart Association. These are 7 risk factors that people can improve through lifestyle changes to help achieve ideal cardiovascular health.",
                style: TextStyle(color: textBlack, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 32,),
              cholesterolGoal(),
              SizedBox(height: 16,),
              physicalActivityGoal(),
              SizedBox(height: 16,),
              weightBmiGoal(),
            ],
          ),
      ),
    );

  }


  Widget cholesterolGoal(){
    return Container(
        height: 140,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: colorF6F6FF,
                  border: Border.all(color: primaryLightColor),
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Cholesterol",
                        style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "December 25, 2020",
                          style: TextStyle( color: primaryColor,fontSize: 12, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8,),
                        Icon(Icons.edit, color: primaryColor, size: 24,),
                        SizedBox(width: 8,),
                        Icon(Icons.delete, color: primaryColor, size: 24,),
                      ],
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "LDL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "<   100 mg/dL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "HDL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    ">   45 mg/dL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "<   170 mg/dL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Triglycerides",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    ">   150 mg/dL",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget physicalActivityGoal(){
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: colorF6F6FF,
                  border: Border.all(color: primaryLightColor),
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Physical Activity",
                        style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "December 25, 2020",
                          style: TextStyle( color: primaryColor,fontSize: 12, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8,),
                        Icon(Icons.edit, color: primaryColor, size: 24,),
                        SizedBox(width: 8,),
                        Icon(Icons.delete, color: primaryColor, size: 24,),
                      ],
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width : 120,
                    child: Text(
                      "Yoga",
                      style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Text(
                    "30 min",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "6:00 PM",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "Daily",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width : 120,
                    child: Text(
                      "Brisk walking",
                      style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Text(
                    "20 min",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "6:30 PM",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "Daily",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget weightBmiGoal(){
    return Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: colorF6F6FF,
                  border: Border.all(color: primaryLightColor),
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Weight / BMI",
                        style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "December 25, 2020",
                          style: TextStyle( color: primaryColor,fontSize: 12, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8,),
                        Icon(Icons.edit, color: primaryColor, size: 24,),
                        SizedBox(width: 8,),
                        Icon(Icons.delete, color: primaryColor, size: 24,),
                      ],
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Weight",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "82 Kg  BMI 27.5",
                    style: TextStyle( color: textBlack,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}
