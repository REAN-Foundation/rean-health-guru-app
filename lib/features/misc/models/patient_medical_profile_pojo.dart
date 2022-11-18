class PatientMedicalProfilePojo {
  String? status;
  String? message;
  int? httpCode;
  Data? data;
  Client? client;
  User? user;
  String? context;
  List<String>? clientIps;
  String? aPIVersion;

  PatientMedicalProfilePojo(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.user,
      this.context,
      this.clientIps,
      this.aPIVersion});

  PatientMedicalProfilePojo.fromJson(Map<String, dynamic> json) {
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
  HealthProfile? healthProfile;

  Data({this.healthProfile});

  Data.fromJson(Map<String, dynamic> json) {
    healthProfile = json['HealthProfile'] != null
        ? HealthProfile.fromJson(json['HealthProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (healthProfile != null) {
      data['HealthProfile'] = healthProfile!.toJson();
    }
    return data;
  }
}

class HealthProfile {
  String? id;
  String? patientUserId;
  String? bloodGroup;
  String? majorAilment;
  String? otherConditions;
  bool? isDiabetic;
  bool? hasHeartAilment;
  String? maritalStatus;
  String? ethnicity;
  String? race;
  String? nationality;
  String? occupation;
  bool? sedentaryLifestyle;
  bool? isSmoker;
  String? smokingSeverity;
  String? smokingSince;
  bool? isDrinker;
  String? drinkingSeverity;
  String? drinkingSince;
  bool? substanceAbuse;
  String? procedureHistory;
  String? obstetricHistory;
  String? otherInformation;
  String? typeOfStroke;
  bool? hasHighBloodPressure;
  bool? hasHighCholesterol;
  bool? hasAtrialFibrillation;

  HealthProfile(
      {this.id,
      this.patientUserId,
      this.bloodGroup,
      this.majorAilment,
      this.otherConditions,
      this.isDiabetic,
      this.hasHeartAilment,
      this.maritalStatus,
      this.ethnicity,
      this.race,
      this.nationality,
      this.occupation,
      this.sedentaryLifestyle,
      this.isSmoker,
      this.smokingSeverity,
      this.smokingSince,
      this.isDrinker,
      this.drinkingSeverity,
      this.drinkingSince,
      this.substanceAbuse,
      this.procedureHistory,
      this.obstetricHistory,
      this.otherInformation,
      this.typeOfStroke,
      this.hasHighBloodPressure,
      this.hasHighCholesterol,
      this.hasAtrialFibrillation});

  HealthProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    bloodGroup = json['BloodGroup'];
    majorAilment = json['MajorAilment'];
    otherConditions = json['OtherConditions'];
    isDiabetic = json['IsDiabetic'];
    hasHeartAilment = json['HasHeartAilment'];
    maritalStatus = json['MaritalStatus'];
    ethnicity = json['Ethnicity'];
    race = json['Race'];
    nationality = json['Nationality'];
    occupation = json['Occupation'];
    sedentaryLifestyle = json['SedentaryLifestyle'];
    isSmoker = json['IsSmoker'];
    smokingSeverity = json['SmokingSeverity'];
    smokingSince = json['SmokingSince'];
    isDrinker = json['IsDrinker'];
    drinkingSeverity = json['DrinkingSeverity'];
    drinkingSince = json['DrinkingSince'];
    substanceAbuse = json['SubstanceAbuse'];
    procedureHistory = json['ProcedureHistory'];
    obstetricHistory = json['ObstetricHistory'];
    otherInformation = json['OtherInformation'];
    typeOfStroke = json['TypeOfStroke'];
    hasHighBloodPressure = json['HasHighBloodPressure'];
    hasHighCholesterol = json['HasHighCholesterol'];
    hasAtrialFibrillation = json['HasAtrialFibrillation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['BloodGroup'] = bloodGroup;
    data['MajorAilment'] = majorAilment;
    data['OtherConditions'] = otherConditions;
    data['IsDiabetic'] = isDiabetic;
    data['HasHeartAilment'] = hasHeartAilment;
    data['MaritalStatus'] = maritalStatus;
    data['Ethnicity'] = ethnicity;
    data['Race'] = race;
    data['Nationality'] = nationality;
    data['Occupation'] = occupation;
    data['SedentaryLifestyle'] = sedentaryLifestyle;
    data['IsSmoker'] = isSmoker;
    data['SmokingSeverity'] = smokingSeverity;
    data['SmokingSince'] = smokingSince;
    data['IsDrinker'] = isDrinker;
    data['DrinkingSeverity'] = drinkingSeverity;
    data['DrinkingSince'] = drinkingSince;
    data['SubstanceAbuse'] = substanceAbuse;
    data['ProcedureHistory'] = procedureHistory;
    data['ObstetricHistory'] = obstetricHistory;
    data['OtherInformation'] = otherInformation;
    data['TypeOfStroke'] = typeOfStroke;
    data['HasHighBloodPressure'] = hasHighBloodPressure;
    data['HasHighCholesterol'] = hasHighCholesterol;
    data['HasAtrialFibrillation'] = hasAtrialFibrillation;
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
    final Map<String, dynamic> data = {};
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
    final Map<String, dynamic> data = {};
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
