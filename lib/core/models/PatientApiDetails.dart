class PatientApiDetails {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  User user;
  String context;
  List<String> clientIps;
  String aPIVersion;

  PatientApiDetails(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.user,
      this.context,
      this.clientIps,
      this.aPIVersion});

  PatientApiDetails.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    client =
        json['Client'] != null ? new Client.fromJson(json['Client']) : null;
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
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
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['Context'] = this.context;
    data['ClientIps'] = this.clientIps;
    data['APIVersion'] = this.aPIVersion;
    return data;
  }
}

class Data {
  Patient patient;

  Data({this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    patient =
        json['Patient'] != null ? new Patient.fromJson(json['Patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patient != null) {
      data['Patient'] = this.patient.toJson();
    }
    return data;
  }
}

class Patient {
  String id;
  String userId;
  User user;
  String displayId;
  String ehrId;
  String healthProfile;

  Patient({
    this.id,
    this.userId,
    this.user,
    this.displayId,
    this.ehrId,
    this.healthProfile,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    displayId = json['DisplayId'];
    ehrId = json['EhrId'];
    healthProfile = json['HealthProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserId'] = this.userId;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    data['DisplayId'] = this.displayId;
    data['EhrId'] = this.ehrId;
    data['HealthProfile'] = this.healthProfile;
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
  String role;

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
    role = json['Role'];
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
    data['Role'] = this.role;
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
  DateTime birthDate;
  String age;
  String phone;
  String email;
  String imageResourceId;
  String activeSince;

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
      this.activeSince});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prefix = json['Prefix'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    displayName = json['DisplayName'];
    gender = json['Gender'];
    birthDate = DateTime.parse(json['BirthDate']);
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
    data['BirthDate'] = this.birthDate.toIso8601String();
    data['Age'] = this.age;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['ImageResourceId'] = this.imageResourceId;
    data['ActiveSince'] = this.activeSince;
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
