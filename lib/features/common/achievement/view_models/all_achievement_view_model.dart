import 'package:get_it/get_it.dart';
import 'package:patient/infra/view_models/base_model.dart';

import '../../../../infra/networking/api_provider.dart';

class AllAchievementViewModel extends BaseModel{
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
}