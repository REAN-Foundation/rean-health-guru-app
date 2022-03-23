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
  Drugs drugs;

  Data({this.drugs});

  Data.fromJson(Map<String, dynamic> json) {
    drugs = json['Drugs'] != null ? Drugs.fromJson(json['Drugs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (drugs != null) {
      data['Drugs'] = drugs.toJson();
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
      items = <Items>[];
      json['Items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCount'] = totalCount;
    data['RetrievedCount'] = retrievedCount;
    data['PageIndex'] = pageIndex;
    data['ItemsPerPage'] = itemsPerPage;
    data['Order'] = order;
    data['OrderedBy'] = orderedBy;
    if (items != null) {
      data['Items'] = items.map((v) => v.toJson()).toList();
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
  String strength;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['EhrId'] = ehrId;
    data['DrugName'] = drugName;
    data['GenericName'] = genericName;
    data['Ingredients'] = ingredients;
    data['Strength'] = strength;
    data['OtherCommercialNames'] = otherCommercialNames;
    data['Manufacturer'] = manufacturer;
    data['OtherInformation'] = otherInformation;
    return data;
  }
}
