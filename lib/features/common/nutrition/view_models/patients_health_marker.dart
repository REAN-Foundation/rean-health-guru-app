import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/activity/models/get_all_activity_record.dart';
import 'package:patient/features/common/activity/models/get_all_meditation_data.dart';
import 'package:patient/features/common/activity/models/get_all_physical_activity_data.dart';
import 'package:patient/features/common/activity/models/get_all_steps_history.dart';
import 'package:patient/features/common/activity/models/get_sleep_history_data.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../../infra/view_models/base_model.dart';

class PatientHealthMarkerViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> recordMyCalories(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post(
        '/wellness/daily-records/calorie-balances',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetAllActivityRecord> getMystandHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/daily-records/stand/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetAllActivityRecord.fromJson(response);
  }

  Future<BaseResponse> deleteStandRecord(String recordId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/wellness/daily-records/stand/' + recordId, header: map);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetAllStepsHistory> getMyStepsHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/daily-records/step-counts/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetAllStepsHistory.fromJson(response);
  }

  Future<BaseResponse> deleteStepsRecord(String recordId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/wellness/daily-records/step-counts/' + recordId, header: map);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetAllPhysicalActivityData> getMyExcersizeHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/exercise/physical-activities/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetAllPhysicalActivityData.fromJson(response);
  }

  Future<BaseResponse> deleteExcersizeRecord(String recordId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/wellness/exercise/physical-activities/' + recordId, header: map);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetSleepHistoryData> getMySleepHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/daily-records/sleep/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetSleepHistoryData.fromJson(response);
  }

  Future<BaseResponse> deleteSleepRecord(String recordId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/wellness/daily-records/sleep/' + recordId, header: map);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetAllMeditationData> getMyMeditationHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/wellness/exercise/meditations/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return GetAllMeditationData.fromJson(response);
  }

  Future<BaseResponse> deleteMeditationRecord(String recordId) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .delete('/wellness/exercise/meditations/' + recordId, header: map);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMySteps(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/daily-records/step-counts', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyExcercise(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/exercise/physical-activities', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyStand(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/daily-records/stand', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyWaterCount(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post(
        '/wellness/nutrition/water-consumptions',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMySleep(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post(
        '/wellness/daily-records/sleep',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyMindfulness(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post(
        '/wellness/exercise/meditations',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyCaloriesConsumed(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/nutrition/food-consumptions', header: map, body: body);

    debugPrint(response.toString());

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyMonitoringFoodConsumtion(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/food-components-monitoring/', header: map, body: body);

    debugPrint(response.toString());

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
