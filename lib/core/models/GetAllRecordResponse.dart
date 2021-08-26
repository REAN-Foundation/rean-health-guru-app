class GetAllRecordResponse {
  String status;
  String message;
  Data data;

  GetAllRecordResponse({this.status, this.message, this.data});

  GetAllRecordResponse.fromJson(Map<String, dynamic> json) {
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
  List<Documents> documents;

  Data({this.documents});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<Documents>();
      json['documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['DocumentType'] = this.documentType;
    data['DisplayId'] = this.displayId;
    data['PatientUserId'] = this.patientUserId;
    data['LabUserId'] = this.labUserId;
    data['PharmacyUserId'] = this.pharmacyUserId;
    data['DoctorUserId'] = this.doctorUserId;
    data['DoctorVisitId'] = this.doctorVisitId;
    data['LabOrderId'] = this.labOrderId;
    data['DrugOrderId'] = this.drugOrderId;
    data['AddedBy'] = this.addedBy;
    data['FileName'] = this.fileName;
    data['ResourceId'] = this.resourceId;
    data['Url_Auth'] = this.urlAuth;
    data['MimeType'] = this.mimeType;
    data['Size'] = this.size;
    data['DateCreated'] = this.dateCreated.toIso8601String();
    data['created_at'] = this.createdAt.toIso8601String();
    data['updated_at'] = this.updatedAt.toIso8601String();
    return data;
  }
}