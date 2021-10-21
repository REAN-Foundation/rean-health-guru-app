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
  SymptomAssessmentTemplate symptomAssessmentTemplate;

  Data({this.symptomAssessmentTemplate});

  Data.fromJson(Map<String, dynamic> json) {
    symptomAssessmentTemplate = json['SymptomAssessmentTemplate'] != null
        ? new SymptomAssessmentTemplate.fromJson(
            json['SymptomAssessmentTemplate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.symptomAssessmentTemplate != null) {
      data['SymptomAssessmentTemplate'] =
          this.symptomAssessmentTemplate.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['SymptomTypeId'] = this.symptomTypeId;
    data['Symptom'] = this.symptom;
    data['Description'] = this.description;
    data['ImageResourceId'] = this.imageResourceId;
    return data;
  }
}
