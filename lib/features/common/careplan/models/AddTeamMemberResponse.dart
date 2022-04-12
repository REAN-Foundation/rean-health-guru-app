import 'TeamCarePlanReesponse.dart';

class AddTeamMemberResponse {
  String? status;
  String? message;
  Data? data;

  AddTeamMemberResponse({this.status, this.message, this.data});

  AddTeamMemberResponse.fromJson(Map<String, dynamic> json) {
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
  TeamMember? teamMember;

  Data({this.teamMember});

  Data.fromJson(Map<String, dynamic> json) {
    teamMember = json['teamMember'] != null
        ? TeamMember.fromJson(json['teamMember'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teamMember != null) {
      data['teamMember'] = teamMember!.toJson();
    }
    return data;
  }
}

class TeamMember {
  String? id;
  String? carePlanId;
  String? userId;
  int? role;
  String? roleName;
  Details? details;

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
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['CarePlanId'] = carePlanId;
    data['UserId'] = userId;
    data['Role'] = role;
    data['RoleName'] = roleName;
    if (details != null) {
      data['Details'] = details!.toJson();
    }
    return data;
  }
}
