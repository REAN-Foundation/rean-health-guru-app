/// id : "0e87f15b-c4ea-4fb5-8c85-ca55d2c5efaa"
/// DisplayId : "AHA-Heart Failure-16355"
/// UserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// Task : "Week televisit"
/// Description : null
/// Category : "Custom"
/// ActionType : "Careplan"
/// ActionId : "3a70ab21-7a4b-4335-968d-b193419f2faa"
/// ScheduledStartTime : "2022-07-12T07:00:02.000Z"
/// ScheduledEndTime : "2022-07-12T23:00:00.000Z"
/// Status : "Pending"
/// Started : false
/// StartedAt : null
/// Finished : false
/// FinishedAt : null
/// Cancelled : false
/// CancelledAt : null
/// CancellationReason : null
/// IsRecurrent : false
/// RecurrenceScheduleId : null
/// Action : {"id":"3a70ab21-7a4b-4335-968d-b193419f2faa","UserTaskId":"0e87f15b-c4ea-4fb5-8c85-ca55d2c5efaa","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":"361","Provider":"AHA","PlanName":"AHA-Heart Failure","PlanCode":"HeartFailure","Type":"Professional","Category":"Custom","ProviderActionId":"16355","Title":"Week televisit","Description":"","Url":null,"ScheduledAt":"2022-07-12T00:00:00.000Z","StartedAt":null,"CompletedAt":null,"Comments":null,"Sequence":3,"Frequency":79,"Status":"Pending","RawContent":null}

class Test {
  Test({
    String? id,
    String? displayId,
    String? userId,
    String? task,
    dynamic description,
    String? category,
    String? actionType,
    String? actionId,
    String? scheduledStartTime,
    String? scheduledEndTime,
    String? status,
    bool? started,
    dynamic startedAt,
    bool? finished,
    dynamic finishedAt,
    bool? cancelled,
    dynamic cancelledAt,
    dynamic cancellationReason,
    bool? isRecurrent,
    dynamic recurrenceScheduleId,
    Action? action,
  }) {
    _id = id;
    _displayId = displayId;
    _userId = userId;
    _task = task;
    _description = description;
    _category = category;
    _actionType = actionType;
    _actionId = actionId;
    _scheduledStartTime = scheduledStartTime;
    _scheduledEndTime = scheduledEndTime;
    _status = status;
    _started = started;
    _startedAt = startedAt;
    _finished = finished;
    _finishedAt = finishedAt;
    _cancelled = cancelled;
    _cancelledAt = cancelledAt;
    _cancellationReason = cancellationReason;
    _isRecurrent = isRecurrent;
    _recurrenceScheduleId = recurrenceScheduleId;
    _action = action;
  }

  Test.fromJson(dynamic json) {
    _id = json['id'];
    _displayId = json['DisplayId'];
    _userId = json['UserId'];
    _task = json['Task'];
    _description = json['Description'];
    _category = json['Category'];
    _actionType = json['ActionType'];
    _actionId = json['ActionId'];
    _scheduledStartTime = json['ScheduledStartTime'];
    _scheduledEndTime = json['ScheduledEndTime'];
    _status = json['Status'];
    _started = json['Started'];
    _startedAt = json['StartedAt'];
    _finished = json['Finished'];
    _finishedAt = json['FinishedAt'];
    _cancelled = json['Cancelled'];
    _cancelledAt = json['CancelledAt'];
    _cancellationReason = json['CancellationReason'];
    _isRecurrent = json['IsRecurrent'];
    _recurrenceScheduleId = json['RecurrenceScheduleId'];
    _action = json['Action'] != null ? Action.fromJson(json['Action']) : null;
  }

  String? _id;
  String? _displayId;
  String? _userId;
  String? _task;
  dynamic _description;
  String? _category;
  String? _actionType;
  String? _actionId;
  String? _scheduledStartTime;
  String? _scheduledEndTime;
  String? _status;
  bool? _started;
  dynamic _startedAt;
  bool? _finished;
  dynamic _finishedAt;
  bool? _cancelled;
  dynamic _cancelledAt;
  dynamic _cancellationReason;
  bool? _isRecurrent;
  dynamic _recurrenceScheduleId;
  Action? _action;

  String? get id => _id;

  String? get displayId => _displayId;

  String? get userId => _userId;

  String? get task => _task;

  dynamic get description => _description;

  String? get category => _category;

  String? get actionType => _actionType;

  String? get actionId => _actionId;

  String? get scheduledStartTime => _scheduledStartTime;

  String? get scheduledEndTime => _scheduledEndTime;

  String? get status => _status;

  bool? get started => _started;

  dynamic get startedAt => _startedAt;

  bool? get finished => _finished;

  dynamic get finishedAt => _finishedAt;

  bool? get cancelled => _cancelled;

  dynamic get cancelledAt => _cancelledAt;

  dynamic get cancellationReason => _cancellationReason;

  bool? get isRecurrent => _isRecurrent;

  dynamic get recurrenceScheduleId => _recurrenceScheduleId;

