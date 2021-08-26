class CheckUserExistOrNotResonse {
  String status;
  String message;
  String error;
  Data data;

  CheckUserExistOrNotResonse({this.status, this.message, this.error, this.data});

  CheckUserExistOrNotResonse.fromJson(Map<String, dynamic> json) {
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
  Exists exists;

  Data({this.exists});

  Data.fromJson(Map<String, dynamic> json) {
    exists =
    json['exists'] != null ? new Exists.fromJson(json['exists']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exists != null) {
      data['exists'] = this.exists.toJson();
    }
    return data;
  }
}

class Exists {
  bool result;
  String message;

  Exists({this.result, this.message});

  Exists.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}