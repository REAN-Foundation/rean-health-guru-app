/// Status : "success"
/// Message : "Patient records deleted successfully!"
/// Data : {"Deleted":true}

class DeleteMyAccount {
  DeleteMyAccount({
    String? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  DeleteMyAccount.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  String? _status;
  String? _message;
  Data? _data;

  String? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }
}

/// Deleted : true

class Data {
  Data({
    bool? deleted,
  }) {
    _deleted = deleted;
  }

  Data.fromJson(dynamic json) {
    _deleted = json['Deleted'];
  }

  bool? _deleted;

  bool? get deleted => _deleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Deleted'] = _deleted;
    return map;
  }
}
