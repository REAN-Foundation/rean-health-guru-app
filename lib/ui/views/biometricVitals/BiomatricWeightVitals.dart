

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyVitalsHistory.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/core/viewmodels/views/patients_vitals.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SimpleTimeSeriesChart.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';

class BiometricWeightVitalsView extends StatefulWidget {

  bool allUIViewsVisible = false;

  BiometricWeightVitalsView(bool allUIViewsVisible){
      this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _BiometricWeightVitalsViewState createState() => _BiometricWeightVitalsViewState();
}

class _BiometricWeightVitalsViewState extends State<BiometricWeightVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<Records> records = new List<Records>();
  var dateFormatStandard = DateFormat("MMM dd, yyyy");
  var _weightController = new TextEditingController();
  ProgressDialog progressDialog;
  String unit = 'Kg';

  CountryDetails details = CountryCodes.detailsForLocale();
  Locale locale = CountryCodes.getDeviceLocale();



  @override
  void initState() {
    getVitalsHistory();
    debugPrint('Country Local ==> ${details.alpha2Code}');
    // TODO: implement initState
    if(details.alpha2Code == "US"){
      unit = 'lbs';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    // TODO: implement build
    return BaseWidget<PatientVitalsViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child: widget.allUIViewsVisible ?
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'Weight',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
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
                      const SizedBox(height: 16,),
                      weightFeilds(),
                      const SizedBox(height: 16,),
                      weightHistoryListFeilds(),
                      const SizedBox(height: 16,),
                      records.length == 0 ? Container() : graph(),
                      //allGoal(),
                      const SizedBox(height: 16,),
                    ],
                  ),
                ),
              ),
            )
            :
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    /*const SizedBox(height: 16,),
                    weightFeilds(),
                    const SizedBox(height: 16,),*/
                    weightHistoryListFeilds(),
                    const SizedBox(height: 16,),
                    records.length == 0 ? Container() : graph(),
                    //allGoal(),
                    //const SizedBox(height: 16,),
                  ],
                ),
              ),
            ),
    );
  }

  Widget weightFeilds(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          Text(
            "Enter your weight:",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(8.0),
                      border: Border.all(
                          color: primaryColor, width: 1),
                      color: Colors.white),
                  child: TextFormField(
                      controller: _weightController,
                      maxLines: 1,
                      textInputAction:
                      TextInputAction.done,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (term) {

                      },
                      inputFormatters: [
                        new BlacklistingTextInputFormatter(new RegExp('[\\,|\\+|\\-]')),
                      ],
                      decoration: InputDecoration(
                          hintText: unit == "lbs" ? "(100 to 200)" : "(50 to 100)",
                          contentPadding: EdgeInsets.all(0),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true)),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: unit == "lbs" ? "    lbs    " : "    Kg    ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w700,
                              color: primaryColor,
                              fontFamily: 'Montserrat',
                              fontStyle:
                              FontStyle.italic)),
                    ]),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){

                if(_weightController.text.toString().isEmpty){
                  showToast('Please enter your weight');
                }else{
                  addvitals();
                }

              },
              child: Container(
                  height: 40,
                  width: 120,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: primaryColor, width: 1),
                    color: Colors.deepPurple,),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weightHistoryListFeilds(){
    return Container(
      color: colorF6F6FF,
      constraints: BoxConstraints(
          minHeight: 100, minWidth: double.infinity, maxHeight: 160),
      padding: EdgeInsets.only(left:16.0, right: 16.0, top: 16, bottom: 16),
      //height: 160,
      child: model.busy ? Center( child: CircularProgressIndicator(),) :
      (records.length == 0 ? noHistoryFound() :Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Date",
                  style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Weight ",
                  style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                    itemBuilder: (context, index) => _makeWeightList(context, index),
                    separatorBuilder: (BuildContext context, int index) {
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
    );
  }

  Widget noHistoryFound() {
    return Center(
      child: Text("No vital history found",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.deepPurple)),
    );
  }


  Widget _makeWeightList(BuildContext context, int index) {
    Records record = records.elementAt(index);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          dateFormatStandard.format(DateTime.parse(record.recordDate)),
          style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        Text(unit == "lbs" ? (double.parse(record.weight.toString()) * 2.20462 ).toStringAsFixed(1)+' lbs' :record.weight.toString()+" Kgs",
          style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w300), maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget graph(){
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: new BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [primaryLightColor, colorF6F6FF]),
                border: Border.all(color: primaryLightColor),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            padding: const EdgeInsets.all(16),
            height: 200,
            child: Center(
              child: SimpleTimeSeriesChart(_createSampleData()),
            ),
          ),
          const SizedBox(height: 8,),
          Text(
            'Weight',
            style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    List<TimeSeriesSales> data = new List<TimeSeriesSales>();
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for(int i = 0 ; i < records.length ; i++){
      String receivedWeight = unit == "lbs" ? (double.parse(records.elementAt(i).weight.toString()) * 2.20462 ).toStringAsFixed(1) : records.elementAt(i).weight.toString();
      data.add(new TimeSeriesSales(DateTime.parse(records.elementAt(i).recordDate), double.parse(receivedWeight)));
    }

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'vitals',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Widget allGoal(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
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
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Initial",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              Text(
                "85",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Target",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              Text(
                "65",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Latest",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              Text(
                "74",
                style: TextStyle( color: primaryColor,fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
        ],
      ),
    );
  }

  addvitals() async {
    try {
      progressDialog.show();

      double entertedWeight = double.parse(_weightController.text.toString());

      if(unit == 'lbs'){
        entertedWeight = entertedWeight / 2.20462;
      }


      var map = new Map<String, dynamic>();
      map['Weight'] = entertedWeight.toString();

      BaseResponse baseResponse  = await model.addMyVitals('weight', map);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        showToast(baseResponse.message);
        Navigator.pop(context);
      } else {
        progressDialog.hide();
        showToast(baseResponse.message);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  getVitalsHistory() async {
    try {
      GetMyVitalsHistory getMyVitalsHistory  = await model.getMyVitalsHistory('weight');
      if (getMyVitalsHistory.status == 'success') {
        records.clear();
        records.addAll(getMyVitalsHistory.data.biometrics.records);
      } else {
        showToast(getMyVitalsHistory.message);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

}