import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class PatientHealthMarkerViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> recordMyCalories(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/exercise/daily-burned-calories/',
        header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMySteps(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/exercise/daily-steps/',
        header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyWaterCount(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .post('/nutrition/daily-water-consumption/', header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyCaloriesConsumed(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response =
        await apiProvider.post('/nutrition/generic', header: map, body: body);

    print(response);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
