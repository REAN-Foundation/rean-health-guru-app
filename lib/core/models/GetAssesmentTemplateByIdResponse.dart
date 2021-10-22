class GetAssesmentTemplateByIdResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  GetAssesmentTemplateByIdResponse(
      {this.status, this.message, this.httpCode, this.data});

  GetAssesmentTemplateByIdResponse.fromJson(Map<String, dynamic> json) {
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
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  SymptomAssessmentTemplate symptomAssessmentTemplate;

  Data({this.symptomAssessmentTemplate});

  Data.fromJson(Map<String, dynamic> json) {
    symptomAssessmentTemplate = json['SymptomAssessmentTemplate'] != null
        ? SymptomAssessmentTemplate.fromJson(json['SymptomAssessmentTemplate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (symptomAssessmentTemplate != null) {
      data['SymptomAssessmentTemplate'] = symptomAssessmentTemplate.toJson();
    }
    return data;
  }
}

class SymptomAssessmentTemplate {
  String id;
  String title;
  String description;
  List<String> tags;
  List<TemplateSymptomTypes> templateSymptomTypes;

  SymptomAssessmentTemplate(
      {this.id,
      this.title,
      this.description,
      this.tags,
      this.templateSymptomTypes});

  SymptomAssessmentTemplate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    description = json['Description'];
    tags = json['Tags'].cast<String>();
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
  String symptomTypeId;
  String symptom;
  String description;
  String imageResourceId;

  TemplateSymptomTypes(
      {this.index,
      this.symptomTypeId,
      this.symptom,
      this.description,
      this.imageResourceId});

  TemplateSymptomTypes.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    symptomTypeId = json['SymptomTypeId'];
    symptom = json['Symptom'];
    description = json['Description'];
    imageResourceId = json['ImageResourceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['SymptomTypeId'] = symptomTypeId;
    data['Symptom'] = symptom;
    data['Description'] = description;
    data['ImageResourceId'] = imageResourceId;
    return data;
  }
}
