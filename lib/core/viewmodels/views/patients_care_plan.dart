import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/AddTeamMemberResponse.dart';
import 'package:paitent/core/models/AnswerAssesmentResponse.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetAHACarePlansResponse.dart';
import 'package:paitent/core/models/GetActionOfGoalPlan.dart';
import 'package:paitent/core/models/GetCarePlanMyResponse.dart';
import 'package:paitent/core/models/GetCarePlanSummaryResponse.dart';
import 'package:paitent/core/models/GetGoalPriorities.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/StartAssesmentResponse.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/core/models/TeamCarePlanReesponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class PatientCarePlanViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<GetAHACarePlansResponse> getAHACarePlans() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get('/aha/care-plan/types', header: map);

    setBusy(false);
    // Convert and return
    return GetAHACarePlansResponse.fromJson(response);
  }

  Future<StartCarePlanResponse> startCarePlan(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/aha/care-plan/enroll',
        body: body, header: map);
    setBusy(false);
    // Convert and return
    return StartCarePlanResponse.fromJson(response);
  }

  Future<AddTeamMemberResponse> addTeamMembers(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/aha/care-plan/add-team-member',
        body: body, header: map);
    setBusy(false);
    // Convert and return
    return AddTeamMemberResponse.fromJson(response);
  }

  Future<BaseResponse> removeTeamMembers(String emergencyContactId) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.delete(
        '/aha/care-plan/team-member/' + emergencyContactId,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<DoctorListApiResponse> getDoctorList(String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider.get('/doctor', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DoctorListApiResponse.fromJson(response);
  }

  Future<PharmacyListApiResponse> getPhrmacyListByLocality(
      String lat, String long, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider
        .get('/pharmacy?long=' + long + '&lat=' + lat, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return PharmacyListApiResponse.fromJson(response);
  }

  Future<GetCarePlanSummaryResponse> getAHACarePlanSummary(
      String ahaCarePlanId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/summary/' + ahaCarePlanId, header: map);

    setBusy(false);
    // Convert and return
    return GetCarePlanSummaryResponse.fromJson(response);
  }

  Future<GetCarePlanMyResponse> getMyAHACarePlan() async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/patient/' + patientUserId, header: map);

    setBusy(false);
    // Convert and return
    return GetCarePlanMyResponse.fromJson(response);
  }

  Future<TeamCarePlanReesponse> getAHACarePlanTeam(String ahaCarePlanId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/' + ahaCarePlanId + '/list-members', header: map);

    setBusy(false);
    // Convert and return
    return TeamCarePlanReesponse.fromJson(response);
  }

  Future<GetTaskOfAHACarePlanResponse> getTaskOfAHACarePlan(
      String ahaCarePlanId, String state) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final String query = state == '' ? '' : '?state=' + state;

    //var response = await apiProvider.get('/aha/care-plan/'+ahaCarePlanId+'/fetch-daily-tasks', header: map);
    final response = await apiProvider
        .get('/aha/care-plan/' + ahaCarePlanId + '/tasks' + query, header: map);

    setBusy(false);
    // Convert and return
    return GetTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<GetTaskOfAHACarePlanResponse> getTaskOfPaitent(String state) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final String query = state == '' ? '' : '?state=' + state;

    //var response = await apiProvider.get('/aha/care-plan/'+ahaCarePlanId+'/fetch-daily-tasks', header: map);
    final response = await apiProvider
        .get('/patient-task/patient/' + patientUserId + query, header: map);

    setBusy(false);
    // Convert and return
    return GetTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<StartTaskOfAHACarePlanResponse> startTaskOfAHACarePlan(
      String ahaCarePlanId, String taskId) async {
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.post(
        '/aha/care-plan/' + ahaCarePlanId + '/start-task/' + taskId,
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return StartTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<StartTaskOfAHACarePlanResponse> stopTaskOfAHACarePlan(
      String ahaCarePlanId, String taskId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.post(
        '/aha/care-plan/' + ahaCarePlanId + '/finish-task/' + taskId,
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return StartTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<StartTaskOfAHACarePlanResponse> completeMessageTaskOfAHACarePlan(
      String ahaCarePlanId, String taskId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/message-task/' +
            taskId +
            '/mark-as-read',
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return StartTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<StartTaskOfAHACarePlanResponse> completeChallengeTask(
      String ahaCarePlanId, String taskId, Map body) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/challenge-task/' +
            taskId +
            '/add-notes',
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return StartTaskOfAHACarePlanResponse.fromJson(response);
  }

  Future<StartAssesmentResponse> startAssesmentResponse(
      String ahaCarePlanId, String taskId) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/assessment-task/' +
            taskId +
            '/start',
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return StartAssesmentResponse.fromJson(response);
  }

  Future<AnswerAssesmentResponse> answerAssesmentResponse(
      String ahaCarePlanId, String taskId, String qNaId, Map body) async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/assessment-task/' +
            taskId +
            '/answer-question/' +
            qNaId,
        body: body,
        header: map);

    setBusy(false);
    // Convert and return
    return AnswerAssesmentResponse.fromJson(response);
  }

  Future<BaseResponse> addBiometricTask(
      String ahaCarePlanId, String biometricId, Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/biometrics-task/' +
            biometricId +
            '/record',
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetGoalPriorities> getGoalsPriority(String planId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/' + planId + '/goal-priority-types', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetGoalPriorities.fromJson(response);
  }

  Future<BaseResponse> setGoalsPriority(String planId, Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' + planId + '/goal-priorities',
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetGoalPriorities> getBehavioralGoal(String planCode) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/aha/care-plan/' + planCode + '/behavioral-goal-types',
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetGoalPriorities.fromJson(response);
  }

  Future<GetGoalPriorities> getBiometricGoal(String planCode) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/aha/care-plan/' + planCode + '/biometric-goal-types',
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetGoalPriorities.fromJson(response);
  }

  Future<BaseResponse> addGoalsTask(
      String planId, String goalTasks, Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' + planId + '/' + goalTasks,
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetActionOfGoalPlan> getActionOfGoalPlan(String planId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/' + planId + '/plan-action-types', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetActionOfGoalPlan.fromJson(response);
  }

  Future<BaseResponse> updateWeeklyReflection(
      String planId, String tasksId, Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            planId +
            '/weekly-patient-reflections-task/' +
            tasksId +
            '/update',
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<AnswerAssesmentResponse> addBiometricAssignmentTask(
      String ahaCarePlanId,
      String assesmentTaskId,
      String qnaId,
      Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            ahaCarePlanId +
            '/assessment-task/' +
            assesmentTaskId +
            '/answer-question' +
            '/' +
            qnaId,
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return AnswerAssesmentResponse.fromJson(response);
  }

  Future<BaseResponse> statusCheck(
      String planId, String tasksId, Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post(
        '/aha/care-plan/' +
            planId +
            '/status-checks-task/' +
            tasksId +
            '/update',
        body: body,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> markMedicationsAsTaken(String consumptionId) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final body = <String, String>{};

    final response = await apiProvider.put(
        '/medication-consumption/mark-as-taken/' + consumptionId,
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
