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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['error'] = error;
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    if (user != null) {
      data['user'] = user.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['RoleId'] = roleId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['PhoneNumber'] = phoneNumber;
    data['Email'] = email;
    data['UserName'] = userName;
    data['VerifiedPhoneNumber'] = verifiedPhoneNumber;
    data['BasicProfileComplete'] = basicProfileComplete;
    data['DateCreated'] = dateCreated;
    data['DateUpdated'] = dateUpdated;
    return data;
  }
}
