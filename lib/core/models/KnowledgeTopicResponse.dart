class KnowledgeTopicResponse {
  String status;
  String message;
  Data data;

  KnowledgeTopicResponse({this.status, this.message, this.data});

  KnowledgeTopicResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<KnowledgeTopic> knowledgeTopic;

  Data({this.knowledgeTopic});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['knowledge_topic'] != null) {
      knowledgeTopic = new List<KnowledgeTopic>();
      json['knowledge_topic'].forEach((v) {
        knowledgeTopic.add(new KnowledgeTopic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.knowledgeTopic != null) {
      data['knowledge_topic'] =
          this.knowledgeTopic.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KnowledgeTopic {
  String id;
  String topicName;
  String briefInformation;

  KnowledgeTopic({this.id, this.topicName, this.briefInformation});

  KnowledgeTopic.fromJson(Map<String, dynamic> json) {
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
