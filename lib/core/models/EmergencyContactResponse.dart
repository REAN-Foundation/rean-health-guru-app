import 'TeamCarePlanReesponse.dart';

class EmergencyContactResponse {
  String status;
  String message;
  Data data;

  EmergencyContactResponse({this.status, this.message, this.data});

  EmergencyContactResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
      contacts = new List<Contacts>();
      json['contacts'].forEach((v) {
        contacts.add(new Contacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
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
        json['Details'] != null ? new Details.fromJson(json['Details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['UserId'] = this.userId;
    data['Role'] = this.role;
    data['RoleName'] = this.roleName;
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    return data;
  }
}
