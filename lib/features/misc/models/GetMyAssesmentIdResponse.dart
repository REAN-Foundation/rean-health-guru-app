class GetMyAssesmentIdResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;
  Client? client;
  User? user;
  String? context;
  List<String>? clientIps;
  String? aPIVersion;

  GetMyAssesmentIdResponse(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.user,
      this.context,
      this.clientIps,
      this.aPIVersion});

  GetMyAssesmentIdResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    if (client != null) {
      data['Client'] = client!.toJson();
    }
    if (user != null) {
      data['User'] = user!.toJson();
    }
    data['Context'] = context;
    data['ClientIps'] = clientIps;
    data['APIVersion'] = aPIVersion;
    return data;
  }
}

class Data {
  SymptomAssessment? symptomAssessment;

  Data({this.symptomAssessment});

  Data.fromJson(Map<String, dynamic> json) {
    symptomAssessment = json['SymptomAssessment'] != null
        ? SymptomAssessment.fromJson(json['SymptomAssessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (symptomAssessment != null) {
      data['SymptomAssessment'] = symptomAssessment!.toJson();
    }
    return data;
  }
}

class SymptomAssessment {
  String? id;
  String? patientUserId;
  String? title;
  String? assessmentTemplateId;
  String? overallStatus;
  String? assessmentDate;
  List<String>? symptomsRecorded;

  SymptomAssessment(
      {this.id,
      this.patientUserId,
      this.title,
      this.assessmentTemplateId,
      this.overallStatus,
      this.assessmentDate,
      this.symptomsRecorded});

  SymptomAssessment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    title = json['Title'];
    assessmentTemplateId = json['AssessmentTemplateId'];
    overallStatus = json['OverallStatus'];
    assessmentDate = json['AssessmentDate'];
    /*if (json['SymptomsRecorded'] != null) {
      symptomsRecorded = new List<Null>();
      json['SymptomsRecorded'].forEach((v) {
        symptomsRecorded.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['Title'] = title;
    data['AssessmentTemplateId'] = assessmentTemplateId;
    data['OverallStatus'] = overallStatus;
    data['AssessmentDate'] = assessmentDate;
    /*if (this.symptomsRecorded != null) {
      data['SymptomsRecorded'] =
          this.symptomsRecorded.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Client {
  String? clientName;
  String? clientCode;

  Client({this.clientName, this.clientCode});

  Client.fromJson(Map<String, dynamic> json) {
    clientName = json['ClientName'];
    clientCode = json['ClientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientName'] = clientName;
    data['ClientCode'] = clientCode;
    return data;
  }
}

class User {
  String? userId;
  String? displayName;
  String? phone;
  String? email;
  String? userName;
  int? currentRoleId;
  int? iat;
  int? exp;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['DisplayName'] = displayName;
    data['Phone'] = phone;
    data['Email'] = email;
    data['UserName'] = userName;
    data['CurrentRoleId'] = currentRoleId;
    data['iat'] = iat;
    data['exp'] = exp;
    return data;
  }
}
