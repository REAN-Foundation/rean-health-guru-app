class MyMedicationSummaryRespose {
  String status;
  String message;
  int httpCode;
  Data data;

  MyMedicationSummaryRespose(
      {this.status, this.message, this.httpCode, this.data});

  MyMedicationSummaryRespose.fromJson(Map<String, dynamic> json) {
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
  List<MedicationConsumptionSummary> medicationConsumptionSummary;

  Data({this.medicationConsumptionSummary});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['MedicationConsumptionSummary'] != null) {
      medicationConsumptionSummary = new List<MedicationConsumptionSummary>();
      json['MedicationConsumptionSummary'].forEach((v) {
        medicationConsumptionSummary
            .add(new MedicationConsumptionSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicationConsumptionSummary != null) {
      data['MedicationConsumptionSummary'] =
          this.medicationConsumptionSummary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationConsumptionSummary {
  String month;
  int daysInMonth;
  List<SummaryForMonth> summaryForMonth;

  MedicationConsumptionSummary(
      {this.month, this.daysInMonth, this.summaryForMonth});

  MedicationConsumptionSummary.fromJson(Map<String, dynamic> json) {
    month = json['Month'];
    daysInMonth = json['DaysInMonth'];
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
    data['DaysInMonth'] = this.daysInMonth;
    if (this.summaryForMonth != null) {
      data['SummaryForMonth'] =
          this.summaryForMonth.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SummaryForMonth {
  String drug;
  SummaryForDrug summaryForDrug;

  SummaryForMonth({this.drug, this.summaryForDrug});

  SummaryForMonth.fromJson(Map<String, dynamic> json) {
    drug = json['Drug'];
    summaryForDrug = json['SummaryForDrug'] != null
        ? new SummaryForDrug.fromJson(json['SummaryForDrug'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Drug'] = this.drug;
    if (this.summaryForDrug != null) {
      data['SummaryForDrug'] = this.summaryForDrug.toJson();
    }
    return data;
  }
}

class SummaryForDrug {
  int missed;
  int taken;
  int unknown;
  int upcoming;
  int overdue;

  SummaryForDrug(
      {this.missed, this.taken, this.unknown, this.upcoming, this.overdue});

  SummaryForDrug.fromJson(Map<String, dynamic> json) {
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
