import 'dart:async';

import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/user_data.dart';

import 'api.dart';

class AuthenticationService {
  final Api _api;

  AuthenticationService({Api api}) : _api = api;

  StreamController<UserData> _userController = StreamController<UserData>();
  StreamController<BaseResponse> _baseResponseController =
      StreamController<BaseResponse>();
  StreamController<BaseResponse> _updateProfileBaseResponseController =
      StreamController<BaseResponse>();

  Stream<UserData> get user => _userController.stream;

  Future<UserData> login(Map body) async {
    UserData fetchedUser = await _api.loginPatient(body);

    print(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _userController.add(fetchedUser);
    }

    return fetchedUser;
  }

  Future<BaseResponse> signUp(Map body) async {
    BaseResponse fetchedUser = await _api.signUpPatient(body);

    print(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _baseResponseController.add(fetchedUser);
    }

    return fetchedUser;
  }

  Future<BaseResponse> updateProfile(
      Map body, String userId, String auth) async {
    BaseResponse fetchedUser =
        await _api.updateProfilePatient(body, userId, auth);

    print(fetchedUser.status.toString());
    //UserData hasUser = fetchedUser != null;
    if (fetchedUser.status == 'success') {
      _updateProfileBaseResponseController.add(fetchedUser);
    }

    return fetchedUser;
  }
}
