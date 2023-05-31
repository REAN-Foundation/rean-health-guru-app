import 'package:get_it/get_it.dart';
import 'package:patient/features/common/achievement/models/get_my_awards_list.dart';
import 'package:patient/infra/networking/awards_api_provider.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/view_models/base_model.dart';


class AllAchievementViewModel extends BaseModel{
  AwardApiProvider? apiProvider = GetIt.instance<AwardApiProvider>();

  Future<GetMyAwardsList> getMyAwards() async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/participants/'+getAwardsSystemId()+'/badges',
        header: map);
    setBusy(false);
    // Convert and return
    return GetMyAwardsList.fromJson(response);
  }

}