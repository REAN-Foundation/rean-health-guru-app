import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class DateStripDate {
  bool isSelected;
  DateTime dateTime;

  DateStripDate(this.isSelected, this.dateTime);
}
