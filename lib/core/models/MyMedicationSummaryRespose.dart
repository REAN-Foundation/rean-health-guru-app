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
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
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
      medicationConsumptionSummary = [];
      json['MedicationConsumptionSummary'].forEach((v) {
        medicationConsumptionSummary
            .add(MedicationConsumptionSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicationConsumptionSummary != null) {
      data['MedicationConsumptionSummary'] =
          medicationConsumptionSummary.map((v) => v.toJson()).toList();
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
      summaryForMonth = <SummaryForMonth>[];
      json['SummaryForMonth'].forEach((v) {
        summaryForMonth.add(SummaryForMonth.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Month'] = month;
    data['DaysInMonth'] = daysInMonth;
    if (summaryForMonth != null) {
      data['SummaryForMonth'] = summaryForMonth.map((v) => v.toJson()).toList();
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
        ? SummaryForDrug.fromJson(json['SummaryForDrug'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Drug'] = drug;
    if (summaryForDrug != null) {
      data['SummaryForDrug'] = summaryForDrug.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Missed'] = missed;
    data['Taken'] = taken;
    data['Unknown'] = unknown;
    data['Upcoming'] = upcoming;
    data['Overdue'] = overdue;
    return data;
  }
}
