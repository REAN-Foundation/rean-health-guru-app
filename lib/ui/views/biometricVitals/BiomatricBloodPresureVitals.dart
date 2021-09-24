import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyVitalsHistory.dart';
import 'package:paitent/core/viewmodels/views/patients_vitals.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SimpleTimeSeriesChart.dart';
import 'package:progress_dialog/progress_dialog.dart';
//ignore: must_be_immutable
class BiometricBloodPresureVitalsView extends StatefulWidget {
  bool allUIViewsVisible = false;

  BiometricBloodPresureVitalsView(bool allUIViewsVisible) {
    this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _BiometricBloodPresureVitalsViewState createState() =>
      _BiometricBloodPresureVitalsViewState();
}

class _BiometricBloodPresureVitalsViewState
    extends State<BiometricBloodPresureVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  List<Records> records = <Records>[];
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _systolicFocus = FocusNode();
  final _diastolicFocus = FocusNode();

  ProgressDialog progressDialog;

  @override
  void initState() {
    getVitalsHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return BaseWidget<PatientVitalsViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: widget.allUIViewsVisible
            ? Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  title: Text(
                    'Blood Pressure',
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        bloodPresureFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                        historyListFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (records.isEmpty) Container() else _systolicgraph(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (records.isEmpty) Container() else _diastolicgraph(),
                        //allGoal(),
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
                    /*bloodPresureFeilds(),
                    const SizedBox(height: 16,),*/
                    historyListFeilds(),
                    const SizedBox(
                      height: 16,
                    ),
                    if (records.isEmpty) Container() else _systolicgraph(),
                    const SizedBox(
                      height: 16,
                    ),
                    if (records.isEmpty) Container() else _diastolicgraph(),
                    //allGoal(),
                    //const SizedBox(height: 16,),
                  ],
                ),
              ),
      ),
    );
  }

  Widget bloodPresureFeilds() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: MergeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                'Enter your blood pressure:',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Systolic',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: '  mm Hg     ',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic)),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: Colors.white),
                      child: Semantics(
                        label: 'between',
                        readOnly: true,
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\,|\\+|\\-]')),
                            ],
                            controller: _systolicController,
                            focusNode: _systolicFocus,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _systolicFocus, _diastolicFocus);
                            },
                            decoration: InputDecoration(
                                hintText: '(80 to 120)',
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Diastolic',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: '  mm Hg  ',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic)),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: Colors.white),
                      child: TextFormField(
                          controller: _diastolicController,
                          focusNode: _diastolicFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\,|\\+|\\-]')),
                          ],
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            /*_fieldFocusChange(
                              context,
                              _diastolicFocus,
                              _weightFocus);*/
                          },
                          decoration: InputDecoration(
                              hintText: '(60 to 80)',
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (_systolicController.text.toString().isEmpty) {
                        showToast('Please enter your systolic blood presure',
                            context);
                      } else if (_diastolicController.text.toString().isEmpty) {
                        showToast('Please enter your diastolic blood presure',
                            context);
                      } else {
                        addvitals();
                      }
                    },
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
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget historyListFeilds() {
    return ExcludeSemantics(
      child: Container(
        color: colorF6F6FF,
        constraints: BoxConstraints(
            minHeight: 100, minWidth: double.infinity, maxHeight: 160),
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 16),
        height: 160,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Systolic',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Diastolic ',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    _makeWeightList(context, index),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
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
      ),
    );
  }

  Widget noHistoryFound() {
    return Center(
      child: Text('No vital history found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeWeightList(BuildContext context, int index) {
    final Records record = records.elementAt(index);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              dateFormatStandard.format(DateTime.parse(record.recordDate)),
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                record.systolicBloodPressure.toString() + ' mm Hg',
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
            flex: 1,
            child: Center(
              child: Text(
                record.diastolicBloodPressure.toString() + ' mm Hg',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _systolicgraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
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
            height: 200,
            child: Center(
              child: SimpleTimeSeriesChart(_createSampleDatasystolic()),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Systolic Blood Pressure',
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleDatasystolic() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(DateTime.parse(records.elementAt(i).recordDate),
          double.parse(records.elementAt(i).systolicBloodPressure.toString())));
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

  Widget _diastolicgraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
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
            height: 200,
            child: Center(
              child: SimpleTimeSeriesChart(_createSampleDataDiastolic()),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Diastolic Blood Pressure',
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleDataDiastolic() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordDate),
          double.parse(
              records.elementAt(i).diastolicBloodPressure.toString())));
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

  Widget allGoal() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Container(
            height: 60,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16,),
                ImageIcon(
                  AssetImage('res/images/ic_dart_goal.png'),
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 8,),
                Text(
                  "Your progress with goals",
                  style: TextStyle( color: Colors.white,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),*/
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Systolic',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Diastolic ',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Initial',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '160',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '100',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Target',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '130',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '80',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Latest',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '140',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '90',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Systolic',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 10,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 10,
                    color: primaryLightColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Diastolic',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 10,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 10,
                    color: primaryLightColor,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  addvitals() async {
    try {
      progressDialog.show();
      final map = <String, dynamic>{};
      map['SystolicBloodPressure'] = _systolicController.text.toString();
      map['DiastolicBloodPressure'] = _diastolicController.text.toString();

      final BaseResponse baseResponse =
          await model.addMyVitals('blood-pressure', map);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        showToast(baseResponse.message, context);
        Navigator.pop(context);
      } else {
        progressDialog.hide();
        showToast(baseResponse.message, context);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getVitalsHistory() async {
    try {
      final GetMyVitalsHistory getMyVitalsHistory =
          await model.getMyVitalsHistory('blood-pressure');
      if (getMyVitalsHistory.status == 'success') {
        records.clear();
        records.addAll(getMyVitalsHistory.data.biometrics.records);
      } else {
        showToast(getMyVitalsHistory.message, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
