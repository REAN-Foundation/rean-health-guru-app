import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_view.dart';

class AboutREANCareView extends StatefulWidget {
  @override
  _AboutREANCareViewState createState() => _AboutREANCareViewState();
}

class _AboutREANCareViewState extends State<AboutREANCareView> {
  var model = PatientCarePlanViewModel();
  String textMsg1 =
      "REAN HealthGuru provides a platform for your healthcare needs, helping you manage your and your family's health and well-being in a simple, comfortable, and economical manner.";
  String textMsg2 =
      "The new HF Helper app can help heart failure patients stay healthy between office visits by tracking their symptoms, managing medication, and sharing health information with their doctor - all in one place.";
  String textMsg3 =
      'The American Heart Association’s National Heart Failure Initiative, IMPLEMENT-HFTM, is made possible with funding by founding sponsor, Novartis and national sponsor, Boehringer Ingelheim and Eli Lilly and Company.';
  String profileImage = '';
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  @override
  void initState() {
    _initPackageInfo();
    //completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    //final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        //_packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
          child: Scaffold(
              backgroundColor: colorF6F6FF,
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        height: 400,
                        color: primaryColor,
                      ),
                    ),
                    /*Positioned(
                      top: 100,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ),*/
                    _content(),
                    Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ))),
    );
  }

  Widget _content() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 160,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Colors.white,
              ),
              child: _aboutUsContent(),
            ),
          ],
        ),
        Positioned(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      color: getAppType() == 'AHA'
                          ? primaryLightColor
                          : primaryColor,
                      shape: BoxShape.circle),
                  child: getAppType() == 'AHA'
                      ? Image.asset(
                          'res/images/aha_logo.png',
                          semanticLabel: 'American Heart Association',
                        )
                      : Image.asset(
                          'res/images/app_logo_tranparent.png',
                          semanticLabel: 'REAN HealthGuru',
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _aboutUsContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getAppType() == 'AHA' ? _titleAha() : _title(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getAppType() == 'AHA' ? textMsg2 : textMsg1,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getAppType() == 'AHA' ? 14 : 16,
                              fontFamily: 'Montserrat'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        getAppType() == 'AHA' ? _ahaContent() : Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'For more information,',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 14,
                              fontFamily: 'Montserrat'),
                        ),
                        Row(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            InkWell(
                              onTap: () async {
                                //_launchURL('https://www.reanfoundation.org/');
                                String url = 'https://www.reanfoundation.org/';
                                if (getAppType() == 'AHA') {
                                  url = 'https://www.heart.org';
                                }
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text(
                                getAppType() == 'AHA'
                                    ? 'https://www.heart.org'
                                    : 'https://www.reanfoundation.org',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                getAppType() == 'AHA'
                    ? 'Powered by\nREAN Foundation (Innovator\'s Network)'
                    : 'Powered by\nREAN Foundation',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ahaContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "With HF Helper you can\n",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'Montserrat'),
        ),
        Text(
          "Track symptoms, medications and other health metrics.Share health information your doctor in real-time. Connect with other  people living with heart failure.\n\nThe American Heart Association’s National Heart Failure Initiative, IMPLEMENT-HF, is made possible with funding by founding sponsor, Novartis, and national sponsor, Boehringer Ingelheim and Eli Lilly and Company.",
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'Montserrat'),
        ),
      ],
    );
  }

  Widget _backButton() {
    return Semantics(
      label: 'Back',
      button: true,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16)),
            /* boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],*/
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                //padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              /*Text('Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'REAN',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
          children: [
            TextSpan(
              text: ' ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'H',
              style: TextStyle(color: primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: 'ealth',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'G',
              style: TextStyle(color: primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: 'uru',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _titleAha() {
    return MergeSemantics(
      child: Semantics(
        label: 'App name',
        readOnly: true,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'HF',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
              children: [
                TextSpan(
                  text: ' Helper',
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
              ]),
        ),
      ),
    );
  }

  completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.completeMessageTaskOfAHACarePlan(
              startCarePlanResponseGlob.data.carePlan.id.toString(),
              task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }
}
