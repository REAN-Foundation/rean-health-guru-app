import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
//ignore: must_be_immutable
class StartCarePlanView extends StatefulWidget {
  String selectedCarePlan = '';

  StartCarePlanView(this.selectedCarePlan);

  @override
  _StartCarePlanViewState createState() => _StartCarePlanViewState();
}

class _StartCarePlanViewState extends State<StartCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dob = '';
  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  String startDate = '';

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: MergeSemantics(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text(
                'Set up plan',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700),
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
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'check image',
                        image: true,
                        child: Image.asset(
                          'res/images/ic_check_blue_circe.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Text(
                        'Congratulations!',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: textBlack,
                            fontSize: 16),
                      ),
                      Text(
                        'Select Date & lets start care plan',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: textBlack,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Your selected plan is : ' + widget.selectedCarePlan,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: primaryColor),
                      ),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: colorF6F6FF,
                        ),
                        child: Center(
                          child: Text(
                            "Let's Set up Your Plan",
                            style: TextStyle(
                                color: textBlack, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Select Start Date:',
                            style: TextStyle(
                                color: textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          GestureDetector(
                            child: ExcludeSemantics(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 160,
                                height: 40.0,
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                    color: Color(0XFF909CAC),
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          dob,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                              'res/images/ic_calender.png')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now()
                                      .subtract(Duration(days: 0)),
                                  onChanged: (date) {
                                debugPrint('change $date');
                              }, onConfirm: (date) {
                                    unformatedDOB = date.toIso8601String();
                                setState(() {
                                  dob = dateFormat.format(date);
                                  startDate = dateFormatStandard.format(date) +
                                      'T00:00:00.000Z';
                                });
                                debugPrint('confirm $date');
                                debugPrint('confirm formated $startDate');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                          ),
                        ],
                      ),
                      Semantics(
                        label: 'please select a start date',
                        readOnly: true,
                        child: model.busy
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () {
                                  //Navigator.pushNamed(context, RoutePaths.Setup_Doctor_For_Care_Plan);
                                  if (startDate == '') {
                                    showToast(
                                        'Please select start date', context);
                                  } else {
                                    startCarePlan();
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 160,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                        color: primaryColor, width: 1),
                                    color: Colors.deepPurple,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.deepPurple,
                                        size: 16,
                                      ),
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  startCarePlan() async {
    try {
      final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
      model.setBusy(true);
      final map = <String, String>{};
      map['PatientUserId'] = patientUserId;
      map['CarePlanCode'] = widget.selectedCarePlan;
      map['StartDate'] = startDate;

      final StartCarePlanResponse startCarePlanResponse =
          await model.startCarePlan(map);
      debugPrint('Registered Care Plan ==> ${startCarePlanResponse.toJson()}');
      if (startCarePlanResponse.status == 'success') {
        _sharedPrefUtils.save('CarePlan', startCarePlanResponse.toJson());
        Navigator.pushNamed(context, RoutePaths.Setup_Doctor_For_Care_Plan);
        showToast(startCarePlanResponse.message, context);
      } else {
        showToast(startCarePlanResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
