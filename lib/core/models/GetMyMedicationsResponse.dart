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
  List<MedConsumptions> medConsumptions;

  Data({this.medConsumptions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medConsumptions'] != null) {
      medConsumptions = new List<MedConsumptions>();
      json['medConsumptions'].forEach((v) {
        medConsumptions.add(new MedConsumptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medConsumptions != null) {
      data['medConsumptions'] =
          this.medConsumptions.map((v) => v.toJson()).toList();
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