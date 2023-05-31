import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_a1clevel.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_hdl.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_ldl.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_ratio.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_total_cholesterol.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_triglycerides.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/widgets/info_screen.dart';

import '../../../misc/ui/base_widget.dart';
import 'lipid_profile_lipoprotein.dart';

class CholesterolTrendView extends StatefulWidget {
  @override
  _CholesterolTrendViewState createState() => _CholesterolTrendViewState();
}

class _CholesterolTrendViewState extends State<CholesterolTrendView> {
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
                        totalCholesterolTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        ldlTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        hdlTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        triglyceridesTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        lpaTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        a1cLevelTrends(),
                        const SizedBox(
                          height: 8,
                        ),
                        /*ratioTrends(),
                        const SizedBox(
                          height: 32,
                        ),*/
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget ldlTrends() {
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
                  AssetImage('res/images/ic_ldl.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'LDL',
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
                      tittle: 'LDL Information',
                      description:
                          'LDL = BAD: Low-density lipoprotein is known as “bad” cholesterol.',
                      height: 200),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            LipidProfileLDLView(false),
          ],
        ),
      ),
    );
  }

  Widget lpaTrends() {
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
                  AssetImage('res/images/ic_lpa.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Lp(a)',
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
                      tittle: 'Lp(a) Information',
                      description:
                      'Lipoprotein(a), like low-density cholesterol (LDL), is a subtype of lipoprotein that can build up in arteries, increasing the risk of a heart attack or stroke. Lp(a) is an independent risk factor for heart disease that is genetically inherited. Talk to your doctor if you should have your Lp(a) measured based on your personal and family history of heart disease.',
                      height: 300),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            LipidProfileLipoproteinView(false),
          ],
        ),
      ),
    );
  }

  Widget hdlTrends() {
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
                  AssetImage('res/images/ic_hdl.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'HDL',
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
                      tittle: 'HDL Information',
                      description:
                          'HDL = GOOD: High-density lipoprotein is known as “good” cholesterol.',
                      height: 208),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            LipidProfileHdlView(false)
          ],
        ),
      ),
    );
  }

  Widget totalCholesterolTrends() {
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
                  AssetImage('res/images/ic_total_cholesterol.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Total Cholesterol',
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
                      tittle: 'Total Cholesterol Information',
                      description:
                          'Your total blood cholesterol is calculated by adding your HDL and LDL cholesterol levels, plus 20% of your triglyceride level. “Normal ranges” are less important than your overall cardiovascular risk. Like HDL and LDL cholesterol levels, your total blood cholesterol level should be considered in context with your other known risk factors. All adults age 20 or older should have their cholesterol (and other traditional risk factors) checked every four to six years. If certain factors put you at high risk, or if you already have heart disease, your doctor may ask you to check it more often. Work with your doctor to determine your risk for cardiovascular disease and stroke and create a plan to reduce your risk.',
                      height: 420),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            LipidProfileTotalCholesterolView(false),
          ],
        ),
      ),
    );
  }

  Widget triglyceridesTrends() {
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
                  AssetImage('res/images/ic_triglycerides.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Triglycerides',
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
                      tittle: 'Triglycerides Information',
                      description:
                          'Triglycerides: The most common type of fat in the body.',
                      height: 200),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            LipidProfileTriglyceridesView(false)
          ],
        ),
      ),
    );
  }

  Widget a1cLevelTrends() {
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
                  AssetImage('res/images/ic_a1c_level.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'A1C Level',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'A1C Level Information',
                      description: "HbA1C (A1C or glycosylated hemoglobin test). The A1C test can diagnose prediabetes and diabetes. It measures your average blood glucose control for the past two to three months. Blood sugar is measured by the amount of glycosylated hemoglobin (A1C) in your blood. An A1C of 5.7% to 6.4% means that you have prediabetes, and you're at high risk for developing diabetes. Diabetes is diagnosed when the A1C is 6.5% or higher.",
                      height: 320)
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            LipidProfileA1CLevelView(false)
          ],
        ),
      ),
    );
  }

  Widget ratioTrends() {
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
                  AssetImage('res/images/ic_ratio.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Ratio',
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
            LipidProfileRatioView(false)
          ],
        ),
      ),
    );
  }
}
