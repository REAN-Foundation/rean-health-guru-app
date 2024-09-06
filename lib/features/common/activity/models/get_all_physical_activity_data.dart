/// Status : "success"
/// Message : "Total 8 Physical activity records retrieved successfully!"
/// HttpCode : 200
/// Data : {"PhysicalActivities":{"TotalCount":8,"RetrievedCount":8,"PageIndex":0,"ItemsPerPage":25,"Order":"ascending","OrderedBy":"Category","Items":[{"id":"c2cefee5-5f88-414f-a66f-0eabb224572d","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":14,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":null,"CreatedAt":"2024-09-05T07:21:17.000Z","UpdatedAt":"2024-09-05T07:21:17.000Z"},{"id":"0eceefa9-95c9-4439-93f2-782dab294735","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-20T14:38:07.000Z","UpdatedAt":"2023-06-20T14:38:07.000Z"},{"id":"3316841c-50e4-456c-a6c9-868fa6e4c23a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-19T17:05:11.000Z","UpdatedAt":"2023-06-19T17:05:11.000Z"},{"id":"44e4ec73-0a75-4d32-bf5f-f16352524a7a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-21T17:25:50.000Z","UpdatedAt":"2023-06-21T17:25:50.000Z"},{"id":"466432ad-37d7-4534-80a4-66abcd87bd34","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-23T15:54:09.000Z","UpdatedAt":"2023-06-23T15:54:09.000Z"},{"id":"48f154c9-8146-45bc-abaf-ebe4740618ba","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-24T10:30:09.000Z","UpdatedAt":"2023-06-24T10:30:09.000Z"},{"id":"b0f1c81a-2f6a-4731-a33d-eaf9fb1e23da","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-25T08:40:15.000Z","UpdatedAt":"2023-06-25T08:40:15.000Z"},{"id":"de1571b2-94e6-444a-8c15-5a3f562af5c9","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-22T16:56:49.000Z","UpdatedAt":"2023-06-22T16:56:49.000Z"}]}}

