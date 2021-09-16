import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class PatientApiDetails {
  String status;
  String message;
  String error;
  Data data;

  PatientApiDetails({this.status, this.message, this.error, this.data});

  PatientApiDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != String ? Data.fromJson(json['data']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['error'] = error;
    if (this.data != String) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Patient patient;

  Data({this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    patient = json['patient'] != String ? Patient.fromJson(json['patient']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != String) {
      data['patient'] = patient.toJson();
    }
    return data;
  }
}

class Patient {
  String userId;
  String roleId;
  String displayId;
  String medicalProfileId;
  String firstName;
  String lastName;
  String prefix;
  String phoneNumber;
  String email;
  String gender;
  DateTime birthDate;
  String imageURL;
  String locality;
  String address;
  String locationCoordsLongitude;
  String locationCoordsLattitude;
  String insuranceProvider;
  String insurancePolicyCode;
  String emergencyContactName;
  String emergencyContactRelation;
  String emergencyContactNumber;
  bool inAppUser;
  String dateCreated;
  String dateUpdated;

  Patient(
      {this.userId,
      this.roleId,
      this.displayId,
      this.medicalProfileId,
      this.firstName,
      this.lastName,
      this.prefix,
      this.phoneNumber,
      this.email,
      this.gender,
      this.birthDate,
      this.imageURL,
      this.locality,
      this.address,
      this.locationCoordsLongitude,
      this.locationCoordsLattitude,
      this.insuranceProvider,
      this.insurancePolicyCode,
      this.emergencyContactName,
      this.emergencyContactRelation,
      this.emergencyContactNumber,
      this.inAppUser,
      this.dateCreated,
      this.dateUpdated});

  Patient.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    displayId = json['DisplayId'];
    medicalProfileId = json['MedicalProfileId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    prefix = json['Prefix'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    gender = json['Gender'];
    birthDate = json['BirthDate'] != null
        ? DateTime.parse(json['BirthDate'])
        : json['BirthDate'];
    imageURL = json['ImageURL'];
    locality = json['Locality'];
    address = json['Address'];
    locationCoordsLongitude = json['LocationCoords_Longitude'];
    locationCoordsLattitude = json['LocationCoords_Lattitude'];
    insuranceProvider = json['InsuranceProvider'];
    insurancePolicyCode = json['InsurancePolicyCode'];
    emergencyContactName = json['EmergencyContactName'];
    emergencyContactRelation = json['EmergencyContactRelation'];
    emergencyContactNumber = json['EmergencyContactNumber'];
    inAppUser = json['InAppUser'];
    dateCreated = json['DateCreated'];
    dateUpdated = json['DateUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['RoleId'] = roleId;
    data['DisplayId'] = displayId;
    data['MedicalProfileId'] = medicalProfileId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Prefix'] = prefix;
    data['PhoneNumber'] = phoneNumber;
    data['Email'] = email;
    data['Gender'] = gender;
    data['BirthDate'] =
        birthDate != null ? birthDate.toIso8601String() : birthDate;
    data['ImageURL'] = imageURL;
    data['Locality'] = locality;
    data['Address'] = address;
    data['LocationCoords_Longitude'] = locationCoordsLongitude;
    data['LocationCoords_Lattitude'] = locationCoordsLattitude;
    data['InsuranceProvider'] = insuranceProvider;
    data['InsurancePolicyCode'] = insurancePolicyCode;
    data['EmergencyContactName'] = emergencyContactName;
    data['EmergencyContactRelation'] = emergencyContactRelation;
    data['EmergencyContactNumber'] = emergencyContactNumber;
    data['InAppUser'] = inAppUser;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    return data;
  }
}

class AppointmentRelatedDetails {
  String userId;

  AppointmentRelatedDetails({this.userId});

  AppointmentRelatedDetails.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    return data;
  }
}
