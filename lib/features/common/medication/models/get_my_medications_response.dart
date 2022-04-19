class GetMyMedicationsResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  GetMyMedicationsResponse(
      {this.status, this.message, this.httpCode, this.data});

  GetMyMedicationsResponse.fromJson(Map<String, dynamic> json) {
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
  MedicationSchedulesForDay? medicationSchedulesForDay;

  Data({this.medicationSchedulesForDay});

  Data.fromJson(Map<String, dynamic> json) {
    medicationSchedulesForDay = json['MedicationSchedulesForDay'] != null
        ? MedicationSchedulesForDay.fromJson(json['MedicationSchedulesForDay'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicationSchedulesForDay != null) {
      data['MedicationSchedulesForDay'] = medicationSchedulesForDay!.toJson();
    }
    return data;
  }
}

class MedicationSchedulesForDay {
  String? day;
  List<Schedules>? schedules;

  MedicationSchedulesForDay({this.day, this.schedules});

  MedicationSchedulesForDay.fromJson(Map<String, dynamic> json) {
    day = json['Day'];
    if (json['Schedules'] != null) {
      schedules = [];
      json['Schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Day'] = day;
    if (schedules != null) {
      data['Schedules'] = schedules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedules {
  String? id;
  String? patientUserId;
  String? drugName;
  String? details;
  DateTime? timeScheduleStart;
  String? timeScheduleEnd;
  String? status;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['DrugName'] = drugName;
    data['Details'] = details;
    data['TimeScheduleStart'] = timeScheduleStart;
    data['TimeScheduleEnd'] = timeScheduleEnd;
    data['Status'] = status;
    return data;
  }
}
