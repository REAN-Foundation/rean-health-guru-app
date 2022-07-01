/// Status : "success"
/// Message : "Fetched priority types successfully!"
/// HttpCode : 201
/// Data : {"PriorityTypes":[{"id":"32af9823-134c-4537-826a-24c8b8c514f1","Type":"Blood Pressure","Tags":["HeartFailure"]},{"id":"4000522c-fbfa-49d6-843d-c5ad3db84484","Type":"Custom","Tags":["HeartFailure"]},{"id":"55d64eb5-0eab-4a9d-bb0b-25ad37d14d69","Type":"Medications","Tags":["HeartFailure"]},{"id":"560a930a-eae7-4b8d-b90e-b0451b611b8c","Type":"Nutrition","Tags":["HeartFailure"]},{"id":"6ba5939b-080e-4a59-bc11-30d4f7224690","Type":"Cholesterol","Tags":["HeartFailure"]},{"id":"70e5a1f3-1ccb-4b73-881e-74fccc36c121","Type":"Childhood Obesity","Tags":["HeartFailure"]},{"id":"8368489f-8b47-42c3-9eda-075b545f0189","Type":"Tobacco","Tags":["HeartFailure"]},{"id":"86bfd60a-dd07-486c-a9c2-3ccf0535fab4","Type":"Mental Health","Tags":["HeartFailure"]},{"id":"a6f97947-eaa0-44f1-93e4-06c72007f9ca","Type":"Glucose","Tags":["HeartFailure"]},{"id":"b37e720f-40a0-41cd-ae9b-793c094ad011","Type":"Weight","Tags":["HeartFailure"]},{"id":"b69a2e1b-da15-4e38-ab1b-dea3b3e6fde6","Type":"Lifes Simple 7","Tags":["HeartFailure"]},{"id":"ddb8ee28-50ff-48c8-a859-bdca95c67c7c","Type":"Physical Activity","Tags":["HeartFailure"]},{"id":"e8a9d30b-1b50-43a4-af16-e5a60eaabfcd","Type":"Professional","Tags":["HeartFailure"]}]}

class GetGoalPriorities {
  GetGoalPriorities({
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

  GetGoalPriorities.fromJson(dynamic json) {
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

/// PriorityTypes : [{"id":"32af9823-134c-4537-826a-24c8b8c514f1","Type":"Blood Pressure","Tags":["HeartFailure"]},{"id":"4000522c-fbfa-49d6-843d-c5ad3db84484","Type":"Custom","Tags":["HeartFailure"]},{"id":"55d64eb5-0eab-4a9d-bb0b-25ad37d14d69","Type":"Medications","Tags":["HeartFailure"]},{"id":"560a930a-eae7-4b8d-b90e-b0451b611b8c","Type":"Nutrition","Tags":["HeartFailure"]},{"id":"6ba5939b-080e-4a59-bc11-30d4f7224690","Type":"Cholesterol","Tags":["HeartFailure"]},{"id":"70e5a1f3-1ccb-4b73-881e-74fccc36c121","Type":"Childhood Obesity","Tags":["HeartFailure"]},{"id":"8368489f-8b47-42c3-9eda-075b545f0189","Type":"Tobacco","Tags":["HeartFailure"]},{"id":"86bfd60a-dd07-486c-a9c2-3ccf0535fab4","Type":"Mental Health","Tags":["HeartFailure"]},{"id":"a6f97947-eaa0-44f1-93e4-06c72007f9ca","Type":"Glucose","Tags":["HeartFailure"]},{"id":"b37e720f-40a0-41cd-ae9b-793c094ad011","Type":"Weight","Tags":["HeartFailure"]},{"id":"b69a2e1b-da15-4e38-ab1b-dea3b3e6fde6","Type":"Lifes Simple 7","Tags":["HeartFailure"]},{"id":"ddb8ee28-50ff-48c8-a859-bdca95c67c7c","Type":"Physical Activity","Tags":["HeartFailure"]},{"id":"e8a9d30b-1b50-43a4-af16-e5a60eaabfcd","Type":"Professional","Tags":["HeartFailure"]}]

class Data {
  Data({
    List<PriorityTypes>? priorityTypes,
  }) {
    _priorityTypes = priorityTypes;
  }

  Data.fromJson(dynamic json) {
    if (json['PriorityTypes'] != null) {
      _priorityTypes = [];
      json['PriorityTypes'].forEach((v) {
        _priorityTypes?.add(PriorityTypes.fromJson(v));
      });
    }
  }

  List<PriorityTypes>? _priorityTypes;

  List<PriorityTypes>? get priorityTypes => _priorityTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_priorityTypes != null) {
      map['PriorityTypes'] = _priorityTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "32af9823-134c-4537-826a-24c8b8c514f1"
/// Type : "Blood Pressure"
/// Tags : ["HeartFailure"]

class PriorityTypes {
  PriorityTypes({
    String? id,
    String? type,
    List<String>? tags,
  }) {
    _id = id;
    _type = type;
    _tags = tags;
  }

  PriorityTypes.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['Type'];
    _tags = json['Tags'] != null ? json['Tags'].cast<String>() : [];
  }

  String? _id;
  String? _type;
  List<String>? _tags;

  String? get id => _id;

  String? get type => _type;

  List<String>? get tags => _tags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Type'] = _type;
    map['Tags'] = _tags;
    return map;
  }
}
