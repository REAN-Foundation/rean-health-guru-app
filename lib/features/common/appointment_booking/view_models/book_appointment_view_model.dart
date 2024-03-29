import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/common/appointment_booking/models/check_conflict_response.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_appointment_booked_successfully.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_details_response.dart';
import 'package:patient/features/common/appointment_booking/models/lab_details_response.dart';
import 'package:patient/features/common/appointment_booking/models/my_appointment_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/labs_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/pharmacy_list_api_response.dart';
import 'package:patient/features/misc/models/get_available_doctor_slot.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../../infra/view_models/base_model.dart';

class BookAppoinmentViewModel extends BaseModel {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  Future<DoctorListApiResponse> getDoctorListBySearch(
      String searchKeyword, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get(
        '/doctor?name=' +
            searchKeyword +
            '&locality=' +
            searchKeyword +
            '&speciality=' +
            searchKeyword,
        header: map);

    debugPrint(response);
    setBusy(false);
    // Convert and return
    return DoctorListApiResponse.fromJson(response);
  }

  Future<DoctorListApiResponse> getDoctorListByLocality(
      String searchKeyword, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider!.get('/doctor?&name=' + searchKeyword, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DoctorListApiResponse.fromJson(response);
  }

  Future<DoctorListApiResponse> getDoctorList(String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get('/doctor', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DoctorListApiResponse.fromJson(response);
  }

  Future<DoctorDetailsResponse> getDoctorDetails(
      String auth, String doctorUserId) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider!.get('/doctor/' + doctorUserId, header: map);

    debugPrint(response.toString());
    //setBusy(false);
    // Convert and return
    return DoctorDetailsResponse.fromJson(response);
  }

  Future<LabDetailsResponse> getLabDetails(
      String auth, String labUserId) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get('/lab/' + labUserId, header: map);

    debugPrint(response.toString());
    //setBusy(false);
    // Convert and return
    return LabDetailsResponse.fromJson(response);
  }

  Future<LabsListApiResponse> getLabsListByLocality(
      String searchKeyword, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider!.get('/lab?&name=' + searchKeyword, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return LabsListApiResponse.fromJson(response);
  }

  Future<LabsListApiResponse> getLabsListBySearch(
      String lat, String long, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!
        .get('/lab?long=' + long + '&lat=' + lat, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return LabsListApiResponse.fromJson(response);
  }

  Future<LabsListApiResponse> getLabsList(String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get('/lab', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return LabsListApiResponse.fromJson(response);
  }

  Future<PharmacyListApiResponse> getPhrmacyListByLocality(
      String lat, String long, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!
        .get('/pharmacy?long=' + long + '&lat=' + lat, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return PharmacyListApiResponse.fromJson(response);
  }

  Future<GetAvailableDoctorSlot> getAvailableDoctorSlot(
      String doctorId, String startDate, String endDate, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get(
        '/appointment/slots/doctor/' +
            doctorId +
            '?from_date=' +
            startDate +
            '&to_date=' +
            endDate,
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetAvailableDoctorSlot.fromJson(response);
  }

  Future<GetAvailableDoctorSlot> getAvailableLabSlot(
      String labId, String startDate, String endDate, String auth) async {
    // Get user profile for id
    setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get(
        '/appointment/slots/lab/' +
            labId +
            '?from_date=' +
            startDate +
            '&to_date=' +
            endDate,
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return GetAvailableDoctorSlot.fromJson(response);
  }

  Future<CheckConflictResponse> checkSlotConflict(Map body) async {
    // Get user profile for id
    //setBusy(true);

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final response = await apiProvider!.post(
        '/appointment/patient/' + patientUserId! + '/check-slot-conflict',
        header: map,
        body: body);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return CheckConflictResponse.fromJson(response);
  }

  Future<DoctorAppoinmentBookedSuccessfully> bookAAppoinmentForDoctor(
      String doctorId, Map body, String auth) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!
        .post('/appointment/book/doctor/' + doctorId, body: body, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DoctorAppoinmentBookedSuccessfully.fromJson(response);
  }

  Future<DoctorAppoinmentBookedSuccessfully> bookAAppoinmentForLab(
      String labId, Map body, String auth) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!
        .post('/appointment/book/lab/' + labId, body: body, header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return DoctorAppoinmentBookedSuccessfully.fromJson(response);
  }

  Future<MyAppointmentApiResponse> getMyAppoinmentList(String auth) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider!.get('/appointment/for-me/', header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return MyAppointmentApiResponse.fromJson(response);
  }

  Future<MyAppointmentApiResponse> getMyAppoinmentByDateList(
      String auth, String startDate, String endDate) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get(
        '/appointment/for-me/?from_date=' +
            startDate +
            '&to_date=' +
            endDate +
            '&time_zone=+0530',
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return MyAppointmentApiResponse.fromJson(response);
  }

  Future<MyAppointmentApiResponse> getMyAppoinmentByDateLisAndStatus(
      String auth, String status, String startDate, String endDate) async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response = await apiProvider!.get(
        '/appointment/for-me/?show=' +
            status +
            '&from_date=' +
            startDate +
            '&to_date=' +
            endDate +
            '&time_zone=+0530',
        header: map);

    debugPrint(response.toString());
    setBusy(false);
    // Convert and return
    return MyAppointmentApiResponse.fromJson(response);
  }
}
