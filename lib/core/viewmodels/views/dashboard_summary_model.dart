import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetAssesmentTemplateByIdResponse.dart';
import 'package:paitent/core/models/GetMyAssesmentIdResponse.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/KnowledgeTopicResponse.dart';
import 'package:paitent/core/models/SearchSymptomAssesmentTempleteResponse.dart';
import 'package:paitent/core/models/TaskSummaryResponse.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class DashboardSummaryModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<TaskSummaryResponse> getTaskPlanSummary() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/patient-task/patient/' + patientUserId + '/summary-for-today',
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<TaskSummaryResponse> getMedicationSummary(String date) async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/medication-consumption/summary-for-day/' + patientUserId + '/' + date,
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<TaskSummaryResponse> getLatestBiometrics() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/biometrics/' + patientUserId + '/latest-biometrics-summary',
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<KnowledgeTopicResponse> getTodaysKnowledgeTopic() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/patient-knowledge/today/' + patientUserId, header: map);
    setBusy(false);
    // Convert and return
    return KnowledgeTopicResponse.fromJson(response);
  }

  Future<BaseResponse> addMedicalEmergencyEvent(Map body) async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response =
        await apiProvider.post('/emergency-event/', header: map, body: body);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetMyMedicationsResponse> getMyMedications(String date) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/medication-consumption/schedule-for-day/' +
            patientUserId +
            '/' +
            date,
        header: map);

    setBusy(false);
    // Convert and return
    return GetMyMedicationsResponse.fromJson(response);
  }

  Future<BaseResponse> markAllMedicationsAsTaken(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.put(
        '/medication-consumption/mark-list-as-taken/',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordHowAreYouFeeling(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response =
        await apiProvider.post('/how-do-you-feel/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<SearchSymptomAssesmentTempleteResponse> searchSymptomAssesmentTemplete(
      String keyword) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/symptom-assessment-templates/search?title=' + keyword,
        header: map);

    setBusy(false);
    // Convert and return
    return SearchSymptomAssesmentTempleteResponse.fromJson(response);
  }

  Future<GetAssesmentTemplateByIdResponse> getAssesmentTemplateById(
      String assesmentId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/symptom-assessment-templates/' + assesmentId, header: map);

    setBusy(false);
    // Convert and return
    return GetAssesmentTemplateByIdResponse.fromJson(response);
  }

  Future<GetMyAssesmentIdResponse> getMyAssesmentId(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/symptom-assessments/',
        header: map, body: body);

    setBusy(false);
    // Convert and return
    return GetMyAssesmentIdResponse.fromJson(response);
  }

  Future<BaseResponse> addPatientSymptomsInAssesment(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response =
        await apiProvider.post('/symptoms/', header: map, body: body);

    //setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
