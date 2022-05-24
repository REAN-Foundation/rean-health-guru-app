class PatientApiDetails {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  PatientApiDetails({this.status, this.message, this.httpCode, this.data});

  PatientApiDetails.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Patient? patient;

  Data({this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    patient =
        json['Patient'] != null ? Patient.fromJson(json['Patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['Patient'] = patient!.toJson();
    }
    return data;
  }
}

class Patient {
  String? id;
  String? userId;
  User? user;
  String? displayId;
  String? ehrId;

  Patient({
    this.id,
    this.userId,
    this.user,
    this.displayId,
    this.ehrId,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    displayId = json['DisplayId'];
    ehrId = json['EhrId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UserId'] = userId;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    data['DisplayId'] = displayId;
    data['EhrId'] = ehrId;

    return data;
  }
}

class User {
  String? id;
  String? userName;
  String? personId;
  Person? person;
  String? lastLogin;
  String? defaultTimeZone;
  String? currentTimeZone;
  int? roleId;
  String? role;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UserName'] = userName;
    data['PersonId'] = personId;
    if (person != null) {
      data['Person'] = person!.toJson();
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
  String? id;
  String? prefix;
  String? firstName;
  String? middleName;
  String? lastName;
  String? displayName;
  String? gender;
  DateTime? birthDate;
  String? age;
  String? phone;
  String? email;
  String? imageResourceId;
  String? activeSince;
  List<Addresses>? addresses;

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
    if (json['BirthDate'] != null) {
      birthDate = DateTime.parse(json['BirthDate']);
    } else {
      birthDate = json['BirthDate'];
    }
    age = json['Age'];
    phone = json['Phone'];
    email = json['Email'];
    imageResourceId = json['ImageResourceId'];
    activeSince = json['ActiveSince'];
    if (json['Addresses'] != null) {
      addresses = <Addresses>[];
      json['Addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Prefix'] = prefix;
    data['FirstName'] = firstName;
    data['MiddleName'] = middleName;
    data['LastName'] = lastName;
    data['DisplayName'] = displayName;
    data['Gender'] = gender;
    if (birthDate == null) {
      data['BirthDate'] = birthDate;
    } else {
      data['BirthDate'] = birthDate!.toIso8601String();
    }
    data['Age'] = age;
    data['Phone'] = phone;
    data['Email'] = email;
    data['ImageResourceId'] = imageResourceId;
    data['ActiveSince'] = activeSince;
    if (addresses != null) {
      data['Addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? id;
  String? type;
  String? addressLine;
  String? city;
  String? district;
  String? state;
  String? country;
  String? postalCode;
  double? longitude;
  double? lattitude;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Type'] = type;
    data['AddressLine'] = addressLine;
    data['City'] = city;
    data['District'] = district;
    data['State'] = state;
    data['Country'] = country;
    data['PostalCode'] = postalCode;
    data['Longitude'] = longitude;
    data['Lattitude'] = lattitude;
    return data;
  }
}
