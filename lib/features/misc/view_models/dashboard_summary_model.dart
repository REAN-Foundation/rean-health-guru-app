import 'package:get_it/get_it.dart';
import 'package:paitent/features/common/medication/models/GetMyMedicationsResponse.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/features/misc/models/GetAssesmentTemplateByIdResponse.dart';
import 'package:paitent/features/misc/models/GetMyAssesmentIdResponse.dart';
import 'package:paitent/features/misc/models/KnowledgeTopicResponse.dart';
import 'package:paitent/features/misc/models/SearchSymptomAssesmentTempleteResponse.dart';
import 'package:paitent/features/misc/models/TaskSummaryResponse.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:paitent/infra/view_models/base_model.dart';

class DashboardSummaryModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<TaskSummaryResponse> getTaskPlanSummary() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-task/patient/' + patientUserId! + '/summary-for-today',
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<TaskSummaryResponse> getMedicationSummary(String date) async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/medication-consumptions/summary-for-day/' +
            patientUserId! +
            '/' +
            date,
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<TaskSummaryResponse> getLatestBiometrics() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/biometrics/' + patientUserId! + '/latest-biometrics-summary',
        header: map);
    setBusy(false);
    // Convert and return
    return TaskSummaryResponse.fromJson(response);
  }

  Future<KnowledgeTopicResponse> getTodaysKnowledgeTopic() async {
    // Get user profile for id
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/educational/knowledge-nuggets/today/' + patientUserId!,
        header: map);
    setBusy(false);
    // Convert and return
    return KnowledgeTopicResponse.fromJson(response);
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

  Future<GetMyMedicationsResponse> getMyMedications(String date) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/medication-consumptions/schedule-for-day/' +
            patientUserId! +
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
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.put(
        '/clinical/medication-consumptions/mark-list-as-taken/',
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
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/clinical/symptoms/how-do-you-feel/', header: map, body: body);

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
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/symptom-assessment-templates/search?title=' + keyword,
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
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/symptom-assessment-templates/' + assesmentId,
        header: map);

    setBusy(false);
    // Convert and return
    return GetAssesmentTemplateByIdResponse.fromJson(response);
  }

  Future<GetMyAssesmentIdResponse> getMyAssesmentId(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/clinical/symptom-assessments/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return GetMyAssesmentIdResponse.fromJson(response);
  }

  Future<BaseResponse> addPatientSymptomsInAssesment(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response =
        await apiProvider!.post('/clinical/symptoms/', header: map, body: body);

    //setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
