/// Status : "success"
/// Message : "Patient eligibility for careplan retrieved successfully!"
/// HttpCode : 200
/// Data : {"Eligibility":{"Eligible":false,"Reason":"You need to be atleast 18 years of age before enrolling to this care plan!"}}

class CheckCareplanEligibility {
  CheckCareplanEligibility({
    String? status,
    String? message,
    int? httpCode,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
  }

  CheckCareplanEligibility.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _httpCode = json['HttpCode'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  String? _status;
  String? _message;
  int? _httpCode;
  Data? _data;

  String? get status => _status;

  String? get message => _message;

  int? get httpCode => _httpCode;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    map['HttpCode'] = _httpCode;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }
}

/// Eligibility : {"Eligible":false,"Reason":"You need to be atleast 18 years of age before enrolling to this care plan!"}

class Data {
  Data({
    Eligibility? eligibility,
  }) {
    _eligibility = eligibility;
  }

  Data.fromJson(dynamic json) {
    _eligibility = json['Eligibility'] != null
        ? Eligibility.fromJson(json['Eligibility'])
        : null;
  }

  Eligibility? _eligibility;

  Eligibility? get eligibility => _eligibility;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_eligibility != null) {
      map['Eligibility'] = _eligibility?.toJson();
    }
    return map;
  }
}

/// Eligible : false
/// Reason : "You need to be atleast 18 years of age before enrolling to this care plan!"

class Eligibility {
  Eligibility({
    bool? eligible,
    String? reason,
  }) {
    _eligible = eligible;
    _reason = reason;
  }

  Eligibility.fromJson(dynamic json) {
    _eligible = json['Eligible'];
    _reason = json['Reason'];
  }

  bool? _eligible;
  String? _reason;

  bool? get eligible => _eligible;

  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Eligible'] = _eligible;
    map['Reason'] = _reason;
    return map;
  }
}
