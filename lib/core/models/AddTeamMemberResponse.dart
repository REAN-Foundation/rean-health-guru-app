import 'TeamCarePlanReesponse.dart';

class AddTeamMemberResponse {
  String status;
  String message;
  Data data;

  AddTeamMemberResponse({this.status, this.message, this.data});

  AddTeamMemberResponse.fromJson(Map<String, dynamic> json) {
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
  TeamMember teamMember;

  Data({this.teamMember});

  Data.fromJson(Map<String, dynamic> json) {
    teamMember = json['teamMember'] != null
        ? new TeamMember.fromJson(json['teamMember'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamMember != null) {
      data['teamMember'] = this.teamMember.toJson();
    }
    return data;
  }
}

class TeamMember {
  String id;
  String carePlanId;
  String userId;
  int role;
  String roleName;
  Details details;

  TeamMember(
      {this.id,
      this.carePlanId,
      this.userId,
      this.role,
      this.roleName,
      this.details});

  TeamMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carePlanId = json['CarePlanId'];
    userId = json['UserId'];
    role = json['Role'];
    roleName = json['RoleName'];
    details =
        json['Details'] != null ? new Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['CarePlanId'] = this.carePlanId;
    data['UserId'] = this.userId;
    data['Role'] = this.role;
    data['RoleName'] = this.roleName;
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    return data;
  }
}
