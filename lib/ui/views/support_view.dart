import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/widgets/bezierContainer.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  //var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg = 'We are here to help you so please get in touch.';
  String phone = '+2025397323';
  String email = 'support@reanfoundation.org';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = ' ';
  String userPhone = ' ';

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      auth = user.data.accessToken;
      patientUserId = user.data.user.userId;
      //debugPrint(user.toJson().toString());

      setState(() {
        name = patient.firstName + ' ' + patient.lastName;
        userPhone = patient.phoneNumber;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  @override
  void initState() {
    //completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);
    // TODO: implement initState
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<PatientCarePlanViewModel>(
      //model: model,
      builder: (context, model, child) => Container(
          child: Scaffold(
              backgroundColor: colorF6F6FF,
              body: Container(
                height: height,
                child: MergeSemantics(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: -height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 6,
                              child: ExcludeSemantics(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Lottie.asset(
                                        'res/lottiefiles/support_us.json',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      child: Text(msg,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: primaryColor)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Semantics(
                                          label: 'tap to dial number',
                                          button: true,
                                          child: InkWell(
                                            onTap: () async {
                                              final String url =
                                                  'tel://' + phone;
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                showToast(
                                                    'Unable to dial number',
                                                    context);
                                                debugPrint(
                                                    'Could not launch $url');
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: Card(
                                              elevation: 8.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              color: colorF6F6FF,
                                              shadowColor: colorF6F6FF,
                                              child: Container(
                                                height: 160,
                                                child: Column(
                                                  children: [
                                                    Lottie.asset(
                                                      'res/lottiefiles/call.json',
                                                      height: 120,
                                                    ),
                                                    Text('Call us',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                            color:
                                                                primaryColor)),
                                                  ],
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
                                          label:
                                              'on tap prepare an email for contact to rean',
                                          button: true,
                                          child: InkWell(
                                            onTap: () async {
                                              /* final Uri _emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: email,
                                                queryParameters: {
                                                  'subject': 'REAN%2BCare%2Bapp%2Bquery',
                                                  'body': 'Hey Team, \n'+name+' wants to get in touch\nContact Number: '+userPhone,
                                                }
                                            );*/

                                              final link = 'mailto:' +
                                                  email +
                                                  '?subject=Regarding%20REAN%20HealthGuru%20App&body=Hey Team,%20\n\n' +
                                                  name +
                                                  '%20wants%20to%20get%20in%20touch%20with%20you.\n\nContact%20Number:%20' +
                                                  userPhone +
                                                  '\n\n';
                                              if (await canLaunch(
                                                  link.toString())) {
                                                await launch(link.toString());
                                              } else {
                                                final Uri _emailLaunchUri = Uri(
                                                    scheme: 'mailto',
                                                    path: email,
                                                    queryParameters: {
                                                      'subject':
                                                          'REAN HealthGuru app query',
                                                      'body': ''
                                                              '' +
                                                          name +
                                                          ' wants to get in touch with you. ---- '
                                                              'Contact Number:' +
                                                          userPhone +
                                                          ''
                                                              '',
                                                    });
                                                await launch(_emailLaunchUri
                                                    .toString()
                                                    .replaceAll('+', '%20'));

                                                debugPrint(
                                                    'Could not launch ${link.toString()}');
                                                throw 'Could not launch ${link.toString()}';
                                              }
                                            },
                                            child: Card(
                                              elevation: 8.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              color: colorF6F6FF,
                                              shadowColor: colorF6F6FF,
                                              child: Container(
                                                height: 160,
                                                child: Column(
                                                  children: [
                                                    Lottie.asset(
                                                      'res/lottiefiles/mail.json',
                                                      height: 120,
                                                    ),
                                                    Text('E mail us',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                            color:
                                                                primaryColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Positioned(top: 40, left: 0, child: _backButton()),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget _backButton() {
    return Semantics(
      label: 'take to back screen',
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
  }

/*completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse = await model.completeMessageTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HomeView( 1 );
            }), (Route<dynamic> route) => false);
        debugPrint("AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}");
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

*/
}
