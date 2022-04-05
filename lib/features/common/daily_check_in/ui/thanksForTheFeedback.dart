import 'package:flutter/material.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/features/misc/view_models/common_config_model.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:paitent/infra/widgets/delayed_animation.dart';

import '../../../misc/ui/base_widget.dart';

class ThanksForTheFeedBack extends StatefulWidget {
  @override
  _ThanksForTheFeedBack createState() => _ThanksForTheFeedBack();
}

class _ThanksForTheFeedBack extends State<ThanksForTheFeedBack>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  late AnimationController _controller;
  List<int> selectedList = [];
  int selectedFeelings = 0;
  var model = CommonConfigModel();

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
    recordHowAreYouFeeling();
    return BaseWidget<CommonConfigModel>(
        model: model,
        builder: (context, model, child) => Container(
            height: 160,
            color: Colors.transparent,
            child: Semantics(
              label: "Thanks for the feedback!",
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
            child: ExcludeSemantics(
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
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Color(0XFF383739)),
                        ),
                        delay: delayedAmount,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  recordHowAreYouFeeling() async {
    try {
      final body = <String, dynamic>{};
      body['PatientUserId'] = patientUserId;
      body['Feeling'] = dailyFeeling;
      body['Mood'] = dailyMood;
      body['EnergyLevels'] = dailyEnergyLevels;

      final BaseResponse baseResponse = await model.recordDailyCheckIn(body);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
      } else {}
    } catch (CustomException) {
      //progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
