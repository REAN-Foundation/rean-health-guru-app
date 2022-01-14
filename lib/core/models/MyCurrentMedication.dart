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
<<<<<<< HEAD
  Medications medications;

  Data({this.medications});

  Data.fromJson(Map<String, dynamic> json) {
    medications = json['Medications'] != null
        ? Medications.fromJson(json['Medications'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medications != null) {
      data['Medications'] = medications.toJson();
    }
    return data;
  }
}

class Medications {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  Medications(
      {this.totalCount,
      this.retrievedCount,
      this.pageIndex,
      this.itemsPerPage,
      this.order,
      this.orderedBy,
      this.items});

  Medications.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items.add(Items.fromJson(v));
=======
  List<CurrentMedications> currentMedications;

  Data({this.currentMedications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['CurrentMedications'] != null) {
      currentMedications = <CurrentMedications>[];
      json['CurrentMedications'].forEach((v) {
        currentMedications.add(CurrentMedications.fromJson(v));
>>>>>>> main
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
<<<<<<< HEAD
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items.map((v) => v.toJson()).toList();
=======
    if (currentMedications != null) {
      data['CurrentMedications'] =
          currentMedications.map((v) => v.toJson()).toList();
>>>>>>> main
    }
    return data;
  }
}

<<<<<<< HEAD
class Items {
=======
class CurrentMedications {
>>>>>>> main
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
<<<<<<< HEAD
  DateTime endDate;
=======
  String endDate;
>>>>>>> main
  bool refillNeeded;
  int refillCount;
  String instructions;
  String imageResourceId;
  bool isExistingMedication;
  int takenForLastNDays;
  int toBeTakenForNextNDays;
  bool isCancelled;

<<<<<<< HEAD
  Items(
=======
  CurrentMedications(
>>>>>>> main
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

<<<<<<< HEAD
  Items.fromJson(Map<String, dynamic> json) {
=======
  CurrentMedications.fromJson(Map<String, dynamic> json) {
>>>>>>> main
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
<<<<<<< HEAD
    endDate = DateTime.parse(json['EndDate']);
=======
    endDate = json['EndDate'];
>>>>>>> main
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
<<<<<<< HEAD
    data['StartDate'] = startDate.toIso8601String();
    data['EndDate'] = endDate.toIso8601String();
=======
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
>>>>>>> main
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
