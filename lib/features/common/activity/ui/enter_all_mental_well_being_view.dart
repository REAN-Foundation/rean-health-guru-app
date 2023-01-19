import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../../infra/utils/string_utility.dart';

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
  int _sleepingHrs = 0;
  Color buttonColor = Color(0XFFCFB4FF);
  DashboardTile? mindfulnessTimeDashboardTile;
  int oldStoreSec = 0;
  var mindfulnessController = TextEditingController();
  var mindfulnessFocus = FocusNode();

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    debugPrint('Start Date $startDate');
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    loadSleepMovement();
    loadSharedPrefs();
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
          _sleepingHrs = _sleepHrs;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  loadSharedPrefs() async {
    try {
      mindfulnessTimeDashboardTile = DashboardTile.fromJson(
          await _sharedPrefUtils.read('mindfulnessTime'));
      if (mindfulnessTimeDashboardTile!.date!
          .difference(DateTime.now())
          .inDays ==
          0) {
        oldStoreSec = int.parse(mindfulnessTimeDashboardTile!.discription!);
      }

      setState(() {
        debugPrint('MindfulnessTime Dashboard Tile ==> $oldStoreSec');
      });
    } on FetchDataException catch (e) {
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
                  mindfulness(),
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
                                toastDisplay = true;
                                if(_sleepingHrs == _sleepHrs && mindfulnessController.text.toString().isEmpty){
                                  showToast('Please enter valid input', context);
                                }else {
                                  if(_sleepingHrs != _sleepHrs) {
                                    recordMySleepTimeInHrs();
                                  }
                                  if (mindfulnessController.text
                                      .toString()
                                      .isNotEmpty) {
                                    saveMindfulnessTime(int.parse(
                                        mindfulnessController.text.toString()));
                                  }
                                }
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
                      'Sleep',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
                InfoScreen(
                    tittle: 'Sleep Information',
                    description:
                    'Getting a good night’s sleep every night is vital to cardiovascular health. Adults should aim for an average of 7-9 hours. Too little or too much sleep is associated with heart disease.',
                    height: 224),
              ],
            ),
            SizedBox(
              height: 8,
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
                                  announceText('$_sleepHrs hours of sleep');
                                  setState(() {});
                                  //recordMySleepTimeInHrs();
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primaryColor,
                                semanticLabel:
                                'decrease sleep in hours',
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: '$_sleepHrs hours of sleep',
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
                                announceText('$_sleepHrs hours of sleep');
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
                                'increase sleep in hours',
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mindfulness() {
    debugPrint('oldStoreSec ==> ${oldStoreSec}');
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
                  AssetImage('res/images/ic_mindfulness.png'),
                  size: 32,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      'Mindfulness',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
                InfoScreen(
                    tittle: 'Mindfulness Information',
                    description:
                    'Practicing mindfulness and meditation may help you manage stress and high blood pressure, sleep better, feel more balanced and connected, and even lower your risk of heart disease.',
                    height: 240),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Enter number of your mindful minutes',
                        style: TextStyle(
                            color: textBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: textBlack,
                              fontSize: 12),
                        ),
                      ),
                      /*Expanded(
                        child: InfoScreen(
                            tittle: 'Stand Information',
                            description:
                                'Standing is better for the back than sitting. It strengthens leg muscles and improves balance. It burns more calories than sitting.',
                            height: 208),
                      ),*/
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: textGrey, width: 1),
                              color: Colors.white),
                          child: Semantics(
                            label: 'mindfulness measures in minutes',
                            child: TextFormField(
                                controller: mindfulnessController,
                                focusNode: mindfulnessFocus,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (term) {
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                ],
                                decoration: InputDecoration(
                                  /*hintText: unit == 'lbs'
                                    ? '(100 to 200)'
                                    : '(50 to 100)',*/
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'or',
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(Conversion.durationFromSecToMinToString(oldStoreSec),
                      semanticsLabel:
                      Conversion.durationFromSecToMinToString(oldStoreSec).replaceAll('sec', 'second').replaceAll('min', 'minutes').replaceAll('hrs', 'hours'),
                      style: const TextStyle(
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                  SizedBox(
                    child: OutlinedButton(
                      child: Text('Start'),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.Meditation).then((_) {
                          loadSharedPrefs();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: primaryColor),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        foregroundColor: primaryColor,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  recordMySleepTimeInHrs() async {
    try {
      if(_sleepHrs != 0 ) {
      if (_sleepTracking == null) {
        debugPrint("123 ");
        _sharedPrefUtils.save(
            'sleepTime', MovementsTracking(startDate, _sleepHrs, '').toJson());
        loadSleepMovement();
      } else {
        debugPrint("456 ");
        _sleepTracking!.value = _sleepHrs;
        _sleepTracking!.date = startDate;
        _sharedPrefUtils.save('sleepTime', _sleepTracking!.toJson());
      }
      clearAllFeilds();
        //showToast("Sleep time recorded successfully", context);
      }
      setState(() {});
       final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['SleepDuration'] = _sleepHrs;
      map['Unit'] = 'Hrs';
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMySleep(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  saveMindfulnessTime(int minutes) async {
    hideKeyboard();
    debugPrint('New Mindful min ==> $minutes');
    int newSec = Duration(minutes: minutes).inSeconds;
    newSec = newSec + oldStoreSec;
    _sharedPrefUtils.save(
        'mindfulnessTime',
        DashboardTile(DateTime.now(), 'mindfulnessTime', newSec.toString())
            .toJson());

    oldStoreSec = newSec;
    mindfulnessController.clear();
    loadSharedPrefs();
    setState(() {});
    final map = <String, dynamic>{};
    map['PatientUserId'] = patientUserId;
    map['DurationInMins'] = Duration(minutes: newSec).inMinutes.toString();
    map['RecordDate'] = dateFormat.format(DateTime.now());

    final BaseResponse baseResponse = await model.recordMyMindfulness(map);
    if (baseResponse.status == 'success') {
      clearAllFeilds();
      //showToast("Mindfulness minutes recorded successfully", context);
    } else {}
    setState(() {});
  }

  bool toastDisplay = true;

  clearAllFeilds() {
    if (toastDisplay) {
      _scrollController.animateTo(0.0,
          duration: Duration(seconds: 2), curve: Curves.ease);
      showSuccessToast('Record Updated Successfully!', context);
      toastDisplay = false;
    }
  }

}
