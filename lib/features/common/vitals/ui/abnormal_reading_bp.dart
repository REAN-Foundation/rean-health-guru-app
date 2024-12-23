import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:url_launcher/url_launcher.dart';

//ignore: must_be_immutable
class AbnormalReadingBpView extends StatefulWidget {

  @override
  _AbnormalReadingBpViewState createState() =>
      _AbnormalReadingBpViewState();
}

class _AbnormalReadingBpViewState
    extends State<AbnormalReadingBpView> {

  var model = PatientVitalsViewModel();






  @override
  Widget build(BuildContext context) {

    return BaseWidget<PatientVitalsViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Blood Pressure Alert',
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
        ),
      ),
    );
  }



  Widget body(){
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notificationMessage,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 20,),

          InkWell(
            onTap: () async{
                  String link = "https://www.heart.org/en/health-topics/high-blood-pressure/changes-you-can-make-to-manage-high-blood-pressure";
                if (await canLaunchUrl(Uri.parse(link))) {
                  await launchUrl(Uri.parse(link));
              } else {
                  throw 'Could not launch $link';
              }


              },
            child: Text(
              'Make lifestyle changes to lower your blood pressure.',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 10,),

          InkWell(
            onTap: () async {
              String link = "https://www.heart.org/en/health-topics/high-blood-pressure/changes-you-can-make-to-manage-high-blood-pressure/types-of-blood-pressure-medications";
              if (await canLaunchUrl(Uri.parse(link))) {
              await launchUrl(Uri.parse(link));
              } else {
              throw 'Could not launch $link';
              }
            },
            child: Text(
              'Learn about blood pressure-lowering medications.',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600),
            ),
          ),



        ],
      ),
    );
  }





}
