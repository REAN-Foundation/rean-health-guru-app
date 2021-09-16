import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class GetMyMedicationsResponse {
  String status;
  String message;
  Data data;

  GetMyMedicationsResponse({this.status, this.message, this.data});

  GetMyMedicationsResponse.fromJson(Map<String, dynamic> json) {
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
  List<MedConsumptions> medConsumptions;

  Data({this.medConsumptions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medConsumptions'] != null) {
      medConsumptions = <MedConsumptions>[];
      json['medConsumptions'].forEach((v) {
        medConsumptions.add(MedConsumptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medConsumptions != null) {
      data['medConsumptions'] = medConsumptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@JsonSerializable(nullable: true)
class MedConsumptions {
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

  MedConsumptions(
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

  MedConsumptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    medicationId = json['MedicationId'];
    drugOrderId = json['DrugOrderId'];
    drugName = json['DrugName'];
    details = json['Details'];
    timeScheduleStart = DateTime.parse(json['TimeScheduleStart']).toLocal();
    timeScheduleEnd = DateTime.parse(json['TimeScheduleEnd']).toLocal();
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
