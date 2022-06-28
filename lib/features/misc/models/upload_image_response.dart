class UploadImageResponse {
  String? status;
  String? message;
  Data? data;

  UploadImageResponse({this.status, this.message, this.data});

  UploadImageResponse.fromJson(Map<String, dynamic> json) {
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
  List<Details>? details;

  Data({this.details});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? fileName;
  String? resourceId;
  String? url;
  String? mimeType;
  int? size;

  Details({this.fileName, this.resourceId, this.url, this.mimeType, this.size});

  Details.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    url = json['Url_Public'];
    mimeType = json['MimeType'];
    size = json['Size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FileName'] = fileName;
    data['ResourceId'] = resourceId;
    data['Url_Public'] = url;
    data['MimeType'] = mimeType;
    data['Size'] = size;
    return data;
  }
}
