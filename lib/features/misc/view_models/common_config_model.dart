import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/achievement/models/how_to_earn_badges.dart';
import 'package:patient/features/common/careplan/models/get_care_plan_enrollment_for_patient.dart';
import 'package:patient/features/common/careplan/models/get_weekly_care_plan_status.dart';
import 'package:patient/features/common/emergency/models/emergency_contact_response.dart';
import 'package:patient/features/common/emergency/models/health_syetem_hospital_pojo.dart';
import 'package:patient/features/common/emergency/models/health_system_pojo.dart';
import 'package:patient/features/misc/models/awards_user_details.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/get_all_record_response.dart';
import 'package:patient/features/misc/models/get_health_report_settings_pojo.dart';
import 'package:patient/features/misc/models/get_sharable_public_link.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/awards_api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../infra/view_models/base_model.dart';
import '../../common/activity/models/GetRecords.dart';
import '../../common/vitals/models/get_my_vitals_history.dart';

class CommonConfigModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  AwardApiProvider? awardApiProvider = GetIt.instance<AwardApiProvider>();

  Future<GetCarePlanEnrollmentForPatient> getCarePlan(bool isActive) async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/care-plans/patients/' + patientUserId! + '/enrollments?isActive='+isActive.toString(),
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

  Future<HealthSystemPojo> getHealthSystem(String planName) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-emergency-contacts/health-systems',//?planName='+planName
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

  Future<GetMyVitalsHistory> getMyVitalsHistory(String path) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/biometrics/' +
            path +
            '/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetMyVitalsHistory.fromJson(response);
  }

  Future<GetRecords> getMySleepHistory(String createFromDate) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/daily-records/sleep/search?patientUserId=' +
            patientUserId!+'&createdDateFrom='+createFromDate,
        header: map);

    setBusy(false);
    // Convert and return
    return GetRecords.fromJson(response);
  }

  Future<GetRecords> getMyStepHistory(String createFromDate) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/daily-records/step-counts/search?patientUserId=' +
            patientUserId!+'&createdDateFrom='+createFromDate,
        header: map);

    setBusy(false);
    // Convert and return
    return GetRecords.fromJson(response);
  }

  Future<BaseResponse> generateReport() async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;
    final response = await apiProvider!
        .get('/patient-statistics/'+patientUserId.toString()+'/report', header: map);
    debugPrint('Report Generation ==> $response');
    // Convert and return
    return BaseResponse.fromJson(response);
  }//your report is getting downloaded, Please check in the medical records after few minutes

  Future<AwardsUserDetails> getAwardsSytstemUserDetails() async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await awardApiProvider!.get(
        '/participants/by-reference-id/'+patientUserId.toString(),
        header: map);
    //setBusy(false);
    // Convert and return
    return AwardsUserDetails.fromJson(response);
  }

  Future<BaseResponse> createAwardParticipent(Map body) async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await awardApiProvider!.post(
        '/participants', body: body,
        header: map);
    //setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<HowToEarnBadges> howToEarnAwardsDescription() async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await awardApiProvider!.get(
        '/badges/how-to-earn',
        header: map);
    //setBusy(false);
    // Convert and return
    return HowToEarnBadges.fromJson(response);
  }

  Future<GetHealthReportSettingsPojo> getHealthReportSettings() async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-statistics/'+patientUserId.toString()+'/settings',
        header: map);
    //setBusy(false);
    // Convert and return
    return GetHealthReportSettingsPojo.fromJson(response);
  }

  Future<GetHealthReportSettingsPojo> setHealthReportSettings(Map body) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.put(
        '/patient-statistics/'+patientUserId.toString()+'/settings',
        header: map, body: body);
    setBusy(false);
    // Convert and return
    return GetHealthReportSettingsPojo.fromJson(response);
  }

}
