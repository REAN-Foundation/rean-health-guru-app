import 'package:flutter/widgets.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/services/authentication_service.dart';

import '../base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<UserData> login(Map body) async {
    setBusy(true);
    UserData response = await _authenticationService.login(body);
    print(response.status.toString());
    setBusy(false);
    return response;
  }

  Future<BaseResponse> signUp(Map body) async {
    setBusy(true);
    BaseResponse response = await _authenticationService.signUp(body);
    print(response.status.toString());
    setBusy(false);
    return response;
  }

  Future<BaseResponse> updateProfile(
      Map body, String userId, String auth) async {
    setBusy(true);
    BaseResponse response =
        await _authenticationService.updateProfile(body, userId, auth);
    print(response.status.toString());
    setBusy(false);
    return response;
  }
}
