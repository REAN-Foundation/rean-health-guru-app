class MedicationDurationUnitsPojo {
  String status;
  String message;
  Data data;

  MedicationDurationUnitsPojo({this.status, this.message, this.data});

  MedicationDurationUnitsPojo.fromJson(Map<String, dynamic> json) {
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
  List<MedicationDurationUnits> medicationDurationUnits;

  Data({this.medicationDurationUnits});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medicationDurationUnits'] != null) {
      medicationDurationUnits = new List<MedicationDurationUnits>();
      json['medicationDurationUnits'].forEach((v) {
        medicationDurationUnits.add(new MedicationDurationUnits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicationDurationUnits != null) {
      data['medicationDurationUnits'] =
          this.medicationDurationUnits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationDurationUnits {
  String name;
  dynamic id;

  MedicationDurationUnits({this.name, this.id});

  MedicationDurationUnits.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}