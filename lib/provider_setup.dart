import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/models/user_data.dart';
import 'core/services/api.dart';
import 'core/services/authentication_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api())
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  )
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<UserData>(
    create: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
  )
];
