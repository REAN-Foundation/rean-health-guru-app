class TeamMemberJsonRequest {
  String carePlanId;
  bool isEmergencyContact;
  String teamMemberType;
  Details details;

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
    json['Details'] != null ? new Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CarePlanId'] = this.carePlanId;
    data['IsEmergencyContact'] = this.isEmergencyContact;
    data['TeamMemberType'] = this.teamMemberType;
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    return data;
  }
}

class Details {
  String userId;
  String firstName;
  String lastName;
  String prefix;
  String phoneNumber;
  String gender;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Prefix'] = this.prefix;
    data['PhoneNumber'] = this.phoneNumber;
    data['Gender'] = this.gender;
    return data;
  }
}