import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MindFullMomentCarePlanView extends StatefulWidget {
  @override
  _MindFullMomentCarePlanViewState createState() =>
      _MindFullMomentCarePlanViewState();
}

class _MindFullMomentCarePlanViewState
    extends State<MindFullMomentCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//https://www.youtube.com/watch?v=s1pG7k_1nSw
  String videourl = "https://www.youtube.com/watch?v=d8PzoTr95ik";

  String textMsg1 = "Welcome to this heart meditation brought to you "
      "by the American Heart Association. Bring your"
      " attention to your breathing. You may want to close"
      " your eyes and block out other sounds. Without"
      " trying to change the pace or volume of your"
      ' breathing try to pay attention to each breath as you'
      ' inhale (pause), and exhale (pause). Breathe in,'
      ' breath out; breathe in, breathe out; breath in, breath'
      " out. As you become more aware of your breathing,"
      ' gradually bring your attention to your'
      ' heart. Try to see if you can feel your heart beating.'
      ' Your heart has been beating every moment of your'
      " entire life. It speeds up when you need to provide ";

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: "s1pG7k_1nSw",
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  String unformatedDOB = "";
  var dateFormat = DateFormat("dd MMM, yyyy");

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Mindful Moment',
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              headerText(),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: videoView(),
              ),
            ],
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
          "Heart Meditation",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  videoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoutubePlayer(
          controller: _controller,
        ),
        const SizedBox(
          height: 16,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  textMsg1,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
