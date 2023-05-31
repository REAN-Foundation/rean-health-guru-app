/// Status : "success"
/// Message : "Participant badges retrieved successfully!"
/// HttpCode : 200
/// Data : {"BadgeList":[{"ParticipantId":"8e7ec11f-517a-4b78-b05b-b274fea7cb33","Badge":{"id":"cba1f1e3-81b9-4ce2-bd6b-423092d09080","Name":"7-Day Medication Adherence","Description":"Badge awarded for 7-day medication adherence.","Category":{"id":"441fe7d2-f3ff-4e96-8080-48bf8733ee09","Name":"Medication","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"AcquiredDate":"2023-04-15","Reason":"Badge awarded for 7-day medication adherence.","CreatedAt":"2023-05-11T07:45:13.006Z"}]}

class GetMyAwardsList {
  GetMyAwardsList({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetMyAwardsList.fromJson(dynamic json) {
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

/// BadgeList : [{"ParticipantId":"8e7ec11f-517a-4b78-b05b-b274fea7cb33","Badge":{"id":"cba1f1e3-81b9-4ce2-bd6b-423092d09080","Name":"7-Day Medication Adherence","Description":"Badge awarded for 7-day medication adherence.","Category":{"id":"441fe7d2-f3ff-4e96-8080-48bf8733ee09","Name":"Medication","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"AcquiredDate":"2023-04-15","Reason":"Badge awarded for 7-day medication adherence.","CreatedAt":"2023-05-11T07:45:13.006Z"}]

class Data {
  Data({
      List<BadgeList>? badgeList,}){
    _badgeList = badgeList;
}

  Data.fromJson(dynamic json) {
    if (json['BadgeList'] != null) {
      _badgeList = [];
      json['BadgeList'].forEach((v) {
        _badgeList?.add(BadgeList.fromJson(v));
      });
    }
  }
  List<BadgeList>? _badgeList;

  List<BadgeList>? get badgeList => _badgeList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_badgeList != null) {
      map['BadgeList'] = _badgeList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ParticipantId : "8e7ec11f-517a-4b78-b05b-b274fea7cb33"
/// Badge : {"id":"cba1f1e3-81b9-4ce2-bd6b-423092d09080","Name":"7-Day Medication Adherence","Description":"Badge awarded for 7-day medication adherence.","Category":{"id":"441fe7d2-f3ff-4e96-8080-48bf8733ee09","Name":"Medication","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"},"ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"}
/// AcquiredDate : "2023-04-15"
/// Reason : "Badge awarded for 7-day medication adherence."
/// CreatedAt : "2023-05-11T07:45:13.006Z"

class BadgeList {
  BadgeList({
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

  BadgeList.fromJson(dynamic json) {
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

/// id : "cba1f1e3-81b9-4ce2-bd6b-423092d09080"
/// Name : "7-Day Medication Adherence"
/// Description : "Badge awarded for 7-day medication adherence."
/// Category : {"id":"441fe7d2-f3ff-4e96-8080-48bf8733ee09","Name":"Medication","ImageUrl":"https://e7.pngegg.com/pngimages/626/893/png-clipart-blue-and-white-check-logo-facebook-social-media-verified-badge-logo-vanity-url-blue-checkmark-blue-angle.png"}
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
  int? _count;
  String? _description;
  Category? _category;
  String? _imageUrl;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  Category? get category => _category;
  String? get imageUrl => _imageUrl;
  int? get count => _count;

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

/// id : "441fe7d2-f3ff-4e96-8080-48bf8733ee09"
/// Name : "Medication"
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