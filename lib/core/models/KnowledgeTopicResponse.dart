class KnowledgeTopicResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  KnowledgeTopicResponse({this.status, this.message, this.httpCode, this.data});

  KnowledgeTopicResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  KnowledgeNugget knowledgeNugget;

  Data({this.knowledgeNugget});

  Data.fromJson(Map<String, dynamic> json) {
    knowledgeNugget = json['KnowledgeNugget'] != null
        ? new KnowledgeNugget.fromJson(json['KnowledgeNugget'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.knowledgeNugget != null) {
      data['KnowledgeNugget'] = this.knowledgeNugget.toJson();
    }
    return data;
  }
}

class KnowledgeNugget {
  String id;
  String topicName;
  String briefInformation;

  KnowledgeNugget(
      {this.id,
        this.topicName,
        this.briefInformation,
      });

  KnowledgeNugget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicName = json['TopicName'];
    briefInformation = json['BriefInformation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['TopicName'] = this.topicName;
    data['BriefInformation'] = this.briefInformation;
    return data;
  }
}
