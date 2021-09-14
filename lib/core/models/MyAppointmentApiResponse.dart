import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class MyAppointmentApiResponse {
  String status;
  String message;
  Data data;

  MyAppointmentApiResponse({this.status, this.message, this.data});

  MyAppointmentApiResponse.fromJson(Map<String, dynamic> json) {
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
  List<Appointments> appointments;

  Data({this.appointments});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['appointments'] != null) {
      appointments = new List<Appointments>();
      json['appointments'].forEach((v) {
        appointments.add(new Appointments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointments != null) {
      data['appointments'] = this.appointments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Appointments {
  String id;
  String businessNodeId;
  String customerId;
  String displayId;
  String businessUserId;
  String businessServiceId;
  String businessNodeName;
  String businessServiceName;
  String businessUserName;
  String customerName;
  String date;
  String startTime;
  String endTime;
  DateTime startTimeUtc;
  DateTime endTimeUtc;
  DateTime customerDOB;
  String customerGender;
  String type;
  String note;
  String status;
  String statusCode;
  int fees;
  int tax;
  int tip;
  int discount;
  int couponCode;
  int total;
  bool isPaid;
  String transactionId;
  String patientUserId;
  String providerUserId;

  Appointments(
      {this.id,
      this.businessNodeId,
      this.customerId,
      this.businessUserId,
      this.displayId,
      this.businessServiceId,
      this.businessNodeName,
      this.businessServiceName,
      this.businessUserName,
      this.customerName,
      this.date,
      this.startTime,
      this.endTime,
      this.startTimeUtc,
      this.endTimeUtc,
      this.customerDOB,
      this.customerGender,
      this.type,
      this.note,
      this.status,
      this.statusCode,
      this.fees,
      this.tax,
      this.tip,
      this.discount,
      this.couponCode,
      this.total,
      this.isPaid,
      this.transactionId,
      this.patientUserId,
      this.providerUserId});

  Appointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessNodeId = json['business_node_id'];
    customerId = json['customer_id'];
    businessUserId = json['business_user_id'];
    displayId = json['display_id'];
    businessServiceId = json['business_service_id'];
    businessNodeName = json['business_node_name'];
    businessServiceName = json['business_service_name'];
    businessUserName = json['business_user_name'];
    customerName = json['customer_name'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    startTimeUtc = DateTime.parse(json['start_time_utc']);
    endTimeUtc = DateTime.parse(json['end_time_utc']);
    customerDOB = DateTime.parse(json['customer_dob']);
    customerGender = json['customer_gender'];
    type = json['type'];
    note = json['note'];
    status = json['status'];
    statusCode = json['status_code'];
    fees = json['fees'];
    tax = json['tax'];
    tip = json['tip'];
    discount = json['discount'];
    couponCode = json['coupon_code'];
    total = json['total'];
    isPaid = json['is_paid'];
    transactionId = json['transaction_id'];
    patientUserId = json['PatientUserId'];
    providerUserId = json['ProviderUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_node_id'] = this.businessNodeId;
    data['customer_id'] = this.customerId;
    data['display_id'] = this.displayId;
    data['business_user_id'] = this.businessUserId;
    data['business_service_id'] = this.businessServiceId;
    data['business_node_name'] = this.businessNodeName;
    data['business_service_name'] = this.businessServiceName;
    data['business_user_name'] = this.businessUserName;
    data['customer_name'] = this.customerName;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['start_time_utc'] = this.startTimeUtc;
    data['end_time_utc'] = this.endTimeUtc;
    data['customer_dob'] = this.customerDOB;
    data['customer_gender'] = this.customerGender;
    data['type'] = this.type;
    data['note'] = this.note;
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['fees'] = this.fees;
    data['tax'] = this.tax;
    data['tip'] = this.tip;
    data['discount'] = this.discount;
    data['coupon_code'] = this.couponCode;
    data['total'] = this.total;
    data['is_paid'] = this.isPaid;
    data['transaction_id'] = this.transactionId;
    data['PatientUserId'] = this.patientUserId;
    data['ProviderUserId'] = this.providerUserId;
    return data;
  }
}
