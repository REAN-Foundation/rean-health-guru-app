class TaskSummaryResponse {
  String status;
  String message;
  Data data;

  TaskSummaryResponse({this.status, this.message, this.data});

  TaskSummaryResponse.fromJson(Map<String, dynamic> json) {
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
  Summary summary;

  Data({this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary.toJson();
    }
    return data;
  }
}

class Summary {
  int completedTaskCount;
  int incompleteTaskCount;
  int missed;
  int taken;
  int unknown;
  int upcoming;
  int overdue;
  Weight weight;
  BloodPressure bloodPressure;
  BloodSugar bloodSugar;
  BloodOxygenSaturation bloodOxygenSaturation;
  Pulse pulse;
  Temperature temperature;

  Summary(
      {this.completedTaskCount,
        this.incompleteTaskCount,
        this.missed,
        this.taken,
        this.unknown,
        this.upcoming,
        this.overdue,
        this.weight,
        this.bloodPressure,
        this.bloodSugar,
        this.bloodOxygenSaturation,
        this.pulse,
        this.temperature});

  Summary.fromJson(Map<String, dynamic> json) {
    completedTaskCount = json['CompletedTaskCount'];
    incompleteTaskCount = json['IncompleteTaskCount'];
    missed = json['Missed'];
    taken = json['Taken'];
    unknown = json['Unknown'];
    upcoming = json['Upcoming'];
    overdue = json['Overdue'];
    weight =
    json['Weight'] != null ? new Weight.fromJson(json['Weight']) : null;
    bloodPressure = json['BloodPressure'] != null
        ? new BloodPressure.fromJson(json['BloodPressure'])
        : null;
    bloodSugar = json['BloodSugar'] != null
        ? new BloodSugar.fromJson(json['BloodSugar'])
        : null;
    bloodOxygenSaturation = json['BloodOxygenSaturation'] != null
        ? new BloodOxygenSaturation.fromJson(json['BloodOxygenSaturation'])
        : null;
    pulse = json['Pulse'] != null ? new Pulse.fromJson(json['Pulse']) : null;
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompletedTaskCount'] = this.completedTaskCount;
    data['IncompleteTaskCount'] = this.incompleteTaskCount;
    data['Missed'] = this.missed;
    data['Taken'] = this.taken;
    data['Unknown'] = this.unknown;
    data['Upcoming'] = this.upcoming;
    data['Overdue'] = this.overdue;
    if (this.weight != null) {
      data['Weight'] = this.weight.toJson();
    }
    if (this.bloodPressure != null) {
      data['BloodPressure'] = this.bloodPressure.toJson();
    }
    if (this.bloodSugar != null) {
      data['BloodSugar'] = this.bloodSugar.toJson();
    }
    if (this.bloodOxygenSaturation != null) {
      data['BloodOxygenSaturation'] = this.bloodOxygenSaturation.toJson();
    }
    if (this.pulse != null) {
      data['Pulse'] = this.pulse.toJson();
    }
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    return data;
  }
}

class Weight {
  dynamic weight;
  String unit;
  String recordDate;

  Weight({this.weight, this.unit, this.recordDate});

  Weight.fromJson(Map<String, dynamic> json) {
    weight = json['Weight'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Weight'] = this.weight;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}

class BloodPressure {
  int bloodPressureSystolic;
  int bloodPressureDiastolic;
  String unit;
  String recordDate;

  BloodPressure(
      {this.bloodPressureSystolic,
        this.bloodPressureDiastolic,
        this.unit,
        this.recordDate});

  BloodPressure.fromJson(Map<String, dynamic> json) {
    bloodPressureSystolic = json['BloodPressure_Systolic'];
    bloodPressureDiastolic = json['BloodPressure_Diastolic'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BloodPressure_Systolic'] = this.bloodPressureSystolic;
    data['BloodPressure_Diastolic'] = this.bloodPressureDiastolic;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}

class BloodSugar {
  dynamic bloodGlucose;
  String unit;
  String recordDate;

  BloodSugar({this.bloodGlucose, this.unit, this.recordDate});

  BloodSugar.fromJson(Map<String, dynamic> json) {
    bloodGlucose = json['BloodGlucose'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BloodGlucose'] = this.bloodGlucose;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}

class BloodOxygenSaturation {
  dynamic bloodOxygenSaturation;
  String unit;
  String recordDate;

  BloodOxygenSaturation(
      {this.bloodOxygenSaturation, this.unit, this.recordDate});

  BloodOxygenSaturation.fromJson(Map<String, dynamic> json) {
    bloodOxygenSaturation = json['BloodOxygenSaturation'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BloodOxygenSaturation'] = this.bloodOxygenSaturation;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}

class Pulse {
  dynamic pulse;
  String unit;
  String recordDate;

  Pulse({this.pulse, this.unit, this.recordDate});

  Pulse.fromJson(Map<String, dynamic> json) {
    pulse = json['Pulse'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Pulse'] = this.pulse;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}

class Temperature {
  dynamic temperature;
  String unit;
  String recordDate;

  Temperature({this.temperature, this.unit, this.recordDate});

  Temperature.fromJson(Map<String, dynamic> json) {
    temperature = json['Temperature'];
    unit = json['Unit'];
    recordDate = json['RecordDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Temperature'] = this.temperature;
    data['Unit'] = this.unit;
    data['RecordDate'] = this.recordDate;
    return data;
  }
}