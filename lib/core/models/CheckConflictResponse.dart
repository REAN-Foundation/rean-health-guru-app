class CheckConflictResponse {
  String status;
  String message;
  String error;
  Data data;

  CheckConflictResponse({this.status, this.message, this.error, this.data});

  CheckConflictResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Result result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  bool canBook;
  dynamic conflictingAppointment;

  Result({this.canBook, this.conflictingAppointment});

  Result.fromJson(Map<String, dynamic> json) {
    canBook = json['CanBook'];
    conflictingAppointment = json['ConflictingAppointment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CanBook'] = this.canBook;
    data['ConflictingAppointment'] = this.conflictingAppointment;
    return data;
  }
}