  Action? get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['DisplayId'] = _displayId;
    map['UserId'] = _userId;
    map['Task'] = _task;
    map['Description'] = _description;
    map['Category'] = _category;
    map['ActionType'] = _actionType;
    map['ActionId'] = _actionId;
    map['ScheduledStartTime'] = _scheduledStartTime;
    map['ScheduledEndTime'] = _scheduledEndTime;
    map['Status'] = _status;
    map['Started'] = _started;
    map['StartedAt'] = _startedAt;
    map['Finished'] = _finished;
    map['FinishedAt'] = _finishedAt;
    map['Cancelled'] = _cancelled;
    map['CancelledAt'] = _cancelledAt;
    map['CancellationReason'] = _cancellationReason;
    map['IsRecurrent'] = _isRecurrent;
    map['RecurrenceScheduleId'] = _recurrenceScheduleId;
    if (_action != null) {
      map['Action'] = _action?.toJson();
    }
    return map;
  }
}

/// id : "3a70ab21-7a4b-4335-968d-b193419f2faa"
/// UserTaskId : "0e87f15b-c4ea-4fb5-8c85-ca55d2c5efaa"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// EnrollmentId : "361"
/// Provider : "AHA"
/// PlanName : "AHA-Heart Failure"
/// PlanCode : "HeartFailure"
/// Type : "Professional"
/// Category : "Custom"
/// ProviderActionId : "16355"
/// Title : "Week televisit"
/// Description : ""
/// Url : null
/// ScheduledAt : "2022-07-12T00:00:00.000Z"
/// StartedAt : null
/// CompletedAt : null
/// Comments : null
/// Sequence : 3
/// Frequency : 79
/// Status : "Pending"
/// RawContent : null

class Action {
  Action({
    String? id,
    String? userTaskId,
    String? patientUserId,
    String? enrollmentId,
    String? provider,
    String? planName,
    String? planCode,
    String? type,
    String? category,
    String? providerActionId,
    String? title,
    String? description,
    dynamic url,
    String? scheduledAt,
    dynamic startedAt,
    dynamic completedAt,
    dynamic comments,
    int? sequence,
    int? frequency,
    String? status,
    dynamic rawContent,
  }) {
    _id = id;
    _userTaskId = userTaskId;
    _patientUserId = patientUserId;
    _enrollmentId = enrollmentId;
    _provider = provider;
    _planName = planName;
    _planCode = planCode;
    _type = type;
    _category = category;
    _providerActionId = providerActionId;
    _title = title;
    _description = description;
    _url = url;
    _scheduledAt = scheduledAt;
    _startedAt = startedAt;
    _completedAt = completedAt;
    _comments = comments;
    _sequence = sequence;
    _frequency = frequency;
    _status = status;
    _rawContent = rawContent;
  }

  Action.fromJson(dynamic json) {
    _id = json['id'];
    _userTaskId = json['UserTaskId'];
    _patientUserId = json['PatientUserId'];
    _enrollmentId = json['EnrollmentId'];
    _provider = json['Provider'];
    _planName = json['PlanName'];
    _planCode = json['PlanCode'];
    _type = json['Type'];
    _category = json['Category'];
    _providerActionId = json['ProviderActionId'];
    _title = json['Title'];
    _description = json['Description'];
    _url = json['Url'];
    _scheduledAt = json['ScheduledAt'];
    _startedAt = json['StartedAt'];
    _completedAt = json['CompletedAt'];
    _comments = json['Comments'];
    _sequence = json['Sequence'];
    _frequency = json['Frequency'];
    _status = json['Status'];
    _rawContent = json['RawContent'];
  }

  String? _id;
  String? _userTaskId;
  String? _patientUserId;
  String? _enrollmentId;
  String? _provider;
  String? _planName;
  String? _planCode;
  String? _type;
  String? _category;
  String? _providerActionId;
  String? _title;
  String? _description;
  dynamic _url;
  String? _scheduledAt;
  dynamic _startedAt;
  dynamic _completedAt;
  dynamic _comments;
  int? _sequence;
  int? _frequency;
  String? _status;
  dynamic _rawContent;

  String? get id => _id;

  String? get userTaskId => _userTaskId;

  String? get patientUserId => _patientUserId;

  String? get enrollmentId => _enrollmentId;

  String? get provider => _provider;

  String? get planName => _planName;

  String? get planCode => _planCode;

  String? get type => _type;

  String? get category => _category;

  String? get providerActionId => _providerActionId;

  String? get title => _title;

  String? get description => _description;

  dynamic get url => _url;

  String? get scheduledAt => _scheduledAt;

  dynamic get startedAt => _startedAt;

  dynamic get completedAt => _completedAt;

  dynamic get comments => _comments;

  int? get sequence => _sequence;

  int? get frequency => _frequency;

  String? get status => _status;

  dynamic get rawContent => _rawContent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserTaskId'] = _userTaskId;
    map['PatientUserId'] = _patientUserId;
    map['EnrollmentId'] = _enrollmentId;
    map['Provider'] = _provider;
    map['PlanName'] = _planName;
    map['PlanCode'] = _planCode;
    map['Type'] = _type;
    map['Category'] = _category;
    map['ProviderActionId'] = _providerActionId;
    map['Title'] = _title;
    map['Description'] = _description;
    map['Url'] = _url;
    map['ScheduledAt'] = _scheduledAt;
    map['StartedAt'] = _startedAt;
    map['CompletedAt'] = _completedAt;
    map['Comments'] = _comments;
    map['Sequence'] = _sequence;
    map['Frequency'] = _frequency;
    map['Status'] = _status;
    map['RawContent'] = _rawContent;
    return map;
  }
}
