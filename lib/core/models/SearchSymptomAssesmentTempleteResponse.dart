class SearchSymptomAssesmentTempleteResponse {
  String status;
  String message;
  Data data;

  SearchSymptomAssesmentTempleteResponse(
      {this.status, this.message, this.data});

  SearchSymptomAssesmentTempleteResponse.fromJson(Map<String, dynamic> json) {
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
  List<AssessmentTemplates> assessmentTemplates;

  Data({this.assessmentTemplates});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['assessmentTemplates'] != null) {
      assessmentTemplates = <AssessmentTemplates>[];
      json['assessmentTemplates'].forEach((v) {
        assessmentTemplates.add(AssessmentTemplates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessmentTemplates != null) {
      data['assessmentTemplates'] =
          assessmentTemplates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssessmentTemplates {
  String id;
  String title;
  String description;
  String tags;
  String createdAt;
  String updatedAt;

  AssessmentTemplates(
      {this.id,
      this.title,
      this.description,
      this.tags,
      this.createdAt,
      this.updatedAt});

  AssessmentTemplates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    description = json['Description'];
    tags = json['Tags'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Title'] = title;
    data['Description'] = description;
    data['Tags'] = tags;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
