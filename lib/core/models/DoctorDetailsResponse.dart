import 'package:json_annotation/json_annotation.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';

@JsonSerializable(nullable: true)
class DoctorDetailsResponse {
  String status;
  String message;
  Data data;

  DoctorDetailsResponse({this.status, this.message, this.data});

  DoctorDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

@JsonSerializable(nullable: true)
class Data {
  Doctors doctor;

  Data({this.doctor});

  Data.fromJson(Map<String, dynamic> json) {
    doctor = json['doctor'] != null ? Doctors.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctor != null) {
      data['doctor'] = doctor.toJson();
    }
    return data;
  }
}
