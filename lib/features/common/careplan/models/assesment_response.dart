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
    AnswerResponse? answerResponse,
  }) {
    _next = next;
    _answerResponse = answerResponse;
  }

  Data.fromJson(dynamic json) {
    _next = json['Next'] != null ? Next.fromJson(json['Next']) : null;
    _answerResponse = json['AnswerResponse'] != null ? AnswerResponse.fromJson(json['AnswerResponse']) : null;
  }

  Next? _next;
  AnswerResponse? _answerResponse;

  Next? get next => _next;
  AnswerResponse? get answerResponse => _answerResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_next != null) {
      map['Next'] = _next?.toJson();
    }
    if (_answerResponse != null) {
      map['AnswerResponse'] = _answerResponse?.toJson();
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

class AnswerResponse{
  AnswerResponse({
    Next? next,
    String? messageBeforeNext,
  }) {
    _next = next;
    _messageBeforeNext = messageBeforeNext;
  }

  AnswerResponse.fromJson(dynamic json) {
    _next = json['Next'] != null ? Next.fromJson(json['Next']) : null;
    _messageBeforeNext = json['MessageBeforeNext'];
  }

  Next? _next;
  String? _messageBeforeNext;

  Next? get next => _next;
  String? get messageBeforeNext => _messageBeforeNext;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_next != null) {
      map['Next'] = _next?.toJson();
    }
    map['MessageBeforeNext'] = _messageBeforeNext;
    return map;
  }

}

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
    bool? serveListNodeChildrenAtOnce,
    List<ChildrenQuestions>? childrenQuestions,
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
    _serveListNodeChildrenAtOnce = serveListNodeChildrenAtOnce;
    _childrenQuestions = childrenQuestions;
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
    _serveListNodeChildrenAtOnce = json['ServeListNodeChildrenAtOnce'];
    if (json['ChildrenQuestions'] != null) {
      _childrenQuestions = [];
      json['ChildrenQuestions'].forEach((v) {
        _childrenQuestions?.add(ChildrenQuestions.fromJson(v));
      });
    }
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
  bool? _serveListNodeChildrenAtOnce;
  List<ChildrenQuestions>? _childrenQuestions;

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

  bool? get serveListNodeChildrenAtOnce => _serveListNodeChildrenAtOnce;

  List<ChildrenQuestions>? get childrenQuestions => _childrenQuestions;

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
    map['ServeListNodeChildrenAtOnce'] = _serveListNodeChildrenAtOnce;
    if (_childrenQuestions != null) {
      map['ChildrenQuestions'] =
          _childrenQuestions?.map((v) => v.toJson()).toList();
    }
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
    bool? isCheck,
    int? sequence,
  }) {
    _id = id;
    _nodeId = nodeId;
    _displayCode = displayCode;
    _providerGivenCode = providerGivenCode;
    _text = text;
    isCheck = false;
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
  bool? isCheck;

  String? get id => _id;

  String? get nodeId => _nodeId;

  String? get displayCode => _displayCode;

  String? get providerGivenCode => _providerGivenCode;

  String? get text => _text;

  dynamic get imageUrl => _imageUrl;

  int? get sequence => _sequence;

  bool? get isChecked => isCheck ?? false;

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

/// id : "2ee14a69-1832-4a89-b5f1-276fec3b5963"
/// DisplayCode : "QNode#tu8w6ek4jzeacsqu4mhvm1od"
/// PatientUserId : "54fc11d6-a8cd-444e-9b32-9d28d1a1848e"
/// AssessmentTemplateId : "f1b83932-b91c-4377-9670-c0bac6619e9d"
/// ParentNodeId : "01f933fd-0183-4d17-b6f4-8c132dd30d5b"
/// AssessmentId : "44cd8793-185b-4415-ac9e-5c843dab2694"
/// Sequence : 1
/// NodeType : "Question"
/// Title : "How frequently do you take showering or bathing?"
/// Description : "Unscheduled daily checks"
/// ExpectedResponseType : "Single Choice Selection"
/// Options : [{"id":"7b243e15-870c-4a04-ae2c-50b1566f7ff8","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#1","ProviderGivenCode":"extremely limited","Text":"Extremely limited","ImageUrl":null,"Sequence":1},{"id":"3a2285b4-f1b2-44f4-90aa-a2d959bec4ef","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#2","ProviderGivenCode":"quite a bit limited","Text":"Quite a bit limited","ImageUrl":null,"Sequence":2},{"id":"c9d2803a-0b38-46a4-a417-34bfe4fd19e6","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#3","ProviderGivenCode":"moderately limited","Text":"Moderately limited","ImageUrl":null,"Sequence":3},{"id":"df2b6b1e-ae7b-432b-9f7d-f6ff6ac932b6","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#4","ProviderGivenCode":"slightly limited","Text":"Slightly limited","ImageUrl":null,"Sequence":4},{"id":"a0607817-584f-46e8-b8ff-9af9cc9f6f1d","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#5","ProviderGivenCode":"not at all limited","Text":"Not at all limited","ImageUrl":null,"Sequence":5},{"id":"58d73eb9-0238-430e-b1f5-d509cfa05c75","NodeId":"2ee14a69-1832-4a89-b5f1-276fec3b5963","DisplayCode":"QNode#tu8w6ek4jzeacsqu4mhvm1od:Option#6","ProviderGivenCode":"limited for other reasons or did not do the activity","Text":"Limited for other reasons or did not do the activity","ImageUrl":null,"Sequence":6}]
/// ProviderGivenCode : null

class ChildrenQuestions {
  ChildrenQuestions({
    String? id,
    String? displayCode,
    String? patientUserId,
    String? assessmentTemplateId,
    String? parentNodeId,
    String? assessmentId,
    int? sequence,
    String? nodeType,
    String? title,
    String? description,
    String? expectedResponseType,
    List<Options>? options,
    dynamic providerGivenCode,
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

  ChildrenQuestions.fromJson(dynamic json) {
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
  String? _description;
  String? _expectedResponseType;
  List<Options>? _options;
  dynamic _providerGivenCode;

  String? get id => _id;

  String? get displayCode => _displayCode;

  String? get patientUserId => _patientUserId;

  String? get assessmentTemplateId => _assessmentTemplateId;

  String? get parentNodeId => _parentNodeId;

  String? get assessmentId => _assessmentId;

  int? get sequence => _sequence;

  String? get nodeType => _nodeType;

  String? get title => _title;

  String? get description => _description;

  String? get expectedResponseType => _expectedResponseType;

  List<Options>? get options => _options;

  dynamic get providerGivenCode => _providerGivenCode;

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
