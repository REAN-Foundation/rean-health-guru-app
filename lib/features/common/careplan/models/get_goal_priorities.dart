class GetGoalPriorities {
  String? status;
  String? message;
  Data? data;

  GetGoalPriorities({this.status, this.message, this.data});

  GetGoalPriorities.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? goals;

  Data({this.goals});

  Data.fromJson(Map<String, dynamic> json) {
    goals = json['goals'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['goals'] = goals;
    return data;
  }
}
