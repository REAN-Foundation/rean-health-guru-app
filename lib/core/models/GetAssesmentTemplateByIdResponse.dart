class GetAssesmentTemplateByIdResponse {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  User user;
  String context;
  List<String> clientIps;
  String aPIVersion;

  GetAssesmentTemplateByIdResponse(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.user,
      this.context,
      this.clientIps,
      this.aPIVersion});

  GetAssesmentTemplateByIdResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    client =
        json['Client'] != null ? new Client.fromJson(json['Client']) : null;
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.client != null) {
      data['Client'] = this.client.toJson();
    }
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['Context'] = this.context;
    data['ClientIps'] = this.clientIps;
    data['APIVersion'] = this.aPIVersion;
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

  TemplateSymptomTypes(
      {this.index, this.symptomTypeId, this.symptom, this.description});

  TemplateSymptomTypes.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    symptomTypeId = json['SymptomTypeId'];
    symptom = json['Symptom'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['SymptomTypeId'] = this.symptomTypeId;
    data['Symptom'] = this.symptom;
    data['Description'] = this.description;
    return data;
  }
}

class Client {
  String clientName;
  String clientCode;

  Client({this.clientName, this.clientCode});

  Client.fromJson(Map<String, dynamic> json) {
    clientName = json['ClientName'];
    clientCode = json['ClientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientName'] = this.clientName;
    data['ClientCode'] = this.clientCode;
    return data;
  }
}

class User {
  String userId;
  String displayName;
  String phone;
  String email;
  String userName;
  int currentRoleId;
  int iat;
  int exp;

  User(
      {this.userId,
      this.displayName,
      this.phone,
      this.email,
      this.userName,
      this.currentRoleId,
      this.iat,
      this.exp});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    displayName = json['DisplayName'];
    phone = json['Phone'];
    email = json['Email'];
    userName = json['UserName'];
    currentRoleId = json['CurrentRoleId'];
    iat = json['iat'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['DisplayName'] = this.displayName;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['UserName'] = this.userName;
    data['CurrentRoleId'] = this.currentRoleId;
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    return data;
  }
}
