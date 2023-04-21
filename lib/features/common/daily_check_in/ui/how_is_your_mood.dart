import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/features/common/daily_check_in/ui/how_is_your_energy_level.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/widgets/delayed_animation.dart';

class HowIsYourMood extends StatefulWidget {
  @override
  _HowIsYourMood createState() => _HowIsYourMood();
}

class _HowIsYourMood extends State<HowIsYourMood>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  late AnimationController _controller;
  int selectedFeelings = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    _controller.isAnimating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 620,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              DelayedAnimation(
                child: Text(
                  "How is your mood today?",
                  semanticsLabel: 'How is your mood today?  Select any one that applied',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Color(0XFF383739)),
                ),
                delay: delayedAmount,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Happy',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 1;
                        dailyMood = 'Happy';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_happy.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 1)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Happy',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Lonely',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 2;
                        dailyMood = 'Lonely';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_lonely.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 2)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Lonely',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Angry',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 3;
                        dailyMood = 'Angry';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_angry.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 3)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Angry',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Stressed',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 4;
                        dailyMood = 'Stressed';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_stressed.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 4)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Stressed',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 2000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Anxious',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 5;
                        dailyMood = 'Anxious';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_axious.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 5)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Anxious',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 2000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Fearfull',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 6;
                        dailyMood = 'Fearfull';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_fearfull.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 6)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Fearful',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 2000,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Sad',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 7;
                        dailyMood = 'Sad';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_sad.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 7)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Sad',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 3000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Hopefull',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 8;
                        dailyMood = 'Hopefull';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                            () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_hopefull.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 8)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Hopeful',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 3000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Calm',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 9;
                        dailyMood = 'Calm';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                                () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_calm.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 9)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Calm',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 3000,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Status Quo',
                    child: InkWell(
                      onTap: () {
                        selectedFeelings = 10;
                        dailyMood = 'Status Quo';
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300),
                                () => showDailyCheckIn());
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'res/images/dailyCheckIn/ic_stats_quo.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  if (selectedFeelings == 10)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Status Quo',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat')),
                            ],
                          ),
                        ),
                        delay: delayedAmount + 3000,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  FirebaseAnalytics.instance.logEvent(name: 'daily_check_in_mood_skip_button_click');
                  Navigator.pop(context);
                },
                child: Text(
                  "Skip",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: primaryColor),
                ),
              )
            ],
          ),
        ));
  }

  showDailyCheckIn() {
    FirebaseAnalytics.instance.logEvent(name: 'daily_check_in_mood_${dailyMood.toLowerCase().replaceAll(' ', '_')}_button_click');
    debugPrint('Inside Daily Check In');
    Navigator.pop(context);
    showMaterialModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) => HowIsYourEnergyLevel());
  }
}
