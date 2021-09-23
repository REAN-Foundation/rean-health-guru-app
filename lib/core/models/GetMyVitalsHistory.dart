class GetMyVitalsHistory {
  String status;
  String message;
  Data data;

  GetMyVitalsHistory({this.status, this.message, this.data});

  GetMyVitalsHistory.fromJson(Map<String, dynamic> json) {
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

class Data {
  Biometrics biometrics;

  Data({this.biometrics});

  Data.fromJson(Map<String, dynamic> json) {
    biometrics = json['biometrics'] != null
        ? Biometrics.fromJson(json['biometrics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (biometrics != null) {
      data['biometrics'] = biometrics.toJson();
    }
    return data;
  }
}

class Biometrics {
  String patientUserId;
  String visitId;
  List<Records> records;

  Biometrics({this.patientUserId, this.visitId, this.records});

  Biometrics.fromJson(Map<String, dynamic> json) {
    patientUserId = json['PatientUserId'];
    visitId = json['VisitId'];
    if (json['Records'] != null) {
      records = <Records>[];
      json['Records'].forEach((v) {
        records.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientUserId'] = patientUserId;
    data['VisitId'] = visitId;
    if (records != null) {
      data['Records'] = records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String id;
  String recordDate;
  dynamic weight;
  dynamic bloodGlucose;
  dynamic systolicBloodPressure;
  dynamic diastolicBloodPressure;
  dynamic bloodOxygenSaturation;
  dynamic pulse;
  dynamic temperature;

  Records(
      {this.id,
      this.recordDate,
      this.weight,
      this.bloodGlucose,
      this.systolicBloodPressure,
      this.diastolicBloodPressure,
      this.bloodOxygenSaturation,
      this.pulse,
      this.temperature});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recordDate = json['RecordDate'];
    weight = json['Weight'];
    bloodGlucose = json['BloodGlucose'];
    systolicBloodPressure = json['SystolicBloodPressure'];
    diastolicBloodPressure = json['DiastolicBloodPressure'];
    bloodOxygenSaturation = json['BloodOxygenSaturation'];
    pulse = json['Pulse'];
    temperature = json['Temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['RecordDate'] = recordDate;
    data['Weight'] = weight;
    data['BloodGlucose'] = bloodGlucose;
    data['SystolicBloodPressure'] = systolicBloodPressure;
    data['DiastolicBloodPressure'] = diastolicBloodPressure;
    data['BloodOxygenSaturation'] = bloodOxygenSaturation;
    data['Pulse'] = pulse;
    data['Temperature'] = temperature;
    return data;
  }
}
