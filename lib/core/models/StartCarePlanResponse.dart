class StartCarePlanResponse {
  String status;
  String message;
  Data data;

  StartCarePlanResponse({this.status, this.message, this.data});

  StartCarePlanResponse.fromJson(Map<String, dynamic> json) {
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
  CarePlan carePlan;

  Data({this.carePlan});

  Data.fromJson(Map<String, dynamic> json) {
    carePlan = json['carePlan'] != null
        ? new CarePlan.fromJson(json['carePlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carePlan != null) {
      data['carePlan'] = this.carePlan.toJson();
    }
    return data;
  }
}

class CarePlan {
  bool isStopped;
  bool isActive;
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
  String enrolledOn;
  String updatedAt;
  String createdAt;

  CarePlan(
      {this.isStopped,
      this.isActive,
      this.id,
      this.patientUserId,
      this.displayId,
      this.allyMRN,
      this.carePlanName,
      this.carePlanCode,
      this.enrollmentBeginDate,
      this.enrollmentEndDate,
      this.durationInWeeks,
      this.endEnrollmentAfterDays,
      this.enrolledOn,
      this.updatedAt,
      this.createdAt});

  CarePlan.fromJson(Map<String, dynamic> json) {
    isStopped = json['IsStopped'];
    isActive = json['IsActive'];
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
    enrolledOn = json['EnrolledOn'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsStopped'] = this.isStopped;
    data['IsActive'] = this.isActive;
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
    data['EnrolledOn'] = this.enrolledOn;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
