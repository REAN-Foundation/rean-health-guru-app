

class PatientApiDetails {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  PatientApiDetails({this.status, this.message, this.httpCode, this.data});

  PatientApiDetails.fromJson(Map<String, dynamic> json) {
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
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Patient? patient;

  Data({this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    patient =
        json['Patient'] != null ? Patient.fromJson(json['Patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['Patient'] = patient!.toJson();
    }
    return data;
  }
}

class Patient {
  String? id;
  String? userId;
  User? user;
  String? displayId;
  String? ehrId;
  String? healthSystem;
  String? associatedHospital;
  HealthProfile? healthProfile;

  Patient({
    this.id,
    this.userId,
    this.user,
    this.displayId,
    this.ehrId,
    this.healthSystem,
    this.associatedHospital,
    this.healthProfile
  });

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    displayId = json['DisplayId'];
    ehrId = json['EhrId'];
    healthSystem = json['HealthSystem'];
    associatedHospital = json['AssociatedHospital'];
    healthProfile = json['HealthProfile'] != null ? HealthProfile.fromJson(json['HealthProfile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UserId'] = userId;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    data['DisplayId'] = displayId;
    data['EhrId'] = ehrId;
    data['HealthSystem'] = healthSystem;
    data['AssociatedHospital'] = associatedHospital;
    if (healthProfile != null) {
      data['HealthProfile'] = healthProfile?.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? userName;
  String? personId;
  Person? person;
  String? lastLogin;
  String? defaultTimeZone;
  String? currentTimeZone;
  int? roleId;
  String? role;

  User(
      {this.id,
      this.userName,
      this.personId,
      this.person,
      this.lastLogin,
      this.defaultTimeZone,
      this.currentTimeZone,
      this.roleId,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['UserName'];
    personId = json['PersonId'];
    person =
    json['Person'] != null ? Person.fromJson(json['Person']) : null;
    lastLogin = json['LastLogin'];
    defaultTimeZone = json['DefaultTimeZone'];
    currentTimeZone = json['CurrentTimeZone'];
    roleId = json['RoleId'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UserName'] = userName;
    data['PersonId'] = personId;
    if (person != null) {
      data['Person'] = person!.toJson();
    }
    data['LastLogin'] = lastLogin;
    data['DefaultTimeZone'] = defaultTimeZone;
    data['CurrentTimeZone'] = currentTimeZone;
    data['RoleId'] = roleId;
    data['Role'] = role;
    return data;
  }
}

class Person {
  String? id;
  String? prefix;
  String? firstName;
  String? middleName;
  String? lastName;
  String? displayName;
  String? gender;
  DateTime? birthDate;
  String? age;
  String? phone;
  String? email;
  String? imageResourceId;
  String? activeSince;
  List<Addresses>? addresses;

  Person(
      {this.id,
      this.prefix,
      this.firstName,
      this.middleName,
      this.lastName,
      this.displayName,
      this.gender,
      this.birthDate,
      this.age,
      this.phone,
      this.email,
      this.imageResourceId,
      this.activeSince,
      this.addresses});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prefix = json['Prefix'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    displayName = json['DisplayName'];
    gender = json['Gender'];
    if (json['BirthDate'] != null) {
      birthDate = DateTime.parse(json['BirthDate']);
    } else {
      birthDate = json['BirthDate'];
    }
    age = json['Age'];
    phone = json['Phone'];
    email = json['Email'];
    imageResourceId = json['ImageResourceId'];
    activeSince = json['ActiveSince'];
    if (json['Addresses'] != null) {
      addresses = <Addresses>[];
      if (addresses != null) {
        json['Addresses'].forEach((v) {
          addresses!.add(Addresses.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Prefix'] = prefix;
    data['FirstName'] = firstName;
    data['MiddleName'] = middleName;
    data['LastName'] = lastName;
    data['DisplayName'] = displayName;
    data['Gender'] = gender;
    if (birthDate == null) {
      data['BirthDate'] = birthDate;
    } else {
      data['BirthDate'] = birthDate!.toIso8601String();
    }
    data['Age'] = age;
    data['Phone'] = phone;
    data['Email'] = email;
    data['ImageResourceId'] = imageResourceId;
    data['ActiveSince'] = activeSince;
    if (addresses != null) {
      data['Addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? id;
  String? type;
  String? addressLine;
  String? city;
  String? district;
  String? state;
  String? country;
  String? postalCode;
  double? longitude;
  double? lattitude;

  Addresses(
      {this.id,
      this.type,
      this.addressLine,
      this.city,
      this.district,
      this.state,
      this.country,
      this.postalCode,
      this.longitude,
        this.lattitude});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['Type'];
    addressLine = json['AddressLine'];
    city = json['City'];
    district = json['District'];
    state = json['State'];
    country = json['Country'];
    postalCode = json['PostalCode'];
    longitude = json['Longitude'];
    lattitude = json['Lattitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Type'] = type;
    data['AddressLine'] = addressLine;
    data['City'] = city;
    data['District'] = district;
    data['State'] = state;
    data['Country'] = country;
    data['PostalCode'] = postalCode;
    data['Longitude'] = longitude;
    data['Lattitude'] = lattitude;
    return data;
  }
}

class HealthProfile {
  HealthProfile({
    String? id,
    String? patientUserId,
    dynamic bloodGroup,
    dynamic bloodTransfusionDate,
    dynamic bloodDonationCycle,
    dynamic majorAilment,
    dynamic otherConditions,
    bool? isDiabetic,
    bool? hasHeartAilment,
    String? maritalStatus,
    dynamic ethnicity,
    dynamic race,
    dynamic nationality,
    dynamic occupation,
    bool? sedentaryLifestyle,
    bool? isSmoker,
    String? smokingSeverity,
    dynamic smokingSince,
    bool? isDrinker,
    String? drinkingSeverity,
    dynamic drinkingSince,
    bool? substanceAbuse,
    dynamic procedureHistory,
    dynamic obstetricHistory,
    dynamic otherInformation,
    dynamic tobaccoQuestion,
    bool? tobaccoQuestionAns,
    dynamic typeOfStroke,
    dynamic hasHighBloodPressure,
    dynamic hasHighCholesterol,
    dynamic hasAtrialFibrillation,
    dynamic strokeSurvivorOrCaregiver,
    dynamic livingAlone,
    dynamic workedPriorToStroke,}){
    _id = id;
    _patientUserId = patientUserId;
    _bloodGroup = bloodGroup;
    _bloodTransfusionDate = bloodTransfusionDate;
    _bloodDonationCycle = bloodDonationCycle;
    _majorAilment = majorAilment;
    _otherConditions = otherConditions;
    _isDiabetic = isDiabetic;
    _hasHeartAilment = hasHeartAilment;
    _maritalStatus = maritalStatus;
    _ethnicity = ethnicity;
    _race = race;
    _nationality = nationality;
    _occupation = occupation;
    _sedentaryLifestyle = sedentaryLifestyle;
    _isSmoker = isSmoker;
    _smokingSeverity = smokingSeverity;
    _smokingSince = smokingSince;
    _isDrinker = isDrinker;
    _drinkingSeverity = drinkingSeverity;
    _drinkingSince = drinkingSince;
    _substanceAbuse = substanceAbuse;
    _procedureHistory = procedureHistory;
    _obstetricHistory = obstetricHistory;
    _otherInformation = otherInformation;
    _tobaccoQuestion = tobaccoQuestion;
    _tobaccoQuestionAns = tobaccoQuestionAns;
    _typeOfStroke = typeOfStroke;
    _hasHighBloodPressure = hasHighBloodPressure;
    _hasHighCholesterol = hasHighCholesterol;
    _hasAtrialFibrillation = hasAtrialFibrillation;
    _strokeSurvivorOrCaregiver = strokeSurvivorOrCaregiver;
    _livingAlone = livingAlone;
    _workedPriorToStroke = workedPriorToStroke;
  }

  HealthProfile.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _bloodGroup = json['BloodGroup'];
    _bloodTransfusionDate = json['BloodTransfusionDate'];
    _bloodDonationCycle = json['BloodDonationCycle'];
    _majorAilment = json['MajorAilment'];
    _otherConditions = json['OtherConditions'];
    _isDiabetic = json['IsDiabetic'];
    _hasHeartAilment = json['HasHeartAilment'];
    _maritalStatus = json['MaritalStatus'];
    _ethnicity = json['Ethnicity'];
    _race = json['Race'];
    _nationality = json['Nationality'];
    _occupation = json['Occupation'];
    _sedentaryLifestyle = json['SedentaryLifestyle'];
    _isSmoker = json['IsSmoker'];
    _smokingSeverity = json['SmokingSeverity'];
    _smokingSince = json['SmokingSince'];
    _isDrinker = json['IsDrinker'];
    _drinkingSeverity = json['DrinkingSeverity'];
    _drinkingSince = json['DrinkingSince'];
    _substanceAbuse = json['SubstanceAbuse'];
    _procedureHistory = json['ProcedureHistory'];
    _obstetricHistory = json['ObstetricHistory'];
    _otherInformation = json['OtherInformation'];
    _tobaccoQuestion = json['TobaccoQuestion'];
    _tobaccoQuestionAns = json['TobaccoQuestionAns'];
    _typeOfStroke = json['TypeOfStroke'];
    _hasHighBloodPressure = json['HasHighBloodPressure'];
    _hasHighCholesterol = json['HasHighCholesterol'];
    _hasAtrialFibrillation = json['HasAtrialFibrillation'];
    _strokeSurvivorOrCaregiver = json['StrokeSurvivorOrCaregiver'];
    _livingAlone = json['LivingAlone'];
    _workedPriorToStroke = json['WorkedPriorToStroke'];
  }
  String? _id;
  String? _patientUserId;
  dynamic _bloodGroup;
  dynamic _bloodTransfusionDate;
  dynamic _bloodDonationCycle;
  dynamic _majorAilment;
  dynamic _otherConditions;
  bool? _isDiabetic;
  bool? _hasHeartAilment;
  String? _maritalStatus;
  dynamic _ethnicity;
  dynamic _race;
  dynamic _nationality;
  dynamic _occupation;
  bool? _sedentaryLifestyle;
  bool? _isSmoker;
  String? _smokingSeverity;
  dynamic _smokingSince;
  bool? _isDrinker;
  String? _drinkingSeverity;
  dynamic _drinkingSince;
  bool? _substanceAbuse;
  dynamic _procedureHistory;
  dynamic _obstetricHistory;
  dynamic _otherInformation;
  dynamic _tobaccoQuestion;
  bool? _tobaccoQuestionAns;
  dynamic _typeOfStroke;
  dynamic _hasHighBloodPressure;
  dynamic _hasHighCholesterol;
  dynamic _hasAtrialFibrillation;
  dynamic _strokeSurvivorOrCaregiver;
  dynamic _livingAlone;
  dynamic _workedPriorToStroke;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  dynamic get bloodGroup => _bloodGroup;
  dynamic get bloodTransfusionDate => _bloodTransfusionDate;
  dynamic get bloodDonationCycle => _bloodDonationCycle;
  dynamic get majorAilment => _majorAilment;
  dynamic get otherConditions => _otherConditions;
  bool? get isDiabetic => _isDiabetic;
  bool? get hasHeartAilment => _hasHeartAilment;
  String? get maritalStatus => _maritalStatus;
  dynamic get ethnicity => _ethnicity;
  dynamic get race => _race;
  dynamic get nationality => _nationality;
  dynamic get occupation => _occupation;
  bool? get sedentaryLifestyle => _sedentaryLifestyle;
  bool? get isSmoker => _isSmoker;
  String? get smokingSeverity => _smokingSeverity;
  dynamic get smokingSince => _smokingSince;
  bool? get isDrinker => _isDrinker;
  String? get drinkingSeverity => _drinkingSeverity;
  dynamic get drinkingSince => _drinkingSince;
  bool? get substanceAbuse => _substanceAbuse;
  dynamic get procedureHistory => _procedureHistory;
  dynamic get obstetricHistory => _obstetricHistory;
  dynamic get otherInformation => _otherInformation;
  dynamic get tobaccoQuestion => _tobaccoQuestion;
  bool? get tobaccoQuestionAns => _tobaccoQuestionAns;
  dynamic get typeOfStroke => _typeOfStroke;
  dynamic get hasHighBloodPressure => _hasHighBloodPressure;
  dynamic get hasHighCholesterol => _hasHighCholesterol;
  dynamic get hasAtrialFibrillation => _hasAtrialFibrillation;
  dynamic get strokeSurvivorOrCaregiver => _strokeSurvivorOrCaregiver;
  dynamic get livingAlone => _livingAlone;
  dynamic get workedPriorToStroke => _workedPriorToStroke;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    map['BloodGroup'] = _bloodGroup;
    map['BloodTransfusionDate'] = _bloodTransfusionDate;
    map['BloodDonationCycle'] = _bloodDonationCycle;
    map['MajorAilment'] = _majorAilment;
    map['OtherConditions'] = _otherConditions;
    map['IsDiabetic'] = _isDiabetic;
    map['HasHeartAilment'] = _hasHeartAilment;
    map['MaritalStatus'] = _maritalStatus;
    map['Ethnicity'] = _ethnicity;
    map['Race'] = _race;
    map['Nationality'] = _nationality;
    map['Occupation'] = _occupation;
    map['SedentaryLifestyle'] = _sedentaryLifestyle;
    map['IsSmoker'] = _isSmoker;
    map['SmokingSeverity'] = _smokingSeverity;
    map['SmokingSince'] = _smokingSince;
    map['IsDrinker'] = _isDrinker;
    map['DrinkingSeverity'] = _drinkingSeverity;
    map['DrinkingSince'] = _drinkingSince;
    map['SubstanceAbuse'] = _substanceAbuse;
    map['ProcedureHistory'] = _procedureHistory;
    map['ObstetricHistory'] = _obstetricHistory;
    map['OtherInformation'] = _otherInformation;
    map['TobaccoQuestion'] = _tobaccoQuestion;
    map['TobaccoQuestionAns'] = _tobaccoQuestionAns;
    map['TypeOfStroke'] = _typeOfStroke;
    map['HasHighBloodPressure'] = _hasHighBloodPressure;
    map['HasHighCholesterol'] = _hasHighCholesterol;
    map['HasAtrialFibrillation'] = _hasAtrialFibrillation;
    map['StrokeSurvivorOrCaregiver'] = _strokeSurvivorOrCaregiver;
    map['LivingAlone'] = _livingAlone;
    map['WorkedPriorToStroke'] = _workedPriorToStroke;
    return map;
  }

}
