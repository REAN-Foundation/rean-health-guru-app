import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/EmergencyContactResponse.dart';
import 'package:paitent/core/models/GetAllRecordResponse.dart';
import 'package:paitent/core/models/GetSharablePublicLink.dart';
import 'package:paitent/core/models/StartCarePlanResponse.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/StringUtility.dart';

import '../base_model.dart';

class CommonConfigModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<StartCarePlanResponse> getCarePlan() async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/aha/care-plan/patient/' + patientUserId, header: map);
    setBusy(false);
    // Convert and return
    return StartCarePlanResponse.fromJson(response);
  }

  Future<GetAllRecordResponse> getAllRecords() async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/patient/' + patientUserId + '/document', header: map);
    setBusy(false);
    // Convert and return
    return GetAllRecordResponse.fromJson(response);
  }

  Future<BaseResponse> renameOfDocument(String documentId, Map body) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.put(
        '/patient/' + patientUserId + '/document/rename/' + documentId,
        header: map,
        body: body);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> deleteDocument(String documentId) async {
    // Get user profile for id
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.delete(
        '/patient/' + patientUserId + '/document/' + documentId,
        header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<GetSharablePublicLink> getDocumentPublicLink(String documentId) async {
    // Get user profile for id
    //setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider.get(
        '/patient/' +
            patientUserId +
            '/share-document/' +
            documentId +
            '/duration-minutes/120',
        header: map);
    //setBusy(false);
    // Convert and return
    return GetSharablePublicLink.fromJson(response);
  }

  Future<EmergencyContactResponse> getEmergencyTeam() async {
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .get('/emergency-contact/list/' + patientUserId, header: map);

    setBusy(false);
    // Convert and return
    return EmergencyContactResponse.fromJson(response);
  }

  Future<BaseResponse> addTeamMembers(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response =
        await apiProvider.post('/emergency-contact', body: body, header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> removeTeamMembers(String emergencyContactId) async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth;

    final response = await apiProvider
        .delete('/emergency-contact/' + emergencyContactId, header: map);
    setBusy(false);
    // Convert and return
    return BaseResponse.fromJson(response);
  }
}
