import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
                        weightTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        bloodPresureTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        bloodGlucoseTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        bloodOxygenSaturationTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        pulseRateTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        bodyTempratureTrends(),
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
                InfoScreen(
                    tittle: 'Info',
                    description:
                        'Your doctor typically will record your weight during your regular health care visits. Please refer to your doctor\'s recommended frequency of measuring your weight at home.',
                    height: 220),
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
                  InfoScreen(
                      tittle: 'Info',
                      description:
                          'Your blood pressure will be measured at your regular health care visits or at least once per year if blood pressure is less than 120/80 mm Hg.  Your doctor might recommend you monitor your blood pressure at home. Your blood pressure readings can be categorized as (in mm Hg): *Normal: Less than 120/80; Elevated: Systolic 120-129 AND Diastolic less than 80; *High Blood Pressure Stage 1: Systolic 130-139 OR Diastolic 80-89; *High Blood Pressure Stage 2: Sytsolic 140+ OR Diasotlic 90+; Hypertensive Crisis (Consult your doctor immediately): Systolic 180+ and/or Diastolic 180+.',
                      height: 380),
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
                Text(
                  'Blood Glucose',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 8,
                ),
                InfoScreen(
                    tittle: 'Info',
                    description:
                        'The American Diabetes Association recommends testing for prediabetes and risk for future diabetes for all people beginning at age 45 years. If tests are normal, it is reasonable to repeat testing at a minimum of 3-year intervals.',
                    height: 240),
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
                InfoScreen(
                    tittle: 'Info',
                    description:
                        'Your heart rate, or pulse, is the number of times your heart beats per minute. Normal heart rate varies from person to person. For most of us (adults), between 60 and 100 beats per minute (bpm) is normal.',
                    height: 240),
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
