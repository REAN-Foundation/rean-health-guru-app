class GetCarePlanSummaryResponse {
  String status;
  String message;
  Data data;

  GetCarePlanSummaryResponse({this.status, this.message, this.data});

  GetCarePlanSummaryResponse.fromJson(Map<String, dynamic> json) {
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
  CarePlanSummary carePlanSummary;

  Data({this.carePlanSummary});

  Data.fromJson(Map<String, dynamic> json) {
    carePlanSummary = json['carePlanSummary'] != null
        ? new CarePlanSummary.fromJson(json['carePlanSummary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carePlanSummary != null) {
      data['carePlanSummary'] = this.carePlanSummary.toJson();
    }
    return data;
  }
}

class CarePlanSummary {
  String patientUserId;
  String carePlanDisplayId;
  String carePlanName;
  String carePlanCode;
  int durationInWeeks;
  DateTime carePlanStartDate;
  DateTime carePlanEndDate;
  String enrolledOn;
  int currentWeek;
  int dayOfCurrentWeek;
  String carePlanStatus;

  CarePlanSummary(
      {this.patientUserId,
        this.carePlanDisplayId,
        this.carePlanName,
        this.carePlanCode,
        this.durationInWeeks,
        this.carePlanStartDate,
        this.carePlanEndDate,
        this.enrolledOn,
        this.currentWeek,
        this.dayOfCurrentWeek,
        this.carePlanStatus});

  CarePlanSummary.fromJson(Map<String, dynamic> json) {
    patientUserId = json['PatientUserId'];
    carePlanDisplayId = json['CarePlanDisplayId'];
    carePlanName = json['CarePlanName'];
    carePlanCode = json['CarePlanCode'];
    durationInWeeks = json['DurationInWeeks'];
    carePlanStartDate = DateTime.parse(json['CarePlanStartDate']);
    carePlanEndDate = DateTime.parse(json['CarePlanEndDate']);
    enrolledOn = json['EnrolledOn'];
    currentWeek = json['CurrentWeek'];
    dayOfCurrentWeek = json['DayOfCurrentWeek'];
    carePlanStatus = json['CarePlanStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PatientUserId'] = this.patientUserId;
    data['CarePlanDisplayId'] = this.carePlanDisplayId;
    data['CarePlanName'] = this.carePlanName;
    data['CarePlanCode'] = this.carePlanCode;
    data['DurationInWeeks'] = this.durationInWeeks;
    data['CarePlanStartDate'] = this.carePlanStartDate.toIso8601String();
    data['CarePlanEndDate'] = this.carePlanEndDate.toIso8601String();
    data['EnrolledOn'] = this.enrolledOn;
    data['CurrentWeek'] = this.currentWeek;
    data['DayOfCurrentWeek'] = this.dayOfCurrentWeek;
    data['CarePlanStatus'] = this.carePlanStatus;
    return data;
  }
}