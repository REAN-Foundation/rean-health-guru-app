class GetAllRecordResponse {
  String status;
  String message;
  Data data;

  GetAllRecordResponse({this.status, this.message, this.data});

  GetAllRecordResponse.fromJson(Map<String, dynamic> json) {
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
  List<Documents> documents;

  Data({this.documents});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (documents != null) {
      data['documents'] = documents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  String id;
  String documentType;
  String displayId;
  String patientUserId;
  String labUserId;
  String pharmacyUserId;
  String doctorUserId;
  String doctorVisitId;
  String labOrderId;
  String drugOrderId;
  String addedBy;
  String fileName;
  String resourceId;
  String urlAuth;
  String mimeType;
  int size;
  DateTime dateCreated;
  DateTime createdAt;
  DateTime updatedAt;

  Documents(
      {this.id,
      this.documentType,
      this.displayId,
      this.patientUserId,
      this.labUserId,
      this.pharmacyUserId,
      this.doctorUserId,
      this.doctorVisitId,
      this.labOrderId,
      this.drugOrderId,
      this.addedBy,
      this.fileName,
      this.resourceId,
      this.urlAuth,
      this.mimeType,
      this.size,
      this.dateCreated,
      this.createdAt,
      this.updatedAt});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentType = json['DocumentType'];
    displayId = json['DisplayId'];
    patientUserId = json['PatientUserId'];
    labUserId = json['LabUserId'];
    pharmacyUserId = json['PharmacyUserId'];
    doctorUserId = json['DoctorUserId'];
    doctorVisitId = json['DoctorVisitId'];
    labOrderId = json['LabOrderId'];
    drugOrderId = json['DrugOrderId'];
    addedBy = json['AddedBy'];
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    urlAuth = json['Url_Auth'];
    mimeType = json['MimeType'];
    size = json['Size'];
    dateCreated = DateTime.parse(json['DateCreated']);
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['DocumentType'] = documentType;
    data['DisplayId'] = displayId;
    data['PatientUserId'] = patientUserId;
    data['LabUserId'] = labUserId;
    data['PharmacyUserId'] = pharmacyUserId;
    data['DoctorUserId'] = doctorUserId;
    data['DoctorVisitId'] = doctorVisitId;
    data['LabOrderId'] = labOrderId;
    data['DrugOrderId'] = drugOrderId;
    data['AddedBy'] = addedBy;
    data['FileName'] = fileName;
    data['ResourceId'] = resourceId;
    data['Url_Auth'] = urlAuth;
    data['MimeType'] = mimeType;
    data['Size'] = size;
    data['DateCreated'] = dateCreated.toIso8601String();
    data['created_at'] = createdAt.toIso8601String();
    data['updated_at'] = updatedAt.toIso8601String();
    return data;
  }
}
