import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class TimeSlot {
  int id;
  String title;
  bool isSelected;
  bool isAvaliable;

  TimeSlot({this.id, this.title, this.isSelected, this.isAvaliable});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isSelected = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['isSelected'] = isSelected;
    return data;
  }
}
