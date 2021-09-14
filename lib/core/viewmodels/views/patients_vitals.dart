import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyVitalsHistory.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class PatientVitalsViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> addMyVitals(String path, Map body) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.post(
        '/biometrics/' + patientUserId + '/' + path,
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetMyVitalsHistory> getMyVitalsHistory(String path) async {
    // Get user profile for id
    setBusy(true);

    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;

    var response = await apiProvider.get(
        '/biometrics/' + patientUserId + '/' + path + '/search',
        header: map);

    setBusy(false);
    // Convert and return
    return GetMyVitalsHistory.fromJson(response);
  }
}
