import 'package:flutter/widgets.dart';
import 'package:paitent/features/misc/models/BaseResponse.dart';
import 'package:paitent/features/misc/models/user_data.dart';
import 'package:paitent/features/misc/view_models/authentication_service.dart';

import '../../../infra/view_models/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService;

  LoginViewModel({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<UserData> login(Map body) async {
    setBusy(true);
    final UserData response = await _authenticationService.login(body);
    debugPrint(response.status.toString());
    setBusy(false);
    return response;
  }

  Future<BaseResponse> signUp(Map body) async {
    setBusy(true);
    final BaseResponse response = await _authenticationService.signUp(body);
    debugPrint(response.status.toString());
    setBusy(false);
    return response;
  }

  Future<BaseResponse> updateProfile(
      Map body, String userId, String auth) async {
    setBusy(true);
    final BaseResponse response =
        await _authenticationService.updateProfile(body, userId, auth);
    debugPrint(response.toString());
    setBusy(false);
    return response;
  }
}
