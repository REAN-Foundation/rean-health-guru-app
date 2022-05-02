class DoctorAppoinmentBookedSuccessfully {
  String? status;
  String? message;
  Data? data;

  DoctorAppoinmentBookedSuccessfully({this.status, this.message, this.data});

  DoctorAppoinmentBookedSuccessfully.fromJson(Map<String, dynamic> json) {
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
  Appointment? appointment;

  Data({this.appointment});

  Data.fromJson(Map<String, dynamic> json) {
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    return data;
  }
}

class Appointment {
  String? id;
  String? businessNodeId;
  String? customerId;
  String? businessUserId;
  String? businessServiceId;
  String? businessNodeName;
  String? businessServiceName;
  String? businessUserName;
  String? customerName;
  String? date;
  String? startTime;
  String? endTime;
  DateTime? startTimeUtc;
  DateTime? endTimeUtc;
  String? type;
  String? note;
  String? status;
  String? statusCode;
  int? fees;
  int? tax;
  int? tip;
  int? discount;
  String? couponCode;
  int? total;
  bool? isPaid;
  String? transactionId;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['business_node_id'] = businessNodeId;
    data['customer_id'] = customerId;
    data['business_user_id'] = businessUserId;
    data['business_service_id'] = businessServiceId;
    data['business_node_name'] = businessNodeName;
    data['business_service_name'] = businessServiceName;
    data['business_user_name'] = businessUserName;
    data['customer_name'] = customerName;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['start_time_utc'] = startTimeUtc;
    data['end_time_utc'] = endTimeUtc;
    data['type'] = type;
    data['note'] = note;
    data['status'] = status;
    data['status_code'] = statusCode;
    data['fees'] = fees;
    data['tax'] = tax;
    data['tip'] = tip;
    data['discount'] = discount;
    data['coupon_code'] = couponCode;
    data['total'] = total;
    data['is_paid'] = isPaid;
    data['transaction_id'] = transactionId;
    return data;
  }
}
