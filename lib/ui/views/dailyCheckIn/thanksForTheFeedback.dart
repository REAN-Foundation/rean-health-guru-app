import 'package:flutter/material.dart';
import 'package:paitent/widgets/delayed_animation.dart';

class ThanksForTheFeedBack extends StatefulWidget {
  @override
  _ThanksForTheFeedBack createState() => _ThanksForTheFeedBack();
}

class _ThanksForTheFeedBack extends State<ThanksForTheFeedBack>
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
    Future.delayed(const Duration(seconds: 5), () => Navigator.pop(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 160,
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
              Image.asset(
                'res/images/ic_thanks_for_feedback.png',
                height: 64,
                width: 64,
              ),
              const SizedBox(
                height: 20,
              ),
              DelayedAnimation(
                child: Text(
                  "Thanks for the feedback!",
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
            ],
          ),
        ));
  }
}
