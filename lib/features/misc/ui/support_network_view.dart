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

  String hfHelprText = 'www.heart.org/HFsupport\nis easy and membership is free. Join an exclusive peer group for heart failure patients like you – putting encouragement and reliable, helpful information at your fingertips whenever you need it.';
  String hfHearthAndStrokeText = 'www.heart.org/SupportNetwork\nis easy, and membership is free — putting advice, encouragement and reliable, helpful information at your fingertips whenever you need it.';

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
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          brightness: Brightness.dark,
          title: Text(
            '',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          iconTheme: IconThemeData(color: Colors.white),
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
        body: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  color: primaryColor,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: primaryColor,
                  height: 0,
                  width: MediaQuery.of(context).size.width,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12))),
                    child: body(),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            AssetImage('res/images/ic_support_network.png'),
                            size: 80,
                            color: primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Support Network",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: textBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                  Text("The American Heart Association’s Support Network exist so real people can share their real stories and make a real difference in people’s lives.",
                      style: TextStyle(
                        height: 1.5,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        )
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text("Signing up at",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,


                          )
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        options: LinkifyOptions(
                          humanize: true,
                        ),
                        text:getAppName() != 'HF Helper' ? 'www.heart.org/SupportNetwork\nis easy, and membership is free — putting advice, encouragement and reliable, helpful information at your fingertips whenever you need it.'
                         : 'www.heart.org/HFsupport\nis easy and membership is free.\nJoin an exclusive peer group for heart failure patients like you – putting encouragement and reliable, helpful information at your fingertips whenever you need it.',
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        linkStyle: TextStyle(color: Colors.lightBlueAccent),
                      ),

                      SizedBox(
                        height: 32,
                      ),
                      if(getAppName() == 'HF Helper')...[
                      Text("Helpful Links",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,


                          )
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        options: LinkifyOptions(
                          humanize: true,
                        ),
                        text:
                        'Need help finding a community resource? Start here https://heart.org/findhelp',
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        linkStyle: TextStyle(color: Colors.lightBlueAccent),
                      ),
      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


 /* Widget body() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
      ],
    );
  }*/

}
