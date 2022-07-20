/// Status : "success"
/// Message : "User task retrieved successfully!"
/// HttpCode : 200
/// Data : {"UserTask":{"id":"60e904f8-e0c1-49b7-82a6-455a5a5964f4","DisplayId":"AHA-Heart Failure-1011","UserId":"5f9ece85-5322-495d-ae31-30c4402aae34","Task":"What's Next","Description":null,"Category":"Custom","ActionType":"Careplan","ActionId":"2fd3bae8-c4a6-4c14-9326-8ab72582f691","ScheduledStartTime":"2022-07-11T07:00:00.000Z","ScheduledEndTime":"2022-07-11T23:00:00.000Z","Status":"Pending","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null,"Action":{"id":"2fd3bae8-c4a6-4c14-9326-8ab72582f691","UserTaskId":"60e904f8-e0c1-49b7-82a6-455a5a5964f4","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":"361","Provider":"AHA","PlanName":"AHA-Heart Failure","PlanCode":"HeartFailure","Type":"Video","Category":"Educational-Video","ProviderActionId":"1011","Title":"What's Next","Description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)\n","Url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4","ScheduledAt":"2022-07-11T00:00:00.000Z","StartedAt":null,"CompletedAt":null,"Comments":null,"Sequence":1,"Frequency":78,"Status":"Pending","RawContent":{"code":"1011","contentTypeCode":"Video","description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)","group":{"category":["Lifes Simple 7","Planning"]},"id":12,"locale":{"es":{"text":"Pat: Bienvenido de nuevo a la Asociación Americana del Corazón, CarePlan basado en la ciencia. Este es Pat Dunn.\nAllison: y yo soy Allison Sundberg. Gran trabajo. Ha completado el plan de atención. Antes de abandonar el Plan de atención, deberá completar una evaluación de seguimiento de Life’s Simple 7 para que podamos documentar su progreso.\nPat: Necesitas desarrollar un plan para mantener el éxito que has logrado hasta ahora. Puede actualizar su plan de atención cambiando su prioridad, restableciendo su objetivo o revisando su plan de acción. Finalmente, mira el video sobre Historias inspiradoras.\nAllison: Si este es el final del camino para ti, buena suerte en tu viaje y búsqueda de una salud cardiovascular ideal."}},"name":"What's Next","status":"PENDING","text":"Pat:  Welcome back to the American Heart Association, Science based CarePlan.  This is Pat Dunn\nAllison:  and I am Allison Sundberg.  Great job.  You have completed the Care Plan.  Before you leave the Care Plan, you will need to complete a follow up Life’s Simple 7 assessment so that we can document your progress.  \nPat:  You need to develop a plan for sustaining the success you have achieved so far.  You can update your care plan by changing your priority, resetting your goal, or revising your action plan.  Finally, watch the video on Inspiring stories.\nAllison:  If this is the end of the road for you, good luck in your journey and pursuit of ideal cardiovascular health.","url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4"}}}}

