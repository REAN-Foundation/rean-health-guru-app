import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class GetAvailableDoctorSlot {
  String status;
  String message;
  Data data;

  GetAvailableDoctorSlot({this.status, this.message, this.data});

  GetAvailableDoctorSlot.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<SlotsByDate> slotsByDate;

  Data({this.slotsByDate});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slots_by_date'] != null) {
      slotsByDate = new List<SlotsByDate>();
      json['slots_by_date'].forEach((v) {
        slotsByDate.add(new SlotsByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slotsByDate != null) {
      data['slots_by_date'] = this.slotsByDate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotsByDate {
  String date;
  int weekDayId;
  String weekDay;
  String dayStartTime;
  String dayEndTime;
  List<Slots> slots;

  SlotsByDate(
      {this.date,
      this.weekDayId,
      this.weekDay,
      this.dayStartTime,
      this.dayEndTime,
      this.slots});

  SlotsByDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    weekDayId = json['week_day_id'];
    weekDay = json['week_day'];
    dayStartTime = json['day_start_time'];
    dayEndTime = json['day_end_time'];
    if (json['slots'] != null) {
      slots = new List<Slots>();
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['week_day_id'] = this.weekDayId;
    data['week_day'] = this.weekDay;
    data['day_start_time'] = this.dayStartTime;
    data['day_end_time'] = this.dayEndTime;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  DateTime slotStart;
  DateTime slotEnd;
  bool isAvailable;
  bool isSelected = false;

  Slots({this.slotStart, this.slotEnd, this.isAvailable});

  Slots.fromJson(Map<String, dynamic> json) {
    slotStart = DateTime.parse(json['slot_start']);
    slotEnd = DateTime.parse(json['slot_end']);
    isAvailable = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_start'] = this.slotStart.toIso8601String();
    data['slot_end'] = this.slotEnd.toIso8601String();
    data['available'] = this.isAvailable;
    return data;
  }
}
