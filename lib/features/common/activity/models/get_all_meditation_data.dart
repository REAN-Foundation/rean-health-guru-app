/// Status : "success"
/// Message : "Total 6 meditation records retrieved successfully!"
/// HttpCode : 200
/// Data : {"MeditationRecords":{"TotalCount":6,"RetrievedCount":6,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"6df67d35-a215-4859-9754-db1f04998150","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:35.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:35.000Z","UpdatedAt":"2024-09-05T15:16:35.000Z"},{"id":"772eb29c-e3c5-4863-9428-501b6e779115","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:15.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:15.000Z","UpdatedAt":"2024-09-05T15:16:15.000Z"},{"id":"6247e467-103b-476f-8e11-ac7bc7cc4d87","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":2160,"StartTime":"2023-07-07T07:40:03.000Z","EndTime":null,"CreatedAt":"2023-07-07T07:40:03.000Z","UpdatedAt":"2023-07-07T07:40:03.000Z"},{"id":"6eb4f51d-ffd7-4115-85de-9f8f3c2f2562","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":1380,"StartTime":"2023-06-25T08:40:41.000Z","EndTime":null,"CreatedAt":"2023-06-25T08:40:41.000Z","UpdatedAt":"2023-06-25T08:40:41.000Z"},{"id":"6eb668b3-d2a3-4746-b07a-6707ba9de012","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":300,"StartTime":"2023-06-21T17:26:40.000Z","EndTime":null,"CreatedAt":"2023-06-21T17:26:40.000Z","UpdatedAt":"2023-06-21T17:26:40.000Z"},{"id":"659c760c-5fa2-41cd-8172-e521abdbe52e","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":12,"StartTime":"2023-06-20T14:38:51.000Z","EndTime":null,"CreatedAt":"2023-06-20T14:38:51.000Z","UpdatedAt":"2023-06-20T14:38:51.000Z"}]}}

