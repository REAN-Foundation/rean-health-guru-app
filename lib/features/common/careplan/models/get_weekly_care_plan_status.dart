/// Status : "success"
/// Message : "Careplan weekly status fetched successfully!"
/// HttpCode : 200
/// Data : {"CareplanStatus":{"CurrentWeek":2,"DayOfCurrentWeek":3,"Message":"Your careplan is in progress.","TotalWeeks":12,"StartDate":"2022-04-25T00:00:00.000Z","EndDate":"2022-07-18T00:00:00.000Z"}}

class GetWeeklyCarePlanStatus {
  GetWeeklyCarePlanStatus({
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

  GetWeeklyCarePlanStatus.fromJson(dynamic json) {
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

/// CareplanStatus : {"CurrentWeek":2,"DayOfCurrentWeek":3,"Message":"Your careplan is in progress.","TotalWeeks":12,"StartDate":"2022-04-25T00:00:00.000Z","EndDate":"2022-07-18T00:00:00.000Z"}

class Data {
  Data({
    CareplanStatus? careplanStatus,
  }) {
    _careplanStatus = careplanStatus;
  }

  Data.fromJson(dynamic json) {
    _careplanStatus = json['CareplanStatus'] != null
        ? CareplanStatus.fromJson(json['CareplanStatus'])
        : null;
  }

  CareplanStatus? _careplanStatus;

  CareplanStatus? get careplanStatus => _careplanStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_careplanStatus != null) {
      map['CareplanStatus'] = _careplanStatus?.toJson();
    }
    return map;
  }
}

/// CurrentWeek : 2
/// DayOfCurrentWeek : 3
/// Message : "Your careplan is in progress."
/// TotalWeeks : 12
/// StartDate : "2022-04-25T00:00:00.000Z"
/// EndDate : "2022-07-18T00:00:00.000Z"

class CareplanStatus {
  CareplanStatus({
    int? currentWeek,
    int? dayOfCurrentWeek,
    String? message,
    int? totalWeeks,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _currentWeek = currentWeek;
    _dayOfCurrentWeek = dayOfCurrentWeek;
    _message = message;
    _totalWeeks = totalWeeks;
    _startDate = startDate;
    _endDate = endDate;
  }

  CareplanStatus.fromJson(dynamic json) {
    _currentWeek = json['CurrentWeek'];
    _dayOfCurrentWeek = json['DayOfCurrentWeek'];
    _message = json['Message'];
    _totalWeeks = json['TotalWeeks'];
    _startDate = DateTime.parse(json['StartDate']);
    _endDate = DateTime.parse(json['EndDate']);
  }

  int? _currentWeek;
  int? _dayOfCurrentWeek;
  String? _message;
  int? _totalWeeks;
  DateTime? _startDate;
  DateTime? _endDate;

  int? get currentWeek => _currentWeek;

  int? get dayOfCurrentWeek => _dayOfCurrentWeek;

  String? get message => _message;

  int? get totalWeeks => _totalWeeks;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CurrentWeek'] = _currentWeek;
    map['DayOfCurrentWeek'] = _dayOfCurrentWeek;
    map['Message'] = _message;
    map['TotalWeeks'] = _totalWeeks;
    map['StartDate'] = _startDate!.toIso8601String();
    map['EndDate'] = _endDate!.toIso8601String();
    return map;
  }
}
