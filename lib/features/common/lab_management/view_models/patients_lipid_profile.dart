import 'package:get_it/get_it.dart';
import 'package:patient/features/common/lab_management/models/lipid_profile_history_response.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../../infra/view_models/base_model.dart';

class PatientLipidProfileViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<BaseResponse> addMylipidProfile(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    body['PatientUserId'] = patientUserId;
    //body['RecordedByUserId'] = recordedByUserId;

    print('body:');

    final response = await apiProvider!.post(
        '/clinical/biometrics/blood-cholesterol/',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<LipidProfileHistoryResponse> getMyVitalsHistory() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/clinical/biometrics/blood-cholesterol/search?patientUserId=' +
            patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return LipidProfileHistoryResponse.fromJson(response);
  }
}
