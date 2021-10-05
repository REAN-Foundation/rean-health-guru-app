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
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (client != null) {
      data['Client'] = client.toJson();
    }
    data['Context'] = context;
    data['ClientIps'] = clientIps;
    data['APIVersion'] = aPIVersion;
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
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    roleId = json['RoleId'];
    isProfileComplete = json['IsProfileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['AccessToken'] = accessToken;
    if (user != null) {
      data['User'] = user.toJson();
    }
    data['RoleId'] = roleId;
    data['IsProfileComplete'] = isProfileComplete;
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
    person = json['Person'] != null ? Person.fromJson(json['Person']) : null;
    lastLogin = json['LastLogin'];
    defaultTimeZone = json['DefaultTimeZone'];
    currentTimeZone = json['CurrentTimeZone'];
    roleId = json['RoleId'];
    role = json['Role'] != null ? Role.fromJson(json['Role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['UserName'] = userName;
    data['PersonId'] = personId;
    if (person != null) {
      data['Person'] = person.toJson();
    }
    data['LastLogin'] = lastLogin;
    data['DefaultTimeZone'] = defaultTimeZone;
    data['CurrentTimeZone'] = currentTimeZone;
    data['RoleId'] = roleId;
    if (role != null) {
      data['Role'] = role.toJson();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['Prefix'] = prefix;
    data['FirstName'] = firstName;
    data['MiddleName'] = middleName;
    data['LastName'] = lastName;
    data['DisplayName'] = displayName;
    data['Gender'] = gender;
    data['BirthDate'] = birthDate;
    data['Age'] = age;
    data['Phone'] = phone;
    data['Email'] = email;
    data['ImageResourceId'] = imageResourceId;
    data['ActiveSince'] = activeSince;

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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['RoleName'] = roleName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientName'] = clientName;
    data['ClientCode'] = clientCode;
    return data;
  }
}
