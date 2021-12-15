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
import 'package:paitent/ui/widgets/bezierContainer.dart';
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
      "The six cardiologists who founded the American Heart Association in 1924 would be amazed. From humble beginnings, the AHA has grown into the nation’s oldest and largest voluntary organization dedicated to fighting heart disease and stroke.";
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
                        top: -height * .15,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer()),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getAppType() == 'AHA' ? 80 : 100,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    height: getAppType() == 'AHA' ? 80 : 120,
                                    width: getAppType() == 'AHA' ? 80 : 120,
                                    decoration: BoxDecoration(
                                        color: getAppType() == 'AHA'
                                            ? primaryLightColor
                                            : primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: getAppType() == 'AHA'
                                        ? Semantics(
                                            label: 'American Heart Association',
                                            image: true,
                                            child: Image.asset(
                                                'res/images/aha_logo.png'))
                                        : Semantics(
                                            label: 'REAN HealthGuru',
                                            image: true,
                                            child: Image.asset(
                                                'res/images/app_logo_tranparent.png'),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  getAppType() == 'AHA'
                                      ? _titleAha()
                                      : _title(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getAppType() == 'AHA'
                                              ? textMsg2
                                              : textMsg1,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getAppType() == 'AHA'
                                                  ? 14
                                                  : 16,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'For more information,',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 16,
                                                fontFamily: 'Montserrat'),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Visit: ',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w200,
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  //_launchURL('https://www.reanfoundation.org/');
                                                  String url =
                                                      'https://www.reanfoundation.org/';
                                                  if (getAppType() == 'AHA') {
                                                    url =
                                                        'https://www.heart.org';
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
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            getAppType() == 'AHA'
                                                ? textMsg3
                                                : '',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getAppType() == 'AHA'
                                                    ? 14
                                                    : 16,
                                                fontFamily: 'Montserrat'),
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
                      ),
                    ),
                    Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ))),
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
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
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
              text: 'American',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
              children: [
                TextSpan(
                  text: ' ',
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
                TextSpan(
                  text: 'H',
                  style: TextStyle(color: primaryColor, fontSize: 26),
                ),
                TextSpan(
                  text: 'eart',
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
                TextSpan(
                  text: '\nA',
                  style: TextStyle(color: primaryColor, fontSize: 26),
                ),
                TextSpan(
                  text: 'ssociation',
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
