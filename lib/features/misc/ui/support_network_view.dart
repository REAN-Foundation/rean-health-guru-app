import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportNetworkView extends StatefulWidget {
  @override
  _SupportNetworkViewState createState() => _SupportNetworkViewState();
}

class _SupportNetworkViewState extends State<SupportNetworkView> {
  var model = PatientCarePlanViewModel();
  String msg = 'We are here to help you so please get in touch.';
  String msgAHA = 'Please call us or email us for technical help.';
  String subtitle =
      'For medical help, please contact your health care professional.';
  String phone = '+12025397323';
  String email = 'support@reanfoundation.org';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = ' ';
  String? userPhone = ' ';

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      auth = user.data!.accessToken;
      patientUserId = user.data!.user!.id;
      //debugPrint(user.toJson().toString());

      setState(() {
        name = patient.user!.person!.firstName! +
            ' ' +
            patient.user!.person!.lastName!;
        userPhone = patient.user!.person!.phone;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    //completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<PatientCarePlanViewModel?>(
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

  Widget _backButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))*/
                ],
              ),
            ),
          ),
        ),
        Semantics(
          header: true,
          child: Text(
            'Support Network',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        )
      ],
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
              height: 150,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 150,
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
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  elevation: 8,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: getAppType() == 'AHA'
                          ? primaryLightColor
                          : Colors.white,
                      shape: BoxShape.circle,
                      /*boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(2, 4),
                            blurRadius: 3,
                            spreadRadius: 2)
                      ],*/
                    ),
                    child: getAppType() == 'AHA'
                        ? Image.asset(
                      'res/images/aha_logo.png',
                      semanticLabel: 'American Heart Association Logo',
                    )
                        : Image.asset(
                      'res/images/app_logo_transparent.png',
                      semanticLabel: 'REAN HealthGuru',
                      color: primaryColor,
                    ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          options: LinkifyOptions(humanize: true, ),

                          text: 'The American Heart Association’s Support Network exists so real people can share their real stories and make a real difference in people’s lives.\nSigning up at www.heart.org/SupportNetwork is easy, and membership is free — putting advice, encouragement and reliable, helpful information at your fingertips whenever you need it.',
                          style: TextStyle(color: textBlack, fontSize: 16, fontWeight: FontWeight.w600),
                          linkStyle: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

}
