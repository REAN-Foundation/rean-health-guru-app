import 'StartAssesmentResponse.dart';

class AnswerAssesmentResponse {
  String status;
  String message;
  Data data;

  AnswerAssesmentResponse({this.status, this.message, this.data});

  AnswerAssesmentResponse.fromJson(Map<String, dynamic> json) {
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
  Assessmment assessmment;

  Data({this.assessmment});

  Data.fromJson(Map<String, dynamic> json) {
    assessmment = json['assessmment'] != null
        ? new Assessmment.fromJson(json['assessmment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmment != null) {
      data['assessmment'] = this.assessmment.toJson();
    }
    return data;
  }
}
