class DrugsLibraryPojo {
  String status;
  String message;
  Data data;

  DrugsLibraryPojo({this.status, this.message, this.data});

  DrugsLibraryPojo.fromJson(Map<String, dynamic> json) {
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
  List<Drugs> drugs;

  Data({this.drugs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['drugs'] != null) {
      drugs = new List<Drugs>();
      json['drugs'].forEach((v) {
        drugs.add(new Drugs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.drugs != null) {
      data['drugs'] = this.drugs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Drugs {
  String name;
  String id;

  Drugs({this.name, this.id});

  Drugs.fromJson(Map<String, dynamic> json) {
    name = json['DrugName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DrugName'] = this.name;
    data['id'] = this.id;
    return data;
  }
}