/// Status : "success"
/// Message : "Total 2 reminder records retrieved successfully!"
/// HttpCode : 200
/// Data : {"Reminders":{"TotalCount":2,"RetrievedCount":2,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"da469945-bf01-46cd-b12b-1affca8df438","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"Daily Remainder working fine","ReminderType":"Repeat-Every-Day","WhenDate":null,"WhenTime":"16:30:00","StartDate":"2023-09-26T00:00:00.000Z","EndDate":"2023-09-27T00:00:00.000Z","EndAfterNRepetitions":1,"RepeatList":["Start"],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null},{"id":"96b2934f-9a66-4b77-8020-1ecf536f06b8","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"api is working fine","ReminderType":"OneTime","WhenDate":"2023-09-26","WhenTime":"16:27:00","StartDate":"2023-09-26T10:54:12.000Z","EndDate":null,"EndAfterNRepetitions":10,"RepeatList":[],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null}]}}

class GetMyAllRemainders {
  GetMyAllRemainder({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetMyAllRemainders.fromJson(dynamic json) {
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

/// Reminders : {"TotalCount":2,"RetrievedCount":2,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"da469945-bf01-46cd-b12b-1affca8df438","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"Daily Remainder working fine","ReminderType":"Repeat-Every-Day","WhenDate":null,"WhenTime":"16:30:00","StartDate":"2023-09-26T00:00:00.000Z","EndDate":"2023-09-27T00:00:00.000Z","EndAfterNRepetitions":1,"RepeatList":["Start"],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null},{"id":"96b2934f-9a66-4b77-8020-1ecf536f06b8","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"api is working fine","ReminderType":"OneTime","WhenDate":"2023-09-26","WhenTime":"16:27:00","StartDate":"2023-09-26T10:54:12.000Z","EndDate":null,"EndAfterNRepetitions":10,"RepeatList":[],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null}]}

class Data {
  Data({
      Reminders? reminders,}){
    _reminders = reminders;
}

  Data.fromJson(dynamic json) {
    _reminders = json['Reminders'] != null ? Reminders.fromJson(json['Reminders']) : null;
  }
  Reminders? _reminders;

  Reminders? get reminders => _reminders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_reminders != null) {
      map['Reminders'] = _reminders?.toJson();
    }
    return map;
  }

}

/// TotalCount : 2
/// RetrievedCount : 2
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "descending"
/// OrderedBy : "CreatedAt"
/// Items : [{"id":"da469945-bf01-46cd-b12b-1affca8df438","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"Daily Remainder working fine","ReminderType":"Repeat-Every-Day","WhenDate":null,"WhenTime":"16:30:00","StartDate":"2023-09-26T00:00:00.000Z","EndDate":"2023-09-27T00:00:00.000Z","EndAfterNRepetitions":1,"RepeatList":["Start"],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null},{"id":"96b2934f-9a66-4b77-8020-1ecf536f06b8","UserId":"775e3534-e4ad-4af5-84f1-8c74fa9abe69","Name":"api is working fine","ReminderType":"OneTime","WhenDate":"2023-09-26","WhenTime":"16:27:00","StartDate":"2023-09-26T10:54:12.000Z","EndDate":null,"EndAfterNRepetitions":10,"RepeatList":[],"RepeatAfterEvery":1,"RepeatAfterEveryNUnit":"Day","HookUrl":null}]

class Reminders {
  Reminders({
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

  Reminders.fromJson(dynamic json) {
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

/// id : "da469945-bf01-46cd-b12b-1affca8df438"
/// UserId : "775e3534-e4ad-4af5-84f1-8c74fa9abe69"
/// Name : "Daily Remainder working fine"
/// ReminderType : "Repeat-Every-Day"
/// WhenDate : null
/// WhenTime : "16:30:00"
/// StartDate : "2023-09-26T00:00:00.000Z"
/// EndDate : "2023-09-27T00:00:00.000Z"
/// EndAfterNRepetitions : 1
/// RepeatList : ["Start"]
/// RepeatAfterEvery : 1
/// RepeatAfterEveryNUnit : "Day"
/// HookUrl : null

class Items {
  Items({
      String? id, 
      String? userId, 
      String? name, 
      String? reminderType, 
      dynamic whenDate, 
      String? whenTime, 
      String? startDate, 
      String? endDate, 
      int? endAfterNRepetitions, 
      List<String>? repeatList, 
      int? repeatAfterEvery, 
      String? repeatAfterEveryNUnit, 
      dynamic hookUrl,}){
    _id = id;
    _userId = userId;
    _name = name;
    _reminderType = reminderType;
    _whenDate = whenDate;
    _whenTime = whenTime;
    _startDate = startDate;
    _endDate = endDate;
    _endAfterNRepetitions = endAfterNRepetitions;
    _repeatList = repeatList;
    _repeatAfterEvery = repeatAfterEvery;
    _repeatAfterEveryNUnit = repeatAfterEveryNUnit;
    _hookUrl = hookUrl;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['UserId'];
    _name = json['Name'];
    _reminderType = json['ReminderType'];
    _whenDate = json['WhenDate'];
    _whenTime = json['WhenTime'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _endAfterNRepetitions = json['EndAfterNRepetitions'];
    _repeatList = json['RepeatList'] != null ? json['RepeatList'].cast<String>() : [];
    _repeatAfterEvery = json['RepeatAfterEvery'];
    _repeatAfterEveryNUnit = json['RepeatAfterEveryNUnit'];
    _hookUrl = json['HookUrl'];
  }
  String? _id;
  String? _userId;
  String? _name;
  String? _reminderType;
  dynamic _whenDate;
  String? _whenTime;
  String? _startDate;
  String? _endDate;
  int? _endAfterNRepetitions;
  List<String>? _repeatList;
  int? _repeatAfterEvery;
  String? _repeatAfterEveryNUnit;
  dynamic _hookUrl;

  String? get id => _id;
  String? get userId => _userId;
  String? get name => _name;
  String? get reminderType => _reminderType;
  dynamic get whenDate => _whenDate;
  String? get whenTime => _whenTime;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  int? get endAfterNRepetitions => _endAfterNRepetitions;
  List<String>? get repeatList => _repeatList;
  int? get repeatAfterEvery => _repeatAfterEvery;
  String? get repeatAfterEveryNUnit => _repeatAfterEveryNUnit;
  dynamic get hookUrl => _hookUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UserId'] = _userId;
    map['Name'] = _name;
    map['ReminderType'] = _reminderType;
    map['WhenDate'] = _whenDate;
    map['WhenTime'] = _whenTime;
    map['StartDate'] = _startDate;
    map['EndDate'] = _endDate;
    map['EndAfterNRepetitions'] = _endAfterNRepetitions;
    map['RepeatList'] = _repeatList;
    map['RepeatAfterEvery'] = _repeatAfterEvery;
    map['RepeatAfterEveryNUnit'] = _repeatAfterEveryNUnit;
    map['HookUrl'] = _hookUrl;
    return map;
  }

}