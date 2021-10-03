class UserData {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  String context;
  List<String> clientIps;
  String aPIVersion;

  UserData(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.context,
      this.clientIps,
      this.aPIVersion});

  UserData.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    client =
        json['Client'] != null ? new Client.fromJson(json['Client']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.client != null) {
      data['Client'] = this.client.toJson();
    }
    data['Context'] = this.context;
    data['ClientIps'] = this.clientIps;
    data['APIVersion'] = this.aPIVersion;
    return data;
  }
}

class Data {
  String accessToken;
  User user;
  int roleId;
  bool isProfileComplete;

  Data({this.accessToken, this.user, this.roleId, this.isProfileComplete});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    roleId = json['RoleId'];
    isProfileComplete = json['IsProfileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccessToken'] = this.accessToken;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['RoleId'] = this.roleId;
    data['IsProfileComplete'] = this.isProfileComplete;
    return data;
  }
}

class User {
  String id;
  String userName;
  String personId;
  Person person;
  String lastLogin;
  String defaultTimeZone;
  String currentTimeZone;
  int roleId;
  Role role;

  User(
      {this.id,
      this.userName,
      this.personId,
      this.person,
      this.lastLogin,
      this.defaultTimeZone,
      this.currentTimeZone,
      this.roleId,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['UserName'];
    personId = json['PersonId'];
    person =
        json['Person'] != null ? new Person.fromJson(json['Person']) : null;
    lastLogin = json['LastLogin'];
    defaultTimeZone = json['DefaultTimeZone'];
    currentTimeZone = json['CurrentTimeZone'];
    roleId = json['RoleId'];
    role = json['Role'] != null ? new Role.fromJson(json['Role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserName'] = this.userName;
    data['PersonId'] = this.personId;
    if (this.person != null) {
      data['Person'] = this.person.toJson();
    }
    data['LastLogin'] = this.lastLogin;
    data['DefaultTimeZone'] = this.defaultTimeZone;
    data['CurrentTimeZone'] = this.currentTimeZone;
    data['RoleId'] = this.roleId;
    if (this.role != null) {
      data['Role'] = this.role.toJson();
    }
    return data;
  }
}

class Person {
  String id;
  String prefix;
  String firstName;
  String middleName;
  String lastName;
  String displayName;
  String gender;
  String birthDate;
  String age;
  String phone;
  String email;
  String imageResourceId;
  String activeSince;
  List<String> roles;
  List<String> addresses;

  Person(
      {this.id,
      this.prefix,
      this.firstName,
      this.middleName,
      this.lastName,
      this.displayName,
      this.gender,
      this.birthDate,
      this.age,
      this.phone,
      this.email,
      this.imageResourceId,
      this.activeSince,
      this.roles,
      this.addresses});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prefix = json['Prefix'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    displayName = json['DisplayName'];
    gender = json['Gender'];
    birthDate = json['BirthDate'];
    age = json['Age'];
    phone = json['Phone'];
    email = json['Email'];
    imageResourceId = json['ImageResourceId'];
    activeSince = json['ActiveSince'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Prefix'] = this.prefix;
    data['FirstName'] = this.firstName;
    data['MiddleName'] = this.middleName;
    data['LastName'] = this.lastName;
    data['DisplayName'] = this.displayName;
    data['Gender'] = this.gender;
    data['BirthDate'] = this.birthDate;
    data['Age'] = this.age;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['ImageResourceId'] = this.imageResourceId;
    data['ActiveSince'] = this.activeSince;

    return data;
  }
}

class Role {
  int id;
  String roleName;

  Role({this.id, this.roleName});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['RoleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['RoleName'] = this.roleName;
    return data;
  }
}

class Client {
  String clientName;
  String clientCode;

  Client({this.clientName, this.clientCode});

  Client.fromJson(Map<String, dynamic> json) {
    clientName = json['ClientName'];
    clientCode = json['ClientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientName'] = this.clientName;
    data['ClientCode'] = this.clientCode;
    return data;
  }
}
