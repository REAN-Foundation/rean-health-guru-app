class GetActionOfGoalPlan {
  String status;
  String message;
  Data data;

  GetActionOfGoalPlan({this.status, this.message, this.data});

  GetActionOfGoalPlan.fromJson(Map<String, dynamic> json) {
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
  List<Goals> goals;

  Data({this.goals});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['goals'] != null) {
      goals = <Goals>[];
      json['goals'].forEach((v) {
        goals.add(Goals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (goals != null) {
      data['goals'] = goals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goals {
  int id;
  int assetID;
  String assetType;
  String assetName;
  String description;
  String language;
  String category;
  String source;
  String tags;
  String createdAt;
  String updatedAt;
  bool isChecked = false;

  Goals(
      {this.id,
      this.assetID,
      this.assetType,
      this.assetName,
      this.description,
      this.language,
      this.category,
      this.source,
      this.tags,
      this.createdAt,
      this.updatedAt});

  Goals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetID = json['AssetID'];
    assetType = json['AssetType'];
    assetName = json['AssetName'];
    description = json['Description'];
    language = json['Language'];
    category = json['Category'];
    source = json['Source'];
    tags = json['Tags'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['AssetID'] = assetID;
    data['AssetType'] = assetType;
    data['AssetName'] = assetName;
    data['Description'] = description;
    data['Language'] = language;
    data['Category'] = category;
    data['Source'] = source;
    data['Tags'] = tags;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
