class GetAllRecordResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  GetAllRecordResponse({this.status, this.message, this.httpCode, this.data});

  GetAllRecordResponse.fromJson(Map<String, dynamic> json) {
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
  PatientDocuments? patientDocuments;

  Data({this.patientDocuments});

  Data.fromJson(Map<String, dynamic> json) {
    patientDocuments = json['PatientDocuments'] != null
        ? PatientDocuments.fromJson(json['PatientDocuments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientDocuments != null) {
      data['PatientDocuments'] = patientDocuments!.toJson();
    }
    return data;
  }
}

class PatientDocuments {
  int? totalCount;
  int? retrievedCount;
  int? pageIndex;
  int? itemsPerPage;
  String? order;
  String? orderedBy;
  List<Items>? items;

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
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? ehrId;
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
  DateTime? recordDate;
  DateTime? uploadedDate;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['EhrId'] = ehrId;
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
    data['RecordDate'] = recordDate!.toIso8601String();
    data['UploadedDate'] = uploadedDate!.toIso8601String();
    return data;
  }
}
