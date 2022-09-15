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
                          'Since LDL is the bad kind of cholesterol, a low LDL level is considered good for your heart health.',
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
                          'HDL cholesterol is called “good” cholesterol. A healthy HDL-cholesterol level may protect against heart attack and stroke.',
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
                          'You might have a fasting lipoprotein profile taken every four to six years, starting at age 20. This is a blood test that measures total cholesterol, LDL (bad) cholesterol and HDL (good) cholesterol. You may need to be tested more frequently if your doctor determines that you’re at an increased risk for heart disease or stroke. After age 40, your doctor will also want to use an equation to calculate your 10-year risk of experiencing cardiovascular disease or stroke.',
                      height: 320),
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
                          'Triglycerides are the most common type of fat in your body. They come from food, and your body also makes them.\n\nNormal triglyceride levels vary by age and sex.',
                      height: 240),
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
                      description: "It's one of the commonly used tests to diagnose prediabetes and diabetes, and is also the main test to help you and your health care team manage your diabetes.",
                      height: 220),
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
