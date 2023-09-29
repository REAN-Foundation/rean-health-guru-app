import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/remainder/models/get_my_all_remainders.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../../infra/view_models/base_model.dart';

class PatientRemainderViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> addRemainder(Map body, String path) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post('/reminders/'+path,
        body: body, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetMyAllRemainders> getAllRemainders() async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response =
    await apiProvider!.get('/reminders/search?userId='+patientUserId.toString(), header: map);
    setBusy(false);
    // Convert and return
    return GetMyAllRemainders.fromJson(response);
  }

  Future<BaseResponse> deleteRemainder(String remainderId) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response =
    await apiProvider!.delete('/reminders/'+remainderId, header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
