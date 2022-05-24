class LabsListApiResponse {
  String? status;
  String? message;
  Data? data;

  LabsListApiResponse({this.status, this.message, this.data});

  LabsListApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Labs>? labs;

  Data({this.labs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['labs'] != null) {
      labs = <Labs>[];
      json['labs'].forEach((v) {
        labs!.add(Labs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (labs != null) {
      data['labs'] = labs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Labs {
  String? userId;
  String? roleId;
  String? firstName;
  String? lastName;
  String? prefix;
  String? phoneNumber;
  String? email;
  String? gender;
  String? birthDate;
  String? imageURL;
  String? locality;
  String? address;
  String? locationCoordsLongitude;
  String? locationCoordsLattitude;
  String? establishmentName;
  String? specialities;
  int? labType;
  String? aboutUs;
  String? operationalSince;
  String? appointmentSlotDuration;
  String? dateCreated;
  String? dateUpdated;
  AppointmentRelatedDetails? appointmentRelatedDetails;

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
        ? AppointmentRelatedDetails.fromJson(json['AppointmentRelatedDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['RoleId'] = roleId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Prefix'] = prefix;
    data['PhoneNumber'] = phoneNumber;
    data['Email'] = email;
    data['Gender'] = gender;
    data['BirthDate'] = birthDate;
    data['ImageURL'] = imageURL;
    data['Locality'] = locality;
    data['Address'] = address;
    data['LocationCoords_Longitude'] = locationCoordsLongitude;
    data['LocationCoords_Lattitude'] = locationCoordsLattitude;
    data['EstablishmentName'] = establishmentName;
    data['Specialities'] = specialities;
    data['LabType'] = labType;
    data['AboutUs'] = aboutUs;
    data['OperationalSince'] = operationalSince;
    data['AppointmentSlotDuration'] = appointmentSlotDuration;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    if (appointmentRelatedDetails != null) {
      data['AppointmentRelatedDetails'] = appointmentRelatedDetails!.toJson();
    }
    return data;
  }
}

class AppointmentRelatedDetails {
  String? userId;
  String? nodeId;
  String? businessServiceId;
  String? operationalTimeZone;
  List<String>? workingHours;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['NodeId'] = nodeId;
    data['BusinessServiceId'] = businessServiceId;
    data['OperationalTimeZone'] = operationalTimeZone;
    data['WorkingHours'] = workingHours;
    return data;
  }
}
