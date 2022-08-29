/// Status : "success"
/// Message : "Total 1 lab records retrieved successfully!"
/// HttpCode : 200
/// Data : {"LabRecordRecords":{"TotalCount":1,"RetrievedCount":1,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"3fd930b7-188e-4611-a77b-5ddd919d596d","EhrId":null,"PatientUserId":"d4f6a394-5f68-409f-9246-7a6e9a15e21e","TypeId":"e7fb3a01-cae5-4101-8249-2e3fcc2621a4","TypeName":"Cholesterol","DisplayName":"Total Cholesterol","PrimaryValue":223,"SecondaryValue":null,"Unit":"mg/dl","ReportId":null,"OrderId":null,"RecordedAt":"2022-08-29T09:40:47.000Z"}]}}

class Test {
  Test({
      String? status, 
      String? message, 
      num? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  Test.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _httpCode = json['HttpCode'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }
  String? _status;
  String? _message;
  num? _httpCode;
  Data? _data;
Test copyWith({  String? status,
  String? message,
  num? httpCode,
  Data? data,
}) => Test(  status: status ?? _status,
  message: message ?? _message,
  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
);
  String? get status => _status;
  String? get message => _message;
  num? get httpCode => _httpCode;
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

/// LabRecordRecords : {"TotalCount":1,"RetrievedCount":1,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"3fd930b7-188e-4611-a77b-5ddd919d596d","EhrId":null,"PatientUserId":"d4f6a394-5f68-409f-9246-7a6e9a15e21e","TypeId":"e7fb3a01-cae5-4101-8249-2e3fcc2621a4","TypeName":"Cholesterol","DisplayName":"Total Cholesterol","PrimaryValue":223,"SecondaryValue":null,"Unit":"mg/dl","ReportId":null,"OrderId":null,"RecordedAt":"2022-08-29T09:40:47.000Z"}]}

class Data {
  Data({
      LabRecordRecords? labRecordRecords,}){
    _labRecordRecords = labRecordRecords;
}

  Data.fromJson(dynamic json) {
    _labRecordRecords = json['LabRecordRecords'] != null ? LabRecordRecords.fromJson(json['LabRecordRecords']) : null;
  }
  LabRecordRecords? _labRecordRecords;
Data copyWith({  LabRecordRecords? labRecordRecords,
}) => Data(  labRecordRecords: labRecordRecords ?? _labRecordRecords,
);
  LabRecordRecords? get labRecordRecords => _labRecordRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_labRecordRecords != null) {
      map['LabRecordRecords'] = _labRecordRecords?.toJson();
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
/// Items : [{"id":"3fd930b7-188e-4611-a77b-5ddd919d596d","EhrId":null,"PatientUserId":"d4f6a394-5f68-409f-9246-7a6e9a15e21e","TypeId":"e7fb3a01-cae5-4101-8249-2e3fcc2621a4","TypeName":"Cholesterol","DisplayName":"Total Cholesterol","PrimaryValue":223,"SecondaryValue":null,"Unit":"mg/dl","ReportId":null,"OrderId":null,"RecordedAt":"2022-08-29T09:40:47.000Z"}]

class LabRecordRecords {
  LabRecordRecords({
      num? totalCount, 
      num? retrievedCount, 
      num? pageIndex, 
      num? itemsPerPage, 
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

  LabRecordRecords.fromJson(dynamic json) {
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
  num? _totalCount;
  num? _retrievedCount;
  num? _pageIndex;
  num? _itemsPerPage;
  String? _order;
  String? _orderedBy;
  List<Items>? _items;
LabRecordRecords copyWith({  num? totalCount,
  num? retrievedCount,
  num? pageIndex,
  num? itemsPerPage,
  String? order,
  String? orderedBy,
  List<Items>? items,
}) => LabRecordRecords(  totalCount: totalCount ?? _totalCount,
  retrievedCount: retrievedCount ?? _retrievedCount,
  pageIndex: pageIndex ?? _pageIndex,
  itemsPerPage: itemsPerPage ?? _itemsPerPage,
  order: order ?? _order,
  orderedBy: orderedBy ?? _orderedBy,
  items: items ?? _items,
);
  num? get totalCount => _totalCount;
  num? get retrievedCount => _retrievedCount;
  num? get pageIndex => _pageIndex;
  num? get itemsPerPage => _itemsPerPage;
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

/// id : "3fd930b7-188e-4611-a77b-5ddd919d596d"
/// EhrId : null
/// PatientUserId : "d4f6a394-5f68-409f-9246-7a6e9a15e21e"
/// TypeId : "e7fb3a01-cae5-4101-8249-2e3fcc2621a4"
/// TypeName : "Cholesterol"
/// DisplayName : "Total Cholesterol"
/// PrimaryValue : 223
/// SecondaryValue : null
/// Unit : "mg/dl"
/// ReportId : null
/// OrderId : null
/// RecordedAt : "2022-08-29T09:40:47.000Z"

class Items {
  Items({
      String? id, 
      dynamic ehrId, 
      String? patientUserId, 
      String? typeId, 
      String? typeName, 
      String? displayName, 
      num? primaryValue, 
      dynamic secondaryValue, 
      String? unit, 
      dynamic reportId, 
      dynamic orderId, 
      String? recordedAt,}){
    _id = id;
    _ehrId = ehrId;
    _patientUserId = patientUserId;
    _typeId = typeId;
    _typeName = typeName;
    _displayName = displayName;
    _primaryValue = primaryValue;
    _secondaryValue = secondaryValue;
    _unit = unit;
    _reportId = reportId;
    _orderId = orderId;
    _recordedAt = recordedAt;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _ehrId = json['EhrId'];
    _patientUserId = json['PatientUserId'];
    _typeId = json['TypeId'];
    _typeName = json['TypeName'];
    _displayName = json['DisplayName'];
    _primaryValue = json['PrimaryValue'];
    _secondaryValue = json['SecondaryValue'];
    _unit = json['Unit'];
    _reportId = json['ReportId'];
    _orderId = json['OrderId'];
    _recordedAt = json['RecordedAt'];
  }
  String? _id;
  dynamic _ehrId;
  String? _patientUserId;
  String? _typeId;
  String? _typeName;
  String? _displayName;
  num? _primaryValue;
  dynamic _secondaryValue;
  String? _unit;
  dynamic _reportId;
  dynamic _orderId;
  String? _recordedAt;
Items copyWith({  String? id,
  dynamic ehrId,
  String? patientUserId,
  String? typeId,
  String? typeName,
  String? displayName,
  num? primaryValue,
  dynamic secondaryValue,
  String? unit,
  dynamic reportId,
  dynamic orderId,
  String? recordedAt,
}) => Items(  id: id ?? _id,
  ehrId: ehrId ?? _ehrId,
  patientUserId: patientUserId ?? _patientUserId,
  typeId: typeId ?? _typeId,
  typeName: typeName ?? _typeName,
  displayName: displayName ?? _displayName,
  primaryValue: primaryValue ?? _primaryValue,
  secondaryValue: secondaryValue ?? _secondaryValue,
  unit: unit ?? _unit,
  reportId: reportId ?? _reportId,
  orderId: orderId ?? _orderId,
  recordedAt: recordedAt ?? _recordedAt,
);
  String? get id => _id;
  dynamic get ehrId => _ehrId;
  String? get patientUserId => _patientUserId;
  String? get typeId => _typeId;
  String? get typeName => _typeName;
  String? get displayName => _displayName;
  num? get primaryValue => _primaryValue;
  dynamic get secondaryValue => _secondaryValue;
  String? get unit => _unit;
  dynamic get reportId => _reportId;
  dynamic get orderId => _orderId;
  String? get recordedAt => _recordedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['EhrId'] = _ehrId;
    map['PatientUserId'] = _patientUserId;
    map['TypeId'] = _typeId;
    map['TypeName'] = _typeName;
    map['DisplayName'] = _displayName;
    map['PrimaryValue'] = _primaryValue;
    map['SecondaryValue'] = _secondaryValue;
    map['Unit'] = _unit;
    map['ReportId'] = _reportId;
    map['OrderId'] = _orderId;
    map['RecordedAt'] = _recordedAt;
    return map;
  }

}