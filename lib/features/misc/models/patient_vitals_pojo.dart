class PatientVitalsPojo {
  String? status;
  String? message;
  Data? data;

  PatientVitalsPojo({this.status, this.message, this.data});

  PatientVitalsPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Vitals>? vitals;

  Data({this.vitals});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vitals'] != null) {
      vitals = <Vitals>[];
      json['vitals'].forEach((v) {
        vitals!.add(Vitals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vitals != null) {
      data['vitals'] = vitals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vitals {
  String? id;
  String? visitId;
  String? patientUserId;
  String? doctorUserId;
  String? weight;
  String? height;
  String? temperature;
  String? pulse;
  String? systolicBloodPressure;
  String? diastolicBloodPressure;
  String? bloodOxygenSaturation;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['VisitId'] = visitId;
    data['PatientUserId'] = patientUserId;
    data['DoctorUserId'] = doctorUserId;
    data['Weight'] = weight;
    data['Height'] = height;
    data['Temperature'] = temperature;
    data['Pulse'] = pulse;
    data['SystolicBloodPressure'] = systolicBloodPressure;
    data['DiastolicBloodPressure'] = diastolicBloodPressure;
    data['BloodOxygenSaturation'] = bloodOxygenSaturation;
    return data;
  }
}
