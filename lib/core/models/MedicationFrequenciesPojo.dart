class MedicationFrequenciesPojo {
  String status;
  String message;
  Data data;

  MedicationFrequenciesPojo({this.status, this.message, this.data});

  MedicationFrequenciesPojo.fromJson(Map<String, dynamic> json) {
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
  List<String> frequencyUnits;

  Data({this.frequencyUnits});

  Data.fromJson(Map<String, dynamic> json) {
    frequencyUnits = json['frequencyUnits'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequencyUnits'] = this.frequencyUnits;
    return data;
  }
}
/*
class MedicationFrequencies {
  String name;
  String uuid;

  MedicationFrequencies({this.name, this.uuid});

  MedicationFrequencies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uuid'] = this.uuid;
    return data;
  }
}*/
