
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DoctorAppoinmentBookedSuccessfully.dart';
import 'package:paitent/core/models/DrugOrderIdPojo.dart';
import 'package:paitent/core/models/DrugsLibraryPojo.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/GetMyVitalsHistory.dart';
import 'package:paitent/core/models/MyAppointmentApiResponse.dart';
import 'package:paitent/core/models/MyCurrentMedication.dart';
import 'package:paitent/core/models/MyMedicationSummaryRespose.dart';
import 'package:paitent/core/models/PatientMedicalProfilePojo.dart';
import 'package:paitent/core/models/PatientVitalsPojo.dart';
import 'package:paitent/core/models/getAvailableDoctorSlot.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/utils/StringUtility.dart';


import '../base_model.dart';

class PatientHealthMarkerViewModel extends BaseModel {

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> recordMyCalories(Map body) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post('/exercise/daily-burned-calories/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMySteps(Map body) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post('/exercise/daily-steps/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyWaterCount(Map body) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post('/nutrition/daily-water-consumption/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }




}