/// Status : "success"
/// Message : "Patient enrollment done successfully!"
/// HttpCode : 201
/// Data : {"Enrollment":{"id":"7863c55e-821a-47ce-9103-ed095a937d75","PatientUserId":"f0e4fe0d-6445-4c7f-beff-d8b2a8a2cdfb","EnrollmentId":284,"ParticipantId":265,"PlanCode":"HeartFailure","Provider":"AHA","PlanName":"AHA-Heart Failure","StartAt":"2022-04-20T00:00:00.000Z","EndAt":"2022-07-13T00:00:00.000Z","IsActive":true}}

class EnrollCarePlanResponse {
  EnrollCarePlanResponse({
    String? status,
    String? message,
    int? httpCode,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
  }

  EnrollCarePlanResponse.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _httpCode = json['HttpCode'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  String? _status;
  String? _message;
  int? _httpCode;
  Data? _data;

  String? get status => _status;

  String? get message => _message;

  int? get httpCode => _httpCode;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    map['HttpCode'] = _httpCode;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }
}

/// Enrollment : {"id":"7863c55e-821a-47ce-9103-ed095a937d75","PatientUserId":"f0e4fe0d-6445-4c7f-beff-d8b2a8a2cdfb","EnrollmentId":284,"ParticipantId":265,"PlanCode":"HeartFailure","Provider":"AHA","PlanName":"AHA-Heart Failure","StartAt":"2022-04-20T00:00:00.000Z","EndAt":"2022-07-13T00:00:00.000Z","IsActive":true}

class Data {
  Data({
    Enrollment? enrollment,
  }) {
    _enrollment = enrollment;
  }

  Data.fromJson(dynamic json) {
    _enrollment = json['Enrollment'] != null
        ? Enrollment.fromJson(json['Enrollment'])
        : null;
  }

  Enrollment? _enrollment;

  Enrollment? get enrollment => _enrollment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_enrollment != null) {
      map['Enrollment'] = _enrollment?.toJson();
    }
    return map;
  }
}

/// id : "7863c55e-821a-47ce-9103-ed095a937d75"
/// PatientUserId : "f0e4fe0d-6445-4c7f-beff-d8b2a8a2cdfb"
/// EnrollmentId : 284
/// ParticipantId : 265
/// PlanCode : "HeartFailure"
/// Provider : "AHA"
/// PlanName : "AHA-Heart Failure"
/// StartAt : "2022-04-20T00:00:00.000Z"
/// EndAt : "2022-07-13T00:00:00.000Z"
/// IsActive : true

class Enrollment {
  Enrollment({
    String? id,
    String? patientUserId,
    int? enrollmentId,
    int? participantId,
    String? planCode,
    String? provider,
    String? planName,
    String? startAt,
    String? endAt,
    bool? isActive,
  }) {
    _id = id;
    _patientUserId = patientUserId;
    _enrollmentId = enrollmentId;
    _participantId = participantId;
    _planCode = planCode;
    _provider = provider;
    _planName = planName;
    _startAt = startAt;
    _endAt = endAt;
    _isActive = isActive;
  }

  Enrollment.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _enrollmentId = json['EnrollmentId'];
    _participantId = json['ParticipantId'];
    _planCode = json['PlanCode'];
    _provider = json['Provider'];
    _planName = json['PlanName'];
    _startAt = json['StartAt'];
    _endAt = json['EndAt'];
    _isActive = json['IsActive'];
  }

  String? _id;
  String? _patientUserId;
  int? _enrollmentId;
  int? _participantId;
  String? _planCode;
  String? _provider;
  String? _planName;
  String? _startAt;
  String? _endAt;
  bool? _isActive;

  String? get id => _id;

  String? get patientUserId => _patientUserId;

  int? get enrollmentId => _enrollmentId;

  int? get participantId => _participantId;

  String? get planCode => _planCode;

  String? get provider => _provider;

  String? get planName => _planName;

  String? get startAt => _startAt;

  String? get endAt => _endAt;

  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['EnrollmentId'] = _enrollmentId;
    map['ParticipantId'] = _participantId;
    map['PlanCode'] = _planCode;
    map['Provider'] = _provider;
    map['PlanName'] = _planName;
    map['StartAt'] = _startAt;
    map['EndAt'] = _endAt;
    map['IsActive'] = _isActive;
    return map;
  }
}
