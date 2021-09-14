import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class BaseResponse {
  String status;
  String message;
  String error;
  dynamic data;

  BaseResponse({this.status, this.message, this.error, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
