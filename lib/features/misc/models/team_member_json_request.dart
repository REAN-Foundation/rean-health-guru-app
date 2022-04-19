class TeamMemberJsonRequest {
  String? carePlanId;
  bool? isEmergencyContact;
  String? teamMemberType;
  Details? details;

  TeamMemberJsonRequest(
      {this.carePlanId,
      this.isEmergencyContact,
      this.teamMemberType,
      this.details});

  TeamMemberJsonRequest.fromJson(Map<String, dynamic> json) {
    carePlanId = json['CarePlanId'];
    isEmergencyContact = json['IsEmergencyContact'];
    teamMemberType = json['TeamMemberType'];
    details =
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CarePlanId'] = carePlanId;
    data['IsEmergencyContact'] = isEmergencyContact;
    data['TeamMemberType'] = teamMemberType;
    if (details != null) {
      data['Details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  String? userId;
  String? firstName;
  String? lastName;
  String? prefix;
  String? phoneNumber;
  String? gender;

  Details(
      {this.userId,
      this.firstName,
      this.lastName,
      this.prefix,
      this.phoneNumber,
      this.gender});

  Details.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    prefix = json['Prefix'];
    phoneNumber = json['PhoneNumber'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Prefix'] = prefix;
    data['PhoneNumber'] = phoneNumber;
    data['Gender'] = gender;
    return data;
  }
}
