class GetMedicationStockImages {
  String status;
  String message;
  int httpCode;
  Data data;

  GetMedicationStockImages(
      {this.status, this.message, this.httpCode, this.data});

  GetMedicationStockImages.fromJson(Map<String, dynamic> json) {
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
  List<MedicationStockImages> medicationStockImages;

  Data({this.medicationStockImages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['MedicationStockImages'] != null) {
      medicationStockImages = new List<MedicationStockImages>();
      json['MedicationStockImages'].forEach((v) {
        medicationStockImages.add(new MedicationStockImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicationStockImages != null) {
      data['MedicationStockImages'] =
          this.medicationStockImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MedicationStockImages {
  int id;
  String code;
  String fileName;
  String resourceId;
  String publicUrl;
  bool isSelected = false;

  MedicationStockImages(
      {this.id, this.code, this.fileName, this.resourceId, this.publicUrl});

  MedicationStockImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    publicUrl = json['PublicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Code'] = this.code;
    data['FileName'] = this.fileName;
    data['ResourceId'] = this.resourceId;
    data['PublicUrl'] = this.publicUrl;
    return data;
  }
}
