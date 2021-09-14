import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class UserData {
  String status;
  String message;
  String error;
  Data data;

  UserData({this.status, this.message, this.error, this.data});

  UserData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String accessToken;
  User user;

  Data({this.accessToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String userId;
  String roleId;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  bool verifiedPhoneNumber;
  bool basicProfileComplete;
  String dateCreated;
  String dateUpdated;

  User(
      {this.userId,
      this.roleId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.userName,
      this.verifiedPhoneNumber,
      this.basicProfileComplete,
      this.dateCreated,
      this.dateUpdated});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    roleId = json['RoleId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    userName = json['UserName'];
    verifiedPhoneNumber = json['VerifiedPhoneNumber'];
    basicProfileComplete = json['BasicProfileComplete'];
    dateCreated = json['DateCreated'];
    dateUpdated = json['DateUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['RoleId'] = this.roleId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['PhoneNumber'] = this.phoneNumber;
    data['Email'] = this.email;
    data['UserName'] = this.userName;
    data['VerifiedPhoneNumber'] = this.verifiedPhoneNumber;
    data['BasicProfileComplete'] = this.basicProfileComplete;
    data['DateCreated'] = this.dateCreated;
    data['DateUpdated'] = this.dateUpdated;
    return data;
  }
}
