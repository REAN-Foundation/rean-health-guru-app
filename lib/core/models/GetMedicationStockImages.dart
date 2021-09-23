class GetMedicationStockImages {
  String status;
  String message;
  Data data;

  GetMedicationStockImages({this.status, this.message, this.data});

  GetMedicationStockImages.fromJson(Map<String, dynamic> json) {
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
  List<MedicationStockImages> medicationStockImages;

  Data({this.medicationStockImages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medicationStockImages'] != null) {
      medicationStockImages = <MedicationStockImages>[];
      json['medicationStockImages'].forEach((v) {
        medicationStockImages.add(MedicationStockImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (medicationStockImages != null) {
      data['medicationStockImages'] =
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
  String urlPublic;
  String createdAt;
  String updatedAt;
  bool isSelected = false;

  MedicationStockImages(
      {this.id,
      this.code,
      this.fileName,
      this.resourceId,
      this.urlPublic,
      this.createdAt,
      this.updatedAt});

  MedicationStockImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    fileName = json['FileName'];
    resourceId = json['ResourceId'];
    urlPublic = json['Url_Public'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Code'] = code;
    data['FileName'] = fileName;
    data['ResourceId'] = resourceId;
    data['Url_Public'] = urlPublic;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
