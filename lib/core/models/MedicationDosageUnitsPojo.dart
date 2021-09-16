class MedicationDosageUnitsPojo {
  String status;
  String message;
  Data data;

  MedicationDosageUnitsPojo({this.status, this.message, this.data});

  MedicationDosageUnitsPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
      medicationDosageUnits = <MedicationDosageUnits>[];
      json['medicationDosageUnits'].forEach((v) {
        medicationDosageUnits.add(MedicationDosageUnits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicationDosageUnits != null) {
      data['medicationDosageUnits'] =
          medicationDosageUnits.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['uuid'] = uuid;
    return data;
  }
}
