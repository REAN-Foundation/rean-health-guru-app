class PatientMedicalProfilePojo {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  User user;
  String context;
  List<String> clientIps;
  String aPIVersion;

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
  HealthProfile healthProfile;

  Data({this.healthProfile});

  Data.fromJson(Map<String, dynamic> json) {
    healthProfile = json['HealthProfile'] != null
        ? new HealthProfile.fromJson(json['HealthProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.healthProfile != null) {
      data['HealthProfile'] = this.healthProfile.toJson();
    }
    return data;
  }
}

class HealthProfile {
  String id;
  String patientUserId;
  String bloodGroup;
  String majorAilment;
  String otherConditions;
  bool isDiabetic;
  bool hasHeartAilment;
  String maritalStatus;
  String ethnicity;
  String nationality;
  String occupation;
  bool sedentaryLifestyle;
  bool isSmoker;
  String smokingSeverity;
  Null smokingSince;
  bool isDrinker;
  String drinkingSeverity;
  String drinkingSince;
  bool substanceAbuse;
  String procedureHistory;
  Null obstetricHistory;
  Null otherInformation;

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
        this.otherInformation});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['BloodGroup'] = this.bloodGroup;
    data['MajorAilment'] = this.majorAilment;
    data['OtherConditions'] = this.otherConditions;
    data['IsDiabetic'] = this.isDiabetic;
    data['HasHeartAilment'] = this.hasHeartAilment;
    data['MaritalStatus'] = this.maritalStatus;
    data['Ethnicity'] = this.ethnicity;
    data['Nationality'] = this.nationality;
    data['Occupation'] = this.occupation;
    data['SedentaryLifestyle'] = this.sedentaryLifestyle;
    data['IsSmoker'] = this.isSmoker;
    data['SmokingSeverity'] = this.smokingSeverity;
    data['SmokingSince'] = this.smokingSince;
    data['IsDrinker'] = this.isDrinker;
    data['DrinkingSeverity'] = this.drinkingSeverity;
    data['DrinkingSince'] = this.drinkingSince;
    data['SubstanceAbuse'] = this.substanceAbuse;
    data['ProcedureHistory'] = this.procedureHistory;
    data['ObstetricHistory'] = this.obstetricHistory;
    data['OtherInformation'] = this.otherInformation;
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
