import 'package:json_annotation/json_annotation.dart';

import 'GetTaskOfAHACarePlanResponse.dart';

@JsonSerializable(nullable: true)
class StartTaskOfAHACarePlanResponse {
  String status;
  String message;
  dynamic data;

  StartTaskOfAHACarePlanResponse({this.status, this.message, this.data});

  StartTaskOfAHACarePlanResponse.fromJson(Map<String, dynamic> json) {
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

@JsonSerializable(nullable: true)
class Data {
  Task task;

  Data({this.task});

  Data.fromJson(Map<String, dynamic> json) {
    task = json['task'] != null ? Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (task != null) {
      data['task'] = task.toJson();
    }
    return data;
  }
}
