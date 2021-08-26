class GetMyVitalsHistory {
  String status;
  String message;
  Data data;

  GetMyVitalsHistory({this.status, this.message, this.data});

  GetMyVitalsHistory.fromJson(Map<String, dynamic> json) {
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
  Biometrics biometrics;

  Data({this.biometrics});

  Data.fromJson(Map<String, dynamic> json) {
    biometrics = json['biometrics'] != null
        ? new Biometrics.fromJson(json['biometrics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.biometrics != null) {
      data['biometrics'] = this.biometrics.toJson();
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
      records = new List<Records>();
      json['Records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PatientUserId'] = this.patientUserId;
    data['VisitId'] = this.visitId;
    if (this.records != null) {
      data['Records'] = this.records.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['RecordDate'] = this.recordDate;
    data['Weight'] = this.weight;
    data['BloodGlucose'] = this.bloodGlucose;
    data['SystolicBloodPressure'] = this.systolicBloodPressure;
    data['DiastolicBloodPressure'] = this.diastolicBloodPressure;
    data['BloodOxygenSaturation'] = this.bloodOxygenSaturation;
    data['Pulse'] = this.pulse;
    data['Temperature'] = this.temperature;
    return data;
  }
}