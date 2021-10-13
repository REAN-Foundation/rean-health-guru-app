class MyCurrentMedication {
  String status;
  String message;
  int httpCode;
  Data data;

  MyCurrentMedication({this.status, this.message, this.httpCode, this.data});

  MyCurrentMedication.fromJson(Map<String, dynamic> json) {
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
  List<CurrentMedications> currentMedications;

  Data({this.currentMedications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['CurrentMedications'] != null) {
      currentMedications = new List<CurrentMedications>();
      json['CurrentMedications'].forEach((v) {
        currentMedications.add(new CurrentMedications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currentMedications != null) {
      data['CurrentMedications'] =
          this.currentMedications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentMedications {
  String id;
  String ehrId;
  String patientUserId;
  String medicalPractitionerUserId;
  String visitId;
  String orderId;
  String drugId;
  String drugName;
  int dose;
  String dosageUnit;
  List<String> timeSchedules;
  int frequency;
  String frequencyUnit;
  String route;
  int duration;
  String durationUnit;
  DateTime startDate;
  String endDate;
  bool refillNeeded;
  int refillCount;
  String instructions;
  String imageResourceId;
  bool isExistingMedication;
  int takenForLastNDays;
  int toBeTakenForNextNDays;
  bool isCancelled;

  CurrentMedications(
      {this.id,
      this.ehrId,
      this.patientUserId,
      this.medicalPractitionerUserId,
      this.visitId,
      this.orderId,
      this.drugId,
      this.drugName,
      this.dose,
      this.dosageUnit,
      this.timeSchedules,
      this.frequency,
      this.frequencyUnit,
      this.route,
      this.duration,
      this.durationUnit,
      this.startDate,
      this.endDate,
      this.refillNeeded,
      this.refillCount,
      this.instructions,
      this.imageResourceId,
      this.isExistingMedication,
      this.takenForLastNDays,
      this.toBeTakenForNextNDays,
      this.isCancelled});

  CurrentMedications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ehrId = json['EhrId'];
    patientUserId = json['PatientUserId'];
    medicalPractitionerUserId = json['MedicalPractitionerUserId'];
    visitId = json['VisitId'];
    orderId = json['OrderId'];
    drugId = json['DrugId'];
    drugName = json['DrugName'];
    dose = json['Dose'];
    dosageUnit = json['DosageUnit'];
    timeSchedules = json['TimeSchedules'].cast<String>();
    frequency = json['Frequency'];
    frequencyUnit = json['FrequencyUnit'];
    route = json['Route'];
    duration = json['Duration'];
    durationUnit = json['DurationUnit'];
    startDate = DateTime.parse(json['StartDate']);
    endDate = json['EndDate'];
    refillNeeded = json['RefillNeeded'];
    refillCount = json['RefillCount'];
    instructions = json['Instructions'];
    imageResourceId = json['ImageResourceId'];
    isExistingMedication = json['IsExistingMedication'];
    takenForLastNDays = json['TakenForLastNDays'];
    toBeTakenForNextNDays = json['ToBeTakenForNextNDays'];
    isCancelled = json['IsCancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['EhrId'] = this.ehrId;
    data['PatientUserId'] = this.patientUserId;
    data['MedicalPractitionerUserId'] = this.medicalPractitionerUserId;
    data['VisitId'] = this.visitId;
    data['OrderId'] = this.orderId;
    data['DrugId'] = this.drugId;
    data['DrugName'] = this.drugName;
    data['Dose'] = this.dose;
    data['DosageUnit'] = this.dosageUnit;
    data['TimeSchedules'] = this.timeSchedules;
    data['Frequency'] = this.frequency;
    data['FrequencyUnit'] = this.frequencyUnit;
    data['Route'] = this.route;
    data['Duration'] = this.duration;
    data['DurationUnit'] = this.durationUnit;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['RefillNeeded'] = this.refillNeeded;
    data['RefillCount'] = this.refillCount;
    data['Instructions'] = this.instructions;
    data['ImageResourceId'] = this.imageResourceId;
    data['IsExistingMedication'] = this.isExistingMedication;
    data['TakenForLastNDays'] = this.takenForLastNDays;
    data['ToBeTakenForNextNDays'] = this.toBeTakenForNextNDays;
    data['IsCancelled'] = this.isCancelled;
    return data;
  }
}
