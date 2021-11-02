class NutritionResponseStore {
  double totalTodayCal;
  double totalBreakfastCal;
  double totalLunchCal;
  double totalDinnerCal;
  double totalMorningSnackCal;
  double totalAfernoonSnackCal;
  double totalEveningSncakCal;
  String date;

  NutritionResponseStore(
      {this.totalTodayCal,
      this.totalBreakfastCal,
      this.totalLunchCal,
      this.totalDinnerCal,
      this.totalMorningSnackCal,
      this.totalAfernoonSnackCal,
      this.totalEveningSncakCal,
      this.date});

  NutritionResponseStore.fromJson(Map<String, dynamic> json) {
    totalTodayCal = json['totalTodayCal'];
    totalBreakfastCal = json['totalBreakfastCal'];
    totalLunchCal = json['totalLunchCal'];
    totalDinnerCal = json['totalDinnerCal'];
    totalMorningSnackCal = json['totalMorningSnackCal'];
    totalAfernoonSnackCal = json['totalAfernoonSnackCal'];
    totalEveningSncakCal = json['totalEveningSncakCal'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalTodayCal'] = totalTodayCal;
    data['totalBreakfastCal'] = totalBreakfastCal;
    data['totalLunchCal'] = totalLunchCal;
    data['totalDinnerCal'] = totalDinnerCal;
    data['totalMorningSnackCal'] = totalMorningSnackCal;
    data['totalAfernoonSnackCal'] = totalAfernoonSnackCal;
    data['totalEveningSncakCal'] = totalEveningSncakCal;
    data['date'] = date;
    return data;
  }
}
