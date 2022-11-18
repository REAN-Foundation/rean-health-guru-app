/// Status : "success"
/// Message : "Fetched hospitals associated with health system!"
/// HttpCode : 201
/// Data : {"HealthSystemHospitals":[{"id":"5229787d-35a0-4f9a-9bcd-fc2a51f0ea9c","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Ridges - Stroke"},{"id":"583819bc-67c2-445d-b62f-d16ccb144fd0","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Ridges Specialty"},{"id":"5b180780-a594-4121-97f5-3bc87c39bb8c","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Southdale - Stroke"},{"id":"6f926a44-bb71-4dd0-8501-cbcaa409f242","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Southdale Specialty"},{"id":"dfbb0834-7853-4a81-9f87-73734c044e5f","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Grand Itasca Clinic System"},{"id":"f91e8657-0454-469c-8d36-aac70a887243","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Grand Itasca - Stroke"}]}

class HealthSyetemHospitalPojo {
  HealthSyetemHospitalPojo({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  HealthSyetemHospitalPojo.fromJson(dynamic json) {
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

/// HealthSystemHospitals : [{"id":"5229787d-35a0-4f9a-9bcd-fc2a51f0ea9c","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Ridges - Stroke"},{"id":"583819bc-67c2-445d-b62f-d16ccb144fd0","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Ridges Specialty"},{"id":"5b180780-a594-4121-97f5-3bc87c39bb8c","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Southdale - Stroke"},{"id":"6f926a44-bb71-4dd0-8501-cbcaa409f242","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Southdale Specialty"},{"id":"dfbb0834-7853-4a81-9f87-73734c044e5f","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Grand Itasca Clinic System"},{"id":"f91e8657-0454-469c-8d36-aac70a887243","HealthSystemId":"21a2a9a9-221b-41c0-882e-3771a5164ac0","Name":"Grand Itasca - Stroke"}]

class Data {
  Data({
      List<HealthSystemHospitals>? healthSystemHospitals,}){
    _healthSystemHospitals = healthSystemHospitals;
}

  Data.fromJson(dynamic json) {
    if (json['HealthSystemHospitals'] != null) {
      _healthSystemHospitals = [];
      json['HealthSystemHospitals'].forEach((v) {
        _healthSystemHospitals?.add(HealthSystemHospitals.fromJson(v));
      });
    }
  }
  List<HealthSystemHospitals>? _healthSystemHospitals;

  List<HealthSystemHospitals>? get healthSystemHospitals => _healthSystemHospitals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_healthSystemHospitals != null) {
      map['HealthSystemHospitals'] = _healthSystemHospitals?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "5229787d-35a0-4f9a-9bcd-fc2a51f0ea9c"
/// HealthSystemId : "21a2a9a9-221b-41c0-882e-3771a5164ac0"
/// Name : "Ridges - Stroke"

class HealthSystemHospitals {
  HealthSystemHospitals({
      String? id, 
      String? healthSystemId, 
      String? name,}){
    _id = id;
    _healthSystemId = healthSystemId;
    _name = name;
}

  HealthSystemHospitals.fromJson(dynamic json) {
    _id = json['id'];
    _healthSystemId = json['HealthSystemId'];
    _name = json['Name'];
  }
  String? _id;
  String? _healthSystemId;
  String? _name;

  String? get id => _id;
  String? get healthSystemId => _healthSystemId;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['HealthSystemId'] = _healthSystemId;
    map['Name'] = _name;
    return map;
  }

}