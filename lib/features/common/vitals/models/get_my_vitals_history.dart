class GetMyVitalsHistory {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  GetMyVitalsHistory({this.status, this.message, this.httpCode, this.data});

  GetMyVitalsHistory.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Records? bloodGlucoseRecords;
  Records? bloodPressureRecords;
  Records? pulseRecords;
  Records? bodyTemperatureRecords;
  Records? bodyWeightRecords;
  Records? bodyHeightRecords;
  Records? bloodOxygenSaturationRecords;

  Data(
      {this.bloodGlucoseRecords,
      this.bloodPressureRecords,
      this.pulseRecords,
      this.bodyTemperatureRecords,
      this.bodyWeightRecords,
      this.bodyHeightRecords,
      this.bloodOxygenSaturationRecords});

  Data.fromJson(Map<String, dynamic> json) {
    bloodGlucoseRecords = json['BloodGlucoseRecords'] != null
        ? Records.fromJson(json['BloodGlucoseRecords'])
        : null;
    bloodPressureRecords = json['BloodPressureRecords'] != null
        ? Records.fromJson(json['BloodPressureRecords'])
        : null;
    pulseRecords = json['PulseRecords'] != null
        ? Records.fromJson(json['PulseRecords'])
        : null;
    bodyTemperatureRecords = json['BodyTemperatureRecords'] != null
        ? Records.fromJson(json['BodyTemperatureRecords'])
        : null;
    bodyWeightRecords = json['BodyWeightRecords'] != null
        ? Records.fromJson(json['BodyWeightRecords'])
        : null;
    bodyHeightRecords = json['BodyHeightRecords'] != null
        ? Records.fromJson(json['BodyHeightRecords'])
        : null;
    bloodOxygenSaturationRecords = json['BloodOxygenSaturationRecords'] != null
        ? Records.fromJson(json['BloodOxygenSaturationRecords'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bloodGlucoseRecords != null) {
      data['BloodGlucoseRecords'] = bloodGlucoseRecords!.toJson();
    }
    if (bloodPressureRecords != null) {
      data['BloodPressureRecords'] = bloodPressureRecords!.toJson();
    }
    if (pulseRecords != null) {
      data['PulseRecords'] = pulseRecords!.toJson();
    }
    if (bodyTemperatureRecords != null) {
      data['BodyTemperatureRecords'] = bodyTemperatureRecords!.toJson();
    }
    if (bodyWeightRecords != null) {
      data['BodyWeightRecords'] = bodyWeightRecords!.toJson();
    }
    if (bodyHeightRecords != null) {
      data['BodyHeightRecords'] = bodyHeightRecords!.toJson();
    }
    if (bloodOxygenSaturationRecords != null) {
      data['BloodOxygenSaturationRecords'] =
          bloodOxygenSaturationRecords!.toJson();
    }
    return data;
  }
}

class Records {
  int? totalCount;
  int? retrievedCount;
  int? pageIndex;
  int? itemsPerPage;
  String? order;
  String? orderedBy;
  List<Items>? items;

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
      items = [];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? ehrId;
  String? patientUserId;
  dynamic bloodGlucose;
  dynamic systolic;
  dynamic diastolic;
  dynamic pulse;
  dynamic bodyTemperature;
  dynamic bodyWeight;
  dynamic bodyHeight;
  dynamic bloodOxygenSaturation;
  String? unit;
  String? recordDate;
  String? recordedByUserId;

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
      this.bodyHeight,
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
    bodyHeight = json['BodyHeight'];
    bloodOxygenSaturation = json['BloodOxygenSaturation'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
    recordedByUserId = json['RecordedByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['EhrId'] = ehrId;
    data['PatientUserId'] = patientUserId;
    data['BloodGlucose'] = bloodGlucose;
    data['Systolic'] = systolic;
    data['Diastolic'] = diastolic;
    data['Pulse'] = pulse;
    data['BodyTemperature'] = bodyTemperature;
    data['BodyWeight'] = bodyWeight;
    data['BodyHeight'] = bodyHeight;
    data['BloodOxygenSaturation'] = bloodOxygenSaturation;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
    data['RecordedByUserId'] = recordedByUserId;
    return data;
  }
}
