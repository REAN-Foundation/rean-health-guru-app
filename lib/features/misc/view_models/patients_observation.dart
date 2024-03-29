import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_medical_profile_pojo.dart';
import 'package:patient/features/misc/models/patient_vitals_pojo.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/view_models/base_model.dart';


class PatientObservationsViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<PatientVitalsPojo> getPatientVitals(
      String auth1, String patientId) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/vitals?patientUserId=' + patientId,
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response);
    setBusy(false);
    // Convert and return
    return PatientVitalsPojo.fromJson(response);
  }

  Future<PatientMedicalProfilePojo> getPatientMedicalProfile(
      String auth1, String? patientId) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.get(
        '/patient-health-profiles/' + patientUserId!,
        header: map); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return PatientMedicalProfilePojo.fromJson(response);
  }

  Future<BaseResponse> updatePatientMedicalProfile(
      String? patientProfileId, Map body) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.put(
        '/patient-health-profiles/' + patientUserId!,
        header: map,
        body: body); //4c47a191-9cb6-4377-b828-83eb9ab48d0a

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> recordMyMonitoringFoodConsumtion(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!
        .post('/wellness/food-components-monitoring/', header: map, body: body);

    debugPrint(response.toString());

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> addMyVitals(String path, Map body) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    body['PatientUserId'] = patientUserId;
    //body['RecordedByUserId'] = recordedByUserId;

    print('body:');

    final response = await apiProvider!
        .post('/clinical/biometrics/' + path, header: map, body: body);

    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
