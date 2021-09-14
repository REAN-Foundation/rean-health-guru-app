import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class DoctorListApiResponse {
  String status;
  String message;
  Data data;

  DoctorListApiResponse({this.status, this.message, this.data});

  DoctorListApiResponse.fromJson(Map<String, dynamic> json) {
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
  List<Doctors> doctors;

  Data({this.doctors});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['doctors'] != null) {
      doctors = new List<Doctors>();
      json['doctors'].forEach((v) {
        doctors.add(new Doctors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctors != null) {
      data['doctors'] = this.doctors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@JsonSerializable(nullable: true)
class Doctors {
  String userId;
  String doctorRoleId;
  String firstName;
  String lastName;
  String prefix;
  String phoneNumber;
  String email;
  String gender;
  String birthDate;
  String imageURL;
  String locality;
  String address;
  String locationCoordsLongitude;
  String locationCoordsLattitude;
  String establishmentName;
  String qualification;
  String specialities;
  String aboutMe;
  String professionalHighlights;
  dynamic consultationFee;
  dynamic appointmentSlotDuration;
  String practisingSince;
  String dateCreated;
  String dateUpdated;
  AppointmentRelatedDetails appointmentRelatedDetails;

  Doctors(
      {this.userId,
      this.doctorRoleId,
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
      this.establishmentName,
      this.qualification,
      this.specialities,
      this.aboutMe,
      this.professionalHighlights,
      this.consultationFee,
      this.appointmentSlotDuration,
      this.practisingSince,
      this.dateCreated,
      this.dateUpdated,
      this.appointmentRelatedDetails});

  Doctors.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    doctorRoleId = json['DoctorRoleId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    prefix = json['Prefix'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    gender = json['Gender'];
    birthDate = json['BirthDate'];
    imageURL = json['ImageURL'];
    locality = json['Locality'];
    address = json['Address'];
    locationCoordsLongitude = json['LocationCoords_Longitude'];
    locationCoordsLattitude = json['LocationCoords_Lattitude'];
    establishmentName = json['EstablishmentName'];
    qualification = json['Qualification'];
    specialities = json['Specialities'] ?? '';
    aboutMe = json['AboutMe'];
    professionalHighlights = json['ProfessionalHighlights'];
    consultationFee = json['ConsultationFee'];
    appointmentSlotDuration = json['AppointmentSlotDuration'];
    practisingSince = json['PractisingSince'];
    dateCreated = json['DateCreated'];
    dateUpdated = json['DateUpdated'];
    appointmentRelatedDetails = json['AppointmentRelatedDetails'] != null
        ? new AppointmentRelatedDetails.fromJson(
            json['AppointmentRelatedDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['DoctorRoleId'] = this.doctorRoleId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Prefix'] = this.prefix;
    data['PhoneNumber'] = this.phoneNumber;
    data['Email'] = this.email;
    data['Gender'] = this.gender;
    data['BirthDate'] = this.birthDate;
    data['ImageURL'] = this.imageURL;
    data['Locality'] = this.locality;
    data['Address'] = this.address;
    data['LocationCoords_Longitude'] = this.locationCoordsLongitude;
    data['LocationCoords_Lattitude'] = this.locationCoordsLattitude;
    data['EstablishmentName'] = this.establishmentName;
    data['Qualification'] = this.qualification;
    data['Specialities'] = this.specialities;
    data['AboutMe'] = this.aboutMe;
    data['ProfessionalHighlights'] = this.professionalHighlights;
    data['ConsultationFee'] = this.consultationFee;
    data['AppointmentSlotDuration'] = this.appointmentSlotDuration;
    data['PractisingSince'] = this.practisingSince;
    data['DateCreated'] = this.dateCreated;
    data['DateUpdated'] = this.dateUpdated;
    if (this.appointmentRelatedDetails != null) {
      data['AppointmentRelatedDetails'] =
          this.appointmentRelatedDetails.toJson();
    }
    return data;
  }
}

class AppointmentRelatedDetails {
  String userId;
  String nodeId;
  String businessServiceId;
  String operationalTimeZone;
  List<String> workingHours;

  AppointmentRelatedDetails(
      {this.userId,
      this.nodeId,
      this.businessServiceId,
      this.operationalTimeZone,
      this.workingHours});

  AppointmentRelatedDetails.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    nodeId = json['NodeId'];
    businessServiceId = json['BusinessServiceId'];
    operationalTimeZone = json['OperationalTimeZone'];
    workingHours = json['WorkingHours'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['NodeId'] = this.nodeId;
    data['BusinessServiceId'] = this.businessServiceId;
    data['OperationalTimeZone'] = this.operationalTimeZone;
    data['WorkingHours'] = this.workingHours;
    return data;
  }
}
