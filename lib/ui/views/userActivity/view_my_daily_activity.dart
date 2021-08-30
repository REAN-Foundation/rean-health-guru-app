import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health/health.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GlassOfWaterConsumption.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/core/viewmodels/views/patients_vitals.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/userActivity/addBMIDetailsDialog.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import '../base_widget.dart';


class ViewMyDailyActivity extends StatefulWidget {
  @override
  _ViewMyDailyActivityState createState() => _ViewMyDailyActivityState();
}

class _ViewMyDailyActivityState extends State<ViewMyDailyActivity> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat("yyyy-MM-dd");

  int steps = 0;
  double weight = 0;
  double height = 0;
  double totalActiveCalories = 0;
  double totalBasalCalories = 0;
  double totalCalories = 0;
  double bmiValue = 0;
  int waterGlass = 0;
  String bmiResult = '';
  Color bmiResultColor = Colors.black87;
  GlassOfWaterConsumption glassOfWaterConsumption;
  DateTime startDate;
  DateTime endDate;

  loadSharedPref() async {

    height = await _sharedPrefUtils.readDouble('height');
    weight = await _sharedPrefUtils.readDouble('weight');

    if(height == 0.0 || weight == 0.0){
      showDialog(
          context: context,
          builder: (_) {
            return _addBMIDetailsDialog(context);
          });
    }else{
      calculetBMI();
    }

  }

  loadWaterConsuption() async {
    var waterConsuption = await _sharedPrefUtils.read("waterConsumption");

    if(waterConsuption != null) {
      glassOfWaterConsumption = GlassOfWaterConsumption.fromJson(waterConsuption);
    }

    if(glassOfWaterConsumption != null) {
      if (startDate == glassOfWaterConsumption.date) {
        waterGlass = glassOfWaterConsumption.count;
      }
    }
  }

  @override
  void initState() {
    startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
    loadSharedPref();
    loadWaterConsuption();
    if(Platform.isIOS) {
      fetchData();
    }
    super.initState();
  }

  Future<void> fetchData() async {
    /// Get everything from midnight until now
    //DateTime startDate = DateTime(2021, 01, 01, 0, 0, 0);
    //DateTime endDate = DateTime(2021, 07, 07, 23, 59, 59);

    /*startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);*/



    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      //HealthDataType.BASAL_ENERGY_BURNED,
      //HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;
    //this.steps = 0;
    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        print("Data point:  $x");
        steps += x.value.round();
      });

      //print("Steps: $steps");

      //this.steps = steps;

      /// Update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40,),
        stepCounter(),
        SizedBox(height: 16,),
        calories(),
        SizedBox(height: 8,),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: heartRate()),
            SizedBox(width: 8,),
            Expanded(
                flex: 1,
                child: bmi()),
          ],
        ),
        SizedBox(height: 8,),
        glassForWater(),
        SizedBox(height: 8,),
        sleep(),*/
      ],
    );
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text(''); //Press the download button to fetch data
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  _content() {
    if (_state == AppState.DATA_READY) {
      calculateSteps();
      debugPrint('DATA_READY');
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA) {
      debugPrint('NO_DATA');
      return _contentDataReady();
    } else if (_state == AppState.FETCHING_DATA){
      debugPrint('FETCHING_DATA');
      return _contentFetchingData();
    }else if (_state == AppState.AUTH_NOT_GRANTED) {
      debugPrint('AUTH_NOT_GRANTED');
      return _authorizationNotGranted();
    }
    return _contentNotFetched();
  }

  calculateSteps(){
    clearAllRecords();
    for(int i = 0 ; i < _healthDataList.length ; i++){
      HealthDataPoint p = _healthDataList[i];
      if(p.typeString == 'STEPS'){
        steps = steps + p.value.toInt();
      }else if(p.typeString == 'WEIGHT'){
        if(p.value.toDouble() != 0) {
          //weight = p.value.toDouble();
        }
      }else if(p.typeString == 'HEIGHT'){
        if(p.value.toDouble() != 0) {
          //height = p.value.toDouble() * 100;
        }
      }else if(p.typeString == 'ACTIVE_ENERGY_BURNED'){
        totalActiveCalories = totalActiveCalories + p.value.toDouble();
      }else if(p.typeString == 'BASAL_ENERGY_BURNED'){
        totalBasalCalories = totalBasalCalories + p.value.toDouble();
      }
    }

    if(height == 0.0 || weight == 0.0){

    }else{
      calculetBMI();
    }

    totalCalories = totalActiveCalories + totalBasalCalories;

    debugPrint('STEPS : ${steps}');
    debugPrint('ACTIVE_ENERGY_BURNED : ${totalActiveCalories}');
    debugPrint('BASAL_ENERGY_BURNED : ${totalBasalCalories}');
    debugPrint('CALORIES_BURNED : ${totalBasalCalories}');
    debugPrint('WEIGHT : ${weight}');
    debugPrint('Height : ${height}');
    //recordMySteps();
    //recordMyCalories();
  }

  calculetBMI(){

    double heightInMeters = height / 100 ;
    double heightInMetersSquare = heightInMeters * heightInMeters;

    bmiValue = weight / heightInMetersSquare;

    if(bmiValue == 0.0) {
      bmiResult = '';
    }else if(bmiValue < 18.5) {
      bmiResult = 'Underweight';
      bmiResultColor = Colors.indigoAccent;
    }else if(bmiValue > 18.6 && bmiValue < 24.9){
      bmiResult = 'Healthy';
      bmiResultColor = Colors.green;
    }else if(bmiValue > 25 && bmiValue < 29.9){
      bmiResult = 'Overweight';
      bmiResultColor = Colors.orange;
    }else if(bmiValue > 30 && bmiValue < 39.9){
      bmiResult = 'Obese';
      bmiResultColor = Colors.deepOrange;
    }else{
      bmiResult = 'Severely Obese';
      bmiResultColor = Colors.red;
    }

    if(Platform.isAndroid) {
      setState(() {

      });
    }


    /*new Timer(const Duration(milliseconds: 3000), () {
      setState(() {
      });
    });
*/
  }

  clearAllRecords(){
    //bmiValue = 0 ;
    totalActiveCalories = 0;
    totalBasalCalories = 0;
    totalCalories = 0;
    steps = 0;
    //weight = 0;
    //height = 0;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientHealthMarkerViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child:  Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'Activity',
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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _content(),
                      bmi(),
                      glassForWater()
                    ],
                  ),
                ),
              )
            ),
          ),
    );
  }

  Widget stepCounter(){
    double stepPercent = steps / 10000;
    if(stepPercent > 1.0){
      stepPercent = 1.0;
    }
    debugPrint('Step % : ${stepPercent}');
    return Align(
      alignment: Alignment.center,
      child: CircularPercentIndicator(
        radius: 160.0,
        lineWidth: 13.0,
        animation: true,
        percent: stepPercent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage('res/images/ic_steps_count.png'),
              size: 32,
              color: Colors.deepPurple,),
            SizedBox(height: 8,),
            Text(
              steps.toString(),
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.deepPurple),
            ),
          ],
        ),
        footer: Column(
          children: [
            SizedBox(height: 16,),
            new Text(
              "Steps",
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.deepPurple),
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.deepPurple,
      ),
    );
  }

  Widget calories(){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage('res/images/ic_calories.png'),
                  size: 24,
                  color: colorOrange,),
                SizedBox(width: 8,),
                Text(
                  "Calories",
                  style:
                  new TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0, color: colorOrange),
                ),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  totalCalories.toStringAsFixed(0),
                  style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, color: primaryColor),
                ),
                SizedBox(width: 8,),
                Text(
                  "Cal",
                  style:
                  new TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget heartRate(){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage('res/images/ic_activity_heart_rate.png'),
                  size: 24,
                  color: Colors.deepPurple,),
                SizedBox(width: 8,),
                Text(
                  "Heart Rate",
                  style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: primaryColor),
                ),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "72",
                  style:
                  new TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, color: primaryColor),
                ),
                SizedBox(width: 4,),
                Text(
                  "bmp",
                  style:
                  new TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bmi(){
    int bmiLeftSideValue = 0;
    int bmiRightSideValue = 0;
    if(bmiValue != 0.0) {
       bmiLeftSideValue = int.parse(bmiValue.toStringAsFixed(0)) - 1;
       bmiRightSideValue = (60 - int.parse(bmiValue.toStringAsFixed(0))) - 1;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(AssetImage('res/images/ic_bmi.png'),
                      size: 24,
                      color: colorGreen,),
                    SizedBox(width: 8,),
                    Text(
                      "BMI",
                      style:
                      new TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0, color: colorGreen),
                    ),
                  ],
                ),

                InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (_) {
                            return _addBMIDetailsDialog(context);
                          });
                    },
                    child: Icon(Icons.edit_rounded, size: 20, color: Colors.black87,))
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      bmiValue == 0.0 ? 'Edit yout height & weight for BMI' : bmiValue.toStringAsFixed(2),
                      style:
                      new TextStyle(fontWeight: FontWeight.w500, fontSize: bmiValue == 0.0 ? 14 : 28.0, color: primaryColor),
                    ),
                    SizedBox(width: 4,),
                    Text(
                      bmiValue == 0.0 ? '' : "Kg / m sq",
                      style:
                      new TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
                Text(
                  bmiResult,
                  style:
                  new TextStyle(fontSize: 16.0, color: bmiResultColor, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 8,),
           bmiValue != 0.0 ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded( flex: bmiLeftSideValue, child: Container()),
                      Expanded( flex : 2, child: ImageIcon( AssetImage('res/images/triangle.png'))),
                      Expanded( flex : bmiRightSideValue, child: Container())
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('res/images/bmi_scale.png')
                ),
              ],
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget glassForWater(){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(AssetImage('res/images/ic_glass_of_water.png'),
                      size: 24,
                      color: colorLightBlue,),
                    SizedBox(width: 8,),
                    Text(
                      "Water",
                      style:
                      new TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0, color: colorLightBlue),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      waterGlass.toString(),
                      style:
                      new TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, color: primaryColor),
                    ),
                    SizedBox(width: 4,),
                    Text(
                      "glasses",
                      style:
                      new TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 00,
              top: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Icon(Icons.remove_circle, color: colorLightBlue, size: 40,),
                  SizedBox(width: 8,),
                  InkWell( onTap: (){ recordMyWaterConsumptions(); }, child: Icon(Icons.add_circle, color: colorLightBlue, size: 40,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget sleep(){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(AssetImage('res/images/ic_sleep_moon.png'),
                      size: 24,
                      color: Colors.deepPurple,),
                    SizedBox(width: 8,),
                    Text(
                      "Sleep",
                      style:
                      new TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      "6",
                      style:
                      new TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, color: primaryColor),
                    ),
                    SizedBox(width: 4,),
                    Text(
                      "hrs",
                      style:
                      new TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      "32",
                      style:
                      new TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, color: primaryColor),
                    ),
                    SizedBox(width: 4,),
                    Text(
                      "min",
                      style:
                      new TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 00,
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Colors.black87, size: 24,),
                  SizedBox(width: 8,),
                  Text(
                    "You didn’t have\nenough sleep.\nIts better to sleep\n7-9 hours every day",
                    textAlign: TextAlign.justify,
                    style:
                    new TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _addBMIDetailsDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 340,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Biometrics',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                    ),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(child: AddBMIDetailDialog( submitButtonListner: (double weight, double height){
                _sharedPrefUtils.saveDouble('height', height);
                _sharedPrefUtils.saveDouble('weight', weight);
                this.height = height;
                this.weight = weight;
                calculetBMI();
                debugPrint('Height : ${height}  Weight: ${weight}');
                Navigator.of(context, rootNavigator: true).pop();
              }, height: height, weight: weight,),)
            ],
          ),
        )
    );
  }


  recordMyCalories() async {
    try {
      var map = new Map<String, dynamic>();
      map['PatientUserId'] = patientUserId;
      map['ActiveCalories'] = totalActiveCalories;
      map['BasalCalories'] = totalBasalCalories;
      map['RecordDate'] = dateFormat.format(new DateTime.now());

      BaseResponse baseResponse  = await model.recordMyCalories(map);
      if (baseResponse.status == 'success') {

      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  recordMySteps() async {
    try {
      var map = new Map<String, dynamic>();
      map['PatientUserId'] = patientUserId;
      map['Steps'] = steps;
      map['DistanceCovered_Km'] = 0;
      map['RecordDate'] = dateFormat.format(new DateTime.now());

      BaseResponse baseResponse  = await model.recordMySteps(map);
      if (baseResponse.status == 'success') {

      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }

  recordMyWaterConsumptions() async {
    try {

      waterGlass = waterGlass + 1;

      _sharedPrefUtils.save(
          'waterConsumption',
          GlassOfWaterConsumption(startDate, waterGlass, '')
              .toJson());

      var map = new Map<String, dynamic>();
      map['PatientUserId'] = patientUserId;
      map['WaterConsumed'] = waterGlass;
      map['RecordDate'] = dateFormat.format(new DateTime.now());

      BaseResponse baseResponse  = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {

      } else {
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
  }


}