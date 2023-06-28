/// Status : "success"
/// Message : "Participant retrieved successfully!"
/// HttpCode : 200
/// Data : {"id":"b74e7e55-2bef-4086-8a19-13eb1349b590","ReferenceId":"744969e2-5573-481a-93d2-31018e9cbd8a","Context":{"id":"69816bd1-e20d-4421-b4ca-2bbe17369559","Type":"Person","ReferenceId":"744969e2-5573-481a-93d2-31018e9cbd8a","CreatedAt":"2023-05-02T11:40:24.559Z","UpdatedAt":"2023-05-02T11:40:24.559Z","DeletedAt":null},"Client":{"id":"9704ce81-6e73-45b5-9295-e3caf8416aed","Name":"REAN Internal client for mobile application","Code":"REAN-App","Email":"pradnya.pacharne@reanfoundation.org","IsActive":false},"Prefix":"Mr.","FirstName":"Sachin","LastName":"Tendulkar","CountryCode":"+91","Phone":"1234567890","Email":"sachin.tendulkar@gmail.com","Gender":"Male","BirthDate":"1974-04-24","OnboardingDate":"2023-05-02"}

class AwardsUserDetails {
  AwardsUserDetails({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  AwardsUserDetails.fromJson(dynamic json) {
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

/// id : "b74e7e55-2bef-4086-8a19-13eb1349b590"
/// ReferenceId : "744969e2-5573-481a-93d2-31018e9cbd8a"
/// Context : {"id":"69816bd1-e20d-4421-b4ca-2bbe17369559","Type":"Person","ReferenceId":"744969e2-5573-481a-93d2-31018e9cbd8a","CreatedAt":"2023-05-02T11:40:24.559Z","UpdatedAt":"2023-05-02T11:40:24.559Z","DeletedAt":null}
/// Client : {"id":"9704ce81-6e73-45b5-9295-e3caf8416aed","Name":"REAN Internal client for mobile application","Code":"REAN-App","Email":"pradnya.pacharne@reanfoundation.org","IsActive":false}
/// Prefix : "Mr."
/// FirstName : "Sachin"
/// LastName : "Tendulkar"
/// CountryCode : "+91"
/// Phone : "1234567890"
/// Email : "sachin.tendulkar@gmail.com"
/// Gender : "Male"
/// BirthDate : "1974-04-24"
/// OnboardingDate : "2023-05-02"

class Data {
  Data({
      String? id, 
      String? referenceId, 
      Context? context, 
      Client? client, 
      String? prefix, 
      String? firstName, 
      String? lastName, 
      String? countryCode, 
      String? phone, 
      String? email, 
      String? gender, 
      String? birthDate, 
      String? onboardingDate,}){
    _id = id;
    _referenceId = referenceId;
    _context = context;
    _client = client;
    _prefix = prefix;
    _firstName = firstName;
    _lastName = lastName;
    _countryCode = countryCode;
    _phone = phone;
    _email = email;
    _gender = gender;
    _birthDate = birthDate;
    _onboardingDate = onboardingDate;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _referenceId = json['ReferenceId'];
    _context = json['Context'] != null ? Context.fromJson(json['Context']) : null;
    _client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
    _prefix = json['Prefix'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
    _countryCode = json['CountryCode'];
    _phone = json['Phone'];
    _email = json['Email'];
    _gender = json['Gender'];
    _birthDate = json['BirthDate'];
    _onboardingDate = json['OnboardingDate'];
  }
  String? _id;
  String? _referenceId;
  Context? _context;
  Client? _client;
  String? _prefix;
  String? _firstName;
  String? _lastName;
  String? _countryCode;
  String? _phone;
  String? _email;
  String? _gender;
  String? _birthDate;
  String? _onboardingDate;

  String? get id => _id;
  String? get referenceId => _referenceId;
  Context? get context => _context;
  Client? get client => _client;
  String? get prefix => _prefix;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get countryCode => _countryCode;
  String? get phone => _phone;
  String? get email => _email;
  String? get gender => _gender;
  String? get birthDate => _birthDate;
  String? get onboardingDate => _onboardingDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ReferenceId'] = _referenceId;
    if (_context != null) {
      map['Context'] = _context?.toJson();
    }
    if (_client != null) {
      map['Client'] = _client?.toJson();
    }
    map['Prefix'] = _prefix;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    map['CountryCode'] = _countryCode;
    map['Phone'] = _phone;
    map['Email'] = _email;
    map['Gender'] = _gender;
    map['BirthDate'] = _birthDate;
    map['OnboardingDate'] = _onboardingDate;
    return map;
  }

}

/// id : "9704ce81-6e73-45b5-9295-e3caf8416aed"
/// Name : "REAN Internal client for mobile application"
/// Code : "REAN-App"
/// Email : "pradnya.pacharne@reanfoundation.org"
/// IsActive : false

class Client {
  Client({
      String? id, 
      String? name, 
      String? code, 
      String? email, 
      bool? isActive,}){
    _id = id;
    _name = name;
    _code = code;
    _email = email;
    _isActive = isActive;
}

  Client.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
    _code = json['Code'];
    _email = json['Email'];
    _isActive = json['IsActive'];
  }
  String? _id;
  String? _name;
  String? _code;
  String? _email;
  bool? _isActive;

  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get email => _email;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Name'] = _name;
    map['Code'] = _code;
    map['Email'] = _email;
    map['IsActive'] = _isActive;
    return map;
  }

}

/// id : "69816bd1-e20d-4421-b4ca-2bbe17369559"
/// Type : "Person"
/// ReferenceId : "744969e2-5573-481a-93d2-31018e9cbd8a"
/// CreatedAt : "2023-05-02T11:40:24.559Z"
/// UpdatedAt : "2023-05-02T11:40:24.559Z"
/// DeletedAt : null

class Context {
  Context({
      String? id, 
      String? type, 
      String? referenceId, 
      String? createdAt, 
      String? updatedAt, 
      dynamic deletedAt,}){
    _id = id;
    _type = type;
    _referenceId = referenceId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  Context.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['Type'];
    _referenceId = json['ReferenceId'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _deletedAt = json['DeletedAt'];
  }
  String? _id;
  String? _type;
  String? _referenceId;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;

  String? get id => _id;
  String? get type => _type;
  String? get referenceId => _referenceId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Type'] = _type;
    map['ReferenceId'] = _referenceId;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['DeletedAt'] = _deletedAt;
    return map;
  }

}