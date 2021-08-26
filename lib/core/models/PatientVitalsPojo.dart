import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class PatientVitalsPojo {
  String status;
  String message;
  Data data;

  PatientVitalsPojo({this.status, this.message, this.data});

  PatientVitalsPojo.fromJson(Map<String, dynamic> json) {
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

class Data {
  List<Vitals> vitals;

  Data({this.vitals});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vitals'] != null) {
      vitals = new List<Vitals>();
      json['vitals'].forEach((v) {
        vitals.add(new Vitals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vitals != null) {
      data['vitals'] = this.vitals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vitals {
  String id;
  String visitId;
  String patientUserId;
  String doctorUserId;
  String weight;
  String height;
  String temperature;
  String pulse;
  String systolicBloodPressure;
  String diastolicBloodPressure;
  String bloodOxygenSaturation;

  Vitals(
      {this.id,
        this.visitId,
        this.patientUserId,
        this.doctorUserId,
        this.weight,
        this.height,
        this.temperature,
        this.pulse,
        this.systolicBloodPressure,
        this.diastolicBloodPressure,
        this.bloodOxygenSaturation});

  Vitals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitId = json['VisitId'];
    patientUserId = json['PatientUserId'];
    doctorUserId = json['DoctorUserId'];
    weight = json['Weight'].toString();
    height = json['Height'].toString();
    temperature = json['Temperature'].toString();
    pulse = json['Pulse'].toString();
    systolicBloodPressure = json['SystolicBloodPressure'].toString();
    diastolicBloodPressure = json['DiastolicBloodPressure'].toString();
    bloodOxygenSaturation = json['BloodOxygenSaturation'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['VisitId'] = this.visitId;
    data['PatientUserId'] = this.patientUserId;
    data['DoctorUserId'] = this.doctorUserId;
    data['Weight'] = this.weight;
    data['Height'] = this.height;
    data['Temperature'] = this.temperature;
    data['Pulse'] = this.pulse;
    data['SystolicBloodPressure'] = this.systolicBloodPressure;
    data['DiastolicBloodPressure'] = this.diastolicBloodPressure;
    data['BloodOxygenSaturation'] = this.bloodOxygenSaturation;
    return data;
  }
}