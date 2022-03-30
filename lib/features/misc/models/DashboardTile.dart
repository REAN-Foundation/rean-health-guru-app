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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date.toIso8601String();
    data['tile'] = tile;
    data['discription'] = discription;
    return data;
  }
}
