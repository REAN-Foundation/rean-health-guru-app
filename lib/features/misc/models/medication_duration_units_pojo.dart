class MedicationDurationUnitsPojo {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  MedicationDurationUnitsPojo(
      {this.status, this.message, this.httpCode, this.data});

  MedicationDurationUnitsPojo.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? medicationDurationUnits;

  Data({this.medicationDurationUnits});

  Data.fromJson(Map<String, dynamic> json) {
    medicationDurationUnits = json['MedicationDurationUnits'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MedicationDurationUnits'] = medicationDurationUnits;
    return data;
  }
}
