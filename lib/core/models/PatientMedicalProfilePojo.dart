class PatientMedicalProfilePojo {
  String status;
  String message;
  Data data;

  PatientMedicalProfilePojo({this.status, this.message, this.data});

  PatientMedicalProfilePojo.fromJson(Map<String, dynamic> json) {
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
  MedicalProfiles medicalProfiles;

  Data({this.medicalProfiles});

  Data.fromJson(Map<String, dynamic> json) {
    medicalProfiles = json['medicalProfiles'] != null
        ? MedicalProfiles.fromJson(json['medicalProfiles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicalProfiles != null) {
      data['medicalProfiles'] = medicalProfiles.toJson();
    }
    return data;
  }
}

class MedicalProfiles {
  String id;
  String patientUserId;
  String updatedBy = '';
  String majorAilment = '';
  String comorbidities = '';
  String gender;
  String birthDate;
  String bloodGroup = '';
  bool isDiabetic;
  bool hasHeartAilment;
  bool isVegetarian;
  bool isVegan;
  bool sedentaryLifestyle;
  bool isSmoker;
  int smokingSeverity;
  String smokingSince = '';
  bool isDrinker;
  int drinkingSeverity;
  String drinkingSince = '';
  String ethnicity = '';
  String nationality = '';
  String occupation = '';
  String maritalStatus = '';
  String surgicalHistory = '';
  String obstetricHistory = '';
  String otherInformation = '';
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['UpdatedBy'] = updatedBy;
    data['MajorAilment'] = majorAilment;
    data['Comorbidities'] = comorbidities;
    data['Gender'] = gender;
    data['BirthDate'] = birthDate;
    data['BloodGroup'] = bloodGroup;
    data['IsDiabetic'] = isDiabetic;
    data['HasHeartAilment'] = hasHeartAilment;
    data['IsVegetarian'] = isVegetarian;
    data['IsVegan'] = isVegan;
    data['SedentaryLifestyle'] = sedentaryLifestyle;
    data['IsSmoker'] = isSmoker;
    data['SmokingSeverity'] = smokingSeverity;
    data['SmokingSince'] = smokingSince;
    data['IsDrinker'] = isDrinker;
    data['DrinkingSeverity'] = drinkingSeverity;
    data['DrinkingSince'] = drinkingSince;
    data['Ethnicity'] = ethnicity;
    data['Nationality'] = nationality;
    data['Occupation'] = occupation;
    data['MaritalStatus'] = maritalStatus;
    data['SurgicalHistory'] = surgicalHistory;
    data['ObstetricHistory'] = obstetricHistory;
    data['OtherInformation'] = otherInformation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
