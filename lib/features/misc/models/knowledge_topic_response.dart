class KnowledgeTopicResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  KnowledgeTopicResponse({this.status, this.message, this.httpCode, this.data});

  KnowledgeTopicResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  KnowledgeNugget? knowledgeNugget;

  Data({this.knowledgeNugget});

  Data.fromJson(Map<String, dynamic> json) {
    knowledgeNugget = json['KnowledgeNugget'] != null
        ? KnowledgeNugget.fromJson(json['KnowledgeNugget'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (knowledgeNugget != null) {
      data['KnowledgeNugget'] = knowledgeNugget!.toJson();
    }
    return data;
  }
}

class KnowledgeNugget {
  String? id;
  String? topicName;
  String? briefInformation;

  KnowledgeNugget({
    this.id,
    this.topicName,
    this.briefInformation,
  });

  KnowledgeNugget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicName = json['TopicName'];
    briefInformation = json['BriefInformation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TopicName'] = topicName;
    data['BriefInformation'] = briefInformation;
    return data;
  }
}
