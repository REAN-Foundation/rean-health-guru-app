

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class CommonAlerts{

  static reminderAlert({required String message, required BuildContext context}){
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24),
      //this right here
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        semanticContainer: false,
        child: Container(
          height: 280.0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                ),
                child: Center(
                  child: Container(
                    height: 80,
                    child: ExcludeSemantics(
                      child: Image.asset(
                        'res/images/ic_drawer_remainder.png',
                        color: primaryColor,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(16.0),
                child: Center(child: Text('Reminder', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w700),)),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView( scrollDirection: Axis.vertical, child: Text(message.toString(), style: TextStyle(color: textBlack, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.left,)),
              )),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Cancel health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'cancel_health_journey_button_click');
                              Navigator.pop(context);
                              Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                  Border.all(color: primaryColor, width: 1),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),*/
                    Semantics(
                      button: true,
                      label: 'Got It',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            FirebaseAnalytics.instance.logEvent(name: 'remainder_got_it_button_click');
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 48,
                            width: 160,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border:
                                Border.all(color: primaryColor, width: 1),
                                color: primaryColor),
                            child: Center(
                              child: Text(
                                'Got It!',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
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
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => sucsessDialog);
  }

  static showHealthJourneyDialog({required BuildContext context}) {
    FirebaseAnalytics.instance.logEvent(name: 'health_journey_popup_displayed');
    Dialog sucsessDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24),
      //this right here
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        semanticContainer: false,
        child: Container(
          height: 248.0,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  color: getAppType() == 'AHA' ? redLightAha : primaryLightColor,
                ),
                child: Center(
                  child: Container(
                    height: 80,
                    child: ExcludeSemantics(
                      child: Image.asset(
                        'res/images/ic_hf_care_plan.png',
                        color: primaryColor,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Text(
                'Start your health journey here',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              Padding(padding: EdgeInsets.only(top: 32.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Cancel health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'cancel_health_journey_button_click');
                              Navigator.pop(context);
                              //Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                  Border.all(color: primaryColor, width: 1),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontSize: 14),
                                ),
                              ),
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
                      child: Semantics(
                        button: true,
                        label: 'Get Started health journey',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'start_health_journey_button_click');
                              if (carePlanEnrollmentForPatientGlobe == null) {
                                Navigator.popAndPushNamed(
                                    context, RoutePaths.Select_Care_Plan);
                              } else {
                                Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                              }
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                  Border.all(color: primaryColor, width: 1),
                                  color: primaryColor),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ),
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
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => sucsessDialog);
  }

}