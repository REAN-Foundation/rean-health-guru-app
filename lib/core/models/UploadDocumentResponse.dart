class UploadDocumentResponse {
  String status;
  String message;
  Data data;

  UploadDocumentResponse({this.status, this.message, this.data});

  UploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  PatientDocument patientDocument;

  Data({this.patientDocument});

  Data.fromJson(Map<String, dynamic> json) {
    patientDocument = json['PatientDocument'] != null
        ? new PatientDocument.fromJson(json['PatientDocument'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientDocument != null) {
      data['PatientDocument'] = this.patientDocument.toJson();
    }
    return data;
  }
}

class PatientDocument {
  String id;
  String displayId;
  String documentType;
  String patientUserId;
  String medicalPractitionerUserId;
  String medicalPractionerRole;
  String uploadedByUserId;
  String associatedVisitId;
  String associatedVisitType;
  String associatedOrderId;
  String associatedOrderType;
  String fileName;
  String resourceId;
  String authenticatedUrl;
  String mimeType;
  int sizeInKBytes;
  String recordDate;
  String uploadedDate;

  PatientDocument(
      {this.id,
      this.displayId,
      this.documentType,
      this.patientUserId,
      this.medicalPractitionerUserId,
      this.medicalPractionerRole,
      this.uploadedByUserId,
      this.associatedVisitId,
      this.associatedVisitType,
      this.associatedOrderId,
      this.associatedOrderType,
      this.fileName,
      this.resourceId,
      this.authenticatedUrl,
      this.mimeType,
      this.sizeInKBytes,
      this.recordDate,
      this.uploadedDate});

  PatientDocument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['DisplayId'];
    documentType = json['DocumentType'];
    patientUserId = json['PatientUserId'];
    medicalPractitionerUserId = json['MedicalPractitionerUserId'];
    medicalPractionerRole = json['MedicalPractionerRole'];
    uploadedByUserId = json['UploadedByUserId'];
    associatedVisitId = json['AssociatedVisitId'];
    associatedVisitType = json['AssociatedVisitType'];
    associatedOrderId = json['AssociatedOrderId'];
    associatedOrderType = json['AssociatedOrderType'];
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    authenticatedUrl = json['AuthenticatedUrl'];
    mimeType = json['MimeType'];
    sizeInKBytes = json['SizeInKBytes'];
    recordDate = json['RecordDate'];
    uploadedDate = json['UploadedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['DisplayId'] = this.displayId;
    data['DocumentType'] = this.documentType;
    data['PatientUserId'] = this.patientUserId;
    data['MedicalPractitionerUserId'] = this.medicalPractitionerUserId;
    data['MedicalPractionerRole'] = this.medicalPractionerRole;
    data['UploadedByUserId'] = this.uploadedByUserId;
    data['AssociatedVisitId'] = this.associatedVisitId;
    data['AssociatedVisitType'] = this.associatedVisitType;
    data['AssociatedOrderId'] = this.associatedOrderId;
    data['AssociatedOrderType'] = this.associatedOrderType;
    data['FileName'] = this.fileName;
    data['ResourceId'] = this.resourceId;
    data['AuthenticatedUrl'] = this.authenticatedUrl;
    data['MimeType'] = this.mimeType;
    data['SizeInKBytes'] = this.sizeInKBytes;
    data['RecordDate'] = this.recordDate;
    data['UploadedDate'] = this.uploadedDate;
    return data;
  }
}
