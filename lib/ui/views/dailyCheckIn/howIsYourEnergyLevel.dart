import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/dailyCheckIn/thanksForTheFeedback.dart';
import 'package:paitent/widgets/delayed_animation.dart';

class HowIsYourEnergyLevel extends StatefulWidget {
  @override
  _HowIsYourEnergyLevel createState() => _HowIsYourEnergyLevel();
}

class _HowIsYourEnergyLevel extends State<HowIsYourEnergyLevel>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  AnimationController _controller;
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
        height: 400,
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
                  "How is your energy level?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black),
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
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(1)) {
                        selectedList.remove(1);
                      } else {
                        selectedList.add(1);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_bed.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Get off the bed',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 1000,
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
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(2)) {
                        selectedList.remove(2);
                      } else {
                        selectedList.add(2);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_stairs.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Climb Stairs',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 2000,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(3)) {
                        selectedList.remove(3);
                      } else {
                        selectedList.add(3);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_exersise.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Exercise',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 2000,
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
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(4)) {
                        selectedList.remove(4);
                      } else {
                        selectedList.add(4);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_walk.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Walk',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 2000,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(5)) {
                        selectedList.remove(5);
                      } else {
                        selectedList.add(5);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_stand.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Stand',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 2000,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedList.contains(6)) {
                        selectedList.remove(6);
                      } else {
                        selectedList.add(6);
                      }
                      setState(() {});
                    },
                    child: DelayedAnimation(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  child: Image.asset(
                                    'res/images/dailyCheckIn/ic_eat.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Eat',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
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
                      delay: delayedAmount + 2000,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    if (selectedList.contains(7)) {
                      selectedList.remove(7);
                    } else {
                      selectedList.add(7);
                    }
                    setState(() {});
                  },
                  child: DelayedAnimation(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                child: Image.asset(
                                  'res/images/dailyCheckIn/ic_nap.png',
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Get through the day without a nap',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
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
                    delay: delayedAmount + 2000,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  showDailyCheckIn();
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: primaryColor),
                ),
              )
            ],
          ),
        ));
  }

  showDailyCheckIn() {
    debugPrint('Inside Daily Check In');
    Navigator.pop(context);
    showMaterialModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) => ThanksForTheFeedBack());
  }
}
