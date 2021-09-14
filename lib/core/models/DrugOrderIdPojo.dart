class DrugOrderIdPojo {
  String status;
  String message;
  Data data;

  DrugOrderIdPojo({this.status, this.message, this.data});

  DrugOrderIdPojo.fromJson(Map<String, dynamic> json) {
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
  DrugOrder drugOrder;

  Data({this.drugOrder});

  Data.fromJson(Map<String, dynamic> json) {
    drugOrder = json['drugOrder'] != null
        ? new DrugOrder.fromJson(json['drugOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drugOrder != null) {
      data['drugOrder'] = this.drugOrder.toJson();
    }
    return data;
  }
}

class DrugOrder {
  String id;
  String patientUserId;
  String doctorUserId;
  String displayId;
  String visitId;
  String suggestedPharmacyId;
  int currentState;
  Null referencedOrderId;
  String updatedAt;
  String createdAt;

  DrugOrder(
      {this.id,
      this.patientUserId,
      this.doctorUserId,
      this.displayId,
      this.visitId,
      this.suggestedPharmacyId,
      this.currentState,
      this.referencedOrderId,
      this.updatedAt,
      this.createdAt});

  DrugOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    doctorUserId = json['DoctorUserId'];
    displayId = json['DisplayId'];
    visitId = json['VisitId'];
    suggestedPharmacyId = json['SuggestedPharmacyId'];
    currentState = json['CurrentState'];
    referencedOrderId = json['ReferencedOrderId'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PatientUserId'] = this.patientUserId;
    data['DoctorUserId'] = this.doctorUserId;
    data['DisplayId'] = this.displayId;
    data['VisitId'] = this.visitId;
    data['SuggestedPharmacyId'] = this.suggestedPharmacyId;
    data['CurrentState'] = this.currentState;
    data['ReferencedOrderId'] = this.referencedOrderId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
