class KnowledgeTopicResponse {
  String status;
  String message;
  Data data;

  KnowledgeTopicResponse({this.status, this.message, this.data});

  KnowledgeTopicResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
      knowledgeTopic = <KnowledgeTopic>[];
      json['knowledge_topic'].forEach((v) {
        knowledgeTopic.add(KnowledgeTopic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (knowledgeTopic != null) {
      data['knowledge_topic'] = knowledgeTopic.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TopicName'] = topicName;
    data['BriefInformation'] = briefInformation;
    return data;
  }
}
