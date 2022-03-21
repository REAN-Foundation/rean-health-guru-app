import 'package:flutter/material.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/services/authentication_service.dart';
import 'package:paitent/core/viewmodels/base_model.dart';

class AppoinmentViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  /*AppoinmentViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;
*/
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

  Future<BaseResponse> updateProfile(Map body, String userId, String auth) async {
    setBusy(true);
    final BaseResponse response =
        await _authenticationService.updateProfile(body, userId, auth);
    debugPrint(response.status.toString());
    setBusy(false);
    return response;
  }
}
