import 'package:flutter/material.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/vitals/view_models/patients_vitals.dart';
import 'package:paitent/infra/themes/app_colors.dart';

import 'base_widget.dart';

class BiometricVitalsView extends StatefulWidget {
  @override
  _BiometricVitalsViewState createState() => _BiometricVitalsViewState();
}

class _BiometricVitalsViewState extends State<BiometricVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientVitalsViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Vitals',
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: MergeSemantics(
                child: Semantics(
                  label: 'button to save weight',
                  enabled: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              RoutePaths.Biometric_Weight_Vitals_Care_Plan);
                        },
                        child: Container(
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: colorF6F6FF,
                              border: Border.all(color: primaryLightColor),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Semantics(
                                    label: 'arrow helps to move to next vital',
                                    readOnly: true,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: primaryColor,
                                      size: 24,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Semantics(
                        label: 'button to save blood pressure',
                        enabled: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                RoutePaths
                                    .Biometric_Blood_Presure_Vitals_Care_Plan);
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Blood Pressure',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Semantics(
                                      label:
                                          'arrow helps to move to next vital',
                                      readOnly: true,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                        size: 24,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Semantics(
                        label: 'button to save blood glucose',
                        enabled: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                RoutePaths
                                    .Biometric_Blood_Glucose_Vitals_Care_Plan);
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Blood Glucose',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Semantics(
                                      label:
                                          'arrow helps to move to next vital',
                                      readOnly: true,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                        size: 24,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Semantics(
                        label: 'button to save blood oxygen',
                        enabled: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                RoutePaths
                                    .Biometric_Blood_Oxygen_Vitals_Care_Plan);
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Blood Oxygen Saturation',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Semantics(
                                      label:
                                          'arrow helps to move to next vital',
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                        size: 24,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Semantics(
                        label: 'button to save pulse rate',
                        enabled: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context,
                                RoutePaths.Biometric_Pulse_Vitals_Care_Plan);
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Resting Pulse Rate',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Semantics(
                                      label:
                                          'arrow helps to move to next vital',
                                      readOnly: true,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                        size: 24,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Semantics(
                        label: 'button to save body temperature',
                        enabled: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                RoutePaths
                                    .Biometric_Temperature_Vitals_Care_Plan);
                          },
                          child: Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Body Temperature',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Semantics(
                                      label:
                                          'arrow helps to move to next vital',
                                      readOnly: true,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                        size: 24,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
