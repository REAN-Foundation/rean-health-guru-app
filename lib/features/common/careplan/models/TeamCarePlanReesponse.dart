class TeamCarePlanReesponse {
  String status;
  String message;
  Data data;

  TeamCarePlanReesponse({this.status, this.message, this.data});

  TeamCarePlanReesponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != String ? Data.fromJson(json['data']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != String) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Team> team;

  Data({this.team});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['team'] != String) {
      team = <Team>[];
      json['team'].forEach((v) {
        team.add(Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (team != String) {
      data['team'] = team.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Team {
  String id;
  int carePlanId;
  String userId;
  int role;
  String roleName;
  String isEmergencyContact;
  Details details;

  Team(
      {this.id,
      this.carePlanId,
      this.userId,
      this.role,
      this.roleName,
      this.isEmergencyContact,
      this.details});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carePlanId = json['CarePlanId'];
    userId = json['UserId'];
    role = json['Role'];
    roleName = json['RoleName'];
    isEmergencyContact = json['IsEmergencyContact'];
    details = json['Details'] != String ? Details.fromJson(json['Details']) : String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['CarePlanId'] = carePlanId;
    data['UserId'] = userId;
    data['Role'] = role;
    data['RoleName'] = roleName;
    data['IsEmergencyContact'] = isEmergencyContact;
    if (details != String) {
      data['Details'] = details.toJson();
    }
    return data;
  }
}

class Details {
  String firstName;
  String lastName;
  String prefix;
  String phoneNumber;
  String email;
  String gender;

  /*String address;
  String imageURL;
  String locationCoordsLongitude;
  String locationCoordsLattitude;
  String displayId;
  String establishmentName;
  String qualification;
  String specialities;
  String aboutMe;
  String professionalHighlights;
  String consultationFee;
  String appointmentSlotDuration;
  String practisingSince;*/
  String relation;

  // String description;

  Details({
    this.firstName,
    this.lastName,
    this.prefix,
    this.phoneNumber,
    this.email,
    this.gender,
    /*this.address,
        this.imageURL,
        this.locationCoordsLongitude,
        this.locationCoordsLattitude,
        this.displayId,
        this.establishmentName,
        this.qualification,
        this.specialities,
        this.aboutMe,
        this.professionalHighlights,
        this.consultationFee,
        this.appointmentSlotDuration,
        this.practisingSince,*/
    this.relation,
    //this.description
  });

  Details.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    prefix = json['Prefix'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    gender = json['Gender'];
    /*address = json['Address'];
    imageURL = json['ImageURL'];
    locationCoordsLongitude = json['LocationCoords_Longitude'];
    locationCoordsLattitude = json['LocationCoords_Lattitude'];
    displayId = json['DisplayId'];
    establishmentName = json['EstablishmentName'];
    qualification = json['Qualification'];
    specialities = json['Specialities'];
    aboutMe = json['AboutMe'];
    professionalHighlights = json['ProfessionalHighlights'];
    consultationFee = json['ConsultationFee'];
    appointmentSlotDuration = json['AppointmentSlotDuration'];
    practisingSince = json['PractisingSince'];*/
    relation = json['Relation'];
    //description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Prefix'] = prefix;
    data['PhoneNumber'] = phoneNumber;
    data['Email'] = email;
    data['Gender'] = gender;
    /*data['Address'] = this.address;
    data['ImageURL'] = this.imageURL;
    data['LocationCoords_Longitude'] = this.locationCoordsLongitude;
    data['LocationCoords_Lattitude'] = this.locationCoordsLattitude;
    data['DisplayId'] = this.displayId;
    data['EstablishmentName'] = this.establishmentName;
    data['Qualification'] = this.qualification;
    data['Specialities'] = this.specialities;
    data['AboutMe'] = this.aboutMe;
    data['ProfessionalHighlights'] = this.professionalHighlights;
    data['ConsultationFee'] = this.consultationFee;
    data['AppointmentSlotDuration'] = this.appointmentSlotDuration;
    data['PractisingSince'] = this.practisingSince;*/
    data['Relation'] = relation;
    //data['Description'] = this.description;
    return data;
  }
}
