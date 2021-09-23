class DoctorListApiResponse {
  String status;
  String message;
  Data data;

  DoctorListApiResponse({this.status, this.message, this.data});

  DoctorListApiResponse.fromJson(Map<String, dynamic> json) {
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
  List<Doctors> doctors;

  Data({this.doctors});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors.add(Doctors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctors != null) {
      data['doctors'] = doctors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
        ? AppointmentRelatedDetails.fromJson(json['AppointmentRelatedDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['DoctorRoleId'] = doctorRoleId;
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
    data['Qualification'] = qualification;
    data['Specialities'] = specialities;
    data['AboutMe'] = aboutMe;
    data['ProfessionalHighlights'] = professionalHighlights;
    data['ConsultationFee'] = consultationFee;
    data['AppointmentSlotDuration'] = appointmentSlotDuration;
    data['PractisingSince'] = practisingSince;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    if (appointmentRelatedDetails != null) {
      data['AppointmentRelatedDetails'] = appointmentRelatedDetails.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['NodeId'] = nodeId;
    data['BusinessServiceId'] = businessServiceId;
    data['OperationalTimeZone'] = operationalTimeZone;
    data['WorkingHours'] = workingHours;
    return data;
  }
}
