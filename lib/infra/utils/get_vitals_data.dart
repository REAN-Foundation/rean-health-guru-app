import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';

import 'common_utils.dart';

class GetVitalsData {
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  var model = PatientVitalsViewModel();
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
    setDate();
  }

  setDate() async {
    DateTime savedDate;
    try {
      savedDate = DateTime.parse( await _sharedPrefUtils.read('LastSyncDateAndTime')) ;
      debugPrint('Saved Date: $savedDate');
    } catch (e) {
      savedDate =DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0); //DateTime.now();
      debugPrint('Saved Date Error: $e');
    }

    startDate = savedDate;

    if (Platform.isIOS) {
      debugPrint('<== Vitals ==>');
      debugPrint('Start Date ==> $startDate');
      debugPrint('End Date ==> ${DateTime.now()}');
      fetchData();
    }

    //2023-09-13 19:59:13.366123

    /*Timer.periodic(Duration(seconds: 30), (timer) {
      debugPrint("Inside ${30} Sec");
      if (Platform.isIOS) {
        fetchData();
      }
    });*/
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
      endDate = DateTime.now();
      debugPrint('<== Vitals ==>');
      debugPrint('Start Date ==> $startDate');
      debugPrint('End Date ==> $endDate');
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
      startDate = endDate;
      _sharedPrefUtils.save('LastSyncDateAndTime', endDate.toIso8601String());
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
          if(weight == 0) {
            if(p.dateFrom.isAfter(startDate)) {
              weight = p.value.toDouble();
              debugPrint(
                  'WEIGHT : $weight   DateFrom :  ${p.dateFrom} DateTo : ${p
                      .dateTo} ');
              addWeightVitals();
            }
          }
        }
      } else if (p.typeString == 'HEIGHT') {
        if (p.value.toDouble() != 0) {
          //height = p.value.toDouble() * 100;
        }
      } else if (p.typeString == 'BLOOD_OXYGEN') {
        if (p.value.toDouble() != 0) {
          bloodOxygen = p.value.toDouble() * 100;
          //addBloodOxygenSaturationVitals();
        }
      } else if (p.typeString == 'BLOOD_GLUCOSE') {
         if(p.dateFrom.isAfter(startDate)) {
           bloodGlucose = p.value.toDouble();
           debugPrint('BLOOD_GLUCOSE : $bloodGlucose   DateFrom :  ${p
               .dateFrom} DateTo : ${p.dateTo} ');
           addBloodGlucoseVitals();
         }
      } else if (p.typeString == 'BLOOD_PRESSURE_DIASTOLIC') {
        if(bloodPressureDiastolic == 0) {
          if(p.dateFrom.isAfter(startDate)) {
            bloodPressureDiastolic = p.value.toDouble();
            debugPrint(
                'BLOOD_PRESSURE_DIASTOLIC : $bloodPressureDiastolic   DateFrom :  ${p
                    .dateFrom} DateTo : ${p.dateTo} ');
          }
        }
      } else if (p.typeString == 'BLOOD_PRESSURE_SYSTOLIC') {
        if(bloodPressureSystolic == 0)
          if(p.dateFrom.isAfter(startDate)) {
            bloodPressureSystolic = p.value.toDouble();
            debugPrint(
                'BLOOD_PRESSURE_SYSTOLIC : $bloodPressureSystolic   DateFrom :  ${p
                    .dateFrom} DateTo : ${p.dateTo} ');
          }
      } else if (p.typeString == 'BODY_TEMPERATURE') {
        if (p.value.toDouble() != 0) {
          if(p.dateFrom.isAfter(startDate)) {

            double temp = p.value.toDouble() * 1.8;
            double temperatureInFaranite = temp + 32;
            bodyTemprature = temperatureInFaranite;
            debugPrint('BODY_TEMPERATURE : $bodyTemprature   DateFrom :  ${p
                .dateFrom} DateTo : ${p.dateTo} ');
            addTemperatureVitals();
          }
        }
      } else if (p.typeString == 'HEART_RATE') {
        if (p.value.toDouble() != 0) {
          heartRate = p.value.toDouble();
        }
      }
    }

    if(bloodPressureDiastolic != 0 && bloodPressureSystolic != 0) {
      //addBPVitals();
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

  addWeightVitals() async {
    try {

      final map = <String, dynamic>{};
      map['BodyWeight'] = weight.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "Kg";

      weight = 0;

      final BaseResponse baseResponse =
      await model.addMyVitals('body-weights', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBPVitals() async {
    try {
      final map = <String, dynamic>{};
      map['Systolic'] = bloodPressureSystolic.toInt().toString();
      map['Diastolic'] = bloodPressureDiastolic.toInt().toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "mmHg";
      //map['RecordedByUserId'] = null;

      bloodPressureSystolic = 0;
      bloodPressureDiastolic = 0;

      final BaseResponse baseResponse =
      await model.addMyVitals('blood-pressures', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBloodGlucoseVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BloodGlucose'] = bloodGlucose.toInt().toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "mg|dL";
      //map['RecordedByUserId'] = null;

      bloodGlucose = 0;

      final BaseResponse baseResponse =
      await model.addMyVitals('blood-glucose', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addBloodOxygenSaturationVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BloodOxygenSaturation'] = bloodOxygen.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "%";
      //map['RecordedByUserId'] = null;

      bloodOxygen = 0;

      final BaseResponse baseResponse =
      await model.addMyVitals('blood-oxygen-saturations', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addPulseVitals() async {
    try {
      final map = <String, dynamic>{};
      map['Pulse'] = heartRate.toInt().toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "bpm";
      //map['RecordedByUserId'] = null;

      heartRate = 0;

      final BaseResponse baseResponse = await model.addMyVitals('pulse', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  addTemperatureVitals() async {
    try {
      final map = <String, dynamic>{};
      map['BodyTemperature'] = bodyTemprature.toString();
      map['PatientUserId'] = patientUserId;
      map['Unit'] = "Celsius";
      //map['RecordedByUserId'] = null;

      bodyTemprature = 0;

      final BaseResponse baseResponse =
      await model.addMyVitals('body-temperatures', map);

      if (baseResponse.status == 'success') {
      } else {
      }
    } catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

}
