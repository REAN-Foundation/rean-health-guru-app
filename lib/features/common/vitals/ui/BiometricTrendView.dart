import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodOxygenVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodPresureVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodSugartVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBodyTempratureVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricPulseVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricWeightVitals.dart';
import 'package:paitent/features/common/vitals/view_models/patients_vitals.dart';
import 'package:paitent/infra/themes/app_colors.dart';

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
                    AssetImage('res/images/ic_blood_presure.png'),
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
