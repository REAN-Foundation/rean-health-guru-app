/// Status : "success"
/// Message : "Participant badges retrieved successfully!"
/// HttpCode : 200
/// Data : [{"ParticipantId":"b74e7e55-2bef-4086-8a19-13eb1349b590","Badge":{"id":"c732f85f-6735-49c9-9648-518fbfe551ff","Name":"7-Day Healthy Nutrition Choice","Description":"Badge awarded choosing healthy nutrition choices for 7-days consistently.","Category":{"id":"197bad4d-9297-4b77-af4c-0ca7ce7ef298","Name":"Nutrition","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"AcquiredDate":"2023-01-06","Reason":"Badge awarded choosing healthy nutrition choices for 7-days consistently.","CreatedAt":"2023-05-08T09:49:54.837Z"}]

class GetMyAwards {
  GetMyAwards({
      String? status, 
      String? message, 
      int? httpCode, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetMyAwards.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _httpCode = json['HttpCode'];
    if (json['Data'] != null) {
      _data = [];
      json['Data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _status;
  String? _message;
  int? _httpCode;
  List<Data>? _data;

  String? get status => _status;
  String? get message => _message;
  int? get httpCode => _httpCode;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    map['HttpCode'] = _httpCode;
    if (_data != null) {
      map['Data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ParticipantId : "b74e7e55-2bef-4086-8a19-13eb1349b590"
/// Badge : {"id":"c732f85f-6735-49c9-9648-518fbfe551ff","Name":"7-Day Healthy Nutrition Choice","Description":"Badge awarded choosing healthy nutrition choices for 7-days consistently.","Category":{"id":"197bad4d-9297-4b77-af4c-0ca7ce7ef298","Name":"Nutrition","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"}
/// AcquiredDate : "2023-01-06"
/// Reason : "Badge awarded choosing healthy nutrition choices for 7-days consistently."
/// CreatedAt : "2023-05-08T09:49:54.837Z"

class Data {
  Data({
      String? participantId, 
      Badge? badge, 
      String? acquiredDate, 
      String? reason, 
      String? createdAt,}){
    _participantId = participantId;
    _badge = badge;
    _acquiredDate = acquiredDate;
    _reason = reason;
    _createdAt = createdAt;
}

  Data.fromJson(dynamic json) {
    _participantId = json['ParticipantId'];
    _badge = json['Badge'] != null ? Badge.fromJson(json['Badge']) : null;
    _acquiredDate = json['AcquiredDate'];
    _reason = json['Reason'];
    _createdAt = json['CreatedAt'];
  }
  String? _participantId;
  Badge? _badge;
  String? _acquiredDate;
  String? _reason;
  String? _createdAt;

  String? get participantId => _participantId;
  Badge? get badge => _badge;
  String? get acquiredDate => _acquiredDate;
  String? get reason => _reason;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ParticipantId'] = _participantId;
    if (_badge != null) {
      map['Badge'] = _badge?.toJson();
    }
    map['AcquiredDate'] = _acquiredDate;
    map['Reason'] = _reason;
    map['CreatedAt'] = _createdAt;
    return map;
  }

}

/// id : "c732f85f-6735-49c9-9648-518fbfe551ff"
/// Name : "7-Day Healthy Nutrition Choice"
/// Description : "Badge awarded choosing healthy nutrition choices for 7-days consistently."
/// Category : {"id":"197bad4d-9297-4b77-af4c-0ca7ce7ef298","Name":"Nutrition","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"}
/// ImageUrl : "https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"

class Badge {
  Badge({
      String? id, 
      String? name, 
      String? description, 
      Category? category, 
      String? imageUrl,}){
    _id = id;
    _name = name;
    _description = description;
    _category = category;
    _imageUrl = imageUrl;
}

  Badge.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
    _description = json['Description'];
    _category = json['Category'] != null ? Category.fromJson(json['Category']) : null;
    _imageUrl = json['ImageUrl'];
  }
  String? _id;
  String? _name;
  String? _description;
  Category? _category;
  String? _imageUrl;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  Category? get category => _category;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Name'] = _name;
    map['Description'] = _description;
    if (_category != null) {
      map['Category'] = _category?.toJson();
    }
    map['ImageUrl'] = _imageUrl;
    return map;
  }

}

/// id : "197bad4d-9297-4b77-af4c-0ca7ce7ef298"
/// Name : "Nutrition"
/// ImageUrl : "https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"

class Category {
  Category({
      String? id, 
      String? name, 
      String? imageUrl,}){
    _id = id;
    _name = name;
    _imageUrl = imageUrl;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
    _imageUrl = json['ImageUrl'];
  }
  String? _id;
  String? _name;
  String? _imageUrl;

  String? get id => _id;
  String? get name => _name;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Name'] = _name;
    map['ImageUrl'] = _imageUrl;
    return map;
  }

}