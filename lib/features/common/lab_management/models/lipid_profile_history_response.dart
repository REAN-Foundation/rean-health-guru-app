/// Status : "success"
/// Message : "Total 3 blood cholesterol records retrieved successfully!"
/// HttpCode : 200
/// Data : {"BloodCholesterolRecords":{"TotalCount":3,"RetrievedCount":3,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"7b913d29-c822-4052-81f8-53bb13ae9dbb","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:42:27.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"},{"id":"ec6f904e-7a4d-4b8c-83e1-f16d3db43673","EhrId":null,"PatientUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:04:44.000Z","RecordedByUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd"},{"id":"3ff4b6af-e502-457b-a527-83114f93ad9c","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:02:54.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"}]}}

class LipidProfileHistoryResponse {
  LipidProfileHistoryResponse({
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

  LipidProfileHistoryResponse.fromJson(dynamic json) {
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

/// BloodCholesterolRecords : {"TotalCount":3,"RetrievedCount":3,"PageIndex":0,"ItemsPerPage":25,"Order":"descending","OrderedBy":"CreatedAt","Items":[{"id":"7b913d29-c822-4052-81f8-53bb13ae9dbb","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:42:27.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"},{"id":"ec6f904e-7a4d-4b8c-83e1-f16d3db43673","EhrId":null,"PatientUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:04:44.000Z","RecordedByUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd"},{"id":"3ff4b6af-e502-457b-a527-83114f93ad9c","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:02:54.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"}]}

class Data {
  Data({
    BloodCholesterolRecords? bloodCholesterolRecords,
  }) {
    _bloodCholesterolRecords = bloodCholesterolRecords;
  }

  Data.fromJson(dynamic json) {
    _bloodCholesterolRecords = json['BloodCholesterolRecords'] != null
        ? BloodCholesterolRecords.fromJson(json['BloodCholesterolRecords'])
        : null;
  }

  BloodCholesterolRecords? _bloodCholesterolRecords;

  BloodCholesterolRecords? get bloodCholesterolRecords =>
      _bloodCholesterolRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_bloodCholesterolRecords != null) {
      map['BloodCholesterolRecords'] = _bloodCholesterolRecords?.toJson();
    }
    return map;
  }
}

/// TotalCount : 3
/// RetrievedCount : 3
/// PageIndex : 0
/// ItemsPerPage : 25
/// Order : "descending"
/// OrderedBy : "CreatedAt"
/// Items : [{"id":"7b913d29-c822-4052-81f8-53bb13ae9dbb","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:42:27.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"},{"id":"ec6f904e-7a4d-4b8c-83e1-f16d3db43673","EhrId":null,"PatientUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:04:44.000Z","RecordedByUserId":"9f9ac031-64a7-44c2-90c1-4cbfea35d7fd"},{"id":"3ff4b6af-e502-457b-a527-83114f93ad9c","EhrId":null,"PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","TotalCholesterol":120,"HDL":150,"LDL":170,"TriglycerideLevel":7,"Ratio":2,"Unit":"mg/dl","RecordDate":"2022-07-14T07:02:54.000Z","RecordedByUserId":"5f9ece85-5322-495d-ae31-30c4402aae34"}]

class BloodCholesterolRecords {
  BloodCholesterolRecords({
    int? totalCount,
    int? retrievedCount,
    int? pageIndex,
    int? itemsPerPage,
    String? order,
    String? orderedBy,
    List<Items>? items,
  }) {
    _totalCount = totalCount;
    _retrievedCount = retrievedCount;
    _pageIndex = pageIndex;
    _itemsPerPage = itemsPerPage;
    _order = order;
    _orderedBy = orderedBy;
    _items = items;
  }

  BloodCholesterolRecords.fromJson(dynamic json) {
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

/// id : "7b913d29-c822-4052-81f8-53bb13ae9dbb"
/// EhrId : null
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// TotalCholesterol : 120
/// HDL : 150
/// LDL : 170
/// TriglycerideLevel : 7
/// Ratio : 2
/// Unit : "mg/dl"
/// RecordDate : "2022-07-14T07:42:27.000Z"
/// RecordedByUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"

class Items {
  Items({
    String? id,
    dynamic ehrId,
    String? patientUserId,
    dynamic totalCholesterol,
    dynamic hdl,
    dynamic ldl,
    dynamic triglycerideLevel,
    dynamic ratio,
    dynamic a1cLevel,
    String? unit,
    String? recordDate,
    String? recordedByUserId,
  }) {
    _id = id;
    _ehrId = ehrId;
    _patientUserId = patientUserId;
    _totalCholesterol = totalCholesterol;
    _hdl = hdl;
    _ldl = ldl;
    _triglycerideLevel = triglycerideLevel;
    _ratio = ratio;
    _a1cLevel = a1cLevel;
    _unit = unit;
    _recordDate = recordDate;
    _recordedByUserId = recordedByUserId;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _ehrId = json['EhrId'];
    _patientUserId = json['PatientUserId'];
    _totalCholesterol = json['TotalCholesterol'];
    _hdl = json['HDL'];
    _ldl = json['LDL'];
    _triglycerideLevel = json['TriglycerideLevel'];
    _ratio = json['Ratio'];
    _a1cLevel = json['A1CLevel'];
    _unit = json['Unit'];
    _recordDate = json['RecordDate'];
    _recordedByUserId = json['RecordedByUserId'];
  }

  String? _id;
  dynamic _ehrId;
  String? _patientUserId;
  dynamic _totalCholesterol;
  dynamic _hdl;
  dynamic _ldl;
  dynamic _triglycerideLevel;
  dynamic _ratio;
  dynamic _a1cLevel;
  String? _unit;
  String? _recordDate;
  String? _recordedByUserId;

  String? get id => _id;

  dynamic get ehrId => _ehrId;

  String? get patientUserId => _patientUserId;

  dynamic get totalCholesterol => _totalCholesterol;

  dynamic get hdl => _hdl;

  dynamic get ldl => _ldl;

  dynamic get triglycerideLevel => _triglycerideLevel;

  dynamic get ratio => _ratio;

  dynamic get a1cLevel => _a1cLevel;

  String? get unit => _unit;

  String? get recordDate => _recordDate;

  String? get recordedByUserId => _recordedByUserId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['EhrId'] = _ehrId;
    map['PatientUserId'] = _patientUserId;
    map['TotalCholesterol'] = _totalCholesterol;
    map['HDL'] = _hdl;
    map['LDL'] = _ldl;
    map['TriglycerideLevel'] = _triglycerideLevel;
    map['Ratio'] = _ratio;
    map['A1CLevel'] = _a1cLevel;
    map['Unit'] = _unit;
    map['RecordDate'] = _recordDate;
    map['RecordedByUserId'] = _recordedByUserId;
    return map;
  }
}
