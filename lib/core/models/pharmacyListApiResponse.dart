class PharmacyListApiResponse {
  String status;
  String message;
  Data data;

  PharmacyListApiResponse({this.status, this.message, this.data});

  PharmacyListApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Pharmacies> pharmacies;

  Data({this.pharmacies});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['pharmacies'] != null) {
      pharmacies = <Pharmacies>[];
      json['pharmacies'].forEach((v) {
        pharmacies.add(Pharmacies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pharmacies != null) {
      data['pharmacies'] = pharmacies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pharmacies {
  String userId;
  String pharmacyRoleId;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String imageURL;
  String locality;
  String address;
  String locationCoordsLongitude;
  String locationCoordsLattitude;
  String pharmacyName;
  String operationalSince;

  Pharmacies(
      {this.userId,
      this.pharmacyRoleId,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthDate,
      this.imageURL,
      this.locality,
      this.address,
      this.locationCoordsLongitude,
      this.locationCoordsLattitude,
      this.pharmacyName,
      this.operationalSince});

  Pharmacies.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    pharmacyRoleId = json['PharmacyRoleId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    gender = json['Gender'];
    birthDate = json['BirthDate'];
    imageURL = json['ImageURL'];
    locality = json['Locality'];
    address = json['Address'];
    locationCoordsLongitude = json['LocationCoords_Longitude'];
    locationCoordsLattitude = json['LocationCoords_Lattitude'];
    pharmacyName = json['PharmacyName'];
    operationalSince = json['OperationalSince'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['PharmacyRoleId'] = pharmacyRoleId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Gender'] = gender;
    data['BirthDate'] = birthDate;
    data['ImageURL'] = imageURL;
    data['Locality'] = locality;
    data['Address'] = address;
    data['LocationCoords_Longitude'] = locationCoordsLongitude;
    data['LocationCoords_Lattitude'] = locationCoordsLattitude;
    data['PharmacyName'] = pharmacyName;
    data['OperationalSince'] = operationalSince;
    return data;
  }
}
