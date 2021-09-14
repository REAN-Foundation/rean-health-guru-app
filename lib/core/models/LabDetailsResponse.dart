import 'package:json_annotation/json_annotation.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';

@JsonSerializable(nullable: true)
class LabDetailsResponse {
  String status;
  String message;
  Data data;

  LabDetailsResponse({this.status, this.message, this.data});

  LabDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  Labs lab;

  Data({this.lab});

  Data.fromJson(Map<String, dynamic> json) {
    lab = json['lab'] != null ? new Labs.fromJson(json['lab']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lab != null) {
      data['lab'] = this.lab.toJson();
    }
    return data;
  }
}
