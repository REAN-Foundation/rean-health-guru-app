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
    final Map<String, dynamic> data = <String, dynamic>{};
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
      this.recurrenceScheduleId});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
