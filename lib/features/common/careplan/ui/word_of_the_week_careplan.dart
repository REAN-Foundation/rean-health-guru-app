import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';

// ignore: must_be_immutable
class WordOfTheWeekCarePlanView extends StatefulWidget {
  AssortedViewConfigs? assortedViewConfigs;

  WordOfTheWeekCarePlanView(assortedViewConfigs) {
    this.assortedViewConfigs = assortedViewConfigs;
  }

  @override
  _WordOfTheWeekCarePlanViewState createState() =>
      _WordOfTheWeekCarePlanViewState();
}

class _WordOfTheWeekCarePlanViewState extends State<WordOfTheWeekCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              'Words for the week',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.black),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerText(),
              wordsList(),
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
          'Flip the card to understand\nthe word!',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget wordsList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 48,
            ),
            FlipCard(
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                padding: const EdgeInsets.all(16.0),
                height: 360,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: primaryLightColor,
                    border: Border.all(color: primaryLightColor),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.assortedViewConfigs!.task!.action!.description
                          .toString(),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'res/images/ic_refresh_blue_circle.png',
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              back: Container(
                padding: const EdgeInsets.all(16.0),
                height: 360,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    color: primaryLightColor,
                    border: Border.all(color: primaryLightColor),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.assortedViewConfigs!.task!.action!.description
                          .toString(),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.assortedViewConfigs!.task!.action!.description
                          .toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      completeMessageTaskOfAHACarePlan(
                          widget.assortedViewConfigs!.task);
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(primaryLightColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // FlipCard(
            //   direction: FlipDirection.VERTICAL, // default
            //   front: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     height: 160,
            //     width: MediaQuery.of(context).size.width - 100,
            //     decoration: new BoxDecoration(
            //         color: primaryLightColor,
            //         border: Border.all(color: primaryLightColor),
            //         borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Ejection Fraction",
            //           style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            //           textAlign: TextAlign.center,
            //         ),
            //         new Image.asset(
            //           'res/images/ic_refresh_blue_circle.png',
            //           fit: BoxFit.cover,
            //         )
            //
            //       ],
            //     ),
            //   ),
            //   back: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     height: 160,
            //     width: MediaQuery.of(context).size.width - 100,
            //     decoration: new BoxDecoration(
            //         color: primaryLightColor,
            //         border: Border.all(color: primaryLightColor),
            //         borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Ejection fraction",
            //           style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            //           textAlign: TextAlign.center,
            //         ),
            //         Text(
            //           "Ejection fraction is a measurement, expressed as a percentage, of how much blood the left ventricle pumps out with each contraction.",
            //           style: TextStyle( fontWeight: FontWeight.w300, fontSize: 12),
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16,),
            // FlipCard(
            //   direction: FlipDirection.HORIZONTAL, // default
            //   front: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     height: 160,
            //     width: MediaQuery.of(context).size.width - 100,
            //     decoration: new BoxDecoration(
            //         color: primaryLightColor,
            //         border: Border.all(color: primaryLightColor),
            //         borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Dyspnea",
            //           style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            //           textAlign: TextAlign.center,
            //         ),
            //         new Image.asset(
            //           'res/images/ic_refresh_blue_circle.png',
            //           fit: BoxFit.cover,
            //         )
            //
            //       ],
            //     ),
            //   ),
            //   back: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     height: 160,
            //     width: MediaQuery.of(context).size.width - 100,
            //     decoration: new BoxDecoration(
            //         color: primaryLightColor,
            //         border: Border.all(color: primaryLightColor),
            //         borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Dyspnea",
            //           style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            //           textAlign: TextAlign.center,
            //         ),
            //         Text(
            //           "Dyspnea is the medical term for shortness of breath, sometimes described as “air hunger.” It is an uncomfortable feeling.",
            //           style: TextStyle( fontWeight: FontWeight.w300, fontSize: 12),
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  completeMessageTaskOfAHACarePlan(UserTask? task) async {
    try {
      final BaseResponse _startTaskOfAHACarePlanResponse =
          await model.finishUserTask(task!.action!.userTaskId!.toString());

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        showToast('Task completed successfully!', context);
        assrotedUICount = 0;
        Navigator.pop(context);
        /*Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);*/
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }
}
