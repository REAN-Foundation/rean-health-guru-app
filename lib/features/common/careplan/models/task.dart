/// Status : "success"
/// Message : "User task retrieved successfully!"
/// HttpCode : 200
/// Data : {"UserTask":{"id":"2dd11f35-0a6f-46e4-9d0f-788df981784b","DisplayId":"TSK-6632-9625","UserId":"69c974f9-4b36-4f0f-8af3-b365dc1458ec","Task":"Survey","Description":null,"Category":"Custom","ActionType":"Custom","ActionId":"295002e0-4154-4d09-8484-2830a886a796","ScheduledStartTime":"2022-06-06T18:15:43.000Z","ScheduledEndTime":null,"Status":"Delayed","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null,"Action":{"id":"295002e0-4154-4d09-8484-2830a886a796","UserId":"69c974f9-4b36-4f0f-8af3-b365dc1458ec","Task":"Survey","Description":"Take a survey to help us understand you better!","Category":"Custom","ActionType":"Custom","Details":{"Link":"https://americanheart.co1.qualtrics.com/jfe/form/SV_b1anZr9DUmEOsce"},"ScheduledStartTime":"2022-06-06T18:15:43.000Z","ScheduledEndTime":null,"Status":"Delayed","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null}}}

class Task {
  Task({
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

  Task.fromJson(dynamic json) {
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

/// UserTask : {"id":"2dd11f35-0a6f-46e4-9d0f-788df981784b","DisplayId":"TSK-6632-9625","UserId":"69c974f9-4b36-4f0f-8af3-b365dc1458ec","Task":"Survey","Description":null,"Category":"Custom","ActionType":"Custom","ActionId":"295002e0-4154-4d09-8484-2830a886a796","ScheduledStartTime":"2022-06-06T18:15:43.000Z","ScheduledEndTime":null,"Status":"Delayed","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null,"Action":{"id":"295002e0-4154-4d09-8484-2830a886a796","UserId":"69c974f9-4b36-4f0f-8af3-b365dc1458ec","Task":"Survey","Description":"Take a survey to help us understand you better!","Category":"Custom","ActionType":"Custom","Details":{"Link":"https://americanheart.co1.qualtrics.com/jfe/form/SV_b1anZr9DUmEOsce"},"ScheduledStartTime":"2022-06-06T18:15:43.000Z","ScheduledEndTime":null,"Status":"Delayed","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null}}

class Data {
  Data({
    UserTask? userTask,
  }) {
    _userTask = userTask;
  }

  Data.fromJson(dynamic json) {
    _userTask =
        json['UserTask'] != null ? UserTask.fromJson(json['UserTask']) : null;
  }

  UserTask? _userTask;

  UserTask? get userTask => _userTask;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_userTask != null) {
      map['UserTask'] = _userTask?.toJson();
    }
    return map;
  }
}

/// id : "2dd11f35-0a6f-46e4-9d0f-788df981784b"
/// DisplayId : "TSK-6632-9625"
/// UserId : "69c974f9-4b36-4f0f-8af3-b365dc1458ec"
/// Task : "Survey"
/// Description : null
/// Category : "Custom"
/// ActionType : "Custom"
/// ActionId : "295002e0-4154-4d09-8484-2830a886a796"
/// ScheduledStartTime : "2022-06-06T18:15:43.000Z"
/// ScheduledEndTime : null
/// Status : "Delayed"
/// Started : false
/// StartedAt : null
/// Finished : false
/// FinishedAt : null
/// Cancelled : false
/// CancelledAt : null
/// CancellationReason : null
/// IsRecurrent : false
/// RecurrenceScheduleId : null
/// Action : {"id":"295002e0-4154-4d09-8484-2830a886a796","UserId":"69c974f9-4b36-4f0f-8af3-b365dc1458ec","Task":"Survey","Description":"Take a survey to help us understand you better!","Category":"Custom","ActionType":"Custom","Details":{"Link":"https://americanheart.co1.qualtrics.com/jfe/form/SV_b1anZr9DUmEOsce"},"ScheduledStartTime":"2022-06-06T18:15:43.000Z","ScheduledEndTime":null,"Status":"Delayed","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null}

class UserTask {
  UserTask({
    String? id,
    String? displayId,
    String? userId,
    String? task,
    dynamic description,
    String? category,
    String? actionType,
    String? actionId,
    String? scheduledStartTime,
    dynamic scheduledEndTime,
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

  UserTask.fromJson(dynamic json) {
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
  dynamic _scheduledEndTime;
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

  dynamic get scheduledEndTime => _scheduledEndTime;

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

/// id : "295002e0-4154-4d09-8484-2830a886a796"
/// UserId : "69c974f9-4b36-4f0f-8af3-b365dc1458ec"
/// Task : "Survey"
/// Description : "Take a survey to help us understand you better!"
/// Category : "Custom"
/// ActionType : "Custom"
/// Details : {"Link":"https://americanheart.co1.qualtrics.com/jfe/form/SV_b1anZr9DUmEOsce"}
/// ScheduledStartTime : "2022-06-06T18:15:43.000Z"
/// ScheduledEndTime : null
/// Status : "Delayed"
/// Started : false
/// StartedAt : null
/// Finished : false
/// FinishedAt : null
/// Cancelled : false
/// CancelledAt : null
/// CancellationReason : null
/// IsRecurrent : false
/// RecurrenceScheduleId : null

class Action {
  Action({
    String? id,
    String? userId,
    String? task,
    String? description,
    String? category,
    String? actionType,
    Details? details,
    String? scheduledStartTime,
    dynamic scheduledEndTime,
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
  }) {
    _id = id;
    _userId = userId;
    _task = task;
    _description = description;
    _category = category;
    _actionType = actionType;
    _details = details;
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
  }

  Action.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['UserId'];
    _task = json['Task'];
    _description = json['Description'];
    _category = json['Category'];
    _actionType = json['ActionType'];
    _details =
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
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
  }

  String? _id;
  String? _userId;
  String? _task;
  String? _description;
  String? _category;
  String? _actionType;
  Details? _details;
  String? _scheduledStartTime;
  dynamic _scheduledEndTime;
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

  String? get id => _id;

  String? get userId => _userId;

  String? get task => _task;

  String? get description => _description;

  String? get category => _category;

  String? get actionType => _actionType;

  Details? get details => _details;

  String? get scheduledStartTime => _scheduledStartTime;

  dynamic get scheduledEndTime => _scheduledEndTime;

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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserId'] = _userId;
    map['Task'] = _task;
    map['Description'] = _description;
    map['Category'] = _category;
    map['ActionType'] = _actionType;
    if (_details != null) {
      map['Details'] = _details?.toJson();
    }
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
    return map;
  }
}

/// Link : "https://americanheart.co1.qualtrics.com/jfe/form/SV_b1anZr9DUmEOsce"

class Details {
  Details({
    String? link,
  }) {
    _link = link;
  }

  Details.fromJson(dynamic json) {
    _link = json['Link'];
  }

  String? _link;

  String? get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Link'] = _link;
    return map;
  }
}
