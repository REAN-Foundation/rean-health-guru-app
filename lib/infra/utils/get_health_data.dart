import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

import 'common_utils.dart';

class GetHealthData {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat('yyyy-MM-dd');
  int steps = 0;
  double weight = 0;
  double height = 0;
  double totalActiveCalories = 0;
  double totalBasalCalories = 0;
  double totalCalories = 0;
  double bmiValue = 0;
  Color bmiResultColor = Colors.black87;
  int waterGlass = 0;
  String bmiResult = '';
  late DateTime startDate;
  late DateTime endDate;
  double totalSleepInMin = 0;
  double totalExerciseMin = 0;
  double bodyTemprature = 0;
  double bloodOxygen = 0;
  double bloodGlucose = 0;
  double bloodPressureSystolic = 0;
  double bloodPressureDiastolic = 0;
  double heartRate = 0;
  late HealthDataPoint diastolicHealthDataPoint;
  late HealthDataPoint systolicHealthDataPoint;

  GetHealthData() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 11, 59, 59);
    debugPrint('Start Date ==> $startDate');
    debugPrint('End Date ==> $endDate');
    if (Platform.isIOS) {
      fetchData();
    }
    //loadHeightAndWeight();
  }

  /*loadHeightAndWeight() async {
    height = await _sharedPrefUtils.readDouble('height');
    weight = await _sharedPrefUtils.readDouble('weight');
  }*/

  Future<void> fetchData() async {
    /// Get everything from midnight until now
    //DateTime startDate = DateTime(2021, 01, 01, 0, 0, 0);
    //DateTime endDate = DateTime(2021, 07, 07, 23, 59, 59);

    /*startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);*/

    final HealthFactory health = HealthFactory();

    /// Define the types to get.
    final List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.EXERCISE_TIME,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      //HealthDataType.BASAL_ENERGY_BURNED,
      //HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    _state = AppState.FETCHING_DATA;

    /// You MUST request access to the data types before reading them
    final bool accessWasGranted = await health.requestAuthorization(types);

    //this.steps = 0;
    if (accessWasGranted) {
      try {
        /// Fetch new data
        final List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        debugPrint('Caught exception in getHealthDataFromTypes: $e');
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      /* _healthDataList.forEach((x) {
        //debugPrint('Data point:  ${x}');
        //steps += x.value.round();
      });*/

      //debugPrint("Steps: $steps");

      //this.steps = steps;

      /// Update the UI to display the results
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      _content();
    } else {
      debugPrint('Authorization not granted');
      _state = AppState.DATA_NOT_FETCHED;
    }
  }

  _content() {
    if (_state == AppState.DATA_READY) {
      calculateData();
      debugPrint('DATA_READY');
    } else if (_state == AppState.NO_DATA) {
      debugPrint('NO_DATA');
    } else if (_state == AppState.FETCHING_DATA) {
      debugPrint('FETCHING_DATA');
    } else if (_state == AppState.AUTH_NOT_GRANTED) {
      debugPrint('AUTH_NOT_GRANTED');
    }
  }

  calculateData() {
    clearAllRecords();
    for (int i = 0; i < _healthDataList.length; i++) {
      final HealthDataPoint p = _healthDataList[i];
      if (p.typeString == 'STEPS') {
        steps = steps + p.value.toInt();
      } else if (p.typeString == 'WEIGHT') {
        if (p.value.toDouble() != 0) {
          weight = p.value.toDouble();
        }
      } else if (p.typeString == 'HEIGHT') {
        if (p.value.toDouble() != 0) {
          //height = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'ACTIVE_ENERGY_BURNED') {
        totalActiveCalories = totalActiveCalories + p.value.toDouble();
      } else if (p.typeString == 'BASAL_ENERGY_BURNED') {
        totalBasalCalories = totalBasalCalories + p.value.toDouble();
      } else if (p.typeString == 'SLEEP_ASLEEP') {
        totalSleepInMin = totalSleepInMin + p.value.toDouble();
      } else if (p.typeString == 'EXERCISE_TIME') {
        totalExerciseMin = totalExerciseMin + p.value.toDouble();
      } else if (p.typeString == 'BLOOD_OXYGEN') {
        if (p.value.toDouble() != 0) {
          bloodOxygen = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'BLOOD_GLUCOSE') {
        bloodGlucose = p.value.toDouble();
      } else if (p.typeString == 'BLOOD_PRESSURE_DIASTOLIC') {
        bloodPressureDiastolic = p.value.toDouble();
        diastolicHealthDataPoint = p;
      } else if (p.typeString == 'BLOOD_PRESSURE_SYSTOLIC') {
        bloodPressureSystolic = p.value.toDouble();
        systolicHealthDataPoint = p;
      } else if (p.typeString == 'BODY_TEMPERATURE') {
        if (p.value.toDouble() != 0) {
          bodyTemprature = p.value.toDouble();
        }
      } else if (p.typeString == 'HEART_RATE') {
        if (p.value.toDouble() != 0) {
          heartRate = p.value.toDouble();
        }
      }
    }

    if (height == 0.0 || weight == 0.0) {} else {
      calculetBMI();
    }

    totalCalories = totalActiveCalories + totalBasalCalories;
    debugPrint(
        '========================############################=============================');
    debugPrint('STEPS : $steps');
    debugPrint('ACTIVE_ENERGY_BURNED : $totalActiveCalories');
    debugPrint('BASAL_ENERGY_BURNED : $totalBasalCalories');
    debugPrint('CALORIES_BURNED : $totalBasalCalories');
    debugPrint('WEIGHT : $weight');
    debugPrint('Height : $height');
    debugPrint('SLEEP_ASLEEP : $totalSleepInMin');
    debugPrint('EXERCISE_TIME : $totalExerciseMin');
    debugPrint('BLOOD_OXYGEN : $bloodOxygen');
    debugPrint('BLOOD_GLUCOSE : $bloodGlucose');
    debugPrint('BLOOD_PRESSURE_DIASTOLIC : $bloodPressureDiastolic');
    debugPrint('BLOOD_PRESSURE_SYSTOLIC : $bloodPressureSystolic');
    debugPrint('BODY_TEMPERATURE : $bodyTemprature');
    debugPrint('HEART_RATE : $heartRate');
    debugPrint(
        '========================############################=============================');
  }

  calculetBMI() {
    final double heightInMeters = height / 100;
    final double heightInMetersSquare = heightInMeters * heightInMeters;

    bmiValue = weight / heightInMetersSquare;

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
  }

  String getHeartRate() {
    return heartRate.toInt().toString();
  }

  String getBodyTemprature() {
    return bodyTemprature.toString();
  }

  String getBloodGlucose() {
    return bloodGlucose.toInt().toString();
  }

  String getBloodOxygen() {
    return bloodOxygen.toString();
  }

  String getBPSystolic() {
    return bloodPressureSystolic.toInt().toString();
  }

  String getBPDiastolic() {
    return bloodPressureDiastolic.toInt().toString();
  }

  HealthDataPoint getBPSystolicHealthDataPoint() {
    return systolicHealthDataPoint;
  }

  HealthDataPoint getBPDiastolicHealthDataPoint() {
    return diastolicHealthDataPoint;
  }

  int getExerciseTimeInMin() {
    return totalExerciseMin.toInt();
  }

  String getWeight() {
    return weight.toString();
  }

  String getHeight() {
    return height.toString();
  }

  String getBMI() {
    return bmiValue.toString();
  }

  String getSteps() {
    return steps.toString();
  }

  String getTotalCaloriesBurned() {
    return totalBasalCalories.toString();
  }

  clearAllRecords() {
    //bmiValue = 0 ;
    totalActiveCalories = 0;
    totalBasalCalories = 0;
    totalCalories = 0;
    steps = 0;
    //weight = 0;
    //height = 0;
  }
}
