class MedicationDosageUnitsPojo {
  String status;
  String message;
  Data data;

  MedicationDosageUnitsPojo({this.status, this.message, this.data});

  MedicationDosageUnitsPojo.fromJson(Map<String, dynamic> json) {
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
  List<MedicationDosageUnits> medicationDosageUnits;

  Data({this.medicationDosageUnits});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medicationDosageUnits'] != null) {
      medicationDosageUnits = new List<MedicationDosageUnits>();
      json['medicationDosageUnits'].forEach((v) {
        medicationDosageUnits.add(new MedicationDosageUnits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicationDosageUnits != null) {
      data['medicationDosageUnits'] =
          this.medicationDosageUnits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationDosageUnits {
  String name;
  String uuid;

  MedicationDosageUnits({this.name, this.uuid});

  MedicationDosageUnits.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['uuid'] = this.uuid;
    return data;
  }
}
