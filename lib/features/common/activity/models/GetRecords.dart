class GetRecords {
  GetRecords({
      String? status, 
      String? message,
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  GetRecords.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }
  String? _status;
  String? _message;
  Data? _data;


  String? get status => _status;
  String? get message => _message;
  Data? get data => _data;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    Records? sleepRecords,
    Records? stepRecords,}){
    _sleepRecords = sleepRecords;
    _stepRecords = stepRecords;
}

  Data.fromJson(dynamic json) {
    _sleepRecords = json['SleepRecords'] != null ? Records.fromJson(json['SleepRecords']) : null;
    _stepRecords = json['StepCountRecords'] != null ? Records.fromJson(json['StepCountRecords']) : null;
  }
  Records? _sleepRecords;
  Records? _stepRecords;

  Records? get sleepRecords => _sleepRecords;
  Records? get stepRecords => _stepRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sleepRecords != null) {
      map['SleepRecords'] = _sleepRecords?.toJson();
    }
    if (_stepRecords != null) {
      map['StepCountRecords'] = _stepRecords?.toJson();
    }
    return map;
  }

}

class Records {
  Records({
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

  Records.fromJson(dynamic json) {
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

class Items {
  Items({
      String? id, 
      String? patientUserId, 
      String? unit, 
      int? sleepDuration,
      dynamic stepCount,
      String? recordDate,}){
    _id = id;
    _patientUserId = patientUserId;
    _unit = unit;
    _sleepDuration = sleepDuration;
    _stepCount = stepCount;
    _recordDate = recordDate;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _unit = json['Unit'];
    _sleepDuration = json['SleepDuration'];
    _stepCount = json['StepCount'];
    _recordDate = json['RecordDate'];
  }
  String? _id;
  String? _patientUserId;
  String? _unit;
  int? _sleepDuration;
  dynamic _stepCount;
  String? _recordDate;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  String? get unit => _unit;
  int? get sleepDuration => _sleepDuration;
  dynamic get stepCount => _stepCount;
  String? get recordDate => _recordDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['Unit'] = _unit;
    map['SleepDuration'] = _sleepDuration;
    map['StepCount'] = _stepCount;
    map['RecordDate'] = _recordDate;
    return map;
  }
}