class GetAllPhysicalActivityData {
  GetAllPhysicalActivityData({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetAllPhysicalActivityData.fromJson(dynamic json) {
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

/// PhysicalActivities : {"TotalCount":8,"RetrievedCount":8,"PageIndex":0,"ItemsPerPage":25,"Order":"ascending","OrderedBy":"Category","Items":[{"id":"c2cefee5-5f88-414f-a66f-0eabb224572d","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":14,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":null,"CreatedAt":"2024-09-05T07:21:17.000Z","UpdatedAt":"2024-09-05T07:21:17.000Z"},{"id":"0eceefa9-95c9-4439-93f2-782dab294735","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-20T14:38:07.000Z","UpdatedAt":"2023-06-20T14:38:07.000Z"},{"id":"3316841c-50e4-456c-a6c9-868fa6e4c23a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-19T17:05:11.000Z","UpdatedAt":"2023-06-19T17:05:11.000Z"},{"id":"44e4ec73-0a75-4d32-bf5f-f16352524a7a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-21T17:25:50.000Z","UpdatedAt":"2023-06-21T17:25:50.000Z"},{"id":"466432ad-37d7-4534-80a4-66abcd87bd34","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-23T15:54:09.000Z","UpdatedAt":"2023-06-23T15:54:09.000Z"},{"id":"48f154c9-8146-45bc-abaf-ebe4740618ba","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-24T10:30:09.000Z","UpdatedAt":"2023-06-24T10:30:09.000Z"},{"id":"b0f1c81a-2f6a-4731-a33d-eaf9fb1e23da","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-25T08:40:15.000Z","UpdatedAt":"2023-06-25T08:40:15.000Z"},{"id":"de1571b2-94e6-444a-8c15-5a3f562af5c9","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-22T16:56:49.000Z","UpdatedAt":"2023-06-22T16:56:49.000Z"}]}

class Data {
  Data({
      PhysicalActivities? physicalActivities,}){
    _physicalActivities = physicalActivities;
}

  Data.fromJson(dynamic json) {
    _physicalActivities = json['PhysicalActivities'] != null ? PhysicalActivities.fromJson(json['PhysicalActivities']) : null;
  }
  PhysicalActivities? _physicalActivities;

  PhysicalActivities? get physicalActivities => _physicalActivities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_physicalActivities != null) {
      map['PhysicalActivities'] = _physicalActivities?.toJson();
    }
    return map;
  }

}

/// TotalCount : 8
/// RetrievedCount : 8
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "ascending"
/// OrderedBy : "Category"
/// Items : [{"id":"c2cefee5-5f88-414f-a66f-0eabb224572d","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":14,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":null,"CreatedAt":"2024-09-05T07:21:17.000Z","UpdatedAt":"2024-09-05T07:21:17.000Z"},{"id":"0eceefa9-95c9-4439-93f2-782dab294735","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-20T14:38:07.000Z","UpdatedAt":"2023-06-20T14:38:07.000Z"},{"id":"3316841c-50e4-456c-a6c9-868fa6e4c23a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-19T17:05:11.000Z","UpdatedAt":"2023-06-19T17:05:11.000Z"},{"id":"44e4ec73-0a75-4d32-bf5f-f16352524a7a","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-21T17:25:50.000Z","UpdatedAt":"2023-06-21T17:25:50.000Z"},{"id":"466432ad-37d7-4534-80a4-66abcd87bd34","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-23T15:54:09.000Z","UpdatedAt":"2023-06-23T15:54:09.000Z"},{"id":"48f154c9-8146-45bc-abaf-ebe4740618ba","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-24T10:30:09.000Z","UpdatedAt":"2023-06-24T10:30:09.000Z"},{"id":"b0f1c81a-2f6a-4731-a33d-eaf9fb1e23da","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-25T08:40:15.000Z","UpdatedAt":"2023-06-25T08:40:15.000Z"},{"id":"de1571b2-94e6-444a-8c15-5a3f562af5c9","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Exercise":null,"Description":null,"Category":"Other","Intensity":null,"CaloriesBurned":null,"StartTime":null,"EndTime":null,"TerraSummaryId":null,"Provider":null,"DurationInMin":null,"PhysicalActivityQuestion":"Did you add movement to your day today?","PhysicalActivityQuestionAns":true,"CreatedAt":"2023-06-22T16:56:49.000Z","UpdatedAt":"2023-06-22T16:56:49.000Z"}]

class PhysicalActivities {
  PhysicalActivities({
      int? totalCount, 
      int? retrievedCount, 
      int? pageIndex, 
      int? itemsPerPage, 
      String? order, 
      String? orderedBy, 
      List<Items>? items,}){
    _totalCount = totalCount;
    _retrievedCount = retrievedCount;
    _pageIndex = pageIndex;
    _itemsPerPage = itemsPerPage;
    _order = order;
    _orderedBy = orderedBy;
    _items = items;
}

  PhysicalActivities.fromJson(dynamic json) {
    _totalCount = json['TotalCount'];
    _retrievedCount = json['RetrievedCount'];
    _pageIndex = json['PageIndex'];
    _itemsPerPage = json['ItemsPerPage'];
    _order = json['Order'];
    _orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      _items = [];
      json['Items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  int? _totalCount;
  int? _retrievedCount;
  int? _pageIndex;
  int? _itemsPerPage;
  String? _order;
  String? _orderedBy;
  List<Items>? _items;

  int? get totalCount => _totalCount;
  int? get retrievedCount => _retrievedCount;
  int? get pageIndex => _pageIndex;
  int? get itemsPerPage => _itemsPerPage;
  String? get order => _order;
  String? get orderedBy => _orderedBy;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TotalCount'] = _totalCount;
    map['RetrievedCount'] = _retrievedCount;
    map['PageIndex'] = _pageIndex;
    map['ItemsPerPage'] = _itemsPerPage;
    map['Order'] = _order;
    map['OrderedBy'] = _orderedBy;
    if (_items != null) {
      map['Items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "c2cefee5-5f88-414f-a66f-0eabb224572d"
/// PatientUserId : "948f887c-2d21-4b6c-97c2-0b7c7d67a58a"
/// Exercise : null
/// Description : null
/// Category : ""
/// Intensity : null
/// CaloriesBurned : null
/// StartTime : null
/// EndTime : null
/// TerraSummaryId : null
/// Provider : null
/// DurationInMin : 14
/// PhysicalActivityQuestion : "Did you add movement to your day today?"
/// PhysicalActivityQuestionAns : null
/// CreatedAt : "2024-09-05T07:21:17.000Z"
/// UpdatedAt : "2024-09-05T07:21:17.000Z"

class Items {
  Items({
      String? id, 
      String? patientUserId, 
      dynamic exercise, 
      dynamic description, 
      String? category, 
      dynamic intensity, 
      dynamic caloriesBurned, 
      dynamic startTime, 
      dynamic endTime, 
      dynamic terraSummaryId, 
      dynamic provider, 
      int? durationInMin, 
      String? physicalActivityQuestion, 
      dynamic physicalActivityQuestionAns, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _patientUserId = patientUserId;
    _exercise = exercise;
    _description = description;
    _category = category;
    _intensity = intensity;
    _caloriesBurned = caloriesBurned;
    _startTime = startTime;
    _endTime = endTime;
    _terraSummaryId = terraSummaryId;
    _provider = provider;
    _durationInMin = durationInMin;
    _physicalActivityQuestion = physicalActivityQuestion;
    _physicalActivityQuestionAns = physicalActivityQuestionAns;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _exercise = json['Exercise'];
    _description = json['Description'];
    _category = json['Category'];
    _intensity = json['Intensity'];
    _caloriesBurned = json['CaloriesBurned'];
    _startTime = json['StartTime'];
    _endTime = json['EndTime'];
    _terraSummaryId = json['TerraSummaryId'];
    _provider = json['Provider'];
    _durationInMin = json['DurationInMin'];
    _physicalActivityQuestion = json['PhysicalActivityQuestion'];
    _physicalActivityQuestionAns = json['PhysicalActivityQuestionAns'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
  }
  String? _id;
  String? _patientUserId;
  dynamic _exercise;
  dynamic _description;
  String? _category;
  dynamic _intensity;
  dynamic _caloriesBurned;
  dynamic _startTime;
  dynamic _endTime;
  dynamic _terraSummaryId;
  dynamic _provider;
  int? _durationInMin;
  String? _physicalActivityQuestion;
  dynamic _physicalActivityQuestionAns;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  dynamic get exercise => _exercise;
  dynamic get description => _description;
  String? get category => _category;
  dynamic get intensity => _intensity;
  dynamic get caloriesBurned => _caloriesBurned;
  dynamic get startTime => _startTime;
  dynamic get endTime => _endTime;
  dynamic get terraSummaryId => _terraSummaryId;
  dynamic get provider => _provider;
  int? get durationInMin => _durationInMin;
  String? get physicalActivityQuestion => _physicalActivityQuestion;
  dynamic get physicalActivityQuestionAns => _physicalActivityQuestionAns;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['Exercise'] = _exercise;
    map['Description'] = _description;
    map['Category'] = _category;
    map['Intensity'] = _intensity;
    map['CaloriesBurned'] = _caloriesBurned;
    map['StartTime'] = _startTime;
    map['EndTime'] = _endTime;
    map['TerraSummaryId'] = _terraSummaryId;
    map['Provider'] = _provider;
    map['DurationInMin'] = _durationInMin;
    map['PhysicalActivityQuestion'] = _physicalActivityQuestion;
    map['PhysicalActivityQuestionAns'] = _physicalActivityQuestionAns;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    return map;
  }

}