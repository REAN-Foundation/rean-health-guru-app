class MyCurrentMedication {
  String status;
  String message;
  Data data;

  MyCurrentMedication({this.status, this.message, this.data});

  MyCurrentMedication.fromJson(Map<String, dynamic> json) {
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
  List<Medications> medications;

  Data({this.medications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications.add(Medications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medications != null) {
      data['medications'] = medications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medications {
  String id;
  String patientUserId;
  String doctorUserId;
  String visitId;
  String drugOrderId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['DoctorUserId'] = doctorUserId;
    data['VisitId'] = visitId;
    data['DrugOrderId'] = drugOrderId;
    data['Drug'] = drug;
    data['Dose'] = dose;
    data['DosageUnit'] = dosageUnit;
    data['TimeSchedule'] = timeSchedule;
    data['Frequency'] = frequency;
    data['FrequencyUnit'] = frequencyUnit;
    data['Route'] = route;
    data['Duration'] = duration;
    data['DurationUnit'] = durationUnit;
    data['StartDate'] = startDate.toIso8601String();
    data['RefillNeeded'] = refillNeeded;
    data['RefillCount'] = refillCount;
    data['Instructions'] = instructions;
    data['EndDate'] = endDate;
    data['TotalConsumptionCount'] = totalConsumptionCount;
    data['TotalDoseCount'] = totalDoseCount;
    data['PendingConsumptionCount'] = pendingConsumptionCount;
    data['PendingDoseCount'] = pendingDoseCount;
    data['DateCreated'] = dateCreated.toIso8601String();
    data['DateUpdated'] = dateUpdated;
    data['MedicationImageResourceId'] = medicationImageResourceId;
    return data;
  }
}
