class GetAllRecordResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  GetAllRecordResponse({this.status, this.message, this.httpCode, this.data});

  GetAllRecordResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  PatientDocuments patientDocuments;

  Data({this.patientDocuments});

  Data.fromJson(Map<String, dynamic> json) {
    patientDocuments = json['PatientDocuments'] != null
        ? new PatientDocuments.fromJson(json['PatientDocuments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientDocuments != null) {
      data['PatientDocuments'] = this.patientDocuments.toJson();
    }
    return data;
  }
}

class PatientDocuments {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  PatientDocuments(
      {this.totalCount,
      this.retrievedCount,
      this.pageIndex,
      this.itemsPerPage,
      this.order,
      this.orderedBy,
      this.items});

  PatientDocuments.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['RetrievedCount'] = this.retrievedCount;
    data['PageIndex'] = this.pageIndex;
    data['ItemsPerPage'] = this.itemsPerPage;
    data['Order'] = this.order;
    data['OrderedBy'] = this.orderedBy;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String ehrId;
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
  DateTime recordDate;
  DateTime uploadedDate;

  Items(
      {this.id,
      this.ehrId,
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

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ehrId = json['EhrId'];
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
    recordDate = DateTime.parse(json['RecordDate']);
    uploadedDate = DateTime.parse(json['UploadedDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['EhrId'] = this.ehrId;
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
    data['RecordDate'] = this.recordDate.toIso8601String();
    data['UploadedDate'] = this.uploadedDate.toIso8601String();
    return data;
  }
}
