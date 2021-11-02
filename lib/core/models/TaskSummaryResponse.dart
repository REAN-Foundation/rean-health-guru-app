class TaskSummaryResponse {
  String status;
  String message;
  Data data;

  TaskSummaryResponse({this.status, this.message, this.data});

  TaskSummaryResponse.fromJson(Map<String, dynamic> json) {
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
  Summary summary;

  Data({this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary.toJson();
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
    weight = json['Weight'] != null ? Weight.fromJson(json['Weight']) : null;
    bloodPressure = json['BloodPressure'] != null
        ? BloodPressure.fromJson(json['BloodPressure'])
        : null;
    bloodSugar = json['BloodSugar'] != null
        ? BloodSugar.fromJson(json['BloodSugar'])
        : null;
    bloodOxygenSaturation = json['BloodOxygenSaturation'] != null
        ? BloodOxygenSaturation.fromJson(json['BloodOxygenSaturation'])
        : null;
    pulse = json['Pulse'] != null ? Pulse.fromJson(json['Pulse']) : null;
    temperature = json['Temperature'] != null
        ? Temperature.fromJson(json['Temperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompletedTaskCount'] = completedTaskCount;
    data['IncompleteTaskCount'] = incompleteTaskCount;
    data['Missed'] = missed;
    data['Taken'] = taken;
    data['Unknown'] = unknown;
    data['Upcoming'] = upcoming;
    data['Overdue'] = overdue;
    if (weight != null) {
      data['Weight'] = weight.toJson();
    }
    if (bloodPressure != null) {
      data['BloodPressure'] = bloodPressure.toJson();
    }
    if (bloodSugar != null) {
      data['BloodSugar'] = bloodSugar.toJson();
    }
    if (bloodOxygenSaturation != null) {
      data['BloodOxygenSaturation'] = bloodOxygenSaturation.toJson();
    }
    if (pulse != null) {
      data['Pulse'] = pulse.toJson();
    }
    if (temperature != null) {
      data['Temperature'] = temperature.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Weight'] = weight;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BloodPressure_Systolic'] = bloodPressureSystolic;
    data['BloodPressure_Diastolic'] = bloodPressureDiastolic;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BloodGlucose'] = bloodGlucose;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BloodOxygenSaturation'] = bloodOxygenSaturation;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Pulse'] = pulse;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Temperature'] = temperature;
    data['Unit'] = unit;
    data['RecordDate'] = recordDate;
    return data;
  }
}
