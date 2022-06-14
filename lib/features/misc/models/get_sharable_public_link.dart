class GetSharablePublicLink {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  GetSharablePublicLink({this.status, this.message, this.httpCode, this.data});

  GetSharablePublicLink.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? patientDocumentLink;

  Data({this.patientDocumentLink});

  Data.fromJson(Map<String, dynamic> json) {
    patientDocumentLink = json['PatientDocumentLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientDocumentLink'] = patientDocumentLink;
    return data;
  }
}
