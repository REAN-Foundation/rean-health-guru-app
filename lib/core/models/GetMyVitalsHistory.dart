class GetMyVitalsHistory {
  String status;
  String message;
  int httpCode;
  Data data;

  GetMyVitalsHistory({this.status, this.message, this.httpCode, this.data});

  GetMyVitalsHistory.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Records bloodGlucoseRecords;
  Records bloodPressureRecords;
  Records pulseRecords;
  Records bodyTemperatureRecords;
  Records bodyWeightRecords;
  Records bloodOxygenSaturationRecords;

  Data(
      {this.bloodGlucoseRecords,
        this.bloodPressureRecords,
        this.pulseRecords,
        this.bodyTemperatureRecords,
        this.bodyWeightRecords,
        this.bloodOxygenSaturationRecords});

  Data.fromJson(Map<String, dynamic> json) {
    bloodGlucoseRecords = json['BloodGlucoseRecords'] != null
        ? new Records.fromJson(json['BloodGlucoseRecords'])
        : null;
    bloodPressureRecords = json['BloodPressureRecords'] != null
        ? new Records.fromJson(json['BloodPressureRecords'])
        : null;
    pulseRecords = json['PulseRecords'] != null
        ? new Records.fromJson(json['PulseRecords'])
        : null;
    bodyTemperatureRecords = json['BodyTemperatureRecords'] != null
        ? new Records.fromJson(json['BodyTemperatureRecords'])
        : null;
    bodyWeightRecords = json['BodyWeightRecords'] != null
        ? new Records.fromJson(json['BodyWeightRecords'])
        : null;
    bloodOxygenSaturationRecords = json['BloodOxygenSaturationRecords'] != null
        ? new Records.fromJson(json['BloodOxygenSaturationRecords'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bloodGlucoseRecords != null) {
      data['BloodGlucoseRecords'] = this.bloodGlucoseRecords.toJson();
    }
    if (this.bloodPressureRecords != null) {
      data['BloodPressureRecords'] = this.bloodPressureRecords.toJson();
    }
    if (this.pulseRecords != null) {
      data['PulseRecords'] = this.pulseRecords.toJson();
    }
    if (this.bodyTemperatureRecords != null) {
      data['BodyTemperatureRecords'] = this.bodyTemperatureRecords.toJson();
    }
    if (this.bodyWeightRecords != null) {
      data['BodyWeightRecords'] = this.bodyWeightRecords.toJson();
    }
    if (this.bloodOxygenSaturationRecords != null) {
      data['BloodOxygenSaturationRecords'] =
          this.bloodOxygenSaturationRecords.toJson();
    }
    return data;
  }
}

class Records {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  Records(
      {this.totalCount,
        this.retrievedCount,
        this.pageIndex,
        this.itemsPerPage,
        this.order,
        this.orderedBy,
        this.items});

  Records.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['RetrievedCount'] = this.retrievedCount;
    data['PageIndex'] = this.pageIndex;
    data['ItemsPerPage'] = this.itemsPerPage;
    data['Order'] = this.order;
    data['OrderedBy'] = this.orderedBy;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String ehrId;
  String patientUserId;
  int bloodGlucose;
  int systolic;
  int diastolic;
  int pulse;
  int bodyTemperature;
  double bodyWeight;
  int bloodOxygenSaturation;
  String unit;
  String recordDate;
  String recordedByUserId;

  Items(
      {this.id,
        this.ehrId,
        this.patientUserId,
        this.bloodGlucose,
        this.systolic,
        this.diastolic,
        this.pulse,
        this.bodyTemperature,
        this.bodyWeight,
        this.bloodOxygenSaturation,
        this.unit,
        this.recordDate,
        this.recordedByUserId});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ehrId = json['EhrId'];
    patientUserId = json['PatientUserId'];
    bloodGlucose = json['BloodGlucose'];
    systolic = json['Systolic'];
    diastolic = json['Diastolic'];
    pulse = json['Pulse'];
    bodyTemperature = json['BodyTemperature'];
    bodyWeight = json['BodyWeight'];
    bloodOxygenSaturation = json['BloodOxygenSaturation'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
    recordedByUserId = json['RecordedByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['EhrId'] = this.ehrId;
    data['PatientUserId'] = this.patientUserId;
    data['BloodGlucose'] = this.bloodGlucose;
    data['Systolic'] = this.systolic;
    data['Diastolic'] = this.diastolic;
    data['Pulse'] = this.pulse;
    data['BodyTemperature'] = this.bodyTemperature;
    data['BodyWeight'] = this.bodyWeight;
    data['BloodOxygenSaturation'] = this.bloodOxygenSaturation;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    data['RecordedByUserId'] = this.recordedByUserId;
    return data;
  }
}
