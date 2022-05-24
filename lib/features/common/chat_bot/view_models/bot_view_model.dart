import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/chat_bot/models/chat_api_response.dart';
import 'package:patient/infra/networking/chat_api_provider.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../../infra/view_models/base_model.dart';

class BotViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ChatApiProvider? apiProvider = GetIt.instance<ChatApiProvider>();

  String clientName = 'REAN_BOT';

  Future<ChatApiResponse> sendMsgApi(Map body) async {
    if (getAppType() == 'AHA') {
      clientName = getAppType();
    }

    setBusy(true);
    Map<String, String>? map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;
    map['authentication'] = dotenv.env['BOT_HEADER_TOKEN'] as String;

    final response = await apiProvider!.post(
        '/' +
            clientName +
            '/REAN_SUPPORT/' +
            dotenv.env['BOT_URL_TOKEN']! +
            '/receive',
        header: map,
        body: body);

    setBusy(false);
    // Convert and return
    return ChatApiResponse.fromJson(response);
  }
}
