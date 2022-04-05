import 'package:paitent/features/misc/view_models/api.dart';
import 'package:paitent/features/misc/view_models/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildWidget> independentServices = [Provider.value(value: Api())];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  )
];

/*List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<UserData>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user)
];*/
