import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/features/common/daily_check_in/ui/thanks_for_the_feedback.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/widgets/delayed_animation.dart';

class HowIsYourEnergyLevel extends StatefulWidget {
  @override
  _HowIsYourEnergyLevel createState() => _HowIsYourEnergyLevel();
}

class _HowIsYourEnergyLevel extends State<HowIsYourEnergyLevel>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  late AnimationController _controller;
  List<int> selectedList = [];
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
        height: 460,
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
                  "How is your energy level today?",
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
              DelayedAnimation(
                child: Text(
                  "You are able to:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
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
                    label: 'Get off the bed',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(1)) {
                          selectedList.remove(1);
                          announceText('Not Ticked Get off the bed');
                          dailyEnergyLevels.remove('Get off the bed');
                        } else {
                          dailyEnergyLevels.add('Get off the bed');
                          announceText('Ticked Get off the bed');
                          selectedList.add(1);
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 48,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_bed.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Get off the bed',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(1))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
                    label: 'Stand',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(5)) {
                          selectedList.remove(5);
                          announceText('Not Ticked Stand');
                          dailyEnergyLevels.remove('Stand');
                        } else {
                          announceText('Ticked Stand');
                          dailyEnergyLevels.add('Stand');
                          selectedList.add(5);
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_stand.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Stand',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(5))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Walk',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(4)) {
                          selectedList.remove(4);
                          announceText('Not Ticked Walk');
                          dailyEnergyLevels.remove('Walk');
                        } else {
                          selectedList.add(4);
                          announceText('Ticked Walk');
                          dailyEnergyLevels.add('Walk');
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_walk.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Walk',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(4))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Eat',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(6)) {
                          selectedList.remove(6);
                          announceText('Not Ticked Eat');
                          dailyEnergyLevels.remove('Eat');
                        } else {
                          announceText('Ticked Eat');
                          dailyEnergyLevels.add('Eat');
                          selectedList.add(6);
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_eat.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('Eat',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(6))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
                    label: 'Climb Stairs',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(2)) {
                          announceText('Not Ticked Climb Stairs');
                          dailyEnergyLevels.remove('Climb Stairs');
                          selectedList.remove(2);
                        } else {
                          announceText('Ticked Climb Stairs');
                          dailyEnergyLevels.add('Climb Stairs');
                          selectedList.add(2);
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_stairs.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Climb Stairs',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(2))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
                        ),
                        delay: delayedAmount + 1000,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Exercise',
                    child: InkWell(
                      onTap: () {
                        if (selectedList.contains(3)) {
                          announceText('Not Ticked Exercise');
                          dailyEnergyLevels.remove('Exercise');
                          selectedList.remove(3);
                        } else {
                          announceText('Ticked Exercise');
                          dailyEnergyLevels.add('Exercise');
                          selectedList.add(3);
                        }
                        setState(() {});
                      },
                      child: DelayedAnimation(
                        child: ExcludeSemantics(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Color(0XFFF0F0F0),
                                  border: Border.all(color: Color(0XFFF0F0F0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0)),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 16,
                                        width: 16,
                                        child: Image.asset(
                                          'res/images/dailyCheckIn/ic_exersise.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Exercise',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat')),
                                  ],
                                ),
                              ),
                              if (selectedList.contains(3))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Semantics(
                  label: 'Get through the day without a nap',
                  child: InkWell(
                    onTap: () {
                      if (selectedList.contains(7)) {
                        announceText('Not Ticked Get through the day without a nap');
                        dailyEnergyLevels
                            .remove('Get through the day without a nap');
                        selectedList.remove(7);
                      } else {
                        announceText('Ticked Get through the day without a nap');
                        dailyEnergyLevels
                            .add('Get through the day without a nap');
                        selectedList.add(7);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: ExcludeSemantics(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0XFFF0F0F0),
                                border: Border.all(color: Color(0XFFF0F0F0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24.0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(36.0)),
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      height: 16,
                                      width: 16,
                                      child: Image.asset(
                                        'res/images/dailyCheckIn/ic_nap.png',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Get through the day without a nap',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                            if (selectedList.contains(7))
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
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
                      ),
                      delay: delayedAmount + 1000,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAnalytics.instance.logEvent(name: 'daily_check_in_energy_level_done_button_click');
                    showDailyCheckIn();
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  showDailyCheckIn() {
    for(int i = 0 ; i < dailyEnergyLevels.length ; i++){
      FirebaseAnalytics.instance.logEvent(name: 'daily_check_in_energy_level_${dailyEnergyLevels[i].toLowerCase().replaceAll(' ', '_')}_button_click');
    }
    debugPrint('Inside Daily Check In');
    Navigator.pop(context);
    showMaterialModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) => ThanksForTheFeedBack());
  }
}
