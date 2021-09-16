class MyMedicationSummaryRespose {
  String status;
  String message;
  Data data;

  MyMedicationSummaryRespose({this.status, this.message, this.data});

  MyMedicationSummaryRespose.fromJson(Map<String, dynamic> json) {
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
  List<Summary> summary;

  Data({this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <Summary>[];
      json['summary'].forEach((v) {
        summary.add(Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String month;
  List<SummaryForMonth> summaryForMonth;

  Summary({this.month, this.summaryForMonth});

  Summary.fromJson(Map<String, dynamic> json) {
    month = json['Month'];
    if (json['SummaryForMonth'] != null) {
      summaryForMonth = <SummaryForMonth>[];
      json['SummaryForMonth'].forEach((v) {
        summaryForMonth.add(SummaryForMonth.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Month'] = month;
    if (summaryForMonth != null) {
      data['SummaryForMonth'] = summaryForMonth.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SummaryForMonth {
  String drug;
  DrugSummary drugSummary;
  List<Schedule> schedule;

  SummaryForMonth({this.drug, this.drugSummary, this.schedule});

  SummaryForMonth.fromJson(Map<String, dynamic> json) {
    drug = json['Drug'];
    drugSummary = json['DrugSummary'] != null
        ? DrugSummary.fromJson(json['DrugSummary'])
        : null;
    if (json['Schedule'] != null) {
      schedule = <Schedule>[];
      json['Schedule'].forEach((v) {
        schedule.add(Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Drug'] = drug;
    if (drugSummary != null) {
      data['DrugSummary'] = drugSummary.toJson();
    }
    if (schedule != null) {
      data['Schedule'] = schedule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrugSummary {
  int missed;
  int taken;
  int unknown;
  int upcoming;
  int overdue;

  DrugSummary(
      {this.missed, this.taken, this.unknown, this.upcoming, this.overdue});

  DrugSummary.fromJson(Map<String, dynamic> json) {
    missed = json['Missed'];
    taken = json['Taken'];
    unknown = json['Unknown'];
    upcoming = json['Upcoming'];
    overdue = json['Overdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Missed'] = missed;
    data['Taken'] = taken;
    data['Unknown'] = unknown;
    data['Upcoming'] = upcoming;
    data['Overdue'] = overdue;
    return data;
  }
}

class Schedule {
  String id;
  String patientUserId;
  String medicationId;
  String drugOrderId;
  String drugName;
  String details;
  DateTime timeScheduleStart;
  DateTime timeScheduleEnd;
  String takenAt;
  bool isTaken;
  bool isMissed;
  bool isCancelled;
  String cancelledOn;
  String note;
  String status;
  String dateCreated;
  String dateUpdated;

  Schedule(
      {this.id,
      this.patientUserId,
      this.medicationId,
      this.drugOrderId,
      this.drugName,
      this.details,
      this.timeScheduleStart,
      this.timeScheduleEnd,
      this.takenAt,
      this.isTaken,
      this.isMissed,
      this.isCancelled,
      this.cancelledOn,
      this.note,
      this.status,
      this.dateCreated,
      this.dateUpdated});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    medicationId = json['MedicationId'];
    drugOrderId = json['DrugOrderId'];
    drugName = json['DrugName'];
    details = json['Details'];
    timeScheduleStart = DateTime.parse(json['TimeScheduleStart']);
    timeScheduleEnd = DateTime.parse(json['TimeScheduleEnd']);
    takenAt = json['TakenAt'];
    isTaken = json['IsTaken'];
    isMissed = json['IsMissed'];
    isCancelled = json['IsCancelled'];
    cancelledOn = json['CancelledOn'];
    note = json['Note'];
    status = json['Status'];
    dateCreated = json['DateCreated'];
    dateUpdated = json['DateUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['MedicationId'] = medicationId;
    data['DrugOrderId'] = drugOrderId;
    data['DrugName'] = drugName;
    data['Details'] = details;
    data['TimeScheduleStart'] = timeScheduleStart.toIso8601String();
    data['TimeScheduleEnd'] = timeScheduleEnd.toIso8601String();
    data['TakenAt'] = takenAt;
    data['IsTaken'] = isTaken;
    data['IsMissed'] = isMissed;
    data['IsCancelled'] = isCancelled;
    data['CancelledOn'] = cancelledOn;
    data['Note'] = note;
    data['Status'] = status;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    return data;
  }
}
