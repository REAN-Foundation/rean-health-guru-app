import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/careplan/models/start_assessment_response.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EnterAllMovementsView extends StatefulWidget {
  @override
  _EnterAllMovementsViewState createState() => _EnterAllMovementsViewState();
}

class _EnterAllMovementsViewState extends State<EnterAllMovementsView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _standController = TextEditingController();
  final _stepscontroller = TextEditingController();
  final _exerciseController = TextEditingController();
  final _exerciseFocus = FocusNode();
  final _stepsFocus = FocusNode();
  final _standFocus = FocusNode();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  ProgressDialog? progressDialog;
  var scrollContainer = ScrollController();
  final ScrollController _scrollController = ScrollController();
  DateTime? startDate;
  var dateFormat = DateFormat('yyyy-MM-dd');
  MovementsTracking? _standMovemntsTracking;
  int standMovements = 0;
  MovementsTracking? _stepsMovemntsTracking;
  int stepsMovements = 0;
  MovementsTracking? _exerciseMovemntsTracking;
  int exerciseMovements = 0;
  DateTime? todaysDate;
  var exersizeType = <Answer>[];
  String radioItem = '';
  // Group Value for Radio Button.
  int id = 0;

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    loadStandMovement();
    loadStepsMovement();
    loadExerciseMovement();
    processAnswer();
    super.initState();
  }

  processAnswer() {

    exersizeType.add(Answer(
          1,
          'Cardio'));
    exersizeType.add(Answer(
        2,
        'Strength'));
    exersizeType.add(Answer(
        3,
        'Mix'));

    setState(() {});
  }

  loadStandMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('standTime');

      if (movements != null) {
        _standMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_standMovemntsTracking != null) {
        if (todaysDate == _standMovemntsTracking!.date) {
          debugPrint('Stand ==> ${_standMovemntsTracking!.value!}');
          standMovements = _standMovemntsTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  loadStepsMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('stepCount');

      if (movements != null) {
        _stepsMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_stepsMovemntsTracking != null) {
        if (todaysDate == _stepsMovemntsTracking!.date) {
          debugPrint('Steps ==> ${_stepsMovemntsTracking!.value!}');
          stepsMovements = _stepsMovemntsTracking!.value!;
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('error caught: $e');
    }
  }

  loadExerciseMovement() async {
    try {
      final movements = await _sharedPrefUtils.read('exerciseTime');

      if (movements != null) {
        _exerciseMovemntsTracking = MovementsTracking.fromJson(movements);
      }

      if (_exerciseMovemntsTracking != null) {
        if (todaysDate == _exerciseMovemntsTracking!.date) {
          debugPrint('Exercise ==> ${_exerciseMovemntsTracking!.value!}');
          exerciseMovements = _exerciseMovemntsTracking!.value!;
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
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //const SizedBox(height: 16,),
                  standFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  stepsFeilds(),
                  const SizedBox(
                    height: 8,
                  ),
                  exerciseFeilds(),
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
                                bool validationToastDisplay = true;
                                if (_standController.text != null &&
                                    _standController.text.trim().isNotEmpty) {
                                  debugPrint(
                                      'Stand ==> ${_standController.text}');
                                  validationToastDisplay = false;
                                  recordMyStand();
                                  recordMyStandTimeInMinutes(
                                      int.parse(_standController.text));
                                }

                                if (_stepscontroller.text != null &&
                                    _stepscontroller.text.trim().isNotEmpty) {
                                  debugPrint(
                                      'Steps ==> ${_stepscontroller.text}');
                                  validationToastDisplay = false;
                                  recordMySteps();
                                  recordMyStepCount(
                                      int.parse(_stepscontroller.text));
                                }

                                if (_exerciseController.text != null &&
                                    _exerciseController.text
                                        .trim()
                                        .isNotEmpty) {
                                  debugPrint(
                                      'Exercise ==> ${_exerciseController.text}');
                                  validationToastDisplay = false;
                                  recordMyExcerciseTimeInMinutes(
                                      int.parse(_exerciseController.text));
                                }

                                if(validationToastDisplay){
                                  showToast('Please enter valid input', context);
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

  Widget standFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_stand.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your stand minutes',
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
                      label: 'Stand measures in minutes',
                      child: TextFormField(
                          controller: _standController,
                          focusNode: _standFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _standFocus, _stepsFocus);
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
    );
  }

  Widget stepsFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_steps_count.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your steps count',
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
                      tittle: 'Steps Information',
                      description:
                          'Steps will increase cardiovascular and pulmonary (heart and lung) fitness. reduced risk of heart disease and stroke. improved management of conditions such as hypertension (high blood pressure), high cholesterol, joint, and muscular pain or stiffness, and diabetes. stronger bones and improved balance.',
                      height: 288),
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
                      label: 'Steps count',
                      child: TextFormField(
                          focusNode: _stepsFocus,
                          controller: _stepscontroller,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _stepsFocus, _exerciseFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(100 to 125)',
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
    );
  }

  Widget exerciseFeilds() {
    return Card(
      semanticContainer: false,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('res/images/ic_exercise_person.png'),
                  size: 24,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Enter your exercise minutes',
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
                Expanded(
                  child: InfoScreen(
                      tittle: 'Exercise Information',
                      description:
                          'Fit in 150+\nGet at least 150 minutes per week of moderate-intensity aerobic activity or 75 minutes per week of vigorous aerobic activity (or a combination of both), preferably spread throughout the week.',
                      height: 248),
                ),
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
                      label: 'exercise in minutes',
                      child: TextFormField(
                          focusNode: _exerciseFocus,
                          controller: _exerciseController,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {},
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              //hintText: '(92 to 100)',
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
            Column(
              children: exersizeType
                  .map((data) => RadioListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(data.text),
                groupValue: id,
                value: data.index,
                onChanged: (dynamic val) {
                  setState(() {
                    radioItem = data.text;
                    id = data.index;
                  });
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  recordMyStandTimeInMinutes(int time) async {
    try {
      if (_standMovemntsTracking == null) {
        _sharedPrefUtils.save(
            'standTime', MovementsTracking(startDate, time, '').toJson());
      } else {
        _standMovemntsTracking!.value = _standMovemntsTracking!.value! + time;
        _sharedPrefUtils.save('standTime', _standMovemntsTracking!.toJson());
      }
      _standController.text = '';
      _standController.selection = TextSelection.fromPosition(
        TextPosition(offset: _standController.text.length),
      );
      clearAllFeilds();
      //showToast("Sodium intake added successfully", context);
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

  recordMyStepCount(int count) async {
    try {
      if (_stepsMovemntsTracking == null) {
        _sharedPrefUtils.save(
            'stepCount', MovementsTracking(startDate, count, '').toJson());
      } else {
        _stepsMovemntsTracking!.value = _stepsMovemntsTracking!.value! + count;
        _sharedPrefUtils.save('stepCount', _stepsMovemntsTracking!.toJson());
      }
      _stepscontroller.text = '';
      _stepscontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: _stepscontroller.text.length),
      );
      clearAllFeilds();
      //showToast("Sodium intake added successfully", context);
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

  recordMyExcerciseTimeInMinutes(int time) async {
    try {
      if (_exerciseMovemntsTracking == null) {
        _sharedPrefUtils.save(
            'exerciseTime', MovementsTracking(startDate, time, '').toJson());
      } else {
        _exerciseMovemntsTracking!.value =
            _exerciseMovemntsTracking!.value! + time;
        _exerciseMovemntsTracking!.date = startDate;
        _sharedPrefUtils.save(
            'exerciseTime', _exerciseMovemntsTracking!.toJson());
      }
      _exerciseController.text = '';
      _exerciseController.selection = TextSelection.fromPosition(
        TextPosition(offset: _exerciseController.text.length),
      );
      clearAllFeilds();
      //showToast("Sodium intake added successfully", context);
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

  bool toastDisplay = true;

  clearAllFeilds() {
    if (toastDisplay) {
      id = 0;
      radioItem = '';
      _scrollController.animateTo(0.0,
          duration: Duration(seconds: 2), curve: Curves.ease);
      showToast('Record Updated Successfully!', context);
      toastDisplay = false;
    }
    setState(() {

    });
  }

  recordMySteps() async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['StepCount'] = _stepscontroller.text;
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMySteps(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMyStand() async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Stand'] = _standController.text;
      map['Unit'] = 'Minutes';
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyStand(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
