class DrugsLibraryPojo {
  String status;
  String message;
  int httpCode;
  Data data;

  DrugsLibraryPojo({this.status, this.message, this.httpCode, this.data});

  DrugsLibraryPojo.fromJson(Map<String, dynamic> json) {
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
  Drugs drugs;

  Data({this.drugs});

  Data.fromJson(Map<String, dynamic> json) {
    drugs = json['Drugs'] != null ? new Drugs.fromJson(json['Drugs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drugs != null) {
      data['Drugs'] = this.drugs.toJson();
    }
    return data;
  }
}

class Drugs {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  Drugs(
      {this.totalCount,
      this.retrievedCount,
      this.pageIndex,
      this.itemsPerPage,
      this.order,
      this.orderedBy,
      this.items});

  Drugs.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    retrievedCount = json['RetrievedCount'];
    pageIndex = json['PageIndex'];
    itemsPerPage = json['ItemsPerPage'];
    order = json['Order'];
    orderedBy = json['OrderedBy'];
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['RetrievedCount'] = this.retrievedCount;
    data['PageIndex'] = this.pageIndex;
    data['ItemsPerPage'] = this.itemsPerPage;
    data['Order'] = this.order;
    data['OrderedBy'] = this.orderedBy;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String ehrId;
  String drugName;
  String genericName;
  String ingredients;
  Null strength;
  String otherCommercialNames;
  String manufacturer;
  String otherInformation;

  Items(
      {this.id,
      this.ehrId,
      this.drugName,
      this.genericName,
      this.ingredients,
      this.strength,
      this.otherCommercialNames,
      this.manufacturer,
      this.otherInformation});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ehrId = json['EhrId'];
    drugName = json['DrugName'];
    genericName = json['GenericName'];
    ingredients = json['Ingredients'];
    strength = json['Strength'];
    otherCommercialNames = json['OtherCommercialNames'];
    manufacturer = json['Manufacturer'];
    otherInformation = json['OtherInformation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['EhrId'] = this.ehrId;
    data['DrugName'] = this.drugName;
    data['GenericName'] = this.genericName;
    data['Ingredients'] = this.ingredients;
    data['Strength'] = this.strength;
    data['OtherCommercialNames'] = this.otherCommercialNames;
    data['Manufacturer'] = this.manufacturer;
    data['OtherInformation'] = this.otherInformation;
    return data;
  }
}