class GetAllMeditationData {
  GetAllMeditationData({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetAllMeditationData.fromJson(dynamic json) {
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

/// MeditationRecords : {"TotalCount":6,"RetrievedCount":6,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"6df67d35-a215-4859-9754-db1f04998150","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:35.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:35.000Z","UpdatedAt":"2024-09-05T15:16:35.000Z"},{"id":"772eb29c-e3c5-4863-9428-501b6e779115","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:15.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:15.000Z","UpdatedAt":"2024-09-05T15:16:15.000Z"},{"id":"6247e467-103b-476f-8e11-ac7bc7cc4d87","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":2160,"StartTime":"2023-07-07T07:40:03.000Z","EndTime":null,"CreatedAt":"2023-07-07T07:40:03.000Z","UpdatedAt":"2023-07-07T07:40:03.000Z"},{"id":"6eb4f51d-ffd7-4115-85de-9f8f3c2f2562","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":1380,"StartTime":"2023-06-25T08:40:41.000Z","EndTime":null,"CreatedAt":"2023-06-25T08:40:41.000Z","UpdatedAt":"2023-06-25T08:40:41.000Z"},{"id":"6eb668b3-d2a3-4746-b07a-6707ba9de012","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":300,"StartTime":"2023-06-21T17:26:40.000Z","EndTime":null,"CreatedAt":"2023-06-21T17:26:40.000Z","UpdatedAt":"2023-06-21T17:26:40.000Z"},{"id":"659c760c-5fa2-41cd-8172-e521abdbe52e","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":12,"StartTime":"2023-06-20T14:38:51.000Z","EndTime":null,"CreatedAt":"2023-06-20T14:38:51.000Z","UpdatedAt":"2023-06-20T14:38:51.000Z"}]}

class Data {
  Data({
      MeditationRecords? meditationRecords,}){
    _meditationRecords = meditationRecords;
}

  Data.fromJson(dynamic json) {
    _meditationRecords = json['MeditationRecords'] != null ? MeditationRecords.fromJson(json['MeditationRecords']) : null;
  }
  MeditationRecords? _meditationRecords;

  MeditationRecords? get meditationRecords => _meditationRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_meditationRecords != null) {
      map['MeditationRecords'] = _meditationRecords?.toJson();
    }
    return map;
  }

}

/// TotalCount : 6
/// RetrievedCount : 6
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "descending"
/// OrderedBy : "CreatedAt"
/// Items : [{"id":"6df67d35-a215-4859-9754-db1f04998150","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:35.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:35.000Z","UpdatedAt":"2024-09-05T15:16:35.000Z"},{"id":"772eb29c-e3c5-4863-9428-501b6e779115","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":20,"StartTime":"2024-09-05T15:16:15.000Z","EndTime":null,"CreatedAt":"2024-09-05T15:16:15.000Z","UpdatedAt":"2024-09-05T15:16:15.000Z"},{"id":"6247e467-103b-476f-8e11-ac7bc7cc4d87","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":2160,"StartTime":"2023-07-07T07:40:03.000Z","EndTime":null,"CreatedAt":"2023-07-07T07:40:03.000Z","UpdatedAt":"2023-07-07T07:40:03.000Z"},{"id":"6eb4f51d-ffd7-4115-85de-9f8f3c2f2562","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":1380,"StartTime":"2023-06-25T08:40:41.000Z","EndTime":null,"CreatedAt":"2023-06-25T08:40:41.000Z","UpdatedAt":"2023-06-25T08:40:41.000Z"},{"id":"6eb668b3-d2a3-4746-b07a-6707ba9de012","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":300,"StartTime":"2023-06-21T17:26:40.000Z","EndTime":null,"CreatedAt":"2023-06-21T17:26:40.000Z","UpdatedAt":"2023-06-21T17:26:40.000Z"},{"id":"659c760c-5fa2-41cd-8172-e521abdbe52e","EhrId":null,"PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Meditation":null,"Description":"","Category":"Mindfulness","DurationInMins":12,"StartTime":"2023-06-20T14:38:51.000Z","EndTime":null,"CreatedAt":"2023-06-20T14:38:51.000Z","UpdatedAt":"2023-06-20T14:38:51.000Z"}]

class MeditationRecords {
  MeditationRecords({
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

  MeditationRecords.fromJson(dynamic json) {
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

/// id : "6df67d35-a215-4859-9754-db1f04998150"
/// EhrId : null
/// PatientUserId : "948f887c-2d21-4b6c-97c2-0b7c7d67a58a"
/// Meditation : null
/// Description : ""
/// Category : "Mindfulness"
/// DurationInMins : 20
/// StartTime : "2024-09-05T15:16:35.000Z"
/// EndTime : null
/// CreatedAt : "2024-09-05T15:16:35.000Z"
/// UpdatedAt : "2024-09-05T15:16:35.000Z"

class Items {
  Items({
      String? id, 
      dynamic ehrId, 
      String? patientUserId, 
      dynamic meditation, 
      String? description, 
      String? category, 
      int? durationInMins, 
      String? startTime, 
      dynamic endTime, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _ehrId = ehrId;
    _patientUserId = patientUserId;
    _meditation = meditation;
    _description = description;
    _category = category;
    _durationInMins = durationInMins;
    _startTime = startTime;
    _endTime = endTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _ehrId = json['EhrId'];
    _patientUserId = json['PatientUserId'];
    _meditation = json['Meditation'];
    _description = json['Description'];
    _category = json['Category'];
    _durationInMins = json['DurationInMins'];
    _startTime = json['StartTime'];
    _endTime = json['EndTime'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
  }
  String? _id;
  dynamic _ehrId;
  String? _patientUserId;
  dynamic _meditation;
  String? _description;
  String? _category;
  int? _durationInMins;
  String? _startTime;
  dynamic _endTime;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  dynamic get ehrId => _ehrId;
  String? get patientUserId => _patientUserId;
  dynamic get meditation => _meditation;
  String? get description => _description;
  String? get category => _category;
  int? get durationInMins => _durationInMins;
  String? get startTime => _startTime;
  dynamic get endTime => _endTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['EhrId'] = _ehrId;
    map['PatientUserId'] = _patientUserId;
    map['Meditation'] = _meditation;
    map['Description'] = _description;
    map['Category'] = _category;
    map['DurationInMins'] = _durationInMins;
    map['StartTime'] = _startTime;
    map['EndTime'] = _endTime;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    return map;
  }

}