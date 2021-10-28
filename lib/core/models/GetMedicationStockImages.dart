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
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
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
      medicationStockImages = <MedicationStockImages>[];
      json['MedicationStockImages'].forEach((v) {
        medicationStockImages.add(MedicationStockImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicationStockImages != null) {
      data['MedicationStockImages'] =
          medicationStockImages.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Code'] = code;
    data['FileName'] = fileName;
    data['ResourceId'] = resourceId;
    data['PublicUrl'] = publicUrl;
    return data;
  }
}
