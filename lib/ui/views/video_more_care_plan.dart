
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/my_medication_history.dart';
import 'package:paitent/ui/views/my_medication_prescription.dart';
import 'package:paitent/ui/views/my_medication_refill.dart';
import 'package:paitent/ui/views/my_medication_remainder.dart';
import 'package:intl/intl.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'home_view.dart';

class VideoMoreCarePlanView extends StatefulWidget {

 AssortedViewConfigs assortedViewConfigs;

 VideoMoreCarePlanView(@required this.assortedViewConfigs);

  @override
  _VideoMoreCarePlanViewState createState() => _VideoMoreCarePlanViewState();
}

class _VideoMoreCarePlanViewState extends State<VideoMoreCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//https://www.youtube.com/watch?v=s1pG7k_1nSw
  String videourl = "https://www.youtube.com/watch?v=d8PzoTr95ik";
  String videoId;
  String textMsg1 = "Welcome to the Connected Heart Health CarePlan. For the next 12 weeks you will be given daily activities designed to help you manage your condition.\n\nThese activities will include education, assessments, challenges, and communication. We will begin with some foundational information and developing your self CarePlan.";
  String textMsg2 = "Heart Failure is a chronic, progressive condition in which the heart muscle is unable to pump enough blood through the heart to meet the body's needs for blood and oxygen.\n\nHeart failure usually results in an enlarged heart.";

  YoutubePlayerController _controller;

  String unformatedDOB = "";
  var dateFormat = DateFormat("dd MMM, yyyy");

  @override
  void initState() {
    // TODO: implement initState
    if(widget.assortedViewConfigs.task.type == 'Video') {
      videoId =
          YoutubePlayer.convertUrlToId(widget.assortedViewConfigs.task.details.url);
      print(videoId);
      _controller = YoutubePlayerController(
        initialVideoId: videoId, //"d8PzoTr95ik",
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,

        ),
      );
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  widget.assortedViewConfigs.header == "" ? 'Learn More!' : widget.assortedViewConfigs.header,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
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
              body:YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                  ),
                  builder: (context, player) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        headerText(),
                        SizedBox(height: 16,),
                        Expanded(
                          child: widget.assortedViewConfigs.toShow == "1"
                              ? iMageView()
                              : widget.assortedViewConfigs.toShow == "2"
                              ? audioView()
                              : videoView(),
                        ),
                        footer(),
                      ],
                    );
                  }
              ),
            ),
          ),
    );
  }

  Widget headerText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          "AHA Heart Failure Care Plan\nAHAHF",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          assrotedUICount != 3 ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){

                  AssortedViewConfigs newAssortedViewConfigs =  new AssortedViewConfigs();
                  if(assrotedUICount == 1) {
                      newAssortedViewConfigs.toShow = "1";
                      newAssortedViewConfigs.testToshow = "1";
                      newAssortedViewConfigs.isNextButtonVisible = true;

                      Navigator.pushNamed(
                          context, RoutePaths.Learn_More_Care_Plan,
                          arguments: newAssortedViewConfigs);
                      assrotedUICount = 2;
                  } else if(assrotedUICount == 2) {
                    newAssortedViewConfigs.toShow = "1";
                    newAssortedViewConfigs.testToshow = "2";
                    newAssortedViewConfigs.isNextButtonVisible = false;

                    Navigator.pushNamed(
                        context, RoutePaths.Learn_More_Care_Plan,
                        arguments: newAssortedViewConfigs);
                    assrotedUICount = 3;
                  }else{
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 1 );
                        }), (Route<dynamic> route) => false);
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 40,
                    width: 160,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.deepPurple,),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.deepPurple, size: 16,),
                        Text(
                          assrotedUICount != 3 ? 'Next' : 'Done',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              :
          Container(),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                    /*assrotedUICount = 0;
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 0 );
                        }), (Route<dynamic> route) => false);*/
                  completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);

                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 40,
                    width: 160,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: Colors.deepPurple,),
                    child:/* assrotedUICount != 3 ?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.deepPurple, size: 16,),
                        Text(
                          'Skip All',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                      ],
                    )
                    :*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget audioView(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.assortedViewConfigs.task.details.text,
              style: TextStyle( fontWeight: FontWeight.w300, fontSize: 12),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  _launchURL(widget.assortedViewConfigs.task.details.concreteTask.mediaUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      height: 40,
                      width: 160,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.deepPurple,),
                      child:/* assrotedUICount != 3 ?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.deepPurple, size: 16,),
                        Text(
                          'Skip All',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                      ],
                    )
                    :*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Play Audio',
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget iMageView(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(16.0),
              child: new Image.asset(
                widget.assortedViewConfigs.testToshow == "1" ? 'res/images/care_plan_message.jpg' : 'res/images/care_plan_info_graphic.jpg',
              fit: BoxFit.cover,
              )
            ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.assortedViewConfigs.task.details.text,
              style: TextStyle( fontWeight: FontWeight.w300, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }


  videoView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url');
      //throw 'Could not launch $url';
    }
  }

  completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse = await model.completeMessageTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), task.id);

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
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }


}