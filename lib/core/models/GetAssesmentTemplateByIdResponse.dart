class GetAssesmentTemplateByIdResponse {
  String status;
  String message;
  Data data;

  GetAssesmentTemplateByIdResponse({this.status, this.message, this.data});

  GetAssesmentTemplateByIdResponse.fromJson(Map<String, dynamic> json) {
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
  AssessmentTemplate assessmentTemplate;

  Data({this.assessmentTemplate});

  Data.fromJson(Map<String, dynamic> json) {
    assessmentTemplate = json['assessmentTemplate'] != null
        ? new AssessmentTemplate.fromJson(json['assessmentTemplate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentTemplate != null) {
      data['assessmentTemplate'] = this.assessmentTemplate.toJson();
    }
    return data;
  }
}

class AssessmentTemplate {
  String id;
  String title;
  String description;
  String tags;
  List<TemplateSymptomTypes> templateSymptomTypes;

  AssessmentTemplate(
      {this.id,
      this.title,
      this.description,
      this.tags,
      this.templateSymptomTypes});

  AssessmentTemplate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    description = json['Description'];
    tags = json['Tags'];
    if (json['TemplateSymptomTypes'] != null) {
      templateSymptomTypes = new List<TemplateSymptomTypes>();
      json['TemplateSymptomTypes'].forEach((v) {
        templateSymptomTypes.add(new TemplateSymptomTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Tags'] = this.tags;
    if (this.templateSymptomTypes != null) {
      data['TemplateSymptomTypes'] =
          this.templateSymptomTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TemplateSymptomTypes {
  int index;
  String id;
  String symptom;
  String description;
  String tags;
  String imageResourceId;
  String publicImageUrl;

  TemplateSymptomTypes(
      {this.index,
      this.id,
      this.symptom,
      this.description,
      this.tags,
      this.imageResourceId,
      this.publicImageUrl});

  TemplateSymptomTypes.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    id = json['id'];
    symptom = json['Symptom'];
    description = json['Description'];
    tags = json['Tags'];
    imageResourceId = json['ImageResourceId'];
    publicImageUrl = json['PublicImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['id'] = this.id;
    data['Symptom'] = this.symptom;
    data['Description'] = this.description;
    data['Tags'] = this.tags;
    data['ImageResourceId'] = this.imageResourceId;
    data['PublicImageUrl'] = this.publicImageUrl;
    return data;
  }
}
