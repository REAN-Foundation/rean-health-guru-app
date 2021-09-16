import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/ChatApiResponse.dart';
import 'package:paitent/networking/ChatApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class BotViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ChatApiProvider apiProvider = GetIt.instance<ChatApiProvider>();

  Future<ChatApiResponse> sendMsgApi(Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.post('/v1/appsupport/receive',
        header: map, body: body);

    setBusy(false);
    // Convert and return
    return ChatApiResponse.fromJson(response);
  }
}
