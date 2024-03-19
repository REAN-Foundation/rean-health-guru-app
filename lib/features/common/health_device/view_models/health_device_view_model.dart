import 'package:get_it/get_it.dart';
import 'package:patient/features/common/health_device/models/health_device_list_with_status.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/view_models/base_model.dart';

class HealthDeviceViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<HealthDeviceListWithStatus> getHealthDeviceListWithTheirList() async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/devices/wearables/patients/' + patientUserId!,
        header: map);

    setBusy(false);
    // Convert and return
    return HealthDeviceListWithStatus.fromJson(response);
  }
}