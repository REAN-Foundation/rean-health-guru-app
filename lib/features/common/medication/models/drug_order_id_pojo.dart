class DrugOrderIdPojo {
  String? status;
  String? message;
  Data? data;

  DrugOrderIdPojo({this.status, this.message, this.data});

  DrugOrderIdPojo.fromJson(Map<String, dynamic> json) {
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
  DrugOrder? drugOrder;

  Data({this.drugOrder});

  Data.fromJson(Map<String, dynamic> json) {
    drugOrder = json['drugOrder'] != null
        ? DrugOrder.fromJson(json['drugOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (drugOrder != null) {
      data['drugOrder'] = drugOrder!.toJson();
    }
    return data;
  }
}

class DrugOrder {
  String? id;
  String? patientUserId;
  String? doctorUserId;
  String? displayId;
  String? visitId;
  String? suggestedPharmacyId;
  int? currentState;
  String? referencedOrderId;
  String? updatedAt;
  String? createdAt;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['DoctorUserId'] = doctorUserId;
    data['DisplayId'] = displayId;
    data['VisitId'] = visitId;
    data['SuggestedPharmacyId'] = suggestedPharmacyId;
    data['CurrentState'] = currentState;
    data['ReferencedOrderId'] = referencedOrderId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
