class PatientApiDetails {
  String status;
  String message;
  int httpCode;
  Data data;

  PatientApiDetails({this.status, this.message, this.httpCode, this.data});

  PatientApiDetails.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
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

  Patient(
      {this.id,
        this.userId,
        this.user,
        this.displayId,
        this.ehrId,
        });

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    displayId = json['DisplayId'];
    ehrId = json['EhrId'];
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
    json['Person'] != null ? Person.fromJson(json['Person']) : null;
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
  Null middleName;
  String lastName;
  String displayName;
  String gender;
  DateTime birthDate;
  String age;
  String phone;
  String email;
  String imageResourceId;
  String activeSince;
  List<Addresses> addresses;

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
        this.addresses});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prefix = json['Prefix'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    displayName = json['DisplayName'];
    gender = json['Gender'];
    birthDate =
        json['BirthDate'] != null ? DateTime.parse(json['BirthDate']) : '';
    age = json['Age'];
    phone = json['Phone'];
    email = json['Email'];
    imageResourceId = json['ImageResourceId'];
    activeSince = json['ActiveSince'];
    if (json['Addresses'] != null) {
      addresses = new List<Addresses>();
      json['Addresses'].forEach((v) {
        addresses.add(new Addresses.fromJson(v));
      });
    }
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
    if (this.addresses != null) {
      data['Addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String id;
  String type;
  String addressLine;
  String city;
  String district;
  String state;
  String country;
  String postalCode;
  double longitude;
  double lattitude;

  Addresses(
      {this.id,
        this.type,
        this.addressLine,
        this.city,
        this.district,
        this.state,
        this.country,
        this.postalCode,
        this.longitude,
        this.lattitude});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['Type'];
    addressLine = json['AddressLine'];
    city = json['City'];
    district = json['District'];
    state = json['State'];
    country = json['Country'];
    postalCode = json['PostalCode'];
    longitude = json['Longitude'];
    lattitude = json['Lattitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Type'] = this.type;
    data['AddressLine'] = this.addressLine;
    data['City'] = this.city;
    data['District'] = this.district;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['PostalCode'] = this.postalCode;
    data['Longitude'] = this.longitude;
    data['Lattitude'] = this.lattitude;
    return data;
  }
}
