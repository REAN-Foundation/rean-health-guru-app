class MovementsTracking {
  DateTime? date;
  int? value;
  String? discription;

  MovementsTracking(this.date, this.value, this.discription);

  MovementsTracking.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    value = json['value'];
    discription = json['discription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date!.toIso8601String();
    data['value'] = value;
    data['discription'] = discription;
    return data;
  }
}
