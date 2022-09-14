import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/widgets/custom_tooltip.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EnterAllMentalWellBeingView extends StatefulWidget {
  @override
  _EnterAllMentalWellBeingViewState createState() => _EnterAllMentalWellBeingViewState();
}

class _EnterAllMentalWellBeingViewState extends State<EnterAllMentalWellBeingView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');

  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  ProgressDialog? progressDialog;
  var scrollContainer = ScrollController();
  final ScrollController _scrollController = ScrollController();
  DateTime? startDate;
  var dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? todaysDate;
  MovementsTracking? _sleepTracking;
  int _sleepHrs = 0;
  Color buttonColor = Color(0XFFCFB4FF);

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    loadSleepMovement();
    super.initState();
  }

  loadSleepMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('sleepTime');

      if (movements != null) {
        _sleepTracking = MovementsTracking.fromJson(movements);
      }

      if (_sleepTracking != null) {
        if (todaysDate == _sleepTracking!.date) {
          debugPrint('Sleep ==> ${_sleepTracking!.value!} Hrs');
          _sleepHrs = _sleepTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0XFFf7f5f5),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            color: Color(0XFFf7f5f5),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  sleep(),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: model!.busy
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator())
                        : Semantics(
                            label: 'Save',
                            button: true,
                            child: InkWell(
                              onTap: () {
                                recordMySleepTimeInHrs();
                              },
                              child: ExcludeSemantics(
                                child: Container(
                                    height: 40,
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      border: Border.all(
                                          color: primaryColor, width: 1),
                                      color: primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sleep() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 8,
                ),
                ImageIcon(
                  AssetImage('res/images/ic_sleep.png'),
                  size: 32,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      'Sleep in hrs',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 56,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                if (_sleepHrs != 0) {
                                  _sleepHrs = _sleepHrs - 1;
                                  setState(() {});
                                  //recordMySleepTimeInHrs();
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primaryColor,
                                semanticLabel:
                                'decrease sleep in hrs',
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: '',
                          child: ExcludeSemantics(
                            child: Container(
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                border:
                                Border.all(color: colorD6D6D6, width: 0.80),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    _sleepHrs == 0
                                        ? ''
                                        : _sleepHrs.toString(),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    _sleepHrs > 1 ? 'hrs' : 'hr',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                _sleepHrs = _sleepHrs + 1;
                                setState(() {});
                                debugPrint(
                                    "_sleepHrs ==> $_sleepHrs");
                                //recordMySleepTimeInHrs();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.add,
                                color: primaryColor,
                                semanticLabel:
                                'increase sleep in hrs',
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomTooltip(
                  message: 'Sleep is essential to recovery and well-being. Lower your risk for serious health problems, like diabetes and heart disease.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  recordMySleepTimeInHrs() async {
    try {
      if (_sleepTracking == null) {
        _sharedPrefUtils.save(
            'sleepTime', MovementsTracking(startDate, -_sleepHrs, '').toJson());
      } else {
        _sleepTracking!.value = _sleepHrs;
        _sharedPrefUtils.save('sleepTime', _sleepTracking!.toJson());
      }

      showToast("Sleep Time recorded successfully", context);
      setState(() {});
      /* final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Volume'] = waterGlass;
      map['Time'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {
      } else {}*/
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

}
