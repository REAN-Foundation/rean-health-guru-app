class GetMyMedicationsResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  GetMyMedicationsResponse(
      {this.status, this.message, this.httpCode, this.data});

  GetMyMedicationsResponse.fromJson(Map<String, dynamic> json) {
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
  MedicationSchedulesForDay medicationSchedulesForDay;

  Data({this.medicationSchedulesForDay});

  Data.fromJson(Map<String, dynamic> json) {
    medicationSchedulesForDay = json['MedicationSchedulesForDay'] != null
        ? new MedicationSchedulesForDay.fromJson(
            json['MedicationSchedulesForDay'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicationSchedulesForDay != null) {
      data['MedicationSchedulesForDay'] =
          this.medicationSchedulesForDay.toJson();
    }
    return data;
  }
}

class MedicationSchedulesForDay {
  String day;
  List<Schedules> schedules;

  MedicationSchedulesForDay({this.day, this.schedules});

  MedicationSchedulesForDay.fromJson(Map<String, dynamic> json) {
    day = json['Day'];
    if (json['Schedules'] != null) {
      schedules = new List<Schedules>();
      json['Schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Day'] = this.day;
    if (this.schedules != null) {
      data['Schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedules {
  String id;
  String patientUserId;
  String drugName;
  String details;
  DateTime timeScheduleStart;
  String timeScheduleEnd;
  String status;

  Schedules(
      {this.id,
      this.patientUserId,
      this.drugName,
      this.details,
      this.timeScheduleStart,
      this.timeScheduleEnd,
      this.status});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    drugName = json['DrugName'];
    details = json['Details'];
    timeScheduleStart = DateTime.parse(json['TimeScheduleStart']);
    timeScheduleEnd = json['TimeScheduleEnd'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['DrugName'] = this.drugName;
    data['Details'] = this.details;
    data['TimeScheduleStart'] = this.timeScheduleStart;
    data['TimeScheduleEnd'] = this.timeScheduleEnd;
    data['Status'] = this.status;
    return data;
  }
}
