class GetAssesmentTemplateByIdResponse {
  String status;
  String message;
  Data data;

  GetAssesmentTemplateByIdResponse({this.status, this.message, this.data});

  GetAssesmentTemplateByIdResponse.fromJson(Map<String, dynamic> json) {
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
  AssessmentTemplate assessmentTemplate;

  Data({this.assessmentTemplate});

  Data.fromJson(Map<String, dynamic> json) {
    assessmentTemplate = json['assessmentTemplate'] != null
        ? AssessmentTemplate.fromJson(json['assessmentTemplate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessmentTemplate != null) {
      data['assessmentTemplate'] = assessmentTemplate.toJson();
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
      templateSymptomTypes = <TemplateSymptomTypes>[];
      json['TemplateSymptomTypes'].forEach((v) {
        templateSymptomTypes.add(TemplateSymptomTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Title'] = title;
    data['Description'] = description;
    data['Tags'] = tags;
    if (templateSymptomTypes != null) {
      data['TemplateSymptomTypes'] =
          templateSymptomTypes.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['id'] = id;
    data['Symptom'] = symptom;
    data['Description'] = description;
    data['Tags'] = tags;
    data['ImageResourceId'] = imageResourceId;
    data['PublicImageUrl'] = publicImageUrl;
    return data;
  }
}
