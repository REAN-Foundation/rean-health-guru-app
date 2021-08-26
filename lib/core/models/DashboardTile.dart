class DashboardTile {
  DateTime date;
  String tile;
  String discription;

  DashboardTile(this.date, this.tile, this.discription);

  DashboardTile.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    tile = json['tile'];
    discription = json['discription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date.toIso8601String();
    data['tile'] = this.tile;
    data['discription'] = this.discription;
    return data;
  }
}