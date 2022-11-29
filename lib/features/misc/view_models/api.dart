import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/infra/networking/api_provider.dart';

/// The service responsible for networking requests
class Api {
  //static const endpoint = 'https://hca-bff-dev.services.tikme.app';

  //var client = new http.Client();

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<UserData> loginPatient(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider!.post('/user/login', body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return UserData.fromJson(response);
  }

  Future<PatientApiDetails> loginPatientWithOTP(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider!.post('/patient', body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return PatientApiDetails.fromJson(response);
  }

  Future<PatientApiDetails> verifyOTP(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider!.post('/user/validate-otp', body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return PatientApiDetails.fromJson(response);
  }

  Future<BaseResponse> signUpPatient(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider!.post('/Patient', body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateProfilePatient(
      Map body, String userId, String auth) async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider!.put('/patients/' + userId, body: body, header: map);

    debugPrint(response.toString());

    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
