/// Status : "success"
/// Message : "Patient enrollments retrieved successfully!"
/// HttpCode : 200
/// Data : {"PatientEnrollments":[{"id":"7c6b7f8f-26b8-4a8d-be79-c9f62f924c07","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":361,"ParticipantId":297,"PlanCode":"HeartFailure","Provider":"AHA","PlanName":"AHA-Heart Failure","StartAt":"2022-04-25T00:00:00.000Z","EndAt":"2022-07-18T00:00:00.000Z","IsActive":true}]}

class GetCarePlanEnrollmentForPatient {
  GetCarePlanEnrollmentForPatient({
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

  GetCarePlanEnrollmentForPatient.fromJson(dynamic json) {
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

/// PatientEnrollments : [{"id":"7c6b7f8f-26b8-4a8d-be79-c9f62f924c07","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":361,"ParticipantId":297,"PlanCode":"HeartFailure","Provider":"AHA","PlanName":"AHA-Heart Failure","StartAt":"2022-04-25T00:00:00.000Z","EndAt":"2022-07-18T00:00:00.000Z","IsActive":true}]

class Data {
  Data({
    List<PatientEnrollments>? patientEnrollments,
  }) {
    _patientEnrollments = patientEnrollments;
  }

  Data.fromJson(dynamic json) {
    if (json['PatientEnrollments'] != null) {
      _patientEnrollments = [];
      json['PatientEnrollments'].forEach((v) {
        _patientEnrollments?.add(PatientEnrollments.fromJson(v));
      });
    }
  }

  List<PatientEnrollments>? _patientEnrollments;

  List<PatientEnrollments>? get patientEnrollments => _patientEnrollments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_patientEnrollments != null) {
      map['PatientEnrollments'] =
          _patientEnrollments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "7c6b7f8f-26b8-4a8d-be79-c9f62f924c07"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// EnrollmentId : 361
/// ParticipantId : 297
/// PlanCode : "HeartFailure"
/// Provider : "AHA"
/// PlanName : "AHA-Heart Failure"
/// StartAt : "2022-04-25T00:00:00.000Z"
/// EndAt : "2022-07-18T00:00:00.000Z"
/// IsActive : true

class PatientEnrollments {
  PatientEnrollments({
    String? id,
    String? patientUserId,
    String? enrollmentId,
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

  PatientEnrollments.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _enrollmentId = json['EnrollmentStringId'];
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
  String? _enrollmentId;
  int? _participantId;
  String? _planCode;
  String? _provider;
  String? _planName;
  String? _startAt;
  String? _endAt;
  bool? _isActive;

  String? get id => _id;

  String? get patientUserId => _patientUserId;

  String? get enrollmentId => _enrollmentId;

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
