class GetCarePlanMyResponse {
  String status;
  String message;
  Data data;

  GetCarePlanMyResponse({this.status, this.message, this.data});

  GetCarePlanMyResponse.fromJson(Map<String, dynamic> json) {
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
  List<CarePlans> carePlans;

  Data({this.carePlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['carePlans'] != null) {
      carePlans = new List<CarePlans>();
      json['carePlans'].forEach((v) {
        carePlans.add(new CarePlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carePlans != null) {
      data['carePlans'] = this.carePlans.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarePlans {
  int id;
  String patientUserId;
  String displayId;
  String allyMRN;
  String carePlanName;
  String carePlanCode;
  String enrollmentBeginDate;
  String enrollmentEndDate;
  int durationInWeeks;
  int endEnrollmentAfterDays;
  bool isStopped;
  Null stoppedDate;
  String enrolledOn;
  bool isActive;
  String createdAt;
  String updatedAt;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['DisplayId'] = this.displayId;
    data['AllyMRN'] = this.allyMRN;
    data['CarePlanName'] = this.carePlanName;
    data['CarePlanCode'] = this.carePlanCode;
    data['EnrollmentBeginDate'] = this.enrollmentBeginDate;
    data['EnrollmentEndDate'] = this.enrollmentEndDate;
    data['DurationInWeeks'] = this.durationInWeeks;
    data['EndEnrollmentAfterDays'] = this.endEnrollmentAfterDays;
    data['IsStopped'] = this.isStopped;
    data['StoppedDate'] = this.stoppedDate;
    data['EnrolledOn'] = this.enrolledOn;
    data['IsActive'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
