class GetAHACarePlansResponse {
  String _status;
  String _message;
  Data _data;

  GetAHACarePlansResponse({String status, String message, Data data}) {
    this._status = status;
    this._message = message;
    this._data = data;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get message => _message;
  set message(String message) => _message = message;
  Data get data => _data;
  set data(Data data) => _data = data;

  GetAHACarePlansResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  List<CarePlanTypes> _carePlanTypes;

  Data({List<CarePlanTypes> carePlanTypes}) {
    this._carePlanTypes = carePlanTypes;
  }

  List<CarePlanTypes> get carePlanTypes => _carePlanTypes;
  set carePlanTypes(List<CarePlanTypes> carePlanTypes) =>
      _carePlanTypes = carePlanTypes;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['carePlanTypes'] != null) {
      _carePlanTypes = new List<CarePlanTypes>();
      json['carePlanTypes'].forEach((v) {
        _carePlanTypes.add(new CarePlanTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._carePlanTypes != null) {
      data['carePlanTypes'] =
          this._carePlanTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarePlanTypes {
  int _id;
  String _code;
  String _name;
  int _durationInWeeks;
  String _description;
  String _createdAt;
  String _updatedAt;

  CarePlanTypes(
      {int id,
        String code,
        String name,
        int durationInWeeks,
        String description,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._code = code;
    this._name = name;
    this._durationInWeeks = durationInWeeks;
    this._description = description;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get code => _code;
  set code(String code) => _code = code;
  String get name => _name;
  set name(String name) => _name = name;
  int get durationInWeeks => _durationInWeeks;
  set durationInWeeks(int durationInWeeks) =>
      _durationInWeeks = durationInWeeks;
  String get description => _description;
  set description(String description) => _description = description;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  CarePlanTypes.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _code = json['Code'];
    _name = json['Name'];
    _durationInWeeks = json['DurationInWeeks'];
    _description = json['Description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['Code'] = this._code;
    data['Name'] = this._name;
    data['DurationInWeeks'] = this._durationInWeeks;
    data['Description'] = this._description;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}