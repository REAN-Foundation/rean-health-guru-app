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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
    doctor =
        json['doctor'] != null ? new Doctors.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    return data;
  }
}
