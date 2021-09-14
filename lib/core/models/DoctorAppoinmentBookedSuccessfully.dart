import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class DoctorAppoinmentBookedSuccessfully {
  String status;
  String message;
  Data data;

  DoctorAppoinmentBookedSuccessfully({this.status, this.message, this.data});

  DoctorAppoinmentBookedSuccessfully.fromJson(Map<String, dynamic> json) {
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
  Appointment appointment;

  Data({this.appointment});

  Data.fromJson(Map<String, dynamic> json) {
    appointment = json['appointment'] != null
        ? new Appointment.fromJson(json['appointment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointment != null) {
      data['appointment'] = this.appointment.toJson();
    }
    return data;
  }
}

class Appointment {
  String id;
  String businessNodeId;
  String customerId;
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
  String type;
  String note;
  String status;
  String statusCode;
  int fees;
  int tax;
  int tip;
  int discount;
  String couponCode;
  int total;
  bool isPaid;
  String transactionId;

  Appointment(
      {this.id,
      this.businessNodeId,
      this.customerId,
      this.businessUserId,
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
      this.transactionId});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessNodeId = json['business_node_id'];
    customerId = json['customer_id'];
    businessUserId = json['business_user_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_node_id'] = this.businessNodeId;
    data['customer_id'] = this.customerId;
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
    return data;
  }
}
