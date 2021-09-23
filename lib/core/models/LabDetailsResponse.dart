import 'package:paitent/core/models/labsListApiResponse.dart';

class LabDetailsResponse {
  String status;
  String message;
  Data data;

  LabDetailsResponse({this.status, this.message, this.data});

  LabDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  Labs lab;

  Data({this.lab});

  Data.fromJson(Map<String, dynamic> json) {
    lab = json['lab'] != null ? Labs.fromJson(json['lab']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lab != null) {
      data['lab'] = lab.toJson();
    }
    return data;
  }
}
