import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/infra/networking/user_analytics_api_provider.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';

class UserAnalyticsServices{

  static UserAnalyticsApiProvider? apiProvider = GetIt.instance<UserAnalyticsApiProvider>();

  static registerScreenEntryEvent(String eventType, String eventCategory, String eventSubject, String actionStatement, dynamic attribute, {String resourceType = ''})  {

    final body = <String, dynamic>{};
    body['UserId'] = patientUserId.toString();
    body['TenantId'] = tenantId.toString();
    body['ResourceId'] = null;
    body['ResourceType'] = resourceType;
    body['SessionId'] = null;
    body['SourceName'] = getAppName().toString();
    body['SourceVersion'] = appVersion;
    body['ActionType'] = 'user-action';
    body['ActionStatement'] = 'user-navigate-to-'+eventType;
    body['EventName'] = "screen-entry";
    body['EventCategory'] = eventCategory;
    body['EventSubject'] = eventSubject;
    body['Timestamp'] = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now().toUtc())+'Z';
    body['Attributes'] = attribute;

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

     apiProvider!.post('/events/', body: body, header: map);

  }


}
