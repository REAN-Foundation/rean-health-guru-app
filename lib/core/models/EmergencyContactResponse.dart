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
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
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
        ? EmergencyContacts.fromJson(json['EmergencyContacts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (emergencyContacts != null) {
      data['EmergencyContacts'] = emergencyContacts.toJson();
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
      items = [];
      json['Items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items.map((v) => v.toJson()).toList();
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
<<<<<<< HEAD

=======
>>>>>>> main
  //String address;
  String organizationId;
  String organization;
  bool isAvailableForEmergency;
  String timeOfAvailability;
  String description;
  String additionalPhoneNumbers;
<<<<<<< HEAD
  String email;

  Items(
      {this.id,
      this.patientUserId,
      this.contactPersonId,
      this.contactPerson,
      this.contactRelation,
      this.addressId,
      //this.address,
      this.organizationId,
      this.organization,
      this.isAvailableForEmergency,
      this.timeOfAvailability,
      this.description,
      this.additionalPhoneNumbers});
=======

  Items(
      {this.id,
        this.patientUserId,
        this.contactPersonId,
        this.contactPerson,
        this.contactRelation,
        this.addressId,
        //this.address,
      this.organizationId,
        this.organization,
        this.isAvailableForEmergency,
        this.timeOfAvailability,
        this.description,
        this.additionalPhoneNumbers});
>>>>>>> main

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    contactPersonId = json['ContactPersonId'];
    contactPerson = json['ContactPerson'] != null
        ? ContactPerson.fromJson(json['ContactPerson'])
        : null;
    contactRelation = json['ContactRelation'];
    addressId = json['AddressId'];
<<<<<<< HEAD
    email = json['Email'];
=======
>>>>>>> main
    //address = json['Address'];
    organizationId = json['OrganizationId'];
    organization = json['Organization'];
    isAvailableForEmergency = json['IsAvailableForEmergency'];
    timeOfAvailability = json['TimeOfAvailability'];
    description = json['Description'];
    additionalPhoneNumbers = json['AdditionalPhoneNumbers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['ContactPersonId'] = contactPersonId;
    if (contactPerson != null) {
      data['ContactPerson'] = contactPerson.toJson();
    }
    data['ContactRelation'] = contactRelation;
    data['AddressId'] = addressId;
<<<<<<< HEAD
    data['Email'] = email;
=======
>>>>>>> main
    //data['Address'] = address;
    data['OrganizationId'] = organizationId;
    data['Organization'] = organization;
    data['IsAvailableForEmergency'] = isAvailableForEmergency;
    data['TimeOfAvailability'] = timeOfAvailability;
    data['Description'] = description;
    data['AdditionalPhoneNumbers'] = additionalPhoneNumbers;
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
