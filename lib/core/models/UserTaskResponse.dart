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
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
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
        ? new UserTasks.fromJson(json['UserTasks'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userTasks != null) {
      data['UserTasks'] = this.userTasks.toJson();
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
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['RetrievedCount'] = this.retrievedCount;
    data['PageIndex'] = this.pageIndex;
    data['ItemsPerPage'] = this.itemsPerPage;
    data['Order'] = this.order;
    data['OrderedBy'] = this.orderedBy;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['DisplayId'] = this.displayId;
    data['UserId'] = this.userId;
    data['Task'] = this.task;
    data['Description'] = this.description;
    data['Category'] = this.category;
    data['ActionType'] = this.actionType;
    data['ActionId'] = this.actionId;
    data['ScheduledStartTime'] = this.scheduledStartTime;
    data['ScheduledEndTime'] = this.scheduledEndTime;
    data['Status'] = this.status;
    data['Started'] = this.started;
    data['StartedAt'] = this.startedAt;
    data['Finished'] = this.finished;
    data['FinishedAt'] = this.finishedAt;
    data['Cancelled'] = this.cancelled;
    data['CancelledAt'] = this.cancelledAt;
    data['CancellationReason'] = this.cancellationReason;
    data['IsRecurrent'] = this.isRecurrent;
    data['RecurrenceScheduleId'] = this.recurrenceScheduleId;
    return data;
  }
}
