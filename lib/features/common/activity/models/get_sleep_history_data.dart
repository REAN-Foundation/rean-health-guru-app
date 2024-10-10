/// Status : "success"
/// Message : "Total 6 sleep records retrieved successfully!"
/// HttpCode : 200
/// Data : {"SleepRecords":{"TotalCount":6,"RetrievedCount":6,"PageIndex":0,"ItemsPerPage":25,"Order":"ascending","OrderedBy":"RecordDate","Items":[{"id":"8d024f0e-ac28-49f8-b73f-7360ef451f41","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":10,"SleepMinutes":null,"RecordDate":"2023-06-19T00:00:00.000Z"},{"id":"dd12916f-8da9-49a2-8abf-162e70e40026","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-22T00:00:00.000Z"},{"id":"40bf6516-db10-4a56-aa22-aa48b97b735b","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-23T00:00:00.000Z"},{"id":"a64855ce-c564-4ecb-b40f-504819451404","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-24T00:00:00.000Z"},{"id":"ebcff25e-d7e0-4b81-aad7-8d7895dce323","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-25T00:00:00.000Z"},{"id":"addff340-cea5-4c26-adcf-af4146217f58","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-07-07T00:00:00.000Z"}]}}

class GetSleepHistoryData {
  GetSleepHistoryData({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetSleepHistoryData.fromJson(dynamic json) {
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

/// SleepRecords : {"TotalCount":6,"RetrievedCount":6,"PageIndex":0,"ItemsPerPage":25,"Order":"ascending","OrderedBy":"RecordDate","Items":[{"id":"8d024f0e-ac28-49f8-b73f-7360ef451f41","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":10,"SleepMinutes":null,"RecordDate":"2023-06-19T00:00:00.000Z"},{"id":"dd12916f-8da9-49a2-8abf-162e70e40026","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-22T00:00:00.000Z"},{"id":"40bf6516-db10-4a56-aa22-aa48b97b735b","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-23T00:00:00.000Z"},{"id":"a64855ce-c564-4ecb-b40f-504819451404","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-24T00:00:00.000Z"},{"id":"ebcff25e-d7e0-4b81-aad7-8d7895dce323","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-25T00:00:00.000Z"},{"id":"addff340-cea5-4c26-adcf-af4146217f58","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-07-07T00:00:00.000Z"}]}

class Data {
  Data({
      SleepRecords? sleepRecords,}){
    _sleepRecords = sleepRecords;
}

  Data.fromJson(dynamic json) {
    _sleepRecords = json['SleepRecords'] != null ? SleepRecords.fromJson(json['SleepRecords']) : null;
  }
  SleepRecords? _sleepRecords;

  SleepRecords? get sleepRecords => _sleepRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sleepRecords != null) {
      map['SleepRecords'] = _sleepRecords?.toJson();
    }
    return map;
  }

}

/// TotalCount : 6
/// RetrievedCount : 6
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "ascending"
/// OrderedBy : "RecordDate"
/// Items : [{"id":"8d024f0e-ac28-49f8-b73f-7360ef451f41","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":10,"SleepMinutes":null,"RecordDate":"2023-06-19T00:00:00.000Z"},{"id":"dd12916f-8da9-49a2-8abf-162e70e40026","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-22T00:00:00.000Z"},{"id":"40bf6516-db10-4a56-aa22-aa48b97b735b","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-23T00:00:00.000Z"},{"id":"a64855ce-c564-4ecb-b40f-504819451404","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":7,"SleepMinutes":null,"RecordDate":"2023-06-24T00:00:00.000Z"},{"id":"ebcff25e-d7e0-4b81-aad7-8d7895dce323","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-06-25T00:00:00.000Z"},{"id":"addff340-cea5-4c26-adcf-af4146217f58","PatientUserId":"948f887c-2d21-4b6c-97c2-0b7c7d67a58a","Unit":"Hrs","SleepDuration":8,"SleepMinutes":null,"RecordDate":"2023-07-07T00:00:00.000Z"}]

class SleepRecords {
  SleepRecords({
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

  SleepRecords.fromJson(dynamic json) {
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

/// id : "8d024f0e-ac28-49f8-b73f-7360ef451f41"
/// PatientUserId : "948f887c-2d21-4b6c-97c2-0b7c7d67a58a"
/// Unit : "Hrs"
/// SleepDuration : 10
/// SleepMinutes : null
/// RecordDate : "2023-06-19T00:00:00.000Z"

class Items {
  Items({
      String? id, 
      String? patientUserId, 
      String? unit, 
      int? sleepDuration, 
      dynamic sleepMinutes, 
      String? recordDate,}){
    _id = id;
    _patientUserId = patientUserId;
    _unit = unit;
    _sleepDuration = sleepDuration;
    _sleepMinutes = sleepMinutes;
    _recordDate = recordDate;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _unit = json['Unit'];
    _sleepDuration = json['SleepDuration'];
    _sleepMinutes = json['SleepMinutes'];
    _recordDate = json['RecordDate'];
  }
  String? _id;
  String? _patientUserId;
  String? _unit;
  int? _sleepDuration;
  dynamic _sleepMinutes;
  String? _recordDate;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  String? get unit => _unit;
  int? get sleepDuration => _sleepDuration;
  dynamic get sleepMinutes => _sleepMinutes;
  String? get recordDate => _recordDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['Unit'] = _unit;
    map['SleepDuration'] = _sleepDuration;
    map['SleepMinutes'] = _sleepMinutes;
    map['RecordDate'] = _recordDate;
    return map;
  }

}