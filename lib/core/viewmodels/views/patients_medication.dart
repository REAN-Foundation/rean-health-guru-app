
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/DoctorAppoinmentBookedSuccessfully.dart';
import 'package:paitent/core/models/DrugOrderIdPojo.dart';
import 'package:paitent/core/models/DrugsLibraryPojo.dart';
import 'package:paitent/core/models/GetMedicationStockImages.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
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

class PatientMedicationViewModel extends BaseModel {

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<MyCurrentMedication> getMyCurrentMedications() async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.get('/medication/current/'+patientUserId, header: map);

    setBusy(false);
    // Convert and return
    return MyCurrentMedication.fromJson(response);
  }

  Future<GetMyMedicationsResponse> getMyMedications(String date) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.get('/medication-consumption/schedule-for-day/'+patientUserId+'/'+date , header: map);

    setBusy(false);
    // Convert and return
    return GetMyMedicationsResponse.fromJson(response);
  }

  Future<BaseResponse> markMedicationsAsTaken(String consumptionId) async {
    // Get user profile for id
    //setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var body = new Map<String, String>();


    var response = await apiProvider.put('/medication-consumption/mark-as-taken/'+consumptionId , header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> markMedicationsAsMissed(String consumptionId) async {
    // Get user profile for id
    //setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var body = new Map<String, String>();


    var response = await apiProvider.put('/medication-consumption/mark-as-missed/'+consumptionId , header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<MyMedicationSummaryRespose> getMyMedicationSummary() async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.get('/medication-consumption/summary-for-calendar-months/'+patientUserId , header: map);

    setBusy(false);
    // Convert and return
    return MyMedicationSummaryRespose.fromJson(response);
  }



  Future<DrugsLibraryPojo> getDrugsByKeyword(String searchKeyword) async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response = await apiProvider.get('/types/drugs?name='+searchKeyword, header: map);//4c47a191-9cb6-4377-b828-83eb9ab48d0a
    print(response);
    // Convert and return
    return DrugsLibraryPojo.fromJson(response);
  }

  Future<BaseResponse> addMedicationforVisit(Map body) async {
    setBusy(true);
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post('/medication', body: body, header: map);//4c47a191-9cb6-4377-b828-83eb9ab48d0a

    print(response);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> addDrugToLibrary(Map body) async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response = await apiProvider.post('/types/drugs', body: body, header: map);
    print(response);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<DrugOrderIdPojo> createDrugOrderIdForVisit(Map body) async {
    setBusy(true);
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post('/drug-order', body: body, header: map);//4c47a191-9cb6-4377-b828-83eb9ab48d0a

    print(response);
    setBusy(false);
    // Convert and return
    return DrugOrderIdPojo.fromJson(response);
  }

  Future<GetMedicationStockImages> getMedicationStockImages() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response = await apiProvider.get('/medication/stock-images', header: map);//4c47a191-9cb6-4377-b828-83eb9ab48d0a
    print(response);
    // Convert and return
    return GetMedicationStockImages.fromJson(response);
  }

}