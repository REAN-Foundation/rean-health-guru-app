import 'TeamCarePlanReesponse.dart';

class EmergencyContactResponse {
  String status;
  String message;
  Data data;

  EmergencyContactResponse({this.status, this.message, this.data});

  EmergencyContactResponse.fromJson(Map<String, dynamic> json) {
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
  List<Contacts> contacts;

  Data({this.contacts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts.add(Contacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contacts != null) {
      data['contacts'] = contacts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contacts {
  String id;
  String patientUserId;
  String userId;
  String role;
  String roleName;
  Details details;

  Contacts(
      {this.id,
      this.patientUserId,
      this.userId,
      this.role,
      this.roleName,
      this.details});

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    userId = json['UserId'];
    role = json['Role'];
    roleName = json['RoleName'];
    details =
        json['Details'] != null ? Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['UserId'] = userId;
    data['Role'] = role;
    data['RoleName'] = roleName;
    if (details != null) {
      data['Details'] = details.toJson();
    }
    return data;
  }
}
