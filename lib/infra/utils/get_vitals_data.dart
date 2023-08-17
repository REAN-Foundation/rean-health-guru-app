import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

import 'common_utils.dart';

class GetVitalsData {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  var dateFormat = DateFormat('yyyy-MM-dd');
  double weight = 0;
  double height = 0;
  late DateTime startDate;
  late DateTime endDate;
  double bodyTemprature = 0;
  double bloodOxygen = 0;
  double bloodGlucose = 0;
  double bloodPressureSystolic = 0;
  double bloodPressureDiastolic = 0;
  double heartRate = 0;

  GetVitalsData() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    debugPrint('<== Vitals ==>');
    debugPrint('Start Date ==> $startDate');
    debugPrint('End Date ==> $endDate');
    Timer.periodic(Duration(seconds: 10), (timer) {
      debugPrint("Inside 30 Sec");
      if (Platform.isIOS) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {


    final HealthFactory health = HealthFactory();

    /// Define the types to get.
    final List<HealthDataType> types = [
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
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

       //Print the results
       /*_healthDataList.forEach((x) {
        debugPrint('Data point:  ${x}');
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
    for (int i = 0; i < _healthDataList.length; i++) {
      final HealthDataPoint p = _healthDataList[i];
       if (p.typeString == 'WEIGHT') {
        if (p.value.toDouble() != 0) {
          if(weight == 0)
          weight = p.value.toDouble();
        }
      } else if (p.typeString == 'HEIGHT') {
        if (p.value.toDouble() != 0) {
          //height = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'BLOOD_OXYGEN') {
        if (p.value.toDouble() != 0) {
          bloodOxygen = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'BLOOD_GLUCOSE') {
        bloodGlucose = p.value.toDouble();
      } else if (p.typeString == 'BLOOD_PRESSURE_DIASTOLIC') {
        if(bloodPressureDiastolic == 0)
        bloodPressureDiastolic = p.value.toDouble();
      } else if (p.typeString == 'BLOOD_PRESSURE_SYSTOLIC') {
        if(bloodPressureSystolic == 0)
        bloodPressureSystolic = p.value.toDouble();
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

    debugPrint('========================############## Get Vitals Data ##############=============================');
    debugPrint('WEIGHT : $weight');
    debugPrint('Height : $height');
    debugPrint('BLOOD_OXYGEN : $bloodOxygen');
    debugPrint('BLOOD_GLUCOSE : $bloodGlucose');
    debugPrint('BLOOD_PRESSURE_DIASTOLIC : $bloodPressureDiastolic');
    debugPrint('BLOOD_PRESSURE_SYSTOLIC : $bloodPressureSystolic');
    debugPrint('BODY_TEMPERATURE : $bodyTemprature');
    debugPrint('HEART_RATE : $heartRate');
    debugPrint('===============================############## END ##############===================================');
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

  String getWeight() {
    return weight.toStringAsFixed(1);
  }

  String getHeight() {
    return height.toString();
  }

}
