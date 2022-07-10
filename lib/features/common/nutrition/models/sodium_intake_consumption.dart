class SodiumIntakeConsumption {
  DateTime? date;
  int? count;
  String? discription;

  SodiumIntakeConsumption(this.date, this.count, this.discription);

  SodiumIntakeConsumption.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    count = json['count'];
    discription = json['discription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date!.toIso8601String();
    data['count'] = count;
    data['discription'] = discription;
    return data;
  }
}
