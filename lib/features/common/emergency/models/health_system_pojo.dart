/// Status : "success"
/// Message : "Fetched health systems successfully!"
/// HttpCode : 201
/// Data : {"HealthSystems":[{"id":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"M Health Fairview"},{"id":"39075dd7-7a82-463c-886d-85bcf4e4d600","Name":"Nebraska Health System"},{"id":"432ef5ca-1c40-4719-915a-b3eea3060197","Name":"Kaiser Permanente"},{"id":"9d291ae2-2600-43f4-beec-6dcffe92b801","Name":"Atrium Health"},{"id":"cf77a60b-cd9a-4b01-95b9-a26890a9515d","Name":"UC San Diego Health"},{"id":"e8f01bb4-f354-4066-b4a4-5326ae54b4eb","Name":"Wellstar Health System"}]}

class HealthSystemPojo {
  HealthSystemPojo({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  HealthSystemPojo.fromJson(dynamic json) {
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

/// HealthSystems : [{"id":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"M Health Fairview"},{"id":"39075dd7-7a82-463c-886d-85bcf4e4d600","Name":"Nebraska Health System"},{"id":"432ef5ca-1c40-4719-915a-b3eea3060197","Name":"Kaiser Permanente"},{"id":"9d291ae2-2600-43f4-beec-6dcffe92b801","Name":"Atrium Health"},{"id":"cf77a60b-cd9a-4b01-95b9-a26890a9515d","Name":"UC San Diego Health"},{"id":"e8f01bb4-f354-4066-b4a4-5326ae54b4eb","Name":"Wellstar Health System"}]

class Data {
  Data({
      List<HealthSystems>? healthSystems,}){
    _healthSystems = healthSystems;
}

  Data.fromJson(dynamic json) {
    if (json['HealthSystems'] != null) {
      _healthSystems = [];
      json['HealthSystems'].forEach((v) {
        _healthSystems?.add(HealthSystems.fromJson(v));
      });
    }
  }
  List<HealthSystems>? _healthSystems;

  List<HealthSystems>? get healthSystems => _healthSystems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_healthSystems != null) {
      map['HealthSystems'] = _healthSystems?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "21a2a9a9-221b-41c0-882e-3771a5164ac0"
/// Name : "M Health Fairview"

class HealthSystems {
  HealthSystems({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  HealthSystems.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Name'] = _name;
    return map;
  }

}