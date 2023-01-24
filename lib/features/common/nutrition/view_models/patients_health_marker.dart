import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
