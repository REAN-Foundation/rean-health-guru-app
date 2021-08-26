class MyCurrentMedication {
  String status;
  String message;
  Data data;

  MyCurrentMedication({this.status, this.message, this.data});

  MyCurrentMedication.fromJson(Map<String, dynamic> json) {
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
  List<Medications> medications;

  Data({this.medications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medications'] != null) {
      medications = new List<Medications>();
      json['medications'].forEach((v) {
        medications.add(new Medications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medications != null) {
      data['medications'] = this.medications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medications {
  String id;
  String patientUserId;
  Null doctorUserId;
  Null visitId;
  Null drugOrderId;
  String drug;
  int dose;
  String dosageUnit;
  String timeSchedule;
  int frequency;
  String frequencyUnit;
  String route;
  int duration;
  String durationUnit;
  DateTime startDate;
  bool refillNeeded;
  int refillCount;
  String instructions;
  String endDate;
  int totalConsumptionCount;
  int totalDoseCount;
  int pendingConsumptionCount;
  int pendingDoseCount;
  DateTime dateCreated;
  String dateUpdated;
  String medicationImageResourceId;

  Medications(
      {this.id,
        this.patientUserId,
        this.doctorUserId,
        this.visitId,
        this.drugOrderId,
        this.drug,
        this.dose,
        this.dosageUnit,
        this.timeSchedule,
        this.frequency,
        this.frequencyUnit,
        this.route,
        this.duration,
        this.durationUnit,
        this.startDate,
        this.refillNeeded,
        this.refillCount,
        this.instructions,
        this.endDate,
        this.totalConsumptionCount,
        this.totalDoseCount,
        this.pendingConsumptionCount,
        this.pendingDoseCount,
        this.dateCreated,
        this.dateUpdated,
        this.medicationImageResourceId});

  Medications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    doctorUserId = json['DoctorUserId'];
    visitId = json['VisitId'];
    drugOrderId = json['DrugOrderId'];
    drug = json['Drug'];
    dose = json['Dose'];
    dosageUnit = json['DosageUnit'];
    timeSchedule = json['TimeSchedule'];
    frequency = json['Frequency'];
    frequencyUnit = json['FrequencyUnit'];
    route = json['Route'];
    duration = json['Duration'];
    durationUnit = json['DurationUnit'];
    startDate = DateTime.parse(json['StartDate']);
    refillNeeded = json['RefillNeeded'];
    refillCount = json['RefillCount'];
    instructions = json['Instructions'];
    endDate = json['EndDate'];
    totalConsumptionCount = json['TotalConsumptionCount'];
    totalDoseCount = json['TotalDoseCount'];
    pendingConsumptionCount = json['PendingConsumptionCount'];
    pendingDoseCount = json['PendingDoseCount'];
    dateCreated = DateTime.parse(json['DateCreated']);
    dateUpdated = json['DateUpdated'];
    medicationImageResourceId = json['MedicationImageResourceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['DoctorUserId'] = this.doctorUserId;
    data['VisitId'] = this.visitId;
    data['DrugOrderId'] = this.drugOrderId;
    data['Drug'] = this.drug;
    data['Dose'] = this.dose;
    data['DosageUnit'] = this.dosageUnit;
    data['TimeSchedule'] = this.timeSchedule;
    data['Frequency'] = this.frequency;
    data['FrequencyUnit'] = this.frequencyUnit;
    data['Route'] = this.route;
    data['Duration'] = this.duration;
    data['DurationUnit'] = this.durationUnit;
    data['StartDate'] = this.startDate.toIso8601String();
    data['RefillNeeded'] = this.refillNeeded;
    data['RefillCount'] = this.refillCount;
    data['Instructions'] = this.instructions;
    data['EndDate'] = this.endDate;
    data['TotalConsumptionCount'] = this.totalConsumptionCount;
    data['TotalDoseCount'] = this.totalDoseCount;
    data['PendingConsumptionCount'] = this.pendingConsumptionCount;
    data['PendingDoseCount'] = this.pendingDoseCount;
    data['DateCreated'] = this.dateCreated.toIso8601String();
    data['DateUpdated'] = this.dateUpdated;
    data['MedicationImageResourceId'] = this.medicationImageResourceId;
    return data;
  }
}