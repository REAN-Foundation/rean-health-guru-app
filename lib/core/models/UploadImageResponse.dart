import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class UploadImageResponse {
  String status;
  String message;
  Data data;

  UploadImageResponse({this.status, this.message, this.data});

  UploadImageResponse.fromJson(Map<String, dynamic> json) {
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
  List<Details> details;

  Data({this.details});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String fileName;
  String resourceId;
  String url;
  String mimeType;
  int size;

  Details({this.fileName, this.resourceId, this.url, this.mimeType, this.size});

  Details.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    url = json['Url_Public'];
    mimeType = json['MimeType'];
    size = json['Size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    data['ResourceId'] = this.resourceId;
    data['Url_Public'] = this.url;
    data['MimeType'] = this.mimeType;
    data['Size'] = this.size;
    return data;
  }
}
