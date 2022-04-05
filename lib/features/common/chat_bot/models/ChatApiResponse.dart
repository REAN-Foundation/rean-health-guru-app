class ChatApiResponse {
  bool? success;
  String? message;
  Data? data;

  ChatApiResponse({this.success, this.message, this.data});

  ChatApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? responseMessage;

  Data({this.responseMessage});

  Data.fromJson(Map<String, dynamic> json) {
    responseMessage = json['response_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_message'] = responseMessage;
    return data;
  }
}
