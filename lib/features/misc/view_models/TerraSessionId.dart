/// expires_in : 900
/// session_id : "ca5757dc-8297-4d8c-b1d8-c246239ac705"
/// status : "success"
/// url : "https://widget.tryterra.co/session/ca5757dc-8297-4d8c-b1d8-c246239ac705"

class TerraSessionId {
  TerraSessionId({
      int? expiresIn, 
      String? sessionId,
      String? message,
      String? status, 
      String? url,}){
    _expiresIn = expiresIn;
    _sessionId = sessionId;
    _status = status;
    _url = url;
}

  TerraSessionId.fromJson(dynamic json) {
    _expiresIn = json['expires_in'];
    _sessionId = json['session_id'];
    _message = json['message'];
    _status = json['status'];
    _url = json['url'];
  }
  int? _expiresIn;
  String? _sessionId;
  String? _message;
  String? _status;
  String? _url;

  int? get expiresIn => _expiresIn;
  String? get sessionId => _sessionId;
  String? get message => _message;
  String? get status => _status;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['expires_in'] = _expiresIn;
    map['session_id'] = _sessionId;
    map['message'] = _message;
    map['status'] = _status;
    map['url'] = _url;
    return map;
  }

}