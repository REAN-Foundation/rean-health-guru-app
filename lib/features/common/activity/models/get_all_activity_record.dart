/// Status : "success"
/// Message : "Total 1 Step Count records retrieved successfully!"
/// HttpCode : 200
/// Data : {"StepCountRecords":{"TotalCount":1,"RetrievedCount":1,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"34df1bc1-068b-4b5f-8d48-4ee4cbf5a6cd","PatientUserId":"596133ef-dc70-462b-82aa-c7a8a70d94ab","TerraSummaryId":null,"Provider":null,"StepCount":500,"Unit":"","RecordDate":"2024-09-04T00:00:00.000Z"}]}}

class GetAllActivityRecord {
  GetAllActivityRecord({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetAllActivityRecord.fromJson(dynamic json) {
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

/// StepCountRecords : {"TotalCount":1,"RetrievedCount":1,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"34df1bc1-068b-4b5f-8d48-4ee4cbf5a6cd","PatientUserId":"596133ef-dc70-462b-82aa-c7a8a70d94ab","TerraSummaryId":null,"Provider":null,"StepCount":500,"Unit":"","RecordDate":"2024-09-04T00:00:00.000Z"}]}

class Data {
  Data({
    StandRecords? standRecords,}){
    _standRecords = standRecords;
}

  Data.fromJson(dynamic json) {
    _standRecords = json['StandRecords'] != null ? StandRecords.fromJson(json['StandRecords']) : null;
  }
  StandRecords? _standRecords;

  StandRecords? get standRecords => _standRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_standRecords != null) {
      map['StandRecords'] = _standRecords?.toJson();
    }
    return map;
  }

}

/// TotalCount : 1
/// RetrievedCount : 1
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "descending"
/// OrderedBy : "CreatedAt"
/// Items : [{"id":"34df1bc1-068b-4b5f-8d48-4ee4cbf5a6cd","PatientUserId":"596133ef-dc70-462b-82aa-c7a8a70d94ab","TerraSummaryId":null,"Provider":null,"StepCount":500,"Unit":"","RecordDate":"2024-09-04T00:00:00.000Z"}]

class StandRecords {
  StandRecords({
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

  StandRecords.fromJson(dynamic json) {
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

/// id : "34df1bc1-068b-4b5f-8d48-4ee4cbf5a6cd"
/// PatientUserId : "596133ef-dc70-462b-82aa-c7a8a70d94ab"
/// TerraSummaryId : null
/// Provider : null
/// StepCount : 500
/// Unit : ""
/// RecordDate : "2024-09-04T00:00:00.000Z"

class Items {
  Items({
      String? id, 
      String? patientUserId, 
      dynamic terraSummaryId, 
      dynamic provider, 
      int? stepCount,
      int? stand,
      int? durationInMin,
      String? unit, 
      String? recordDate,}){
    _id = id;
    _patientUserId = patientUserId;
    _terraSummaryId = terraSummaryId;
    _provider = provider;
    _stepCount = stepCount;
    _stand = stand;
    _durationInMin = durationInMin;
    _unit = unit;
    _recordDate = recordDate;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _terraSummaryId = json['TerraSummaryId'];
    _provider = json['Provider'];
    _stepCount = json['StepCount'];
    _stand = json['Stand'];
    _durationInMin = json['DurationInMin'];
    _unit = json['Unit'];
    _recordDate = json['RecordDate'];
  }
  String? _id;
  String? _patientUserId;
  dynamic _terraSummaryId;
  dynamic _provider;
  int? _stepCount;
  int? _stand;
  int? _durationInMin;
  String? _unit;
  String? _recordDate;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  dynamic get terraSummaryId => _terraSummaryId;
  dynamic get provider => _provider;
  int? get stepCount => _stepCount;
  int? get stand => _stand;
  int? get durationInMin => _durationInMin;
  String? get unit => _unit;
  String? get recordDate => _recordDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['TerraSummaryId'] = _terraSummaryId;
    map['Provider'] = _provider;
    map['StepCount'] = _stepCount;
    map['Stand'] = _stand;
    map['DurationInMin'] = _durationInMin;
    map['Unit'] = _unit;
    map['RecordDate'] = _recordDate;
    return map;
  }

}