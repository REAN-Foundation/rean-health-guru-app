import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/models/get_all_physical_activity_data.dart';
import 'package:patient/features/common/activity/models/movements_tracking.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/simple_time_series_chart.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class ActivityExcersizeView extends StatefulWidget {
  bool allUIViewsVisible = false;
  late Function dataRefrshfunction;

  ActivityExcersizeView(bool allUIViewsVisible, @required Function dataRefrshfunction) {
    this.allUIViewsVisible = allUIViewsVisible;
    this.dataRefrshfunction = dataRefrshfunction;
  }

  @override
  _ActivityExcersizeViewState createState() =>
      _ActivityExcersizeViewState();
}

class _ActivityExcersizeViewState extends State<ActivityExcersizeView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<Items> records = <Items>[];
  var dateFormatExcersizeard = DateFormat('MMM dd, yyyy');
  final controller = TextEditingController();
  late ProgressDialog progressDialog;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  var dateFormat = DateFormat('yyyy-MM-dd');
  MovementsTracking? _exerciseMovemntsTracking;
  int stepsMovements = 0;

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    getVitalsHistory();
    todaysDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

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
              'Exercise',
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
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your Exercise :',
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: InfoScreen(
                    tittle: 'Weight Information',
                    description:
                        'Achieving and maintaining a healthy weight is beneficial in loweing your risk for heart disease and stroke. Please refer to your doctor\'s recommended healthy weight range and frequency of measuring your weight at home.',
                    height: 240),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Exercise measures in minutes',
                    child: TextFormField(
                        controller: controller,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (term) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\+|\\-|\\a-zA-Z|\\ ]')),
                        ],
                        decoration: InputDecoration(
                          //hintText: unit == 'lbs' ? '(100 to 200)' : '(50 to 100)',
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: '    Min    ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textBlack,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ]),
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
                  FirebaseAnalytics.instance.logEvent(name: 'activity_Excersize_save_button_click');
                  if (controller.text.toString().isEmpty) {
                    showToast('Please enter your Exercise in minutes', context);
                  } else if(isNumeric(controller.text)) {
                    progressDialog.show(max: 100, msg: 'Loading...');
                    double entertedWeight = double.parse(controller.text.toString());


                    addvitals(entertedWeight.toStringAsFixed(1));
                  } else{
                    showToast('Please enter valid input', context);
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
        ],
      ),
    );
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
                            child: Text('Exercise\n(hr:min)',
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

    String valueToDisplay = record.durationInMin.toString();
    if(record.durationInMin == null){
      valueToDisplay = "00:00";
    }else{
      valueToDisplay = Conversion.durationFromMinToHrsOnlyDigit(record.durationInMin!.toInt());
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
                  dateFormatExcersizeard.format(records
                              .elementAt(index)
                              .createdAt ==
                          null
                      ? DateTime.now()
                      : DateTime.parse(records.elementAt(index).createdAt!)),
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
                label: 'Excercise ',
                readOnly: true,
                child: Text(valueToDisplay,
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
              'Exercise',
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
      if(records.elementAt(i).durationInMin != null) {
        data.add(TimeSeriesSales(
            DateTime.parse(records
                .elementAt(i)
                .createdAt!).toLocal(),
            double.parse(records
                .elementAt(i)
                .durationInMin
                .toString())));
      }
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


  addvitals(String bodyWeight) async {
    try {

      /*double entertedWeight = double.parse(bodyWeight);

      if (unit == 'lbs') {
        entertedWeight = entertedWeight / 2.20462;
      }*/

      final map = <String, dynamic>{};
      map['BodyWeight'] = bodyWeight;
      map['PatientUserId'] = "";
      map['Unit'] = "kg";

      final BaseResponse baseResponse =
      await model.recordMyExcercise(map);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        controller.clear();
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
          await model.deleteExcersizeRecord(recordId);

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
      final GetAllPhysicalActivityData getAllActivityRecord =
      await model.getMyExcersizeHistory();
      if (getAllActivityRecord.status == 'success') {
        if(progressDialog.isOpen()) {
          progressDialog.close();
        }
        records.clear();
        records.addAll(getAllActivityRecord.data!.physicalActivities!.items!);
        if(records.isNotEmpty) {
          dataSync();
        }else{
          _exerciseMovemntsTracking!.date = todaysDate;
          _exerciseMovemntsTracking!.value = 0;
          _sharedPrefUtils.save('exerciseTime', _exerciseMovemntsTracking!.toJson());
          widget.dataRefrshfunction();
        }

      } else {
        if(progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(getAllActivityRecord.message!, context);
      }
    } on FetchDataException catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  DateTime? todaysDate;

  dataSync() async {
    try {
      debugPrint("Todays date stepCount ==> ${dateFormat.format(todaysDate!)}");
      debugPrint("Todays date stepCount 1 ==> ${dateFormat.format(DateTime.parse(records.elementAt(0).createdAt!))}");

      if(dateFormat.format(todaysDate!) == dateFormat.format(DateTime.parse(records.elementAt(0).createdAt!))) {
        if(records.elementAt(0).durationInMin == null) {
          debugPrint("Todays date excersize 2 ==> In min => ${records
              .elementAt(0)
              .durationInMin}");
          _exerciseMovemntsTracking!.date = todaysDate;
          _exerciseMovemntsTracking!.value = records
              .elementAt(0)
              .durationInMin;
          _sharedPrefUtils.save(
              'exerciseTime', _exerciseMovemntsTracking!.toJson());
        }else{
          _exerciseMovemntsTracking!.date = todaysDate;
          _exerciseMovemntsTracking!.value = 0;
          _sharedPrefUtils.save('exerciseTime', _exerciseMovemntsTracking!.toJson());
        }
      }else{
        _exerciseMovemntsTracking!.date = todaysDate;
        _exerciseMovemntsTracking!.value = 0;
        _sharedPrefUtils.save('exerciseTime', _exerciseMovemntsTracking!.toJson());
      }
      widget.dataRefrshfunction;
      //(context as Element).reassemble();
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

}
