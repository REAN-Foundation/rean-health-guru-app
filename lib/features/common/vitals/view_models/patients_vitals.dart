import 'package:get_it/get_it.dart';
import 'package:paitent/features/common/vitals/models/GetMyVitalsHistory.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/utils/StringUtility.dart';

import '../../../../infra/view_models/base_model.dart';

class PatientVitalsViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> addMyVitals(String path, Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    body['PatientUserId'] = patientUserId;
    //body['RecordedByUserId'] = recordedByUserId;

    print('body:');

    final response = await apiProvider.post(
        '/clinical/biometrics/' + path,
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetMyVitalsHistory> getMyVitalsHistory(String path) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/clinical/biometrics/' + path + '/search?patientUserId=' + patientUserId,
        header: map);

    setBusy(false);
    // Convert and return
    return GetMyVitalsHistory.fromJson(response);
  }
}
