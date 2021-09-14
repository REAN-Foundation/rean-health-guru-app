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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalTodayCal'] = this.totalTodayCal;
    data['totalBreakfastCal'] = this.totalBreakfastCal;
    data['totalLunchCal'] = this.totalLunchCal;
    data['totalDinnerCal'] = this.totalDinnerCal;
    data['totalMorningSnackCal'] = this.totalMorningSnackCal;
    data['totalAfernoonSnackCal'] = this.totalAfernoonSnackCal;
    data['totalEveningSncakCal'] = this.totalEveningSncakCal;
    data['date'] = this.date;
    return data;
  }
}
