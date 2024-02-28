/// Status : "success"
/// Message : "Patient goal retrieved successfully!"
/// HttpCode : 200
/// Data : {"Goals":[{"PatientUserId":"eb43207a-5d54-4742-a78f-c1e1f4255549","ProviderEnrollmentId":"481","Provider":"AHA","ProviderCareplanName":"AHA-Heart Failure","ProviderCareplanCode":"HeartFailure","ProviderGoalCode":"8004","Title":"Improve eating habits","Sequence":0,"HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","GoalAchieved":false,"GoalAbandoned":false},{"PatientUserId":"eb43207a-5d54-4742-a78f-c1e1f4255549","ProviderEnrollmentId":"481","Provider":"AHA","ProviderCareplanName":"AHA-Heart Failure","ProviderCareplanCode":"HeartFailure","ProviderGoalCode":"8005","Title":"Eat healthier foods","Sequence":0,"HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","GoalAchieved":false,"GoalAbandoned":false}]}

class GetGoalsByPriority {
  GetGoalsByPriority({
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

  GetGoalsByPriority.fromJson(dynamic json) {
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

/// Goals : [{"PatientUserId":"eb43207a-5d54-4742-a78f-c1e1f4255549","ProviderEnrollmentId":"481","Provider":"AHA","ProviderCareplanName":"AHA-Heart Failure","ProviderCareplanCode":"HeartFailure","ProviderGoalCode":"8004","Title":"Improve eating habits","Sequence":0,"HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","GoalAchieved":false,"GoalAbandoned":false},{"PatientUserId":"eb43207a-5d54-4742-a78f-c1e1f4255549","ProviderEnrollmentId":"481","Provider":"AHA","ProviderCareplanName":"AHA-Heart Failure","ProviderCareplanCode":"HeartFailure","ProviderGoalCode":"8005","Title":"Eat healthier foods","Sequence":0,"HealthPriorityId":"aa4b0eff-3e0c-4b56-b139-debf050e55a6","GoalAchieved":false,"GoalAbandoned":false}]

class Data {
  Data({
    List<Goals>? goals,
  }) {
    _goals = goals;
  }

  Data.fromJson(dynamic json) {
    if (json['Goals'] != null) {
      _goals = [];
      json['Goals'].forEach((v) {
        _goals?.add(Goals.fromJson(v));
      });
    }
  }

  List<Goals>? _goals;

  List<Goals>? get goals => _goals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_goals != null) {
      map['Goals'] = _goals?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// PatientUserId : "eb43207a-5d54-4742-a78f-c1e1f4255549"
/// ProviderEnrollmentId : "481"
/// Provider : "AHA"
/// ProviderCareplanName : "AHA-Heart Failure"
/// ProviderCareplanCode : "HeartFailure"
/// ProviderGoalCode : "8004"
/// Title : "Improve eating habits"
/// Sequence : 0
/// HealthPriorityId : "aa4b0eff-3e0c-4b56-b139-debf050e55a6"
/// GoalAchieved : false
/// GoalAbandoned : false

class Goals {
  Goals({
    String? patientUserId,
    String? providerEnrollmentId,
    String? provider,
    String? providerCareplanName,
    String? providerCareplanCode,
    String? providerGoalCode,
    String? title,
    int? sequence,
    String? healthPriorityId,
    bool? isCheck,
    bool? goalAchieved,
    bool? goalAbandoned,
  }) {
    _patientUserId = patientUserId;
    _providerEnrollmentId = providerEnrollmentId;
    _provider = provider;
    _providerCareplanName = providerCareplanName;
    _providerCareplanCode = providerCareplanCode;
    _providerGoalCode = providerGoalCode;
    _title = title;
    isCheck = false;
    _sequence = sequence;
    _healthPriorityId = healthPriorityId;
    _goalAchieved = goalAchieved;
    _goalAbandoned = goalAbandoned;
  }

  Goals.fromJson(dynamic json) {
    _patientUserId = json['PatientUserId'];
    _providerEnrollmentId = json['ProviderEnrollmentId'];
    _provider = json['Provider'];
    _providerCareplanName = json['ProviderCareplanName'];
    _providerCareplanCode = json['ProviderCareplanCode'];
    _providerGoalCode = json['ProviderGoalCode'];
    _title = json['Title'];
    _sequence = json['Sequence'];
    _healthPriorityId = json['HealthPriorityId'];
    _goalAchieved = json['GoalAchieved'];
    _goalAbandoned = json['GoalAbandoned'];
  }

  String? _patientUserId;
  String? _providerEnrollmentId;
  String? _provider;
  String? _providerCareplanName;
  String? _providerCareplanCode;
  String? _providerGoalCode;
  String? _title;
  int? _sequence;
  String? _healthPriorityId;
  bool? isCheck = false;
  bool? _goalAchieved;
  bool? _goalAbandoned;

  String? get patientUserId => _patientUserId;

  String? get providerEnrollmentId => _providerEnrollmentId;

  String? get provider => _provider;

  String? get providerCareplanName => _providerCareplanName;

  String? get providerCareplanCode => _providerCareplanCode;

  String? get providerGoalCode => _providerGoalCode;

  String? get title => _title;

  int? get sequence => _sequence;

  String? get healthPriorityId => _healthPriorityId;

  bool? get isChecked => isCheck ?? false;

  bool? get goalAchieved => _goalAchieved;

  bool? get goalAbandoned => _goalAbandoned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PatientUserId'] = _patientUserId;
    map['ProviderEnrollmentId'] = _providerEnrollmentId;
    map['Provider'] = _provider;
    map['ProviderCareplanName'] = _providerCareplanName;
    map['ProviderCareplanCode'] = _providerCareplanCode;
    map['ProviderGoalCode'] = _providerGoalCode;
    map['Title'] = _title;
    map['Sequence'] = _sequence;
    map['HealthPriorityId'] = _healthPriorityId;
    map['GoalAchieved'] = _goalAchieved;
    map['GoalAbandoned'] = _goalAbandoned;
    return map;
  }
}
