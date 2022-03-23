class UserTaskResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  UserTaskResponse({this.status, this.message, this.httpCode, this.data});

  UserTaskResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  UserTasks userTasks;

  Data({this.userTasks});

  Data.fromJson(Map<String, dynamic> json) {
    userTasks = json['UserTasks'] != null
        ? UserTasks.fromJson(json['UserTasks'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userTasks != null) {
      data['UserTasks'] = userTasks.toJson();
    }
    return data;
  }
}

class UserTasks {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  UserTasks(
      {this.totalCount,
      this.retrievedCount,
      this.pageIndex,
      this.itemsPerPage,
      this.order,
      this.orderedBy,
      this.items});

  UserTasks.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String displayId;
  String userId;
  String task;
  String description;
  String category;
  String actionType;
  String actionId;
  String scheduledStartTime;
  String scheduledEndTime;
  String status;
  bool started;
  String startedAt;
  bool finished;
  String finishedAt;
  bool cancelled;
  String cancelledAt;
  String cancellationReason;
  bool isRecurrent;
  String recurrenceScheduleId;
  Action action;

  Items(
      {this.id,
      this.displayId,
      this.userId,
      this.task,
      this.description,
      this.category,
      this.actionType,
      this.actionId,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.status,
      this.started,
      this.startedAt,
      this.finished,
      this.finishedAt,
      this.cancelled,
      this.cancelledAt,
      this.cancellationReason,
      this.isRecurrent,
      this.recurrenceScheduleId,
      this.action});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['DisplayId'];
    userId = json['UserId'];
    task = json['Task'];
    description = json['Description'];
    category = json['Category'];
    actionType = json['ActionType'];
    actionId = json['ActionId'];
    scheduledStartTime = json['ScheduledStartTime'];
    scheduledEndTime = json['ScheduledEndTime'];
    status = json['Status'];
    started = json['Started'];
    startedAt = json['StartedAt'];
    finished = json['Finished'];
    finishedAt = json['FinishedAt'];
    cancelled = json['Cancelled'];
    cancelledAt = json['CancelledAt'];
    cancellationReason = json['CancellationReason'];
    isRecurrent = json['IsRecurrent'];
    recurrenceScheduleId = json['RecurrenceScheduleId'];
    action = json['Action'] != null ? Action.fromJson(json['Action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['DisplayId'] = displayId;
    data['UserId'] = userId;
    data['Task'] = task;
    data['Description'] = description;
    data['Category'] = category;
    data['ActionType'] = actionType;
    data['ActionId'] = actionId;
    data['ScheduledStartTime'] = scheduledStartTime;
    data['ScheduledEndTime'] = scheduledEndTime;
    data['Status'] = status;
    data['Started'] = started;
    data['StartedAt'] = startedAt;
    data['Finished'] = finished;
    data['FinishedAt'] = finishedAt;
    data['Cancelled'] = cancelled;
    data['CancelledAt'] = cancelledAt;
    data['CancellationReason'] = cancellationReason;
    data['IsRecurrent'] = isRecurrent;
    data['RecurrenceScheduleId'] = recurrenceScheduleId;
    if (action != null) {
      data['Action'] = action.toJson();
    }
    return data;
  }
}

class Action {
  String id;
  String ehrId;
  String patientUserId;
  String medicationId;
  String drugName;
  String drugId;
  int dose;
  String details;
  String timeScheduleStart;
  String timeScheduleEnd;
  bool isTaken;
  String takenAt;
  bool isMissed;
  bool isCancelled;
  String cancelledOn;
  String note;
  String status;

  Action(
      {this.id,
      this.ehrId,
      this.patientUserId,
      this.medicationId,
      this.drugName,
      this.drugId,
      this.dose,
      this.details,
      this.timeScheduleStart,
      this.timeScheduleEnd,
      this.isTaken,
      this.takenAt,
      this.isMissed,
      this.isCancelled,
      this.cancelledOn,
      this.note,
      this.status});

  Action.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ehrId = json['EhrId'];
    patientUserId = json['PatientUserId'];
    medicationId = json['MedicationId'];
    drugName = json['DrugName'];
    drugId = json['DrugId'];
    dose = json['Dose'];
    details = json['Details'];
    timeScheduleStart = json['TimeScheduleStart'];
    timeScheduleEnd = json['TimeScheduleEnd'];
    isTaken = json['IsTaken'];
    takenAt = json['TakenAt'];
    isMissed = json['IsMissed'];
    isCancelled = json['IsCancelled'];
    cancelledOn = json['CancelledOn'];
    note = json['Note'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['EhrId'] = ehrId;
    data['PatientUserId'] = patientUserId;
    data['MedicationId'] = medicationId;
    data['DrugName'] = drugName;
    data['DrugId'] = drugId;
    data['Dose'] = dose;
    data['Details'] = details;
    data['TimeScheduleStart'] = timeScheduleStart;
    data['TimeScheduleEnd'] = timeScheduleEnd;
    data['IsTaken'] = isTaken;
    data['TakenAt'] = takenAt;
    data['IsMissed'] = isMissed;
    data['IsCancelled'] = isCancelled;
    data['CancelledOn'] = cancelledOn;
    data['Note'] = note;
    data['Status'] = status;
    return data;
  }
}
