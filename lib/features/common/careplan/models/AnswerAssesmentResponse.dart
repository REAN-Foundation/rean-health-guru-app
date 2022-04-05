import 'StartAssesmentResponse.dart';

class AnswerAssesmentResponse {
  String? status;
  String? message;
  Data? data;

  AnswerAssesmentResponse({this.status, this.message, this.data});

  AnswerAssesmentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Assessmment? assessmment;

  Data({this.assessmment});

  Data.fromJson(Map<String, dynamic> json) {
    assessmment = json['assessmment'] != null
        ? Assessmment.fromJson(json['assessmment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessmment != null) {
      data['assessmment'] = assessmment!.toJson();
    }
    return data;
  }
}
