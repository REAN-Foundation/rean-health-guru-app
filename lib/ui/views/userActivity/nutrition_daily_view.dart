import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/NutritionResponseStore.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

import 'addNutritionsDetailsDialog.dart';

class NutritionDailyView extends StatefulWidget {
  @override
  _NutritionDailyViewState createState() => _NutritionDailyViewState();
}

class _NutritionDailyViewState extends State<NutritionDailyView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat('yyyy-MM-dd');
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  double totalTodayCal = 0.0;
  double totalBreakfastCal = 0.0;
  double totalLunchCal = 0.0;
  double totalDinnerCal = 0.0;
  double totalMorningSnackCal = 0.0;
  double totalAfernoonSnackCal = 0.0;
  double totalEveningSncakCal = 0.0;

  NutritionResponseStore nutritionResponseStore;

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

  @override
  void initState() {
    loadSharedPref();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientHealthMarkerViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text(
                'Nutrition',
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
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          width: 10,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Total Calories',
                          semanticsLabel: 'Calories',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Today',
                          semanticsLabel: 'Today',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalTodayCal.toStringAsFixed(0),
                              semanticsLabel: totalTodayCal.toStringAsFixed(0),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Breakfast',
                          semanticsLabel: 'Breakfast',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalBreakfastCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'breakfast');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Lunch',
                          semanticsLabel: 'Lunch',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalLunchCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'lunch');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Dinner',
                          semanticsLabel: 'Dinner',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalDinnerCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'dinner');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Morning Snack',
                          semanticsLabel: 'Morning Snack',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalMorningSnackCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'morningSnacks');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Afternoon Snack',
                          semanticsLabel: 'Afternoon Snack',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalAfernoonSnackCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'afternoonSnacks');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Evening Snack',
                          semanticsLabel: 'Evening Snack',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              totalEveningSncakCal.toStringAsFixed(0),
                              semanticsLabel: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'cals',
                              semanticsLabel: 'cals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _addCaloriesConsumedDialog(
                                            context, 'eveningSnacks');
                                      });
                                },
                                child: Icon(
                                  Icons.add_circle,
                                  color: primaryColor,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _addCaloriesConsumedDialog(
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
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Calories Intake ' +
                            nutritionName.replaceAll('Snacks', ' snacks'),
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
              Expanded(
                child: AddNutritionDetailsDialog(
                    submitButtonListner:
                        (name, caloriesConsumed, nutritionType) {
                      debugPrint(nutritionType);
                      recordMyCaloriesConsumed(name, caloriesConsumed);
                      addNutrition(nutritionType, caloriesConsumed);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    nutritionName: nutritionName),
              )
            ],
          ),
        ));
  }

  addNutrition(String type, double caloriesConsumed) {
    if (type == 'breakfast') {
      totalBreakfastCal = totalBreakfastCal + caloriesConsumed;
    } else if (type == 'lunch') {
      totalLunchCal = totalLunchCal + caloriesConsumed;
    } else if (type == 'dinner') {
      totalDinnerCal = totalDinnerCal + caloriesConsumed;
    } else if (type == 'morningSnacks') {
      totalMorningSnackCal = totalMorningSnackCal + caloriesConsumed;
    } else if (type == 'afternoonSnacks') {
      totalAfernoonSnackCal = totalAfernoonSnackCal + caloriesConsumed;
    } else if (type == 'eveningSnacks') {
      totalEveningSncakCal = totalEveningSncakCal + caloriesConsumed;
    }

    totalTodayCal = totalBreakfastCal +
        totalLunchCal +
        totalDinnerCal +
        totalMorningSnackCal +
        totalAfernoonSnackCal +
        totalEveningSncakCal;

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

  recordMyCaloriesConsumed(
      String nutritionName, double caloriesConsumed) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Name'] = nutritionName;
      map['ConsumedCalories'] = caloriesConsumed.toString();
      map['StartTime'] = dateFormat.format(DateTime.now());
      map['EndTime'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
          await model.recordMyCaloriesConsumed(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