class GetUserTaskDetails {
  GetUserTaskDetails({
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

  GetUserTaskDetails.fromJson(dynamic json) {
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

/// UserTask : {"id":"60e904f8-e0c1-49b7-82a6-455a5a5964f4","DisplayId":"AHA-Heart Failure-1011","UserId":"5f9ece85-5322-495d-ae31-30c4402aae34","Task":"What's Next","Description":null,"Category":"Custom","ActionType":"Careplan","ActionId":"2fd3bae8-c4a6-4c14-9326-8ab72582f691","ScheduledStartTime":"2022-07-11T07:00:00.000Z","ScheduledEndTime":"2022-07-11T23:00:00.000Z","Status":"Pending","Started":false,"StartedAt":null,"Finished":false,"FinishedAt":null,"Cancelled":false,"CancelledAt":null,"CancellationReason":null,"IsRecurrent":false,"RecurrenceScheduleId":null,"Action":{"id":"2fd3bae8-c4a6-4c14-9326-8ab72582f691","UserTaskId":"60e904f8-e0c1-49b7-82a6-455a5a5964f4","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":"361","Provider":"AHA","PlanName":"AHA-Heart Failure","PlanCode":"HeartFailure","Type":"Video","Category":"Educational-Video","ProviderActionId":"1011","Title":"What's Next","Description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)\n","Url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4","ScheduledAt":"2022-07-11T00:00:00.000Z","StartedAt":null,"CompletedAt":null,"Comments":null,"Sequence":1,"Frequency":78,"Status":"Pending","RawContent":{"code":"1011","contentTypeCode":"Video","description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)","group":{"category":["Lifes Simple 7","Planning"]},"id":12,"locale":{"es":{"text":"Pat: Bienvenido de nuevo a la Asociación Americana del Corazón, CarePlan basado en la ciencia. Este es Pat Dunn.\nAllison: y yo soy Allison Sundberg. Gran trabajo. Ha completado el plan de atención. Antes de abandonar el Plan de atención, deberá completar una evaluación de seguimiento de Life’s Simple 7 para que podamos documentar su progreso.\nPat: Necesitas desarrollar un plan para mantener el éxito que has logrado hasta ahora. Puede actualizar su plan de atención cambiando su prioridad, restableciendo su objetivo o revisando su plan de acción. Finalmente, mira el video sobre Historias inspiradoras.\nAllison: Si este es el final del camino para ti, buena suerte en tu viaje y búsqueda de una salud cardiovascular ideal."}},"name":"What's Next","status":"PENDING","text":"Pat:  Welcome back to the American Heart Association, Science based CarePlan.  This is Pat Dunn\nAllison:  and I am Allison Sundberg.  Great job.  You have completed the Care Plan.  Before you leave the Care Plan, you will need to complete a follow up Life’s Simple 7 assessment so that we can document your progress.  \nPat:  You need to develop a plan for sustaining the success you have achieved so far.  You can update your care plan by changing your priority, resetting your goal, or revising your action plan.  Finally, watch the video on Inspiring stories.\nAllison:  If this is the end of the road for you, good luck in your journey and pursuit of ideal cardiovascular health.","url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4"}}}

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

/// id : "60e904f8-e0c1-49b7-82a6-455a5a5964f4"
/// DisplayId : "AHA-Heart Failure-1011"
/// UserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// Task : "What's Next"
/// Description : null
/// Category : "Custom"
/// ActionType : "Careplan"
/// ActionId : "2fd3bae8-c4a6-4c14-9326-8ab72582f691"
/// ScheduledStartTime : "2022-07-11T07:00:00.000Z"
/// ScheduledEndTime : "2022-07-11T23:00:00.000Z"
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
/// Action : {"id":"2fd3bae8-c4a6-4c14-9326-8ab72582f691","UserTaskId":"60e904f8-e0c1-49b7-82a6-455a5a5964f4","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","EnrollmentId":"361","Provider":"AHA","PlanName":"AHA-Heart Failure","PlanCode":"HeartFailure","Type":"Video","Category":"Educational-Video","ProviderActionId":"1011","Title":"What's Next","Description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)\n","Url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4","ScheduledAt":"2022-07-11T00:00:00.000Z","StartedAt":null,"CompletedAt":null,"Comments":null,"Sequence":1,"Frequency":78,"Status":"Pending","RawContent":{"code":"1011","contentTypeCode":"Video","description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)","group":{"category":["Lifes Simple 7","Planning"]},"id":12,"locale":{"es":{"text":"Pat: Bienvenido de nuevo a la Asociación Americana del Corazón, CarePlan basado en la ciencia. Este es Pat Dunn.\nAllison: y yo soy Allison Sundberg. Gran trabajo. Ha completado el plan de atención. Antes de abandonar el Plan de atención, deberá completar una evaluación de seguimiento de Life’s Simple 7 para que podamos documentar su progreso.\nPat: Necesitas desarrollar un plan para mantener el éxito que has logrado hasta ahora. Puede actualizar su plan de atención cambiando su prioridad, restableciendo su objetivo o revisando su plan de acción. Finalmente, mira el video sobre Historias inspiradoras.\nAllison: Si este es el final del camino para ti, buena suerte en tu viaje y búsqueda de una salud cardiovascular ideal."}},"name":"What's Next","status":"PENDING","text":"Pat:  Welcome back to the American Heart Association, Science based CarePlan.  This is Pat Dunn\nAllison:  and I am Allison Sundberg.  Great job.  You have completed the Care Plan.  Before you leave the Care Plan, you will need to complete a follow up Life’s Simple 7 assessment so that we can document your progress.  \nPat:  You need to develop a plan for sustaining the success you have achieved so far.  You can update your care plan by changing your priority, resetting your goal, or revising your action plan.  Finally, watch the video on Inspiring stories.\nAllison:  If this is the end of the road for you, good luck in your journey and pursuit of ideal cardiovascular health.","url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4"}}

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

  bool get finished => _finished ?? false;

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

/// id : "2fd3bae8-c4a6-4c14-9326-8ab72582f691"
/// UserTaskId : "60e904f8-e0c1-49b7-82a6-455a5a5964f4"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// EnrollmentId : "361"
/// Provider : "AHA"
/// PlanName : "AHA-Heart Failure"
/// PlanCode : "HeartFailure"
/// Type : "Video"
/// Category : "Educational-Video"
/// ProviderActionId : "1011"
/// Title : "What's Next"
/// Description : "Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)\n"
/// Url : "https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4"
/// ScheduledAt : "2022-07-11T00:00:00.000Z"
/// StartedAt : null
/// CompletedAt : null
/// Comments : null
/// Sequence : 1
/// Frequency : 78
/// Status : "Pending"
/// RawContent : {"code":"1011","contentTypeCode":"Video","description":"Week 12 video.  This video is designed to introduce What's Next.  Alternative is 'What's Next-PB' (A25) and 'Update' (A81)","group":{"category":["Lifes Simple 7","Planning"]},"id":12,"locale":{"es":{"text":"Pat: Bienvenido de nuevo a la Asociación Americana del Corazón, CarePlan basado en la ciencia. Este es Pat Dunn.\nAllison: y yo soy Allison Sundberg. Gran trabajo. Ha completado el plan de atención. Antes de abandonar el Plan de atención, deberá completar una evaluación de seguimiento de Life’s Simple 7 para que podamos documentar su progreso.\nPat: Necesitas desarrollar un plan para mantener el éxito que has logrado hasta ahora. Puede actualizar su plan de atención cambiando su prioridad, restableciendo su objetivo o revisando su plan de acción. Finalmente, mira el video sobre Historias inspiradoras.\nAllison: Si este es el final del camino para ti, buena suerte en tu viaje y búsqueda de una salud cardiovascular ideal."}},"name":"What's Next","status":"PENDING","text":"Pat:  Welcome back to the American Heart Association, Science based CarePlan.  This is Pat Dunn\nAllison:  and I am Allison Sundberg.  Great job.  You have completed the Care Plan.  Before you leave the Care Plan, you will need to complete a follow up Life’s Simple 7 assessment so that we can document your progress.  \nPat:  You need to develop a plan for sustaining the success you have achieved so far.  You can update your care plan by changing your priority, resetting your goal, or revising your action plan.  Finally, watch the video on Inspiring stories.\nAllison:  If this is the end of the road for you, good luck in your journey and pursuit of ideal cardiovascular health.","url":"https://careplans-content-delivery-stg.heartblr.org/contents/1/video/mp4/5cb15a18041bd0fd5f7e980589649df4.mp4"}

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
    String? url,
    Details? details,
    String? scheduledAt,
    dynamic startedAt,
    dynamic completedAt,
    dynamic comments,
    int? sequence,
    int? frequency,
    String? status,
    RawContent? rawContent,
    Assessment? assessment,
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
    _details = details;
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
    _assessment = assessment;
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
    _details =
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
    _url = json['Url'];
    _scheduledAt = json['ScheduledAt'];
    _startedAt = json['StartedAt'];
    _completedAt = json['CompletedAt'];
    _comments = json['Comments'];
    _sequence = json['Sequence'];
    _frequency = json['Frequency'];
    _status = json['Status'];
    _rawContent = json['RawContent'] != null
        ? json['RawContent'].toString().contains('Newsfeed')
            ? RawContent.fromJson(json['RawContent'])
            : null
        : null;
    _assessment = json['Assessment'] != null
        ? Assessment.fromJson(json['Assessment'])
        : null;
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
  Details? _details;
  String? _providerActionId;
  String? _title;
  String? _description;
  String? _url;
  String? _scheduledAt;
  dynamic _startedAt;
  dynamic _completedAt;
  dynamic _comments;
  int? _sequence;
  int? _frequency;
  String? _status;
  RawContent? _rawContent;
  Assessment? _assessment;

  String? get id => _id;

  String? get userTaskId => _userTaskId;

  String? get patientUserId => _patientUserId;

  String? get enrollmentId => _enrollmentId;

  String? get provider => _provider;

  String? get planName => _planName;

  String? get planCode => _planCode;

  String? get type => _type;

  Details? get details => _details;

  String? get category => _category;

  String? get providerActionId => _providerActionId;

  String? get title => _title;

  String? get description => _description;

  String? get url => _url;

  String? get scheduledAt => _scheduledAt;

  dynamic get startedAt => _startedAt;

  dynamic get completedAt => _completedAt;

  dynamic get comments => _comments;

  int? get sequence => _sequence;

  int? get frequency => _frequency;

  String? get status => _status;

  RawContent? get rawContent => _rawContent;

  Assessment? get assessment => _assessment;

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
    if (_details != null) {
      map['Details'] = _details?.toJson();
    }
    map['Description'] = _description;
    map['Url'] = _url;
    map['ScheduledAt'] = _scheduledAt;
    map['StartedAt'] = _startedAt;
    map['CompletedAt'] = _completedAt;
    map['Comments'] = _comments;
    map['Sequence'] = _sequence;
    map['Frequency'] = _frequency;
    map['Status'] = _status;
    if (_rawContent != null) {
      map['RawContent'] = _rawContent?.toJson();
    }
    if (_assessment != null) {
      map['Assessment'] = _assessment?.toJson();
    }
    return map;
  }
}

class Assessment {
  Assessment({
    String? id,
    String? type,
    String? displayCode,
    String? title,
    dynamic description,
    String? patientUserId,
    String? assessmentTemplateId,
    String? provider,
    String? providerEnrollmentId,
    String? providerAssessmentCode,
    dynamic providerAssessmentId,
    String? status,
    String? scheduledAt,
    String? createdAt,
    String? parentActivityId,
    String? userTaskId,
    String? currentNodeId,
  }) {
    _id = id;
    _type = type;
    _displayCode = displayCode;
    _title = title;
    _description = description;
    _patientUserId = patientUserId;
    _assessmentTemplateId = assessmentTemplateId;
    _provider = provider;
    _providerEnrollmentId = providerEnrollmentId;
    _providerAssessmentCode = providerAssessmentCode;
    _providerAssessmentId = providerAssessmentId;
    _status = status;
    _scheduledAt = scheduledAt;
    _createdAt = createdAt;
    _parentActivityId = parentActivityId;
    _userTaskId = userTaskId;
    _currentNodeId = currentNodeId;
  }

  Assessment.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['Type'];
    _displayCode = json['DisplayCode'];
    _title = json['Title'];
    _description = json['Description'];
    _patientUserId = json['PatientUserId'];
    _assessmentTemplateId = json['AssessmentTemplateId'];
    _provider = json['Provider'];
    _providerEnrollmentId = json['ProviderEnrollmentId'];
    _providerAssessmentCode = json['ProviderAssessmentCode'];
    _providerAssessmentId = json['ProviderAssessmentId'];
    _status = json['Status'];
    _scheduledAt = json['ScheduledAt'];
    _createdAt = json['CreatedAt'];
    _parentActivityId = json['ParentActivityId'];
    _userTaskId = json['UserTaskId'];
    _currentNodeId = json['CurrentNodeId'];
  }

  String? _id;
  String? _type;
  String? _displayCode;
  String? _title;
  dynamic _description;
  String? _patientUserId;
  String? _assessmentTemplateId;
  String? _provider;
  String? _providerEnrollmentId;
  String? _providerAssessmentCode;
  dynamic _providerAssessmentId;
  String? _status;
  String? _scheduledAt;
  String? _createdAt;
  String? _parentActivityId;
  String? _userTaskId;
  String? _currentNodeId;

  String? get id => _id;

  String? get type => _type;

  String? get displayCode => _displayCode;

  String? get title => _title;

  dynamic get description => _description;

  String? get patientUserId => _patientUserId;

  String? get assessmentTemplateId => _assessmentTemplateId;

  String? get provider => _provider;

  String? get providerEnrollmentId => _providerEnrollmentId;

  String? get providerAssessmentCode => _providerAssessmentCode;

  dynamic get providerAssessmentId => _providerAssessmentId;

  String? get status => _status;

  String? get scheduledAt => _scheduledAt;

  String? get createdAt => _createdAt;

  String? get parentActivityId => _parentActivityId;

  String? get userTaskId => _userTaskId;

  String? get currentNodeId => _currentNodeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Type'] = _type;
    map['DisplayCode'] = _displayCode;
    map['Title'] = _title;
    map['Description'] = _description;
    map['PatientUserId'] = _patientUserId;
    map['AssessmentTemplateId'] = _assessmentTemplateId;
    map['Provider'] = _provider;
    map['ProviderEnrollmentId'] = _providerEnrollmentId;
    map['ProviderAssessmentCode'] = _providerAssessmentCode;
    map['ProviderAssessmentId'] = _providerAssessmentId;
    map['Status'] = _status;
    map['ScheduledAt'] = _scheduledAt;
    map['CreatedAt'] = _createdAt;
    map['ParentActivityId'] = _parentActivityId;
    map['UserTaskId'] = _userTaskId;
    map['CurrentNodeId'] = _currentNodeId;
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

/// Newsfeed : [{"Title":"Kitchen magnet with list of heart attack symptoms convinced him to go to the hospital","Link":"https://www.heart.org/en/news/2022/06/17/kitchen-magnet-with-list-of-heart-attack-symptoms-convinced-him-to-go-to-the-hospital"},{"Title":"Can the groan-up humor of 'dad jokes' possibly be good for health?","Link":"https://www.heart.org/en/news/2022/06/15/can-the-groan-up-humor-of-dad-jokes-possibly-be-good-for-health"},{"Title":"Why the world of LGBTQ health doesn't fit under a single label","Link":"https://www.heart.org/en/news/2022/06/14/why-the-world-of-lgbtq-health-doesnt-fit-under-a-single-label"},{"Title":"She thought she had bronchitis, but the problem was her heart","Link":"https://www.heart.org/en/news/2022/06/13/she-thought-she-had-bronchitis-but-the-problem-was-her-heart"},{"Title":"High exposure to 'forever chemicals' may raise women's blood pressure","Link":"https://www.heart.org/en/news/2022/06/13/high-exposure-to-forever-chemicals-may-raise-womens-blood-pressure"},{"Title":"After stroke at 32, young mom's small town pitched in to help","Link":"https://www.heart.org/en/news/2022/06/09/after-stroke-at-32-young-moms-small-town-pitched-in-to-help"},{"Title":"Cardiovascular risk factors undertreated in childhood cancer survivors","Link":"https://www.heart.org/en/news/2022/06/08/cardiovascular-risk-factors-undertreated-in-childhood-cancer-survivors"},{"Title":"Tiny sprouts provide big nutrition","Link":"https://www.heart.org/en/news/2022/06/07/tiny-sprouts-provide-big-nutrition"},{"Title":"Grammy winner, chart-topping producer – and kidney transplant recipient","Link":"https://www.heart.org/en/news/2022/06/06/grammy-winner-chart-topping-producer-and-kidney-transplant-recipient"},{"Title":"New research sheds light on a leading cause of heart attacks related to pregnancy","Link":"https://www.heart.org/en/news/2022/06/03/new-research-sheds-light-on-a-leading-cause-of-heart-attacks-related-to-pregnancy"},{"Title":"Gender gap in some heart risk factors widens among young adults","Link":"https://www.heart.org/en/news/2022/06/02/gender-gap-in-some-heart-risk-factors-widens-among-young-adults"},{"Title":"Consuming about 3 grams of omega-3 fatty acids a day may lower blood pressure","Link":"https://www.heart.org/en/news/2022/06/01/consuming-about-3-grams-of-omega-3-fatty-acids-a-day-may-lower-blood-pressure"},{"Title":"In secondhand vape, scientists smell risk","Link":"https://www.heart.org/en/news/2022/05/31/in-secondhand-vape-scientists-smell-risk"},{"Title":"Her 2-year-old niece noticed something wrong during a video chat. It was a mini-stroke.","Link":"https://www.heart.org/en/news/2022/05/26/her-2-year-old-niece-noticed-something-wrong-during-a-video-chat-it-was-a-mini-stroke"},{"Title":"Asian American, Native Hawaiian and Pacific Islander adults less likely to receive mental health services despite growing need","Link":"https://www.heart.org/en/news/2022/05/25/asian-american-native-hawaiian-and-pacific-islander-adults-less-likely-to-receive-mental-health"},{"Title":"New study looks at heart defect risk in children of people with heart defects","Link":"https://www.heart.org/en/news/2022/05/24/new-study-looks-at-heart-defect-risk-in-children-of-people-with-heart-defects"},{"Title":"Family's heart disease history inspired her fitness – and got her to the base of Mount Everest","Link":"https://www.heart.org/en/news/2022/05/24/familys-heart-disease-history-inspired-her-fitness-and-got-her-to-the-base-of-mount-everest"},{"Title":"She was a prime candidate for a heart attack, if only she'd realized it","Link":"https://www.heart.org/en/news/2022/05/20/she-was-a-prime-candidate-for-a-heart-attack-if-only-shed-realized-it"},{"Title":"Falls can be a serious, poorly understood threat to people with heart disease","Link":"https://www.heart.org/en/news/2022/05/19/falls-can-be-a-serious-poorly-understood-threat-to-people-with-heart-disease"},{"Title":"Rate of high blood pressure disorders in pregnancy doubled in 12 years","Link":"https://www.heart.org/en/news/2022/05/18/rate-of-high-blood-pressure-disorders-in-pregnancy-doubled-in-12-years"},{"Title":"At 23 days old, he had open-heart surgery","Link":"https://www.heart.org/en/news/2022/05/17/at-23-days-old-he-had-open-heart-surgery"},{"Title":"Updated guidelines rethink care for people with bleeding stroke","Link":"https://www.heart.org/en/news/2022/05/17/updated-guidelines-rethink-care-for-people-with-bleeding-stroke"},{"Title":"Stroke hospitalizations rising among younger adults, but deaths falling","Link":"https://www.heart.org/en/news/2022/05/16/stroke-hospitalizations-rising-among-younger-adults-but-deaths-falling"},{"Title":"Improved fitness gave man chance to walk daughter down the aisle after heart attack","Link":"https://www.heart.org/en/news/2022/05/13/improved-fitness-gave-man-chance-to-walk-daughter-down-the-aisle-after-heart-attack"},{"Title":"College athletes rarely develop heart problems one year after having COVID-19","Link":"https://www.heart.org/en/news/2022/05/12/college-athletes-rarely-develop-heart-problems-one-year-after-having-covid19"},{"Title":"Theater director has a stroke the day after a crushing fall","Link":"https://www.heart.org/en/news/2022/05/10/theater-director-has-a-stroke-the-day-after-a-crushing-fall"},{"Title":"Report calls out gaps in women's heart disease research, care","Link":"https://www.heart.org/en/news/2022/05/09/report-calls-out-gaps-in-womens-heart-disease-research-care"},{"Title":"She's been a nurse for 50 years; the last 30, she's also been a heart patient","Link":"https://www.heart.org/en/news/2022/05/06/shes-been-a-nurse-for-50-years-the-last-30-shes-also-been-a-heart-patient"},{"Title":"Smoking both traditional and e-cigarettes may carry same heart risks as cigarettes alone","Link":"https://www.heart.org/en/news/2022/05/06/smoking-both-traditional-and-e-cigarettes-may-carry-same-heart-risks-as-cigarettes-alone"},{"Title":"The healing power of music for stroke survivors","Link":"https://www.heart.org/en/news/2022/05/04/the-healing-power-of-music-for-stroke-survivors"}]

class RawContent {
  RawContent({
    List<Newsfeed>? newsfeed,
  }) {
    _newsfeed = newsfeed;
  }

  RawContent.fromJson(dynamic json) {
    if (json['Newsfeed'] != null) {
      _newsfeed = [];
      json['Newsfeed'].forEach((v) {
        _newsfeed?.add(Newsfeed.fromJson(v));
      });
    }
  }

  List<Newsfeed>? _newsfeed;

  List<Newsfeed>? get newsfeed => _newsfeed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_newsfeed != null) {
      map['Newsfeed'] = _newsfeed?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Title : "Kitchen magnet with list of heart attack symptoms convinced him to go to the hospital"
/// Link : "https://www.heart.org/en/news/2022/06/17/kitchen-magnet-with-list-of-heart-attack-symptoms-convinced-him-to-go-to-the-hospital"

class Newsfeed {
  Newsfeed({
    String? title,
    String? link,
  }) {
    _title = title;
    _link = link;
  }

  Newsfeed.fromJson(dynamic json) {
    _title = json['Title'];
    _link = json['Link'];
  }

  String? _title;
  String? _link;

  String? get title => _title;

  String? get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = _title;
    map['Link'] = _link;
    return map;
  }
}