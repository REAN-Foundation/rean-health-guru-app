class MyMedicationSummaryRespose {
  String status;
  String message;
  Data data;

  MyMedicationSummaryRespose({this.status, this.message, this.data});

  MyMedicationSummaryRespose.fromJson(Map<String, dynamic> json) {
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
  List<Summary> summary;

  Data({this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = new List<Summary>();
      json['summary'].forEach((v) {
        summary.add(new Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary.map((v) => v.toJson()).toList();
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
      summaryForMonth = new List<SummaryForMonth>();
      json['SummaryForMonth'].forEach((v) {
        summaryForMonth.add(new SummaryForMonth.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Month'] = this.month;
    if (this.summaryForMonth != null) {
      data['SummaryForMonth'] =
          this.summaryForMonth.map((v) => v.toJson()).toList();
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
        ? new DrugSummary.fromJson(json['DrugSummary'])
        : null;
    if (json['Schedule'] != null) {
      schedule = new List<Schedule>();
      json['Schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Drug'] = this.drug;
    if (this.drugSummary != null) {
      data['DrugSummary'] = this.drugSummary.toJson();
    }
    if (this.schedule != null) {
      data['Schedule'] = this.schedule.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Missed'] = this.missed;
    data['Taken'] = this.taken;
    data['Unknown'] = this.unknown;
    data['Upcoming'] = this.upcoming;
    data['Overdue'] = this.overdue;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['MedicationId'] = this.medicationId;
    data['DrugOrderId'] = this.drugOrderId;
    data['DrugName'] = this.drugName;
    data['Details'] = this.details;
    data['TimeScheduleStart'] = this.timeScheduleStart.toIso8601String();
    data['TimeScheduleEnd'] = this.timeScheduleEnd.toIso8601String();
    data['TakenAt'] = this.takenAt;
    data['IsTaken'] = this.isTaken;
    data['IsMissed'] = this.isMissed;
    data['IsCancelled'] = this.isCancelled;
    data['CancelledOn'] = this.cancelledOn;
    data['Note'] = this.note;
    data['Status'] = this.status;
    data['DateCreated'] = this.dateCreated;
    data['DateUpdated'] = this.dateUpdated;
    return data;
  }
}
