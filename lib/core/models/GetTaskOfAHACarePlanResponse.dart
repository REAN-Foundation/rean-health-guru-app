class GetTaskOfAHACarePlanResponse {
  String status;
  String message;
  Data data;

  GetTaskOfAHACarePlanResponse({this.status, this.message, this.data});

  GetTaskOfAHACarePlanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Task> tasks;

  Data({this.tasks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tasks'] != null) {
      tasks = new List<Task>();
      json['tasks'].forEach((v) {
        tasks.add(new Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tasks != null) {
      data['tasks'] = this.tasks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String id;
  String patientUserId;
  String displayId;
  String name;
  int categoryId;
  String categoryName;
  String type;
  DateTime scheduledStartTime;
  DateTime scheduledEndTime;
  bool started;
  String startedAt;
  bool finished;
  String finishedAt;
  bool taskIsSuccess;
  bool cancelled;
  Details details;

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
    json['Details'] != null ? new Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['DisplayId'] = this.displayId;
    data['Name'] = this.name;
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['Type'] = this.type;
    data['ScheduledStartTime'] = this.scheduledStartTime.toIso8601String();
    data['ScheduledEndTime'] = this.scheduledEndTime.toIso8601String();
    data['Started'] = this.started;
    data['StartedAt'] = this.startedAt;
    data['Finished'] = this.finished;
    data['FinishedAt'] = this.finishedAt;
    data['TaskIsSuccess'] = this.taskIsSuccess;
    data['Cancelled'] = this.cancelled;
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    return data;
  }
}

class Details {
  String id;
  String patientUserId;
  int carePlanId;
  String type;
  bool isEducationalTask;
  String mainTitle;
  String subTitle;
  String description;
  String language;
  String taskDate;
  int weekNumber;
  int weekDayNumber;
  int sessionNumber;
  String scheduledStartTime;
  String scheduledEndTime;
  bool started;
  String startedAt;
  bool finished;
  String finishedAt;
  String action;
  String category;
  int bloodGlucose;
  int bloodPressureSystolic;
  int bloodPressureDiastolic;
  int weight;
  String text;
  String assetName;
  String challengeText;
  String challengeNotes;
  String medicationId;
  String drugOrderId;
  String drugName;
  String details;
  String timeScheduleStart;
  String timeScheduleEnd;
  String takenAt;
  bool isTaken;
  bool isMissed;
  bool isCancelled;
  DateTime cancelledOn;
  String note;
  String status;
  String dateCreated;
  String dateUpdated;
  String url;
  String additionalInfo;
  ConcreteTask concreteTask;
  String businessUserName;
  String businessNodeName;

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
        ? new ConcreteTask.fromJson(json['ConcreteTask'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['CarePlanId'] = this.carePlanId;
    data['Type'] = this.type;
    data['IsEducationalTask'] = this.isEducationalTask;
    data['MainTitle'] = this.mainTitle;
    data['SubTitle'] = this.subTitle;
    data['Description'] = this.description;
    data['Language'] = this.language;
    data['TaskDate'] = this.taskDate;
    data['WeekNumber'] = this.weekNumber;
    data['WeekDayNumber'] = this.weekDayNumber;
    data['SessionNumber'] = this.sessionNumber;
    data['ScheduledStartTime'] = this.scheduledStartTime;
    data['ScheduledEndTime'] = this.scheduledEndTime;
    data['Started'] = this.started;
    data['StartedAt'] = this.startedAt;
    data['Finished'] = this.finished;
    data['FinishedAt'] = this.finishedAt;
    data['Action'] = this.action;
    data['Category'] = this.category;
    data['BloodGlucose'] = this.bloodGlucose;
    data['BloodPressure_Systolic'] = this.bloodPressureSystolic;
    data['BloodPressure_Diastolic'] = this.bloodPressureDiastolic;
    data['Weight'] = this.weight;
    data['Text'] = this.text;
    data['AssetName'] = this.assetName;
    data['ChallengeText'] = this.challengeText;
    data['ChallengeNotes'] = this.challengeNotes;
    data['MedicationId'] = this.medicationId;
    data['DrugOrderId'] = this.drugOrderId;
    data['DrugName'] = this.drugName;
    data['Details'] = this.details;
    data['TimeScheduleStart'] = this.timeScheduleStart;
    data['TimeScheduleEnd'] = this.timeScheduleEnd;
    data['TakenAt'] = this.takenAt;
    data['IsTaken'] = this.isTaken;
    data['IsMissed'] = this.isMissed;
    data['IsCancelled'] = this.isCancelled;
    data['CancelledOn'] = this.cancelledOn;
    data['Note'] = this.note;
    data['Status'] = this.status;
    data['DateCreated'] = this.dateCreated;
    data['DateUpdated'] = this.dateUpdated;
    data['Url'] = this.url;
    data['AdditionalInfo'] = this.additionalInfo;
    data['business_node_name'] = this.businessNodeName;
    data['business_user_name'] = this.businessUserName;
    if (this.concreteTask != null) {
      data['ConcreteTask'] = this.concreteTask.toJson();
    }
    return data;
  }
}

class ConcreteTask {
  String id;
  String patientUserId;
  String taskId;
  String taskType;
  int carePlanId;
  String allyMRN;
  String sessionId;
  String assetID;
  String assetName;
  String text;
  String mediaUrl;
  String word;
  String meaning;
  String category;
  String language;
  String createdAt;
  String updatedAt;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['TaskId'] = this.taskId;
    data['TaskType'] = this.taskType;
    data['CarePlanId'] = this.carePlanId;
    data['AllyMRN'] = this.allyMRN;
    data['SessionId'] = this.sessionId;
    data['AssetID'] = this.assetID;
    data['AssetName'] = this.assetName;
    data['Text'] = this.text;
    data['MediaUrl'] = this.mediaUrl;
    data['Word'] = this.word;
    data['Meaning'] = this.meaning;
    data['Category'] = this.category;
    data['Language'] = this.language;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}