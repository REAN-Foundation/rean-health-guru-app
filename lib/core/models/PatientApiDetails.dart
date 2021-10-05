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
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (client != null) {
      data['Client'] = client.toJson();
    }
    if (user != null) {
      data['User'] = user.toJson();
    }
    data['Context'] = context;
    data['ClientIps'] = clientIps;
    data['APIVersion'] = aPIVersion;
    return data;
  }
}

class Data {
  Patient patient;

  Data({this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    patient =
        json['Patient'] != null ? Patient.fromJson(json['Patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['Patient'] = patient.toJson();
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
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    displayId = json['DisplayId'];
    ehrId = json['EhrId'];
    healthProfile = json['HealthProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['UserId'] = userId;
    if (user != null) {
      data['User'] = user.toJson();
    }
    data['DisplayId'] = displayId;
    data['EhrId'] = ehrId;
    data['HealthProfile'] = healthProfile;
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
    person = json['Person'] != null ? Person.fromJson(json['Person']) : null;
    lastLogin = json['LastLogin'];
    defaultTimeZone = json['DefaultTimeZone'];
    currentTimeZone = json['CurrentTimeZone'];
    roleId = json['RoleId'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['Role'] = role;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['Prefix'] = prefix;
    data['FirstName'] = firstName;
    data['MiddleName'] = middleName;
    data['LastName'] = lastName;
    data['DisplayName'] = displayName;
    data['Gender'] = gender;
    data['BirthDate'] = birthDate.toIso8601String();
    data['Age'] = age;
    data['Phone'] = phone;
    data['Email'] = email;
    data['ImageResourceId'] = imageResourceId;
    data['ActiveSince'] = activeSince;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ClientName'] = clientName;
    data['ClientCode'] = clientCode;
    return data;
  }
}
