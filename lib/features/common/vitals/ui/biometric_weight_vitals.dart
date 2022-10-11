import 'dart:io';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/activity/ui/add_height_cm_dialog.dart';
import 'package:patient/features/common/activity/ui/add_height_ft_n_Inch_dialog.dart';
import 'package:patient/features/common/vitals/models/get_my_vitals_history.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/conversion.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/simple_time_series_chart.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class BiometricWeightVitalsView extends StatefulWidget {
  bool allUIViewsVisible = false;

  BiometricWeightVitalsView(bool allUIViewsVisible) {
    this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _BiometricWeightVitalsViewState createState() =>
      _BiometricWeightVitalsViewState();
}

class _BiometricWeightVitalsViewState extends State<BiometricWeightVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<Items> records = <Items>[];
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _weightController = TextEditingController();
  late ProgressDialog progressDialog;
  String unit = 'Kg';
  GetHealthData getHealthData = GetIt.instance<GetHealthData>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  double weight = 0;
  int height = 0;
  double bmiValue = 0;
  String bmiResult = '';
  Color bmiResultColor = Colors.black87;
  int heightInFt = 1;
  int heightInInch = 0;
  String heightInDouble = '0.0';
  late var heightArry;

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    getVitalsHistory();
    debugPrint('Country Local ==> ${getCurrentLocale()}');
    if (getCurrentLocale() == 'US') {
      unit = 'lbs';
    }

    loadSharedPref();

    getVitalsFromDevice();
    super.initState();
  }

  loadSharedPref() async {
    var heightStored = await _sharedPrefUtils.readDouble('height');
    debugPrint('Height Stored ==> $heightStored');
    height = heightStored.toInt();
    weight = await _sharedPrefUtils.readDouble('weight');

    debugPrint('Height ==> $height');

    if (height != 0.0) {
      debugPrint('Height In ==> $height');
      conversion();
      calculetBMI();
    }
  }

  conversion() {
    if (height != 0.0) {
      debugPrint('Conversion Height in cms => $height');
      heightInDouble = Conversion.cmToFeet(height.toInt());
      debugPrint('Conversion Height in ft & inch => $heightInDouble');
      heightArry = heightInDouble.toString().split('.');
      heightInFt = int.parse(heightArry[0]);
      heightInInch = int.parse(heightArry[1]);

      if(heightInInch == 12){
        heightInFt = heightInFt + 1;
        heightInInch = 0;
        heightInDouble = heightInFt.toString()+'.0';
      }
      debugPrint('Conversion Height => $heightInFt ft $heightInInch inch');
    }
  }

  getVitalsFromDevice() {
    if (getHealthData.getWeight() != '0.0') {
      _weightController.text = getHealthData.getWeight();
      _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientVitalsViewModel?>(
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
              'Weight',
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
                        bmi(),
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

  calculetBMI() {
    debugPrint('Height ==> $height');
    debugPrint('Weight ==> $weight');

    final double heightInMeters = height / 100;
    final double heightInMetersSquare = heightInMeters * heightInMeters;

    bmiValue = weight.roundToDouble() / heightInMetersSquare;

    if (bmiValue == 0.0) {
      bmiResult = '';
    } else if (bmiValue < 18.5) {
      bmiResult = 'Underweight';
      bmiResultColor = Colors.indigoAccent;
    } else if (bmiValue > 18.6 && bmiValue < 24.9) {
      bmiResult = 'Healthy';
      bmiResultColor = Colors.green;
    } else if (bmiValue > 25 && bmiValue < 29.9) {
      bmiResult = 'Overweight';
      bmiResultColor = Colors.orange;
    } else if (bmiValue > 30 && bmiValue < 39.9) {
      bmiResult = 'Obese';
      bmiResultColor = Colors.deepOrange;
    } else {
      bmiResult = 'Severely Obese';
      bmiResultColor = Colors.red;
    }

    if (Platform.isAndroid) {
      setState(() {});
    }

    /*new Timer(const Duration(milliseconds: 3000), () {
      setState(() {
      });
    });
*/
  }

  Widget bmi() {
    int bmiLeftSideValue = 0;
    int bmiRightSideValue = 0;
    debugPrint('BMI Value ==> $bmiValue');
    if (bmiValue != 0.0) {
      bmiLeftSideValue = int.parse(bmiValue.toStringAsFixed(0)) - 1;
      bmiRightSideValue = (60 - int.parse(bmiValue.toStringAsFixed(0))) - 1;
    }

    return Card(
      semanticContainer: false,
      elevation: 0,
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
                    ImageIcon(
                      AssetImage('res/images/ic_bmi.png'),
                      size: 24,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'BMI',
                      semanticsLabel: 'BMI',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    records.isNotEmpty
                        ? Container()
                        : Text(
                            '(Add your weight to see BMI)',
                            semanticsLabel: 'Add your weight to see BMI',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0,
                                color: textBlack),
                          ),
                    InfoScreen(
                        tittle: 'BMI Information',
                        description:
                            'BMI stands for Body Mass Index.\nBMI is an indicator of the amount of body fat for most people. It is used as a screening tool to identify whether an adult is at a healthy weight. This is a numerical value of your weight in relation to your height. A BMI between 18.5 and 25 kg/m² indicates a normal weight. A BMI of less than 18.5 kg/m² is considered underweight. A BMI between 25 kg/m² and 29.9 kg/m² is considered overweight. A BMI of 30 kg/m² or higher is considered obese.',
                        height: 340),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            if (bmiValue == 0.0)
              model.busy
                  ? Container()
                  : Semantics(
                button: true,
                      label: height == 0
                          ? 'Add height to see BMI'
                          : 'Update height to see BMI',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            /*if (getCurrentLocale() == 'US') {
                              showHeightPickerInFoot(context);
                            } else {
                              showHeightPickerCms(context);
                            }*/

                            if (getCurrentLocale() == 'US') {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return _addHeightInFtnInchDialog(context);
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return _addHeightInCmDialog(context);
                                  });
                            }
                            /*showDialog(
                                context: context,
                                builder: (_) {
                                  return _addBMIDetailsDialog(context);
                                });*/
                            /*showToast("Please add height by clicking on edit",
                                context);
                            Navigator.popAndPushNamed(
                                context, RoutePaths.My_Medical_Profile);*/
                          },
                          child: Text(
                            height == 0
                                ? 'Add height to see BMI'
                                : 'Update height to see BMI',
                            semanticsLabel: bmiValue.toStringAsFixed(2),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                fontSize: bmiValue == 0.0 ? 14 : 28.0,
                                color: Colors.lightBlueAccent),
                          ),
                        ),
                      ),
                    ),
            if (bmiValue != 0.0)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            bmiValue.toStringAsFixed(2),
                            semanticsLabel: bmiValue.toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: bmiValue == 0.0 ? 14 : 28.0,
                                color: primaryColor),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            bmiValue == 0.0
                                ? ''
                                : /*getCurrentLocale() == 'US'
                              ? 'lbs / m sq'
                              :
                                'kg/m sq'*/
                                '',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black87),
                          ),
                        ],
                      ),
                      Text(
                        bmiResult,
                        semanticsLabel: bmiResult,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: bmiResultColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: bmiLeftSideValue, child: Container()),
                        Expanded(
                            flex: 2,
                            child: ImageIcon(
                                AssetImage('res/images/triangle.png'))),
                        Expanded(flex: bmiRightSideValue, child: Container())
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'res/images/bmi_scale.png',
                        semanticLabel: 'BMI scale',
                      )),
                ],
              )
            else
              Container(),
          ],
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
                'Enter your weight:',
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
                    label: 'Weight measures in ' + unit,
                    child: TextFormField(
                        controller: _weightController,
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
                          text: unit == 'lbs' ? '    lbs    ' : '    Kg    ',
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
                  if (_weightController.text.toString().isEmpty) {
                    showToast('Please enter your weight', context);
                  } else {
                    addvitals();
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
                            child: Text(
                              unit == 'lbs' ? 'Weight\n(lbs)' : 'Weight\n(Kg)',
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
      child: Text('No vital history found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeWeightList(BuildContext context, int index) {
    final Items record = records.elementAt(index);
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
                  dateFormatStandard.format(records
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
                label: 'Weight ',
                readOnly: true,
                child: Text(
                  unit == 'lbs'
                      ? (double.parse(record.bodyWeight.toString()) * 2.20462)
                          .toStringAsFixed(1)
                      : record.bodyWeight.toString(),
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
                  semanticLabel: 'Weight Delete',
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
        label: 'making graph of ',
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
              'Weight',
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
      final String receivedWeight = unit == 'lbs'
          ? (double.parse(records.elementAt(i).bodyWeight.toString()) * 2.20462)
          .toStringAsFixed(1)
          : records.elementAt(i).bodyWeight.toString();
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordDate!).toLocal(),
          double.parse(receivedWeight)));
    }

    debugPrint('Biometric Weight Date ==> ${data.elementAt(0).time}');

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'WT',
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
          Container(
            height: 60,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                ImageIcon(
                  AssetImage('res/images/ic_dart_goal.png'),
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Your progress with goals',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Initial',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '85',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Target',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '65',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Latest',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '74',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

  /* Widget _addBMIDetailsDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Height',
                        semanticsLabel: 'Height',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
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
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddHeightDialog(
                  submitButtonListner: (double height) {
                    _sharedPrefUtils.saveDouble('height', height);
                    this.height = height;
                    showToast('Height record created successfully!', context);
                    calculetBMI();
                    debugPrint('Height : $height');
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {});
                  },
                  height: height.toInt(),
                ),
              )
            ],
          ),
        ));
  }*/

  addvitals() async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      double entertedWeight = double.parse(_weightController.text.toString());

      if (unit == 'lbs') {
        entertedWeight = entertedWeight / 2.20462;
      }

      final map = <String, dynamic>{};
      map['BodyWeight'] = entertedWeight.toString();
      map['PatientUserId'] = "";
      map['Unit'] = "kg";

      final BaseResponse baseResponse =
      await model.addMyVitals('body-weights', map);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        _weightController.clear();
        _sharedPrefUtils.saveDouble(
            'weight', double.parse(entertedWeight.toString()));
        showToast(baseResponse.message!, context);
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
          await model.deleteVitalsRecord('body-weights', recordId);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(baseResponse.message!, context);
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
      final GetMyVitalsHistory getMyVitalsHistory =
      await model.getMyVitalsHistory('body-weights');
      if (getMyVitalsHistory.status == 'success') {
        records.clear();
        records.addAll(getMyVitalsHistory.data!.bodyWeightRecords!.items!);

        if (records.isNotEmpty) {
          weight = double.parse(records.elementAt(0).bodyWeight.toString());
          _sharedPrefUtils.saveDouble('weight', weight);
        } else {
          weight = 0.0;
          _sharedPrefUtils.saveDouble('weight', weight);
        }
        if (height != 0) {
          debugPrint('Inside');
          calculetBMI();
        }
      } else {
        showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

/*  showHeightPickerInFoot(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 1,
            end: 9,
            initValue: heightInFt,
            suffix: Text('  ft'),
          ),
          NumberPickerColumn(
            begin: 0,
            end: 11,
            initValue: heightInInch,
            suffix: Text('  inch'),
          ),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        hideHeader: true,
        title: Center(
            child: Text(
          " Height",
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 18.0),
          textAlign: TextAlign.center,
        )),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var localHeight = Conversion.FeetAndInchToCm(
              picker.getSelectedValues().elementAt(0),
              picker.getSelectedValues().elementAt(1));
          _sharedPrefUtils.saveDouble('height', double.parse(localHeight));
          height = int.parse(localHeight);
          conversion();
          calculetBMI();
          debugPrint('Selected Height ==> $localHeight');
          setState(() {
            showToast('Height record created successfully!', context);
          });
        }).showDialog(context);
  }

  showHeightPickerCms(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
            begin: 1,
            end: 250,
            initValue: height.toInt(),
            suffix: Text('  cm'),
          ),
        ]),
        hideHeader: true,
        title: Center(
            child: Text(
          " Height",
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              fontSize: 18.0),
          textAlign: TextAlign.center,
        )),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var localHeight =
              double.parse(picker.getSelectedValues().elementAt(0).toString());
          _sharedPrefUtils.saveDouble('height', localHeight);
          height = localHeight.toInt();
          conversion();
          calculetBMI();
          debugPrint('Selected Height ==> $localHeight');
          setState(() {
            showToast('Height record created successfully!', context);
          });
        }).showDialog(context);
  }*/

  Widget _addHeightInFtnInchDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Height',
                        semanticsLabel: 'Height',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
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
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddHeightInFtNInchDialog(
                  submitButtonListner: (int heightInFeet, int heightInInches) {
                    var localHeight = Conversion.FeetAndInchToCm(
                        heightInFeet,
                        heightInInches);
                    _sharedPrefUtils.saveDouble('height', double.parse(localHeight));
                    height = int.parse(localHeight);
                    conversion();
                    debugPrint('Selected Height ==> $localHeight');
                    setState(() {
                      showToast('Height record created successfully!', context);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  heightInFeet: heightInFt,
                  heightInInches: heightInInch,
                ),
              )
            ],
          ),
        ));
  }

  Widget _addHeightInCmDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Height',
                        semanticsLabel: 'Height',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
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
                      semanticLabel: 'Close',
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddHeightInCmDialog(
                  submitButtonListner: (int heightInCm) {
                    var localHeight =
                    double.parse(heightInCm.toString());
                    _sharedPrefUtils.saveDouble('height', localHeight);
                    height = localHeight.toInt();
                    conversion();
                    debugPrint('Selected Height ==> $localHeight');
                    setState(() {
                      showToast('Height record created successfully!', context);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  heightInCm: height.toInt(),
                ),
              )
            ],
          ),
        ));
  }
}
