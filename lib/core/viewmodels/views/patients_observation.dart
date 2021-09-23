import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/PatientMedicalProfilePojo.dart';
import 'package:paitent/core/models/PatientVitalsPojo.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class PatientObservationsViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<PatientVitalsPojo> getPatientVitals(String auth1, String patientId) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get('/vitals?patientUserId=' + patientId,
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response);
    setBusy(false);
    // Convert and return
    return PatientVitalsPojo.fromJson(response);
  }

  Future<PatientMedicalProfilePojo> getPatientMedicalProfile(String auth1, String patientId) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/medical-profile?patientUserId=' + patientId,
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return PatientMedicalProfilePojo.fromJson(response);
  }

  Future<BaseResponse> updatePatientMedicalProfile(String patientProfileId, Map body) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.put(
        '/medical-profile/' + patientProfileId,
        header: map,
        body: body); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
