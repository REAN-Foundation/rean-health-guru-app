/// Status : "success"
/// Message : "Assessment next question retrieved successfully!"
/// HttpCode : 200
/// Data : {"Next":{"id":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","AssessmentTemplateId":"6d34c5bd-c273-4955-91b6-622bd4316a0a","ParentNodeId":"0042a9c8-fed9-4220-82b1-8df61c75aa81","AssessmentId":"f4a98473-e97a-4cdb-a3e0-5014e7eeaa9e","Sequence":6,"NodeType":"Question","Title":"I avoid eating prepackaged and processed foods?","Description":null,"ExpectedResponseType":"Single Choice Selection","Options":[{"id":"6c8b5f10-f1ed-4b60-a8ad-9ad53b50cf0b","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#1","ProviderGivenCode":"yes","Text":"Yes","ImageUrl":null,"Sequence":1},{"id":"36d7f839-ed8a-4c06-a8ae-17aa0d96950e","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#2","ProviderGivenCode":"no","Text":"No","ImageUrl":null,"Sequence":2}],"ProviderGivenCode":"q6"}}

class AssesmentResponse {
  AssesmentResponse({
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

  AssesmentResponse.fromJson(dynamic json) {
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

/// Next : {"id":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4","PatientUserId":"5f9ece85-5322-495d-ae31-30c4402aae34","AssessmentTemplateId":"6d34c5bd-c273-4955-91b6-622bd4316a0a","ParentNodeId":"0042a9c8-fed9-4220-82b1-8df61c75aa81","AssessmentId":"f4a98473-e97a-4cdb-a3e0-5014e7eeaa9e","Sequence":6,"NodeType":"Question","Title":"I avoid eating prepackaged and processed foods?","Description":null,"ExpectedResponseType":"Single Choice Selection","Options":[{"id":"6c8b5f10-f1ed-4b60-a8ad-9ad53b50cf0b","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#1","ProviderGivenCode":"yes","Text":"Yes","ImageUrl":null,"Sequence":1},{"id":"36d7f839-ed8a-4c06-a8ae-17aa0d96950e","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#2","ProviderGivenCode":"no","Text":"No","ImageUrl":null,"Sequence":2}],"ProviderGivenCode":"q6"}

class Data {
  Data({
    Next? next,
  }) {
    _next = next;
  }

  Data.fromJson(dynamic json) {
    _next = json['Next'] != null ? Next.fromJson(json['Next']) : null;
  }

  Next? _next;

  Next? get next => _next;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_next != null) {
      map['Next'] = _next?.toJson();
    }
    return map;
  }
}

/// id : "53127220-ac1b-4fd9-8249-3a5e194e0fdb"
/// DisplayCode : "QNode#0s7i1pvph15cviayw7iir1t4"
/// PatientUserId : "5f9ece85-5322-495d-ae31-30c4402aae34"
/// AssessmentTemplateId : "6d34c5bd-c273-4955-91b6-622bd4316a0a"
/// ParentNodeId : "0042a9c8-fed9-4220-82b1-8df61c75aa81"
/// AssessmentId : "f4a98473-e97a-4cdb-a3e0-5014e7eeaa9e"
/// Sequence : 6
/// NodeType : "Question"
/// Title : "I avoid eating prepackaged and processed foods?"
/// Description : null
/// ExpectedResponseType : "Single Choice Selection"
/// Options : [{"id":"6c8b5f10-f1ed-4b60-a8ad-9ad53b50cf0b","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#1","ProviderGivenCode":"yes","Text":"Yes","ImageUrl":null,"Sequence":1},{"id":"36d7f839-ed8a-4c06-a8ae-17aa0d96950e","NodeId":"53127220-ac1b-4fd9-8249-3a5e194e0fdb","DisplayCode":"QNode#0s7i1pvph15cviayw7iir1t4:Option#2","ProviderGivenCode":"no","Text":"No","ImageUrl":null,"Sequence":2}]
/// ProviderGivenCode : "q6"

class Next {
  Next({
    String? id,
    String? displayCode,
    String? patientUserId,
    String? assessmentTemplateId,
    String? parentNodeId,
    String? assessmentId,
    int? sequence,
    String? nodeType,
    String? title,
    dynamic description,
    String? expectedResponseType,
    List<Options>? options,
    String? providerGivenCode,
  }) {
    _id = id;
    _displayCode = displayCode;
    _patientUserId = patientUserId;
    _assessmentTemplateId = assessmentTemplateId;
    _parentNodeId = parentNodeId;
    _assessmentId = assessmentId;
    _sequence = sequence;
    _nodeType = nodeType;
    _title = title;
    _description = description;
    _expectedResponseType = expectedResponseType;
    _options = options;
    _providerGivenCode = providerGivenCode;
  }

  Next.fromJson(dynamic json) {
    _id = json['id'];
    _displayCode = json['DisplayCode'];
    _patientUserId = json['PatientUserId'];
    _assessmentTemplateId = json['AssessmentTemplateId'];
    _parentNodeId = json['ParentNodeId'];
    _assessmentId = json['AssessmentId'];
    _sequence = json['Sequence'];
    _nodeType = json['NodeType'];
    _title = json['Title'];
    _description = json['Description'];
    _expectedResponseType = json['ExpectedResponseType'];
    if (json['Options'] != null) {
      _options = [];
      json['Options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    _providerGivenCode = json['ProviderGivenCode'];
  }

  String? _id;
  String? _displayCode;
  String? _patientUserId;
  String? _assessmentTemplateId;
  String? _parentNodeId;
  String? _assessmentId;
  int? _sequence;
  String? _nodeType;
  String? _title;
  dynamic _description;
  String? _expectedResponseType;
  List<Options>? _options;
  String? _providerGivenCode;

  String? get id => _id;

  String? get displayCode => _displayCode;

  String? get patientUserId => _patientUserId;

  String? get assessmentTemplateId => _assessmentTemplateId;

  String? get parentNodeId => _parentNodeId;

  String? get assessmentId => _assessmentId;

  int? get sequence => _sequence;

  String? get nodeType => _nodeType;

  String? get title => _title;

  dynamic get description => _description;

  String? get expectedResponseType => _expectedResponseType;

  List<Options>? get options => _options;

  String? get providerGivenCode => _providerGivenCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['DisplayCode'] = _displayCode;
    map['PatientUserId'] = _patientUserId;
    map['AssessmentTemplateId'] = _assessmentTemplateId;
    map['ParentNodeId'] = _parentNodeId;
    map['AssessmentId'] = _assessmentId;
    map['Sequence'] = _sequence;
    map['NodeType'] = _nodeType;
    map['Title'] = _title;
    map['Description'] = _description;
    map['ExpectedResponseType'] = _expectedResponseType;
    if (_options != null) {
      map['Options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['ProviderGivenCode'] = _providerGivenCode;
    return map;
  }
}

/// id : "6c8b5f10-f1ed-4b60-a8ad-9ad53b50cf0b"
/// NodeId : "53127220-ac1b-4fd9-8249-3a5e194e0fdb"
/// DisplayCode : "QNode#0s7i1pvph15cviayw7iir1t4:Option#1"
/// ProviderGivenCode : "yes"
/// Text : "Yes"
/// ImageUrl : null
/// Sequence : 1

class Options {
  Options({
    String? id,
    String? nodeId,
    String? displayCode,
    String? providerGivenCode,
    String? text,
    dynamic imageUrl,
    int? sequence,
  }) {
    _id = id;
    _nodeId = nodeId;
    _displayCode = displayCode;
    _providerGivenCode = providerGivenCode;
    _text = text;
    _imageUrl = imageUrl;
    _sequence = sequence;
  }

  Options.fromJson(dynamic json) {
    _id = json['id'];
    _nodeId = json['NodeId'];
    _displayCode = json['DisplayCode'];
    _providerGivenCode = json['ProviderGivenCode'];
    _text = json['Text'];
    _imageUrl = json['ImageUrl'];
    _sequence = json['Sequence'];
  }

  String? _id;
  String? _nodeId;
  String? _displayCode;
  String? _providerGivenCode;
  String? _text;
  dynamic _imageUrl;
  int? _sequence;

  String? get id => _id;

  String? get nodeId => _nodeId;

  String? get displayCode => _displayCode;

  String? get providerGivenCode => _providerGivenCode;

  String? get text => _text;

  dynamic get imageUrl => _imageUrl;

  int? get sequence => _sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['NodeId'] = _nodeId;
    map['DisplayCode'] = _displayCode;
    map['ProviderGivenCode'] = _providerGivenCode;
    map['Text'] = _text;
    map['ImageUrl'] = _imageUrl;
    map['Sequence'] = _sequence;
    return map;
  }
}
