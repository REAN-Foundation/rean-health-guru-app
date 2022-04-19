class UploadDocumentResponse {
  String? status;
  String? message;
  Data? data;

  UploadDocumentResponse({this.status, this.message, this.data});

  UploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  PatientDocument? patientDocument;

  Data({this.patientDocument});

  Data.fromJson(Map<String, dynamic> json) {
    patientDocument = json['PatientDocument'] != null
        ? PatientDocument.fromJson(json['PatientDocument'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientDocument != null) {
      data['PatientDocument'] = patientDocument!.toJson();
    }
    return data;
  }
}

class PatientDocument {
  String? id;
  String? displayId;
  String? documentType;
  String? patientUserId;
  String? medicalPractitionerUserId;
  String? medicalPractionerRole;
  String? uploadedByUserId;
  String? associatedVisitId;
  String? associatedVisitType;
  String? associatedOrderId;
  String? associatedOrderType;
  String? fileName;
  String? resourceId;
  String? authenticatedUrl;
  String? mimeType;
  int? sizeInKBytes;
  String? recordDate;
  String? uploadedDate;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['DisplayId'] = displayId;
    data['DocumentType'] = documentType;
    data['PatientUserId'] = patientUserId;
    data['MedicalPractitionerUserId'] = medicalPractitionerUserId;
    data['MedicalPractionerRole'] = medicalPractionerRole;
    data['UploadedByUserId'] = uploadedByUserId;
    data['AssociatedVisitId'] = associatedVisitId;
    data['AssociatedVisitType'] = associatedVisitType;
    data['AssociatedOrderId'] = associatedOrderId;
    data['AssociatedOrderType'] = associatedOrderType;
    data['FileName'] = fileName;
    data['ResourceId'] = resourceId;
    data['AuthenticatedUrl'] = authenticatedUrl;
    data['MimeType'] = mimeType;
    data['SizeInKBytes'] = sizeInKBytes;
    data['RecordDate'] = recordDate;
    data['UploadedDate'] = uploadedDate;
    return data;
  }
}
