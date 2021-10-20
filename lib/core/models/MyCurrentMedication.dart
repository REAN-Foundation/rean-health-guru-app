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
  List<CurrentMedications> currentMedications;

  Data({this.currentMedications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['CurrentMedications'] != null) {
      currentMedications = <CurrentMedications>[];
      json['CurrentMedications'].forEach((v) {
        currentMedications.add(CurrentMedications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentMedications != null) {
      data['CurrentMedications'] =
          currentMedications.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['EhrId'] = ehrId;
    data['PatientUserId'] = patientUserId;
    data['MedicalPractitionerUserId'] = medicalPractitionerUserId;
    data['VisitId'] = visitId;
    data['OrderId'] = orderId;
    data['DrugId'] = drugId;
    data['DrugName'] = drugName;
    data['Dose'] = dose;
    data['DosageUnit'] = dosageUnit;
    data['TimeSchedules'] = timeSchedules;
    data['Frequency'] = frequency;
    data['FrequencyUnit'] = frequencyUnit;
    data['Route'] = route;
    data['Duration'] = duration;
    data['DurationUnit'] = durationUnit;
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
    data['RefillNeeded'] = refillNeeded;
    data['RefillCount'] = refillCount;
    data['Instructions'] = instructions;
    data['ImageResourceId'] = imageResourceId;
    data['IsExistingMedication'] = isExistingMedication;
    data['TakenForLastNDays'] = takenForLastNDays;
    data['ToBeTakenForNextNDays'] = toBeTakenForNextNDays;
    data['IsCancelled'] = isCancelled;
    return data;
  }
}
