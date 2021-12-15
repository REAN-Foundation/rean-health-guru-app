import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

enum CoachMarkContentPosition { top, bottom }

class CoachMarkUtilites {
  TargetFocus getTargetFocus(GlobalKey key, String sequence, String heading,
      String description, CoachMarkContentPosition coachMarkContentPosition) {
    debugPrint('Target Sequence ==> ${'Target ' + sequence}');
    debugPrint('Coach Mark Content Position ==> $coachMarkContentPosition');
    return TargetFocus(
      identify: 'Target ' + sequence,
      keyTarget: key,
      contents: [
        TargetContent(
            align: coachMarkContentPosition == CoachMarkContentPosition.top
                ? ContentAlign.top
                : ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    heading,
                    semanticsLabel: heading,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  child: Text(
                    description,
                    semanticsLabel: description,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w100),
                  ),
                ),
              ],
            )),
      ],
      shape: ShapeLightFocus.Circle,
    );
  }

  TutorialCoachMark displayCoachMark(
      BuildContext context, List<TargetFocus> targets,
      {@required Function onCoachMartkFinish,
      @required Function onCoachMartkSkip,
      @required Function onCoachMartkClickTarget,
      @required Function onCoachMartkClickOverlay}) {
    return TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black,
      alignSkip: Alignment.topRight,
      textSkip: 'SKIP',
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        onCoachMartkFinish();
        //debugPrint("finish");
      },
      onClickTarget: (target) {
        onCoachMartkClickTarget(target);
        //debugPrint('onClickTarget: $target');
      },
      onSkip: () {
        onCoachMartkSkip();
        //debugPrint("skip");
      },
      onClickOverlay: (target) {
        onCoachMartkClickOverlay(target);
        //debugPrint('onClickOverlay: $target');
      },
    );
  }
}
