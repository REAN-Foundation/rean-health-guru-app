class CheckUserExistOrNotResonse {
  String? status;
  String? message;
  String? error;
  dynamic data;

  CheckUserExistOrNotResonse(
      {this.status, this.message, this.error, this.data});

  CheckUserExistOrNotResonse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    error = json['Error'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['Error'] = error;
    data['Data'] = this.data;
    return data;
  }
}
