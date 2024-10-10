import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/get_sleep_history_data.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/simple_time_series_chart.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class ActivitySleepView extends StatefulWidget {
  bool allUIViewsVisible = false;

  ActivitySleepView(bool allUIViewsVisible) {
    this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _ActivitySleepViewState createState() =>
      _ActivitySleepViewState();
}

class _ActivitySleepViewState extends State<ActivitySleepView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<Items> records = <Items>[];
  var dateFormatSleepard = DateFormat('MMM dd, yyyy');
  var sleepInHrsController = TextEditingController();
  var sleepInMinController = TextEditingController();
  var sleepInMinFocus = FocusNode();
  var sleepInHrsFocus = FocusNode();
  late ProgressDialog progressDialog;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  MovementsTracking? _sleepTracking;
  //MovementsTracking? _sleepTrackingMin;
  DateTime? startDate;
  var dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? todaysDate;


  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    getVitalsHistory();
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    debugPrint('Start Date $startDate');

    loadSharedPref();
    super.initState();
  }

  loadSharedPref() async {

  }



  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: widget.allUIViewsVisible
            ? Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              'Sleep',
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                        const SizedBox(
                          height: 16,
                        ),
                        weightFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (records.isEmpty) Container() else graph(),
                        //allGoal(),
                        const SizedBox(
                          height: 16,
                        ),
                        weightHistoryListFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
              ),
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                    /*const SizedBox(height: 16,),
                    weightFeilds(),
                    const SizedBox(height: 16,),*/
                    if (records.isEmpty) Container() else graph(),
                    const SizedBox(
                      height: 16,
                    ),
                    weightHistoryListFeilds(),
                    //allGoal(),
                    //const SizedBox(height: 16,),
                  ],
                ),
              ),
      ),
    );
  }


  Widget weightFeilds() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Enter your sleep in hours and minutes',
            style: TextStyle(
                color: textBlack,
                fontWeight: FontWeight.w600,
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8,),
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
                    label: 'Sleep measures in ',
                    child: TextFormField(
                        controller: sleepInHrsController,
                        focusNode: sleepInHrsFocus,
                        maxLines: 1,
                        maxLength: 2,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onChanged: (data){
                          if(int.parse(data) > 23){
                            showToast("Please enter valid hours", context);
                            sleepInHrsController.clear();
                            sleepInHrsController.text = data.substring(0,1);
                            sleepInHrsController.selection = TextSelection.fromPosition(
                              TextPosition(offset: sleepInHrsController.text.length),
                            );
                            setState(() {

                            });
                          }
                        },
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, sleepInHrsFocus,
                              sleepInMinFocus);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\.|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Hours',
                            counterText: "",
                            suffixIcon: Padding(padding: EdgeInsets.fromLTRB(40,15, 0, 0),  child: Text("hr")),
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(4,15,0,0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Sleep measures in ',
                    child: TextFormField(
                        controller: sleepInMinController,
                        focusNode: sleepInMinFocus,
                        maxLines: 1,
                        maxLength: 2,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onChanged: (data){
                          if(int.parse(data) > 59){
                            showToast("Please enter valid minutes", context);
                            sleepInMinController.clear();
                            sleepInMinController.text = data.substring(0,1);
                            sleepInMinController.selection = TextSelection.fromPosition(
                              TextPosition(offset: sleepInMinController.text.length),
                            );
                            setState(() {

                            });
                          }
                        },
                        onFieldSubmitted: (term) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\.|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintText: 'Minutes',
                            counterText: "",
                            suffixIcon: Padding(padding: EdgeInsets.fromLTRB(40,15, 0, 0),  child: Text("min")),
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(4,15,0,0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              label: "Save",
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'activity_stand_save_button_click');
                  if(sleepInHrsController.text.isEmpty && sleepInMinController.text.isEmpty ){
                    showToast('Please enter valid input', context);
                  }else {
                    if (sleepInHrsController.text.isNotEmpty ||
                        sleepInMinController.text.isNotEmpty) {
                      addSleep();
                    }
                  }
                },
                child: ExcludeSemantics(
                  child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
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
          SizedBox(
            height: 20,
          ),
          /*Container(
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
                    )*/
        ],
      )
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  Widget weightHistoryListFeilds() {
    return Container(
      color: colorF6F6FF,
      constraints: BoxConstraints(
          minHeight: 160, minWidth: double.infinity, maxHeight: 200),
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 16),
      //height: 160,
      child: model.busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (records.isEmpty
              ? noHistoryFound()
              : Column(
                  children: [
                    Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Date',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('Sleep\n(hr:min)',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ExcludeSemantics(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                              ),
                            ),
                          )
                        ],
            ),
          ),
          const SizedBox(
            height: 8,
                    ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        _makeWeightList(context, index),
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return SizedBox(
                        height: 0,
                                );
                    },
                    itemCount: records.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget noHistoryFound() {
    return Center(
      child: Text('No history found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeWeightList(BuildContext context, int index) {
    final Items record = records.elementAt(index);
    String valuetoDisplay = record.sleepDuration.toString();

    if(record.sleepMinutes == null){
      valuetoDisplay = valuetoDisplay + ":00";
    }else{
      valuetoDisplay = valuetoDisplay + ":"+record.sleepMinutes.toString();
    }

    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: colorF6F6FF,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Semantics(
                child: Text(
                  dateFormatSleepard.format(records
                              .elementAt(index)
                              .recordDate ==
                          null
                      ? DateTime.now()
                      : DateTime.parse(records.elementAt(index).recordDate!)),
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Semantics(
                label: 'Sleep ',
                readOnly: true,
                child: Text(valuetoDisplay,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  ConfirmationBottomSheet(
                      context: context,
                      height: 180,
                      onPositiveButtonClickListner: () {
                        //debugPrint('Positive Button Click');
                        deleteVitals(record.id.toString());
                      },
                      onNegativeButtonClickListner: () {
                        //debugPrint('Negative Button Click');
                      },
                      question: 'Are you sure you want to delete this record?',
                      tittle: 'Alert!');
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: primaryColor,
                  size: 24,
                  semanticLabel:'Delete',
                ))
          ],
        ),
      ),
    );
  }

  Widget graph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Semantics(
        label: 'Showing the graph for ',
        readOnly: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [primaryLightColor, colorF6F6FF]),
                  border: Border.all(color: primaryLightColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: const EdgeInsets.all(16),
              height: 250,
              child: Center(
                child: SimpleTimeSeriesChart(_createSampleData()),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Sleep',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordDate!).toLocal(),
          double.parse(records.elementAt(i).sleepDuration.toString())));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'vitals',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  clearAllFeilds() {
    /*if (toastDisplay) {
      _scrollController.animateTo(0.0,
          duration: Duration(seconds: 2), curve: Curves.ease);
      showSuccessToast('Record Updated Successfully!', context);
      toastDisplay = false;
    }*/
  }

  addSleep() async {
    try {

      String sleepHrsInTextFeild = sleepInHrsController.text.isNotEmpty ? sleepInHrsController.text : "0";
      String sleepMinInTextFeild = sleepInMinController.text.isNotEmpty ? sleepInMinController.text : "0";

      if(sleepHrsInTextFeild.isNotEmpty  || sleepMinInTextFeild.isNotEmpty) {
        if (_sleepTracking == null) {
          debugPrint("123 ");
          _sharedPrefUtils.save(
              'sleepTime', MovementsTracking(startDate, int.parse(sleepHrsInTextFeild), sleepMinInTextFeild).toJson());
        } else {
          debugPrint("456 ");
          _sleepTracking!.value = int.parse(sleepHrsInTextFeild.toString());
          _sleepTracking!.date = startDate;
          _sleepTracking!.discription = sleepMinInTextFeild;
          _sharedPrefUtils.save('sleepTime', _sleepTracking!.toJson());
        }
        clearAllFeilds();
        //showToast("Sleep time recorded successfully", context);
      }
      setState(() {});
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['SleepDuration'] = sleepHrsInTextFeild;
      map['SleepMinutes'] = sleepMinInTextFeild;
      map['Unit'] = 'Hrs';
      map['RecordDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
      await model.recordMySleep(map);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        sleepInHrsController.clear();
        sleepInMinController.clear();
        showSuccessToast(baseResponse.message!, context);
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  deleteVitals(String recordId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      final BaseResponse baseResponse =
          await model.deleteSleepRecord(recordId);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        showSuccessToast(baseResponse.message!, context);
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getVitalsHistory() async {
    try {
      final GetSleepHistoryData getAllRecord =
      await model.getMySleepHistory();
      if (getAllRecord.status == 'success') {
        if(progressDialog.isOpen()) {
          progressDialog.close();
        }
        records.clear();
        records.addAll(getAllRecord.data!.sleepRecords!.items!);
        records.reversed.toList();
        setState(() {

        });

      } else {
        if(progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(getAllRecord.message!, context);
      }
    } on FetchDataException catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
