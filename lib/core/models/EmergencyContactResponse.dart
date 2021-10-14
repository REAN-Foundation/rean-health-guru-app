class EmergencyContactResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  EmergencyContactResponse(
      {this.status, this.message, this.httpCode, this.data});

  EmergencyContactResponse.fromJson(Map<String, dynamic> json) {
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
  EmergencyContacts emergencyContacts;

  Data({this.emergencyContacts});

  Data.fromJson(Map<String, dynamic> json) {
    emergencyContacts = json['EmergencyContacts'] != null
        ? new EmergencyContacts.fromJson(json['EmergencyContacts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.emergencyContacts != null) {
      data['EmergencyContacts'] = this.emergencyContacts.toJson();
    }
    return data;
  }
}

class EmergencyContacts {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  EmergencyContacts(
      {this.totalCount,
        this.retrievedCount,
        this.pageIndex,
        this.itemsPerPage,
        this.order,
        this.orderedBy,
        this.items});

  EmergencyContacts.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['RetrievedCount'] = this.retrievedCount;
    data['PageIndex'] = this.pageIndex;
    data['ItemsPerPage'] = this.itemsPerPage;
    data['Order'] = this.order;
    data['OrderedBy'] = this.orderedBy;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String patientUserId;
  String contactPersonId;
  ContactPerson contactPerson;
  String contactRelation;
  String addressId;
  String address;
  String organizationId;
  String organization;
  bool isAvailableForEmergency;
  String timeOfAvailability;
  String description;
  String additionalPhoneNumbers;

  Items(
      {this.id,
        this.patientUserId,
        this.contactPersonId,
        this.contactPerson,
        this.contactRelation,
        this.addressId,
        this.address,
        this.organizationId,
        this.organization,
        this.isAvailableForEmergency,
        this.timeOfAvailability,
        this.description,
        this.additionalPhoneNumbers});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    contactPersonId = json['ContactPersonId'];
    contactPerson = json['ContactPerson'] != null
        ? new ContactPerson.fromJson(json['ContactPerson'])
        : null;
    contactRelation = json['ContactRelation'];
    addressId = json['AddressId'];
    address = json['Address'];
    organizationId = json['OrganizationId'];
    organization = json['Organization'];
    isAvailableForEmergency = json['IsAvailableForEmergency'];
    timeOfAvailability = json['TimeOfAvailability'];
    description = json['Description'];
    additionalPhoneNumbers = json['AdditionalPhoneNumbers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['ContactPersonId'] = this.contactPersonId;
    if (this.contactPerson != null) {
      data['ContactPerson'] = this.contactPerson.toJson();
    }
    data['ContactRelation'] = this.contactRelation;
    data['AddressId'] = this.addressId;
    data['Address'] = this.address;
    data['OrganizationId'] = this.organizationId;
    data['Organization'] = this.organization;
    data['IsAvailableForEmergency'] = this.isAvailableForEmergency;
    data['TimeOfAvailability'] = this.timeOfAvailability;
    data['Description'] = this.description;
    data['AdditionalPhoneNumbers'] = this.additionalPhoneNumbers;
    return data;
  }
}

class ContactPerson {
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

  ContactPerson(
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
        this.activeSince });

  ContactPerson.fromJson(Map<String, dynamic> json) {
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
