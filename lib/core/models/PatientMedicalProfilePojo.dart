class PatientMedicalProfilePojo {
  String status;
  String message;
  Data data;

  PatientMedicalProfilePojo({this.status, this.message, this.data});

  PatientMedicalProfilePojo.fromJson(Map<String, dynamic> json) {
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
  MedicalProfiles medicalProfiles;

  Data({this.medicalProfiles});

  Data.fromJson(Map<String, dynamic> json) {
    medicalProfiles = json['medicalProfiles'] != null
        ? new MedicalProfiles.fromJson(json['medicalProfiles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicalProfiles != null) {
      data['medicalProfiles'] = this.medicalProfiles.toJson();
    }
    return data;
  }
}

class MedicalProfiles {
  String id;
  String patientUserId;
  String updatedBy = "";
  String majorAilment = "";
  String comorbidities = "";
  String gender;
  String birthDate;
  String bloodGroup = "";
  bool isDiabetic;
  bool hasHeartAilment;
  bool isVegetarian;
  bool isVegan;
  bool sedentaryLifestyle;
  bool isSmoker;
  int smokingSeverity;
  String smokingSince = "";
  bool isDrinker;
  int drinkingSeverity;
  String drinkingSince = "";
  String ethnicity = "";
  String nationality = "";
  String occupation = "";
  String maritalStatus = "";
  String surgicalHistory = "";
  String obstetricHistory = "";
  String otherInformation = "";
  String createdAt;
  String updatedAt;

  MedicalProfiles(
      {this.id,
        this.patientUserId,
        this.updatedBy,
        this.majorAilment,
        this.comorbidities,
        this.gender,
        this.birthDate,
        this.bloodGroup,
        this.isDiabetic,
        this.hasHeartAilment,
        this.isVegetarian,
        this.isVegan,
        this.sedentaryLifestyle,
        this.isSmoker,
        this.smokingSeverity,
        this.smokingSince,
        this.isDrinker,
        this.drinkingSeverity,
        this.drinkingSince,
        this.ethnicity,
        this.nationality,
        this.occupation,
        this.maritalStatus,
        this.surgicalHistory,
        this.obstetricHistory,
        this.otherInformation,
        this.createdAt,
        this.updatedAt});

  MedicalProfiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    updatedBy = json['UpdatedBy'];
    majorAilment = json['MajorAilment'];
    comorbidities = json['Comorbidities'];
    gender = json['Gender'];
    birthDate = json['BirthDate'];
    bloodGroup = json['BloodGroup'];
    isDiabetic = json['IsDiabetic'];
    hasHeartAilment = json['HasHeartAilment'];
    isVegetarian = json['IsVegetarian'];
    isVegan = json['IsVegan'];
    sedentaryLifestyle = json['SedentaryLifestyle'];
    isSmoker = json['IsSmoker'];
    smokingSeverity = json['SmokingSeverity'];
    smokingSince = json['SmokingSince'];
    isDrinker = json['IsDrinker'];
    drinkingSeverity = json['DrinkingSeverity'];
    drinkingSince = json['DrinkingSince'];
    ethnicity = json['Ethnicity'];
    nationality = json['Nationality'];
    occupation = json['Occupation'];
    maritalStatus = json['MaritalStatus'];
    surgicalHistory = json['SurgicalHistory'];
    obstetricHistory = json['ObstetricHistory'];
    otherInformation = json['OtherInformation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['UpdatedBy'] = this.updatedBy;
    data['MajorAilment'] = this.majorAilment;
    data['Comorbidities'] = this.comorbidities;
    data['Gender'] = this.gender;
    data['BirthDate'] = this.birthDate;
    data['BloodGroup'] = this.bloodGroup;
    data['IsDiabetic'] = this.isDiabetic;
    data['HasHeartAilment'] = this.hasHeartAilment;
    data['IsVegetarian'] = this.isVegetarian;
    data['IsVegan'] = this.isVegan;
    data['SedentaryLifestyle'] = this.sedentaryLifestyle;
    data['IsSmoker'] = this.isSmoker;
    data['SmokingSeverity'] = this.smokingSeverity;
    data['SmokingSince'] = this.smokingSince;
    data['IsDrinker'] = this.isDrinker;
    data['DrinkingSeverity'] = this.drinkingSeverity;
    data['DrinkingSince'] = this.drinkingSince;
    data['Ethnicity'] = this.ethnicity;
    data['Nationality'] = this.nationality;
    data['Occupation'] = this.occupation;
    data['MaritalStatus'] = this.maritalStatus;
    data['SurgicalHistory'] = this.surgicalHistory;
    data['ObstetricHistory'] = this.obstetricHistory;
    data['OtherInformation'] = this.otherInformation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}