class DrugsLibraryPojo {
  String status;
  String message;
  Data data;

  DrugsLibraryPojo({this.status, this.message, this.data});

  DrugsLibraryPojo.fromJson(Map<String, dynamic> json) {
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
  List<Drugs> drugs;

  Data({this.drugs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['drugs'] != null) {
      drugs = <Drugs>[];
      json['drugs'].forEach((v) {
        drugs.add(Drugs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (drugs != null) {
      data['drugs'] = drugs.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DrugName'] = name;
    data['id'] = id;
    return data;
  }
}
