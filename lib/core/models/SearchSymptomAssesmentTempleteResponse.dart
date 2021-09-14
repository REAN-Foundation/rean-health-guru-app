class SearchSymptomAssesmentTempleteResponse {
  String status;
  String message;
  Data data;

  SearchSymptomAssesmentTempleteResponse(
      {this.status, this.message, this.data});

  SearchSymptomAssesmentTempleteResponse.fromJson(Map<String, dynamic> json) {
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
  List<AssessmentTemplates> assessmentTemplates;

  Data({this.assessmentTemplates});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['assessmentTemplates'] != null) {
      assessmentTemplates = new List<AssessmentTemplates>();
      json['assessmentTemplates'].forEach((v) {
        assessmentTemplates.add(new AssessmentTemplates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentTemplates != null) {
      data['assessmentTemplates'] =
          this.assessmentTemplates.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Tags'] = this.tags;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
