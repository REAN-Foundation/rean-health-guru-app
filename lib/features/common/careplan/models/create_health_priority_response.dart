/// Status : "success"
/// Message : "health priority record created successfully!"
/// HttpCode : 201
/// Data : {"HealthPriority":{"id":"00d4e383-cc6d-47e5-b6b0-75f035edca10","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","Source":"Careplan","ProviderEnrollmentId":"{{CAREPLAN_ENROLLMENT_ID}}","Provider":"{{CAREPLAN_PROVIDER}}","ProviderCareplanName":"{{CAREPLAN_CODE}}","ProviderCareplanCode":"{{CAREPLAN_CODE}}","HealthPriorityType":"Custom","StartedAt":"2022-05-06T11:24:40.190Z","CompletedAt":null,"Status":null,"IsPrimary":true}}

class CreateHealthPriorityResponse {
  CreateHealthPriorityResponse({
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

  CreateHealthPriorityResponse.fromJson(dynamic json) {
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

/// HealthPriority : {"id":"00d4e383-cc6d-47e5-b6b0-75f035edca10","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","Source":"Careplan","ProviderEnrollmentId":"{{CAREPLAN_ENROLLMENT_ID}}","Provider":"{{CAREPLAN_PROVIDER}}","ProviderCareplanName":"{{CAREPLAN_CODE}}","ProviderCareplanCode":"{{CAREPLAN_CODE}}","HealthPriorityType":"Custom","StartedAt":"2022-05-06T11:24:40.190Z","CompletedAt":null,"Status":null,"IsPrimary":true}

class Data {
  Data({
    HealthPriority? healthPriority,
  }) {
    _healthPriority = healthPriority;
  }

  Data.fromJson(dynamic json) {
    _healthPriority = json['HealthPriority'] != null
        ? HealthPriority.fromJson(json['HealthPriority'])
        : null;
  }

  HealthPriority? _healthPriority;

  HealthPriority? get healthPriority => _healthPriority;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_healthPriority != null) {
      map['HealthPriority'] = _healthPriority?.toJson();
    }
    return map;
  }
}

/// id : "00d4e383-cc6d-47e5-b6b0-75f035edca10"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// Source : "Careplan"
/// ProviderEnrollmentId : "{{CAREPLAN_ENROLLMENT_ID}}"
/// Provider : "{{CAREPLAN_PROVIDER}}"
/// ProviderCareplanName : "{{CAREPLAN_CODE}}"
/// ProviderCareplanCode : "{{CAREPLAN_CODE}}"
/// HealthPriorityType : "Custom"
/// StartedAt : "2022-05-06T11:24:40.190Z"
/// CompletedAt : null
/// Status : null
/// IsPrimary : true

class HealthPriority {
  HealthPriority({
    String? id,
    String? patientUserId,
    String? source,
    String? providerEnrollmentId,
    String? provider,
    String? providerCareplanName,
    String? providerCareplanCode,
    String? healthPriorityType,
    String? startedAt,
    dynamic completedAt,
    dynamic status,
    bool? isPrimary,
  }) {
    _id = id;
    _patientUserId = patientUserId;
    _source = source;
    _providerEnrollmentId = providerEnrollmentId;
    _provider = provider;
    _providerCareplanName = providerCareplanName;
    _providerCareplanCode = providerCareplanCode;
    _healthPriorityType = healthPriorityType;
    _startedAt = startedAt;
    _completedAt = completedAt;
    _status = status;
    _isPrimary = isPrimary;
  }

  HealthPriority.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _source = json['Source'];
    _providerEnrollmentId = json['ProviderEnrollmentId'];
    _provider = json['Provider'];
    _providerCareplanName = json['ProviderCareplanName'];
    _providerCareplanCode = json['ProviderCareplanCode'];
    _healthPriorityType = json['HealthPriorityType'];
    _startedAt = json['StartedAt'];
    _completedAt = json['CompletedAt'];
    _status = json['Status'];
    _isPrimary = json['IsPrimary'];
  }

  String? _id;
  String? _patientUserId;
  String? _source;
  String? _providerEnrollmentId;
  String? _provider;
  String? _providerCareplanName;
  String? _providerCareplanCode;
  String? _healthPriorityType;
  String? _startedAt;
  dynamic _completedAt;
  dynamic _status;
  bool? _isPrimary;

  String? get id => _id;

  String? get patientUserId => _patientUserId;

  String? get source => _source;

  String? get providerEnrollmentId => _providerEnrollmentId;

  String? get provider => _provider;

  String? get providerCareplanName => _providerCareplanName;

  String? get providerCareplanCode => _providerCareplanCode;

  String? get healthPriorityType => _healthPriorityType;

  String? get startedAt => _startedAt;

  dynamic get completedAt => _completedAt;

  dynamic get status => _status;

  bool? get isPrimary => _isPrimary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['Source'] = _source;
    map['ProviderEnrollmentId'] = _providerEnrollmentId;
    map['Provider'] = _provider;
    map['ProviderCareplanName'] = _providerCareplanName;
    map['ProviderCareplanCode'] = _providerCareplanCode;
    map['HealthPriorityType'] = _healthPriorityType;
    map['StartedAt'] = _startedAt;
    map['CompletedAt'] = _completedAt;
    map['Status'] = _status;
    map['IsPrimary'] = _isPrimary;
    return map;
  }
}
