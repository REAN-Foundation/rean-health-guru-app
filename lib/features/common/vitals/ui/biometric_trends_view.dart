import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_glucose_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_oxygen_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_pressure_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_body_temperature_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_pulse_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_weight_vitals.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/widgets/info_screen.dart';

import '../../../misc/ui/base_widget.dart';

class BiometricTrendView extends StatefulWidget {
  @override
  _BiometricTrendViewState createState() => _BiometricTrendViewState();
}

class _BiometricTrendViewState extends State<BiometricTrendView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget loadProgress() {
    return Center(
      child: Lottie.asset('res/lottiefiles/heart_loading.json'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientVitalsViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: model!.busy
              ? loadProgress()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        for (int i = 0 ; i < RemoteConfigValues.vitalScreenTile.length ; i++)...[
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Weight')
                            weightTrends(),
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Pressure')
                            bloodPresureTrends(),
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Glucose')
                            bloodGlucoseTrends(),
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Blood Oxygen Sturation')
                            bloodOxygenSaturationTrends(),
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Pulse Rate')
                            pulseRateTrends(),
                          if(RemoteConfigValues.vitalScreenTile[i] == 'Body Temprature')
                            bodyTempratureTrends(),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget weightTrends() {
    return Card(
      elevation: 8,
      semanticContainer: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_body_weight.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Weight',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Weight Information',
                      description:
                      'Achieving and maintaining a healthy weight is beneficial in loweing your risk for heart disease and stroke. Please refer to your doctor\'s recommended healthy weight range and frequency of measuring your weight at home.',
                      height: 240),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            BiometricWeightVitalsView(false),
          ],
        ),
      ),
    );
  }

  Widget bloodPresureTrends() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_blood_pressure.png'),
                    size: 24,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Blood Pressure',
                    style: TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InfoScreen(
                        tittle: 'Blood Pressure Information',
                        description:
                        'If your blood pressure is below 120/80 mm Hg, be sure to get it checked at least once every two years, starting at age 20. If your blood pressure is higher, your doctor may want to check it more often. High blood pressure can be controlled through lifestyle changes and/or medication. \n*Normal: Less than 120/80 \n*Elevated: Systolic 120-129 AND Diastolic less than 80 \n*High Blood Pressure Stage 1: Systolic 130-139 OR Diastolic 80-89 \n*High Blood Pressure Stage 2: Systolic 140+ OR Diastolic 90+ \n*Hypertensive Crisis (Consult your doctor immediately): Systolic 180+ and/or Diastolic 120+',
                        height: 408),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              BiometricBloodPresureVitalsView(false),
            ],
          )),
    );
  }

  Widget bloodGlucoseTrends() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_blood_glucose.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blood Glucose',
                      style: TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4,),
                    Text(
                      '(Also known as blood sugar)',
                      style: TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Blood Glucose Information',
                      description:
                      'High blood glucose or "blood sugar" levels put you at greater risk of developing insulin resistance, prediabetes and type 2 diabetes. Prediabetes and Type 2 diabetes increases risk of heart disease and stroke. Blood glucose is measured through a blood test.\n\nPrediabetes: Fasting blood glucose range is 100 to 125 mg/dL\nDiabetes mellitus (Type 2 diabetes): 126 mg/dL',
                      height: 320),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BiometricBloodSugarVitalsView(false)
          ],
        ),
      ),
    );
  }

  Widget bloodOxygenSaturationTrends() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_oximeter.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Blood Oxygen Saturation',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Blood Oxygen Saturation Information',
                      description: "Pulse oximetry testing is conducted to estimate the percentage of hemoglobin in the blood that is saturated with oxygen.",
                      height: 220),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BiometricBloodOxygenVitalsView(),
          ],
        ),
      ),
    );
  }

  Widget pulseRateTrends() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_pulse.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Pulse Rate',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Pulse Rate Information',
                      description:
                          'Your heart rate, or pulse, is the number of times your heart beats per minute. Normal heart rate varies from person to person. For most of us (adults), between 60 and 100 beats per minute (bpm) is normal. ',
                      height: 240),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BiometricPulseVitalsView(false)
          ],
        ),
      ),
    );
  }

  Widget bodyTempratureTrends() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_thermometer.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Body Temperature',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Body Temperature Information',
                      description: "The optimal temperature of the human body is 37 °C (98.6 °F), but various factors can affect this value, including exposure to the elements in the environment.",
                      height: 220),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            BiometricBodyTemperatureVitalsView()
          ],
        ),
      ),
    );
  }
}
