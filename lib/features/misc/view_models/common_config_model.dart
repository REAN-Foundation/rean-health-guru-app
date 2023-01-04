import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/models/get_weekly_care_plan_status.dart';
import 'package:patient/features/common/emergency/models/emergency_contact_response.dart';
import 'package:patient/features/common/emergency/models/health_syetem_hospital_pojo.dart';
import 'package:patient/features/common/emergency/models/health_system_pojo.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/get_all_record_response.dart';
import 'package:patient/features/misc/models/get_sharable_public_link.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../infra/view_models/base_model.dart';

class CommonConfigModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<GetCarePlanEnrollmentForPatient> getCarePlan() async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/care-plans/patients/' + patientUserId! + '/enrollments?isAcvtive=true',
        header: map);
    setBusy(false);
    // Convert and return
    return GetCarePlanEnrollmentForPatient.fromJson(response);
  }

  Future<GetWeeklyCarePlanStatus> getCarePlanWeeklyStatus(
      String carePlanId) async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .get('/care-plans/' + carePlanId + '/weekly-status', header: map);
    setBusy(false);
    // Convert and return
    return GetWeeklyCarePlanStatus.fromJson(response);
  }

  Future<GetAllRecordResponse> getAllRecords() async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response =
        await apiProvider!.get('/patient-documents/search', header: map);
    setBusy(false);
    // Convert and return
    return GetAllRecordResponse.fromJson(response);
  }

  Future<BaseResponse> renameOfDocument(String documentId, Map body) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.put(
        '/patient-documents/' + documentId + '/rename',
        header: map,
        body: body);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> deleteDocument(String documentId) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/patient-documents/' + documentId, header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetSharablePublicLink> getDocumentPublicLink(String documentId) async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-documents/' + documentId + '/share?durationMinutes=120',
        header: map);
    //setBusy(false);
    // Convert and return
    return GetSharablePublicLink.fromJson(response);
  }

  Future<EmergencyContactResponse> getEmergencyTeam() async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-emergency-contacts/search?isAvailableForEmergency=true&order=ascending&patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return EmergencyContactResponse.fromJson(response);
  }

  Future<HealthSystemPojo> getHealthSystem() async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-emergency-contacts/health-systems',
        header: map);

    setBusy(false);
    // Convert and return
    return HealthSystemPojo.fromJson(response);
  }

  Future<HealthSyetemHospitalPojo> getHealthSystemHospital(String healthSystemId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-emergency-contacts/health-systems/'+healthSystemId,
        header: map);

    setBusy(false);
    // Convert and return
    return HealthSyetemHospitalPojo.fromJson(response);
  }

  Future<BaseResponse> updateProfilePatient(
      Map body) async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response =
    await apiProvider!.put('/patients/' + patientUserId!, body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> addTeamMembers(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/patient-emergency-contacts', body: body, header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> removeTeamMembers(String emergencyContactId) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.delete(
        '/patient-emergency-contacts/' + emergencyContactId,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> addMedicalEmergencyEvent(Map body) async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/clinical/emergency-events', header: map, body: body);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordDailyCheckIn(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/clinical/daily-assessments/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
