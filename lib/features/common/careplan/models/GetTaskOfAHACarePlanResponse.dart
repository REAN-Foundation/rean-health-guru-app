class GetTaskOfAHACarePlanResponse {
  String? status;
  String? message;
  Data? data;

  GetTaskOfAHACarePlanResponse({this.status, this.message, this.data});

  GetTaskOfAHACarePlanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Task>? tasks;

  Data({this.tasks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      tasks = <Task>[];
      json['tasks'].forEach((v) {
        tasks!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tasks != null) {
      data['tasks'] = tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String? id;
  String? patientUserId;
  String? displayId;
  String? name;
  int? categoryId;
  String? categoryName;
  String? type;
  DateTime? scheduledStartTime;
  DateTime? scheduledEndTime;
  bool? started;
  String? startedAt;
  bool? finished;
  String? finishedAt;
  bool? taskIsSuccess;
  bool? cancelled;
  Details? details;

  Task(
      {this.id,
      this.patientUserId,
      this.displayId,
      this.name,
      this.categoryId,
      this.categoryName,
      this.type,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.started,
      this.startedAt,
      this.finished,
      this.finishedAt,
      this.taskIsSuccess,
      this.cancelled,
      this.details});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    displayId = json['DisplayId'];
    name = json['Name'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
    type = json['Type'];
    scheduledStartTime = DateTime.parse(json['ScheduledStartTime']);
    scheduledEndTime = DateTime.parse(json['ScheduledEndTime']);
    started = json['Started'];
    startedAt = json['StartedAt'];
    finished = json['Finished'];
    finishedAt = json['FinishedAt'];
    taskIsSuccess = json['TaskIsSuccess'];
    cancelled = json['Cancelled'];
    details =
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['DisplayId'] = displayId;
    data['Name'] = name;
    data['CategoryId'] = categoryId;
    data['CategoryName'] = categoryName;
    data['Type'] = type;
    data['ScheduledStartTime'] = scheduledStartTime!.toIso8601String();
    data['ScheduledEndTime'] = scheduledEndTime!.toIso8601String();
    data['Started'] = started;
    data['StartedAt'] = startedAt;
    data['Finished'] = finished;
    data['FinishedAt'] = finishedAt;
    data['TaskIsSuccess'] = taskIsSuccess;
    data['Cancelled'] = cancelled;
    if (details != null) {
      data['Details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  String? id;
  String? patientUserId;
  int? carePlanId;
  String? type;
  bool? isEducationalTask;
  String? mainTitle;
  String? subTitle;
  String? description;
  String? language;
  String? taskDate;
  int? weekNumber;
  int? weekDayNumber;
  int? sessionNumber;
  String? scheduledStartTime;
  String? scheduledEndTime;
  bool? started;
  String? startedAt;
  bool? finished;
  String? finishedAt;
  String? action;
  String? category;
  int? bloodGlucose;
  int? bloodPressureSystolic;
  int? bloodPressureDiastolic;
  int? weight;
  String? text;
  String? assetName;
  String? challengeText;
  String? challengeNotes;
  String? medicationId;
  String? drugOrderId;
  String? drugName;
  String? details;
  String? timeScheduleStart;
  String? timeScheduleEnd;
  String? takenAt;
  bool? isTaken;
  bool? isMissed;
  bool? isCancelled;
  DateTime? cancelledOn;
  String? note;
  String? status;
  String? dateCreated;
  String? dateUpdated;
  String? url;
  String? additionalInfo;
  ConcreteTask? concreteTask;
  String? businessUserName;
  String? businessNodeName;

  Details(
      {this.id,
      this.patientUserId,
      this.carePlanId,
      this.type,
      this.isEducationalTask,
      this.mainTitle,
      this.subTitle,
      this.description,
      this.language,
      this.taskDate,
      this.weekNumber,
      this.weekDayNumber,
      this.sessionNumber,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.started,
      this.startedAt,
      this.finished,
      this.finishedAt,
      this.action,
      this.category,
      this.bloodGlucose,
      this.bloodPressureSystolic,
      this.bloodPressureDiastolic,
      this.weight,
      this.text,
      this.assetName,
      this.challengeText,
      this.challengeNotes,
      this.medicationId,
      this.drugOrderId,
      this.drugName,
      this.details,
      this.timeScheduleStart,
      this.timeScheduleEnd,
      this.takenAt,
      this.isTaken,
      this.isMissed,
      this.isCancelled,
      this.cancelledOn,
      this.note,
      this.status,
      this.dateCreated,
      this.dateUpdated,
      this.url,
      this.additionalInfo,
      this.concreteTask,
      this.businessNodeName,
      this.businessUserName});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    carePlanId = json['CarePlanId'];
    type = json['Type'];
    isEducationalTask = json['IsEducationalTask'];
    mainTitle = json['MainTitle'];
    subTitle = json['SubTitle'];
    description = json['Description'];
    language = json['Language'];
    taskDate = json['TaskDate'];
    weekNumber = json['WeekNumber'];
    weekDayNumber = json['WeekDayNumber'];
    sessionNumber = json['SessionNumber'];
    scheduledStartTime = json['ScheduledStartTime'];
    scheduledEndTime = json['ScheduledEndTime'];
    started = json['Started'];
    startedAt = json['StartedAt'];
    finished = json['Finished'];
    finishedAt = json['FinishedAt'];
    action = json['Action'];
    category = json['Category'];
    bloodGlucose = json['BloodGlucose'];
    bloodPressureSystolic = json['BloodPressure_Systolic'];
    bloodPressureDiastolic = json['BloodPressure_Diastolic'];
    weight = json['Weight'];
    text = json['Text'];
    assetName = json['AssetName'];
    challengeText = json['ChallengeText'];
    challengeNotes = json['ChallengeNotes'];
    medicationId = json['MedicationId'];
    drugOrderId = json['DrugOrderId'];
    drugName = json['DrugName'];
    details = json['Details'];
    timeScheduleStart = json['TimeScheduleStart'];
    timeScheduleEnd = json['TimeScheduleEnd'];
    takenAt = json['TakenAt'];
    isTaken = json['IsTaken'];
    isMissed = json['IsMissed'];
    isCancelled = json['IsCancelled'];
    cancelledOn = json['CancelledOn'];
    note = json['Note'];
    status = json['Status'];
    dateCreated = json['DateCreated'];
    dateUpdated = json['DateUpdated'];
    url = json['Url'];
    additionalInfo = json['AdditionalInfo'];
    businessNodeName = json['business_node_name'];
    businessUserName = json['business_user_name'];
    concreteTask = json['ConcreteTask'] != null
        ? ConcreteTask.fromJson(json['ConcreteTask'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['CarePlanId'] = carePlanId;
    data['Type'] = type;
    data['IsEducationalTask'] = isEducationalTask;
    data['MainTitle'] = mainTitle;
    data['SubTitle'] = subTitle;
    data['Description'] = description;
    data['Language'] = language;
    data['TaskDate'] = taskDate;
    data['WeekNumber'] = weekNumber;
    data['WeekDayNumber'] = weekDayNumber;
    data['SessionNumber'] = sessionNumber;
    data['ScheduledStartTime'] = scheduledStartTime;
    data['ScheduledEndTime'] = scheduledEndTime;
    data['Started'] = started;
    data['StartedAt'] = startedAt;
    data['Finished'] = finished;
    data['FinishedAt'] = finishedAt;
    data['Action'] = action;
    data['Category'] = category;
    data['BloodGlucose'] = bloodGlucose;
    data['BloodPressure_Systolic'] = bloodPressureSystolic;
    data['BloodPressure_Diastolic'] = bloodPressureDiastolic;
    data['Weight'] = weight;
    data['Text'] = text;
    data['AssetName'] = assetName;
    data['ChallengeText'] = challengeText;
    data['ChallengeNotes'] = challengeNotes;
    data['MedicationId'] = medicationId;
    data['DrugOrderId'] = drugOrderId;
    data['DrugName'] = drugName;
    data['Details'] = details;
    data['TimeScheduleStart'] = timeScheduleStart;
    data['TimeScheduleEnd'] = timeScheduleEnd;
    data['TakenAt'] = takenAt;
    data['IsTaken'] = isTaken;
    data['IsMissed'] = isMissed;
    data['IsCancelled'] = isCancelled;
    data['CancelledOn'] = cancelledOn;
    data['Note'] = note;
    data['Status'] = status;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    data['Url'] = url;
    data['AdditionalInfo'] = additionalInfo;
    data['business_node_name'] = businessNodeName;
    data['business_user_name'] = businessUserName;
    if (concreteTask != null) {
      data['ConcreteTask'] = concreteTask!.toJson();
    }
    return data;
  }
}

class ConcreteTask {
  String? id;
  String? patientUserId;
  String? taskId;
  String? taskType;
  int? carePlanId;
  String? allyMRN;
  String? sessionId;
  String? assetID;
  String? assetName;
  String? text;
  String? mediaUrl;
  String? word;
  String? meaning;
  String? category;
  String? language;
  String? createdAt;
  String? updatedAt;

  ConcreteTask(
      {this.id,
      this.patientUserId,
      this.taskId,
      this.taskType,
      this.carePlanId,
      this.allyMRN,
      this.sessionId,
      this.assetID,
      this.assetName,
      this.text,
      this.mediaUrl,
      this.word,
      this.meaning,
      this.category,
      this.language,
      this.createdAt,
      this.updatedAt});

  ConcreteTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    taskId = json['TaskId'];
    taskType = json['TaskType'];
    carePlanId = json['CarePlanId'];
    allyMRN = json['AllyMRN'];
    sessionId = json['SessionId'];
    assetID = json['AssetID'];
    assetName = json['AssetName'];
    text = json['Text'];
    mediaUrl = json['MediaUrl'];
    word = json['Word'];
    meaning = json['Meaning'];
    category = json['Category'];
    language = json['Language'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['TaskId'] = taskId;
    data['TaskType'] = taskType;
    data['CarePlanId'] = carePlanId;
    data['AllyMRN'] = allyMRN;
    data['SessionId'] = sessionId;
    data['AssetID'] = assetID;
    data['AssetName'] = assetName;
    data['Text'] = text;
    data['MediaUrl'] = mediaUrl;
    data['Word'] = word;
    data['Meaning'] = meaning;
    data['Category'] = category;
    data['Language'] = language;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
