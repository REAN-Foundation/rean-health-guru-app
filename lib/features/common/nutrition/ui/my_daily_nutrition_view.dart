
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/nutrition/models/alcohol_consumption.dart';
import 'package:patient/features/common/nutrition/models/glass_of_water_consumption.dart';
import 'package:patient/features/common/nutrition/models/nutrition_response_store.dart';
import 'package:patient/features/common/nutrition/models/sodium_intake_consumption.dart';
import 'package:patient/features/common/nutrition/models/tobacco_consumption.dart';
import 'package:patient/features/common/nutrition/ui/add_alcohol_consumption_view.dart';
import 'package:patient/features/common/nutrition/ui/add_sodium_intake_view.dart';
import 'package:patient/features/common/nutrition/ui/add_tobacco_consumption_view.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/db_utils/database_helper.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'add_daily_nutrition_view.dart';

//ignore: must_be_immutable
class MyDailyNutritionView extends StatefulWidget {
  String? mode;

  MyDailyNutritionView(this.mode);

  @override
  _MyDailyNutritionViewState createState() => _MyDailyNutritionViewState();
}

class _MyDailyNutritionViewState extends State<MyDailyNutritionView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat('yyyy-MM-dd');
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  double? totalTodayCal = 0.0;
  double? totalBreakfastCal = 0.0;
  double? totalLunchCal = 0.0;
  double? totalDinnerCal = 0.0;
  double? totalMorningSnackCal = 0.0;
  double? totalAfernoonSnackCal = 0.0;
  double? totalEveningSncakCal = 0.0;
  Color buttonColor = primaryLightColor;
  int? waterGlass = 0;
  GlassOfWaterConsumption? glassOfWaterConsumption;
  int? sodiumIntakeInMiligram = 0;
  SodiumIntakeConsumption? _sodiumIntakeConsumption;
  int? alcoholIntakeInMililitre = 0;
  AlcoholConsumption? _alcoholConsumption;
  int? tobaccoIntakeInGram = 0;
  TobaccoConsumption? _tobaccoConsumption;
  late NutritionResponseStore nutritionResponseStore;
  DateTime? startDate;
  final dbHelper = DatabaseHelper.instance;

  loadSharedPref() async {
    try {
      nutritionResponseStore = NutritionResponseStore.fromJson(
          await _sharedPrefUtils.read('nutrition'));
      debugPrint('Nutrition Date ==> ${nutritionResponseStore.date}');
      setUpData();
    } catch (e) {
      saveData();
      debugPrint('error caught: $e');
    }
  }

  loadWaterConsuption() async {
    final waterConsuption = await _sharedPrefUtils.read('waterConsumption');

    if (waterConsuption != null) {
      glassOfWaterConsumption =
          GlassOfWaterConsumption.fromJson(waterConsuption);
    }

    if (glassOfWaterConsumption != null) {
      if (startDate == glassOfWaterConsumption!.date) {
        waterGlass = glassOfWaterConsumption!.count;
      }
    }
  }

  loadSodiumIntake() async {
    final sodiumIntake = await _sharedPrefUtils.read('sodiumIntake');

    if (sodiumIntake != null) {
      _sodiumIntakeConsumption = SodiumIntakeConsumption.fromJson(sodiumIntake);
    }

    if (_sodiumIntakeConsumption != null) {
      if (startDate == _sodiumIntakeConsumption!.date) {
        sodiumIntakeInMiligram = _sodiumIntakeConsumption!.count;

      }
    }
  }
  loadAlcohol() async {
    final alcoholIntake = await _sharedPrefUtils.read('alcoholIntake');

    if (alcoholIntake != null) {
      _alcoholConsumption = AlcoholConsumption.fromJson(alcoholIntake);
    }

    if (_alcoholConsumption != null) {
      if (startDate == _alcoholConsumption!.date) {
        alcoholIntakeInMililitre = _alcoholConsumption!.count;

      }
    }
  }
  loadTobacco() async {
    final tobaccoIntake = await _sharedPrefUtils.read('tobaccoIntake');

    if (tobaccoIntake != null) {
      _tobaccoConsumption = TobaccoConsumption.fromJson(tobaccoIntake);
    }

    if (_tobaccoConsumption != null) {
      if (startDate == _tobaccoConsumption!.date) {
        tobaccoIntakeInGram = _tobaccoConsumption!.count;

      }
    }
  }

  setUpData() {
    debugPrint('Todays Date ==> ${dateFormat.format(DateTime.now())}');
    if (dateFormat.format(DateTime.now()) == nutritionResponseStore.date) {
      totalTodayCal = nutritionResponseStore.totalTodayCal;
      totalBreakfastCal = nutritionResponseStore.totalBreakfastCal;
      totalLunchCal = nutritionResponseStore.totalLunchCal;
      totalDinnerCal = nutritionResponseStore.totalDinnerCal;
      totalMorningSnackCal = nutritionResponseStore.totalMorningSnackCal;
      totalAfernoonSnackCal = nutritionResponseStore.totalAfernoonSnackCal;
      totalEveningSncakCal = nutritionResponseStore.totalEveningSncakCal;
      setState(() {});
    } else {
      saveData();
    }
  }

  saveData() {
    debugPrint('Test');
    nutritionResponseStore = NutritionResponseStore();
    nutritionResponseStore.totalTodayCal = totalTodayCal;
    nutritionResponseStore.totalBreakfastCal = totalBreakfastCal;
    nutritionResponseStore.totalLunchCal = totalLunchCal;
    nutritionResponseStore.totalDinnerCal = totalDinnerCal;
    nutritionResponseStore.totalMorningSnackCal = totalMorningSnackCal;
    nutritionResponseStore.totalAfernoonSnackCal = totalAfernoonSnackCal;
    nutritionResponseStore.totalEveningSncakCal = totalEveningSncakCal;
    nutritionResponseStore.date = dateFormat.format(DateTime.now());
    _sharedPrefUtils.save('nutrition', nutritionResponseStore.toJson());
  }

  addCaloriesDialog() {
    if (widget.mode != '') {
      Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => AddDailyNutritionView(
                submitButtonListner: (name, caloriesConsumed, nutritionType) {
                  debugPrint(nutritionType);
                  recordMyCaloriesConsumed(
                      name, nutritionType, caloriesConsumed);
                  addNutrition(nutritionType, caloriesConsumed);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                nutritionName: widget.mode)),
      );
    }
  }

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    loadSharedPref();
    loadWaterConsuption();
    loadSodiumIntake();
    loadAlcohol();
    loadTobacco();

    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }

    Future.delayed(
        const Duration(milliseconds: 200), () => addCaloriesDialog());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: primaryColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              title: Text(
                'Nutrition Management',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              iconTheme: IconThemeData(color: Colors.white),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: primaryColor,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total calories consumed today',
                        semanticsLabel: 'Total calories consumed today',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Semantics(
                        label: totalTodayCal!.toStringAsFixed(0) + ' Calories',
                        child: ExcludeSemantics(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                totalTodayCal!.toStringAsFixed(0),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.0,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'cals',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.0,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*SizedBox(
                        height: 16,
                      ),*/
                      Text(
                        '',
                        semanticsLabel: 'Total Calories',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12))),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Breakfast',
                            semanticsLabel: 'Breakfast',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label:
                                    totalBreakfastCal!.toStringAsFixed(0) +
                                            ' Calories',
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            totalBreakfastCal!
                                                .toStringAsFixed(0),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'calories',
                                            semanticsLabel: 'calories',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () async {
                                          /*showDialog(
                                              context: context,
                                              builder: (_) {
                                                return _addCaloriesConsumedDialog(
                                                    context, 'breakfast');
                                              });*/
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    AddDailyNutritionView(
                                                        submitButtonListner:
                                                            (name,
                                                                caloriesConsumed,
                                                                nutritionType) {
                                                          debugPrint(
                                                              nutritionType);
                                                          recordMyCaloriesConsumed(
                                                              name,
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          addNutrition(
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        nutritionName:
                                                            'breakfast')),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel:
                                              'Add Calories for Breakfast',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Lunch',
                            semanticsLabel: 'Lunch',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: totalLunchCal!.toStringAsFixed(0) +
                                        ' Calories',
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            totalLunchCal!.toStringAsFixed(0),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'calories',
                                            semanticsLabel: 'calories',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          /*showDialog(
                                              context: context,
                                              builder: (_) {
                                                return _addCaloriesConsumedDialog(
                                                    context, 'lunch');
                                              });*/
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    AddDailyNutritionView(
                                                        submitButtonListner:
                                                            (name,
                                                                caloriesConsumed,
                                                                nutritionType) {
                                                          debugPrint(
                                                              nutritionType);
                                                          recordMyCaloriesConsumed(
                                                              name,
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          addNutrition(
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        nutritionName:
                                                            'lunch')),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel:
                                              'Add Calories for lunch',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Dinner',
                            semanticsLabel: 'Dinner',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: totalDinnerCal!.toStringAsFixed(0) +
                                        ' Calories',
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            totalDinnerCal!.toStringAsFixed(0),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'calories',
                                            semanticsLabel: 'calories',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          /*showDialog(
                                              context: context,
                                              builder: (_) {
                                                return _addCaloriesConsumedDialog(
                                                    context, 'dinner');
                                              });*/
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    AddDailyNutritionView(
                                                        submitButtonListner:
                                                            (name,
                                                                caloriesConsumed,
                                                                nutritionType) {
                                                          debugPrint(
                                                              nutritionType);
                                                          recordMyCaloriesConsumed(
                                                              name,
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          addNutrition(
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        nutritionName:
                                                            'dinner')),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel:
                                              'Add Calories for dinner',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Snack',
                            semanticsLabel: 'Snack',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: totalMorningSnackCal!
                                            .toStringAsFixed(0) +
                                        ' Calories',
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            totalMorningSnackCal!
                                                .toStringAsFixed(0),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'calories',
                                            semanticsLabel: 'calories',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          /*showDialog(
                                              context: context,
                                              builder: (_) {
                                                return _addCaloriesConsumedDialog(
                                                    context, 'snack');
                                              });*/
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    AddDailyNutritionView(
                                                        submitButtonListner:
                                                            (name,
                                                                caloriesConsumed,
                                                                nutritionType) {
                                                          debugPrint(
                                                              nutritionType);
                                                          recordMyCaloriesConsumed(
                                                              name,
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          addNutrition(
                                                              nutritionType,
                                                              caloriesConsumed);
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        nutritionName:
                                                            'snack')),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel:
                                              'Add Calories for snack',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Water',
                                semanticsLabel: 'Water',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '( 1 glass = 8 ounces of water )',
                                semanticsLabel: '1 glass = 8 ounces of water',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14.0,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: waterGlass!.toStringAsFixed(0) +
                                        (waterGlass! > 1 ? 'glasses' : 'glass')
                                            .toString(),
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            waterGlass.toString(),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            waterGlass! > 1
                                                ? 'glasses'
                                                : 'glass',
                                            semanticsLabel: waterGlass! > 1
                                                ? 'glasses'
                                                : 'glass',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          recordMyWaterConsumptions();
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel: 'Add water glass',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Sodium Intake',
                            semanticsLabel: 'Sodium Intake',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: sodiumIntakeInMiligram!
                                            .toStringAsFixed(0) +
                                        (sodiumIntakeInMiligram! > 1
                                            ? 'mg'
                                            : 'mg'),
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            sodiumIntakeInMiligram.toString(),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            sodiumIntakeInMiligram! > 1
                                                ? 'mg'
                                                : 'mg',
                                            semanticsLabel:
                                                sodiumIntakeInMiligram! > 1
                                                    ? 'mg'
                                                    : 'mg',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AddSodiumIntakeView(
                                                submitButtonListner:
                                                    (sodiumConsumed) {
                                                  debugPrint(sodiumConsumed);
                                                  recordMySodiumIntake(
                                                      int.parse(
                                                          sodiumConsumed));
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel: 'Add sodium intake',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Alcohol Intake',
                            semanticsLabel: 'Alcohol Intake',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: alcoholIntakeInMililitre!
                                        .toStringAsFixed(0) +
                                        (alcoholIntakeInMililitre! > 1
                                            ? 'ml'
                                            : 'ml'),
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            alcoholIntakeInMililitre.toString(),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            alcoholIntakeInMililitre! > 1
                                                ? 'ml'
                                                : 'ml',
                                            semanticsLabel:
                                            alcoholIntakeInMililitre! > 1
                                                ? 'ml'
                                                : 'ml',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AddAlcoholConsumptionView(
                                                    submitButtonListner:
                                                        (alcoholConsumed) {
                                                      debugPrint(alcoholConsumed);
                                                      recordMyAlcoholConsumption(
                                                          int.parse(
                                                              alcoholConsumed));
                                                      Navigator.of(context,
                                                          rootNavigator: true)
                                                          .pop();
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel: 'Add alcohol intake',
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Tobacco Intake',
                            semanticsLabel: 'Tobacco Intake',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Semantics(
                                    label: tobaccoIntakeInGram!
                                        .toStringAsFixed(0) +
                                        (tobaccoIntakeInGram! > 1
                                            ? 'gm'
                                            : 'gm'),
                                    child: ExcludeSemantics(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            tobaccoIntakeInGram.toString(),
                                            semanticsLabel: '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            tobaccoIntakeInGram! > 1
                                                ? 'gm'
                                                : 'gm',
                                            semanticsLabel:
                                            tobaccoIntakeInGram! > 1
                                                ? 'gm'
                                                : 'gm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AddTobaccoConsumptionView(
                                                    submitButtonListner:
                                                        (tobaccoConsumed) {
                                                      debugPrint(tobaccoConsumed);
                                                      recordMyTobaccoConsumption(
                                                          int.parse(
                                                              tobaccoConsumed));
                                                      Navigator.of(context,
                                                          rootNavigator: true)
                                                          .pop();
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          semanticLabel: 'Add tobacco intake',
                                          size: 32,
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
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

/*  Widget _addCaloriesConsumedDialog(
      BuildContext context, String nutritionName) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 380,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    excluding: true,
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
                        'Calories Intake ' +
                            nutritionName.replaceAll('snack', ' snack'),
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
                    ),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddNutritionDetailsDialog(
                    submitButtonListner:
                        (name, caloriesConsumed, nutritionType) {
                      debugPrint(nutritionType);
                      recordMyCaloriesConsumed(name, nutritionType, caloriesConsumed);
                      addNutrition(nutritionType, caloriesConsumed);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    nutritionName: nutritionName),
              )
            ],
          ),
        ));
  }*/

  addNutrition(String type, double caloriesConsumed) {
    if (type == 'breakfast') {
      totalBreakfastCal = totalBreakfastCal! + caloriesConsumed;
    } else if (type == 'lunch') {
      totalLunchCal = totalLunchCal! + caloriesConsumed;
    } else if (type == 'dinner') {
      totalDinnerCal = totalDinnerCal! + caloriesConsumed;
    } else if (type == 'snack') {
      totalMorningSnackCal = totalMorningSnackCal! + caloriesConsumed;
    } else if (type == 'afternoonSnacks') {
      totalAfernoonSnackCal = totalAfernoonSnackCal! + caloriesConsumed;
    } else if (type == 'eveningSnacks') {
      totalEveningSncakCal = totalEveningSncakCal! + caloriesConsumed;
    }

    totalTodayCal = totalBreakfastCal! +
        totalLunchCal! +
        totalDinnerCal! +
        totalMorningSnackCal! +
        totalAfernoonSnackCal! +
        totalEveningSncakCal!;

    setState(() {});

    nutritionResponseStore.totalTodayCal = totalTodayCal;
    nutritionResponseStore.totalBreakfastCal = totalBreakfastCal;
    nutritionResponseStore.totalLunchCal = totalLunchCal;
    nutritionResponseStore.totalDinnerCal = totalDinnerCal;
    nutritionResponseStore.totalMorningSnackCal = totalMorningSnackCal;
    nutritionResponseStore.totalAfernoonSnackCal = totalAfernoonSnackCal;
    nutritionResponseStore.totalEveningSncakCal = totalEveningSncakCal;
    nutritionResponseStore.date = dateFormat.format(DateTime.now());
    debugPrint('Saved Data ==> ${nutritionResponseStore.toJson()}');
    _sharedPrefUtils.save('nutrition', nutritionResponseStore.toJson());
  }

  recordMyCaloriesConsumed(String nutritionName, String nutritionType,
      double caloriesConsumed) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['ConsumedAs'] =
          nutritionType[0].toUpperCase() + nutritionType.substring(1);
      map['Food'] = nutritionName;
      map['Calories'] = caloriesConsumed.toString();
      map['StartTime'] = dateFormat.format(DateTime.now());
      map['EndTime'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
          await model.recordMyCaloriesConsumed(map);
      if (baseResponse.status == 'success') {
        showToast(baseResponse.message!, context);
        recordNutririonEntry(nutritionName, nutritionType, caloriesConsumed);
      } else {}
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }

  recordNutririonEntry(String nutritionName, String nutritionType,
      double caloriesConsumed) async {
    final allRows = await dbHelper.querySelectWhereFoodName(nutritionName);
    print('Query first row: ${allRows.length}');
    allRows.forEach((row) => print(row));

    if (allRows.isEmpty) {
      final Map<String, dynamic> row = {
        DatabaseHelper.columnNutritionFoodItemName: nutritionName.trim(),
        DatabaseHelper.columnNutritionFoodItemCalories: caloriesConsumed,
        DatabaseHelper.columnNutritionFoodConsumedTag: nutritionType.trim(),
        DatabaseHelper.columnNutritionFoodConsumedQuantity: 1,
      };
      final id = await dbHelper.insert(row);
      //showToast('Data saved offline');
      print('inserted row id: $id');
    } else {
      final row = allRows.elementAt(0);
      final int? consumedCount =
          row[DatabaseHelper.columnNutritionFoodConsumedQuantity] + 1;

      final Map<String, dynamic> updateRow = {
        DatabaseHelper.columnNutritionFoodItemName: nutritionName.trim(),
        DatabaseHelper.columnNutritionFoodItemCalories: caloriesConsumed,
        DatabaseHelper.columnNutritionFoodConsumedTag: nutritionType.trim(),
        DatabaseHelper.columnNutritionFoodConsumedQuantity: consumedCount,
      };
      final id = await dbHelper.update(updateRow);
      //showToast('Data saved offline');
      print('Updated row id: $id');
    }
  }

  recordMyWaterConsumptions() async {
    try {
      waterGlass = waterGlass! + 1;

      _sharedPrefUtils.save('waterConsumption',
          GlassOfWaterConsumption(startDate, waterGlass, '').toJson());

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Volume'] = waterGlass;
      map['Time'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMySodiumIntake(int sodiumInMiligram) async {
    try {
      recordMyMonitoringFoodConsumtion(
          'Sodium', 'mg', sodiumInMiligram.toDouble());
      sodiumIntakeInMiligram = sodiumIntakeInMiligram! + sodiumInMiligram;
      _sharedPrefUtils.save(
          'sodiumIntake',
          SodiumIntakeConsumption(startDate, sodiumIntakeInMiligram, '')
              .toJson());
      showToast("Sodium intake added successfully", context);
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

  recordMyAlcoholConsumption(int alcoholInMililitre) async {
    try {
      recordMyMonitoringFoodConsumtion(
          'Alcohol', 'ml', alcoholInMililitre.toDouble());
      alcoholIntakeInMililitre = alcoholIntakeInMililitre! + alcoholInMililitre;
      _sharedPrefUtils.save('alcoholIntake',
          AlcoholConsumption(startDate, alcoholIntakeInMililitre, '').toJson());
      showToast("Alcohol intake added successfully", context);
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
  recordMyTobaccoConsumption(int tobaccoInGram) async {
    try {
      recordMyMonitoringFoodConsumtion(
          'Tobaco', 'gm', tobaccoInGram.toDouble());
      tobaccoIntakeInGram = tobaccoIntakeInGram! + tobaccoInGram;
      _sharedPrefUtils.save('tobaccoIntake',
          TobaccoConsumption(startDate, tobaccoIntakeInGram, '').toJson());
      showToast("Tobacco intake added successfully", context);
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

  recordMyMonitoringFoodConsumtion(
      String foodName, String unit, double amount) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['MonitoredFoodComponent'] = foodName;
      map['Unit'] = unit;
      map['Amount'] = amount;

      final BaseResponse baseResponse =
          await model.recordMyMonitoringFoodConsumtion(map);
      if (baseResponse.status == 'success') {
        //showToast(baseResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }
}
