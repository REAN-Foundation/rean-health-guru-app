import 'GetTaskOfAHACarePlanResponse.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class StartTaskOfAHACarePlanResponse {
  String status;
  String message;
  dynamic data;

  StartTaskOfAHACarePlanResponse({this.status, this.message, this.data});

  StartTaskOfAHACarePlanResponse.fromJson(Map<String, dynamic> json) {
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
@JsonSerializable(nullable: true)
class Data {
  Task task;

  Data({this.task});

  Data.fromJson(Map<String, dynamic> json) {
    task = json['task'] != null ? new Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.task != null) {
      data['task'] = this.task.toJson();
    }
    return data;
  }
}
