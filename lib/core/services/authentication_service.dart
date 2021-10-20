import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/user_data.dart';

import 'api.dart';

class AuthenticationService {
  final Api _api;

  AuthenticationService({Api api}) : _api = api;

  final StreamController<UserData> _userController =
      StreamController<UserData>();
  final StreamController<BaseResponse> _baseResponseController =
      StreamController<BaseResponse>();
  final StreamController<BaseResponse> _updateProfileBaseResponseController =
      StreamController<BaseResponse>();

  Stream<UserData> get user => _userController.stream;

  Future<UserData> login(Map body) async {
    final UserData fetchedUser = await _api.loginPatient(body);

    debugPrint(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _userController.add(fetchedUser);
    }

    return fetchedUser;
  }

  Future<BaseResponse> signUp(Map body) async {
    final BaseResponse fetchedUser = await _api.signUpPatient(body);

    debugPrint(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _baseResponseController.add(fetchedUser);
    }

    return fetchedUser;
  }

  Future<BaseResponse> updateProfile(
      Map body, String userId, String auth) async {
    final BaseResponse fetchedUser =
        await _api.updateProfilePatient(body, userId, auth);

    debugPrint(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _updateProfileBaseResponseController.add(fetchedUser);
    }
    return fetchedUser;
  }

}
