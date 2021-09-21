import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/StringUtility.dart';

class WeekMyCarePlanView extends StatefulWidget {
  @override
  _WeekMyCarePlanViewState createState() => _WeekMyCarePlanViewState();
}

class _WeekMyCarePlanViewState extends State<WeekMyCarePlanView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  weekSelector(),
                  const SizedBox(
                    height: 16,
                  ),
                  moodGraph(),
                  const SizedBox(
                    height: 16,
                  ),
                  mindFullMoment(),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: todaysMessage(),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: weeksChallenge(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  wordOfTheDay(),
                  const SizedBox(
                    height: 8,
                  ),
                  heartFailurVideo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget weekSelector() {
    return Container(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_left,
            color: primaryColor,
            size: 48,
          ),
          SizedBox(
              width: 100, height: 48, child: Center(child: Text('3rd Week'))),
          Icon(
            Icons.arrow_right,
            color: primaryColor,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget moodGraph() {
    return Container(
        height: 160,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: colorF6F6FF,
                  border: Border.all(color: primaryLightColor),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mood Indicator',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'How do I feel?',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget todaysMessage() {
    return InkWell(
      onTap: () {
        assrotedUICount = 3;
        final AssortedViewConfigs newAssortedViewConfigs =
            AssortedViewConfigs();
        newAssortedViewConfigs.toShow = '1';
        newAssortedViewConfigs.testToshow = '2';
        newAssortedViewConfigs.isNextButtonVisible = false;
        newAssortedViewConfigs.header = 'Message Today';

        Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
            arguments: newAssortedViewConfigs);
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colorF6F6FF,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Message Today',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget weeksChallenge() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.Challenge_Care_Plan);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: colorF6F6FF,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'res/images/ic_challenge.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Challenge',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mindFullMoment() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.Mindfull_Moment_Care_Plan);
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colorF6F6FF,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'res/images/ic_mindful_moment.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Mindful Moment',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.play_arrow,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
              )
              /*Text(
                "How do I feel?",
                style: TextStyle( color: primaryColor,fontSize: 10, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget wordOfTheDay() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.Word_Of_The_Week_Care_Plan);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: colorF6F6FF,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'res/images/ic_dictionary.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Word for the week!',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heartFailurVideo() {
    return InkWell(
      onTap: () {
        assrotedUICount = 3;
        final AssortedViewConfigs newAssortedViewConfigs =
            AssortedViewConfigs();
        newAssortedViewConfigs.toShow = '0';
        newAssortedViewConfigs.testToshow = '1';
        newAssortedViewConfigs.isNextButtonVisible = false;
        newAssortedViewConfigs.header = 'Checking Your Heart Failure';

        Navigator.pushNamed(context, RoutePaths.Learn_More_Care_Plan,
            arguments: newAssortedViewConfigs);
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: colorF6F6FF,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Checking Your Heart Failure',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.play_arrow,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
              )
              /*Text(
                "How do I feel?",
                style: TextStyle( color: primaryColor,fontSize: 10, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
