import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class LabsListApiResponse {
  String status;
  String message;
  Data data;

  LabsListApiResponse({this.status, this.message, this.data});

  LabsListApiResponse.fromJson(Map<String, dynamic> json) {
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
  List<Labs> labs;

  Data({this.labs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['labs'] != null) {
      labs = new List<Labs>();
      json['labs'].forEach((v) {
        labs.add(new Labs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.labs != null) {
      data['labs'] = this.labs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Labs {
  String userId;
  String roleId;
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
  String specialities;
  int labType;
  String aboutUs;
  String operationalSince;
  String appointmentSlotDuration;
  String dateCreated;
  String dateUpdated;
  AppointmentRelatedDetails appointmentRelatedDetails;

  Labs(
      {this.userId,
        this.roleId,
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
        this.specialities,
        this.labType,
        this.aboutUs,
        this.operationalSince,
        this.appointmentSlotDuration,
        this.dateCreated,
        this.dateUpdated,
        this.appointmentRelatedDetails});

  Labs.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
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
    specialities = json['Specialities'];
    labType = json['LabType'];
    aboutUs = json['AboutUs'];
    operationalSince = json['OperationalSince'];
    appointmentSlotDuration = json['AppointmentSlotDuration'];
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
    data['RoleId'] = this.roleId;
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
    data['Specialities'] = this.specialities;
    data['LabType'] = this.labType;
    data['AboutUs'] = this.aboutUs;
    data['OperationalSince'] = this.operationalSince;
    data['AppointmentSlotDuration'] = this.appointmentSlotDuration;
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