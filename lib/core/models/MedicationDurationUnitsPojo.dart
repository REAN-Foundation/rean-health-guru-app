class MedicationDurationUnitsPojo {
  String status;
  String message;
  int httpCode;
  Data data;

  MedicationDurationUnitsPojo(
      {this.status, this.message, this.httpCode, this.data});

  MedicationDurationUnitsPojo.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['HttpCode'] = this.httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<String> medicationDurationUnits;

  Data({this.medicationDurationUnits});

  Data.fromJson(Map<String, dynamic> json) {
    medicationDurationUnits = json['MedicationDurationUnits'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MedicationDurationUnits'] = this.medicationDurationUnits;
    return data;
  }
}
