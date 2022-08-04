import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/nutrition/models/nutrition_response_store.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';

import 'add_nutritions_details_dialog.dart';

//ignore: must_be_immutable
class NutritionDailyView extends StatefulWidget {
  String mode;

  NutritionDailyView(this.mode);

  @override
  _NutritionDailyViewState createState() => _NutritionDailyViewState();
}

class _NutritionDailyViewState extends State<NutritionDailyView> {
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

  late NutritionResponseStore nutritionResponseStore;

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

  addCaloriesDialog() {
    if (widget.mode != '') {
      showDialog(
          context: context,
          builder: (_) {
            return _addCaloriesConsumedDialog(context, widget.mode);
          });
    }
  }

  @override
  void initState() {
    loadSharedPref();
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              title: Text(
                'Nutrition',
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
                          color: textGrey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Total Calories',
                          semanticsLabel: 'Total Calories',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: textGrey),
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
                              color: textGrey),
                        ),
                        Semantics(
                          label:
                              totalTodayCal!.toStringAsFixed(0) + ' Calories',
                          child: ExcludeSemantics(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  totalTodayCal!.toStringAsFixed(0),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24.0,
                                      color: textGrey),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'cals',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: textGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: textGrey,
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
                              color: textGrey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Semantics(
                              label: totalBreakfastCal!.toStringAsFixed(0) +
                                  ' Calories',
                              child: ExcludeSemantics(
                                child: Row(
                                  children: [
                                    Text(
                                      totalBreakfastCal!.toStringAsFixed(0),
                                      semanticsLabel: '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: textGrey),
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
                                          color: textGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: textGrey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return _addCaloriesConsumedDialog(
                                          context, 'breakfast');
                                    });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                                semanticLabel: 'Add Calories for Breakfast',
                                size: 32,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: textGrey,
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
                              color: textGrey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Semantics(
                              label: totalLunchCal!.toStringAsFixed(0) +
                                  ' Calories',
                              child: ExcludeSemantics(
                                child: Row(children: [
                                  Text(
                                    totalLunchCal!.toStringAsFixed(0),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: textGrey),
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
                                        color: textGrey),
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: textGrey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return _addCaloriesConsumedDialog(
                                          context, 'lunch');
                                    });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                                size: 32,
                                semanticLabel: 'Add Calories for lunch',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: textGrey,
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
                              color: textGrey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Semantics(
                              label: totalDinnerCal!.toStringAsFixed(0) +
                                  ' Calories',
                              child: ExcludeSemantics(
                                child: Row(
                                  children: [
                                    Text(
                                      totalDinnerCal!.toStringAsFixed(0),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: textGrey),
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
                                          color: textGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: textGrey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return _addCaloriesConsumedDialog(
                                          context, 'dinner');
                                    });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                                size: 32,
                                semanticLabel: 'Add Calories for dinner',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: textGrey,
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
                          'Snack',
                          semanticsLabel: 'snack',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: textGrey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Semantics(
                              label: totalMorningSnackCal!.toStringAsFixed(0) +
                                  ' Calories',
                              child: ExcludeSemantics(
                                child: Row(
                                  children: [
                                    Text(
                                      totalMorningSnackCal!.toStringAsFixed(0),
                                      semanticsLabel: '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: textGrey),
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
                                          color: textGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: textGrey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return _addCaloriesConsumedDialog(
                                          context, 'snack');
                                    });
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                                size: 32,
                                semanticLabel: 'Add Calories for snack',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: textGrey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
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
                                    color: textGrey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    totalAfernoonSnackCal!.toStringAsFixed(0),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: textGrey),
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
                                        color: textGrey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: textGrey,
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
                            color: textGrey,
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
                                    color: textGrey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    totalEveningSncakCal!.toStringAsFixed(0),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: textGrey),
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
                                        color: textGrey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: textGrey,
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
                            color: textGrey,
                            thickness: 2,
                          ),
                        ],
                      ),
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
  }

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

  recordMyCaloriesConsumed(
      String nutritionName, String nutritionType, double caloriesConsumed) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['ConsumedAs'] = nutritionType[0].toUpperCase() + nutritionType.substring(1);
      map['Food'] = nutritionName;
      map['Calories'] = caloriesConsumed.toString();
      map['StartTime'] = dateFormat.format(DateTime.now());
      map['EndTime'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
          await model.recordMyCaloriesConsumed(map);
      if (baseResponse.status == 'success') {
        showToast(baseResponse.message!, context);
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
}
