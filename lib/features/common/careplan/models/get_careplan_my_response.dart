class GetCarePlanMyResponse {
  String? status;
  String? message;
  Data? data;

  GetCarePlanMyResponse({this.status, this.message, this.data});

  GetCarePlanMyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<CarePlans>? carePlans;

  Data({this.carePlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['carePlans'] != null) {
      carePlans = <CarePlans>[];
      json['carePlans'].forEach((v) {
        carePlans!.add(CarePlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carePlans != null) {
      data['carePlans'] = carePlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarePlans {
  int? id;
  String? patientUserId;
  String? displayId;
  String? allyMRN;
  String? carePlanName;
  String? carePlanCode;
  String? enrollmentBeginDate;
  String? enrollmentEndDate;
  int? durationInWeeks;
  int? endEnrollmentAfterDays;
  bool? isStopped;
  String? stoppedDate;
  String? enrolledOn;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  CarePlans(
      {this.id,
      this.patientUserId,
      this.displayId,
      this.allyMRN,
      this.carePlanName,
      this.carePlanCode,
      this.enrollmentBeginDate,
      this.enrollmentEndDate,
      this.durationInWeeks,
      this.endEnrollmentAfterDays,
      this.isStopped,
      this.stoppedDate,
      this.enrolledOn,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  CarePlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    displayId = json['DisplayId'];
    allyMRN = json['AllyMRN'];
    carePlanName = json['CarePlanName'];
    carePlanCode = json['CarePlanCode'];
    enrollmentBeginDate = json['EnrollmentBeginDate'];
    enrollmentEndDate = json['EnrollmentEndDate'];
    durationInWeeks = json['DurationInWeeks'];
    endEnrollmentAfterDays = json['EndEnrollmentAfterDays'];
    isStopped = json['IsStopped'];
    stoppedDate = json['StoppedDate'];
    enrolledOn = json['EnrolledOn'];
    isActive = json['IsActive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['DisplayId'] = displayId;
    data['AllyMRN'] = allyMRN;
    data['CarePlanName'] = carePlanName;
    data['CarePlanCode'] = carePlanCode;
    data['EnrollmentBeginDate'] = enrollmentBeginDate;
    data['EnrollmentEndDate'] = enrollmentEndDate;
    data['DurationInWeeks'] = durationInWeeks;
    data['EndEnrollmentAfterDays'] = endEnrollmentAfterDays;
    data['IsStopped'] = isStopped;
    data['StoppedDate'] = stoppedDate;
    data['EnrolledOn'] = enrolledOn;
    data['IsActive'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
