/// Status : "success"
/// Message : "Patient goal record created successfully!"
/// HttpCode : 201
/// Data : {"Goal":{"id":"30a8fa6c-5be0-429c-a801-7376abcecce0","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","ProviderEnrollmentId":"{{CAREPLAN_ENROLLMENT_ID}}","Provider":"{{CAREPLAN_PROVIDER}}","ProviderCareplanCode":"{{CAREPLAN_CODE}}","ProviderCareplanName":"{{CAREPLAN_NAME}}","ProviderGoalCode":"123","Title":"{{GOAL_TITLE}}","Sequence":"0","HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","StartedAt":"2022-05-06T14:31:07.570Z","CompletedAt":"2022-05-06T14:31:07.570Z","ScheduledEndDate":null,"GoalAchieved":false,"GoalAbandoned":false}}

class CreateGoalResponse {
  CreateGoalResponse({
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

  CreateGoalResponse.fromJson(dynamic json) {
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

/// Goal : {"id":"30a8fa6c-5be0-429c-a801-7376abcecce0","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","ProviderEnrollmentId":"{{CAREPLAN_ENROLLMENT_ID}}","Provider":"{{CAREPLAN_PROVIDER}}","ProviderCareplanCode":"{{CAREPLAN_CODE}}","ProviderCareplanName":"{{CAREPLAN_NAME}}","ProviderGoalCode":"123","Title":"{{GOAL_TITLE}}","Sequence":"0","HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","StartedAt":"2022-05-06T14:31:07.570Z","CompletedAt":"2022-05-06T14:31:07.570Z","ScheduledEndDate":null,"GoalAchieved":false,"GoalAbandoned":false}

class Data {
  Data({
    Goal? goal,
  }) {
    _goal = goal;
  }

  Data.fromJson(dynamic json) {
    _goal = json['Goal'] != null ? Goal.fromJson(json['Goal']) : null;
  }

  Goal? _goal;

  Goal? get goal => _goal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_goal != null) {
      map['Goal'] = _goal?.toJson();
    }
    return map;
  }
}

/// id : "30a8fa6c-5be0-429c-a801-7376abcecce0"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// ProviderEnrollmentId : "{{CAREPLAN_ENROLLMENT_ID}}"
/// Provider : "{{CAREPLAN_PROVIDER}}"
/// ProviderCareplanCode : "{{CAREPLAN_CODE}}"
/// ProviderCareplanName : "{{CAREPLAN_NAME}}"
/// ProviderGoalCode : "123"
/// Title : "{{GOAL_TITLE}}"
/// Sequence : "0"
/// HealthPriorityId : "aa4b0eff-3e0c-4b56-b139-debf050e55a6"
/// StartedAt : "2022-05-06T14:31:07.570Z"
/// CompletedAt : "2022-05-06T14:31:07.570Z"
/// ScheduledEndDate : null
/// GoalAchieved : false
/// GoalAbandoned : false

class Goal {
  Goal({
    String? id,
    String? patientUserId,
    String? providerEnrollmentId,
    String? provider,
    String? providerCareplanCode,
    String? providerCareplanName,
    String? providerGoalCode,
    String? title,
    String? sequence,
    String? healthPriorityId,
    String? startedAt,
    String? completedAt,
    dynamic scheduledEndDate,
    bool? goalAchieved,
    bool? goalAbandoned,
  }) {
    _id = id;
    _patientUserId = patientUserId;
    _providerEnrollmentId = providerEnrollmentId;
    _provider = provider;
    _providerCareplanCode = providerCareplanCode;
    _providerCareplanName = providerCareplanName;
    _providerGoalCode = providerGoalCode;
    _title = title;
    _sequence = sequence;
    _healthPriorityId = healthPriorityId;
    _startedAt = startedAt;
    _completedAt = completedAt;
    _scheduledEndDate = scheduledEndDate;
    _goalAchieved = goalAchieved;
    _goalAbandoned = goalAbandoned;
  }

  Goal.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _providerEnrollmentId = json['ProviderEnrollmentId'];
    _provider = json['Provider'];
    _providerCareplanCode = json['ProviderCareplanCode'];
    _providerCareplanName = json['ProviderCareplanName'];
    _providerGoalCode = json['ProviderGoalCode'];
    _title = json['Title'];
    _sequence = json['Sequence'];
    _healthPriorityId = json['HealthPriorityId'];
    _startedAt = json['StartedAt'];
    _completedAt = json['CompletedAt'];
    _scheduledEndDate = json['ScheduledEndDate'];
    _goalAchieved = json['GoalAchieved'];
    _goalAbandoned = json['GoalAbandoned'];
  }

  String? _id;
  String? _patientUserId;
  String? _providerEnrollmentId;
  String? _provider;
  String? _providerCareplanCode;
  String? _providerCareplanName;
  String? _providerGoalCode;
  String? _title;
  String? _sequence;
  String? _healthPriorityId;
  String? _startedAt;
  String? _completedAt;
  dynamic _scheduledEndDate;
  bool? _goalAchieved;
  bool? _goalAbandoned;

  String? get id => _id;

  String? get patientUserId => _patientUserId;

  String? get providerEnrollmentId => _providerEnrollmentId;

  String? get provider => _provider;

  String? get providerCareplanCode => _providerCareplanCode;

  String? get providerCareplanName => _providerCareplanName;

  String? get providerGoalCode => _providerGoalCode;

  String? get title => _title;

  String? get sequence => _sequence;

  String? get healthPriorityId => _healthPriorityId;

  String? get startedAt => _startedAt;

  String? get completedAt => _completedAt;

  dynamic get scheduledEndDate => _scheduledEndDate;

  bool? get goalAchieved => _goalAchieved;

  bool? get goalAbandoned => _goalAbandoned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['ProviderEnrollmentId'] = _providerEnrollmentId;
    map['Provider'] = _provider;
    map['ProviderCareplanCode'] = _providerCareplanCode;
    map['ProviderCareplanName'] = _providerCareplanName;
    map['ProviderGoalCode'] = _providerGoalCode;
    map['Title'] = _title;
    map['Sequence'] = _sequence;
    map['HealthPriorityId'] = _healthPriorityId;
    map['StartedAt'] = _startedAt;
    map['CompletedAt'] = _completedAt;
    map['ScheduledEndDate'] = _scheduledEndDate;
    map['GoalAchieved'] = _goalAchieved;
    map['GoalAbandoned'] = _goalAbandoned;
    return map;
  }
}
