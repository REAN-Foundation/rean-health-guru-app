class SearchSymptomAssesmentTempleteResponse {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  User user;
  String context;
  List<String> clientIps;
  String aPIVersion;

  SearchSymptomAssesmentTempleteResponse(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.user,
      this.context,
      this.clientIps,
      this.aPIVersion});

  SearchSymptomAssesmentTempleteResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    context = json['Context'];
    clientIps = json['ClientIps'].cast<String>();
    aPIVersion = json['APIVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['HttpCode'] = httpCode;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (client != null) {
      data['Client'] = client.toJson();
    }
    if (user != null) {
      data['User'] = user.toJson();
    }
    data['Context'] = context;
    data['ClientIps'] = clientIps;
    data['APIVersion'] = aPIVersion;
    return data;
  }
}

class Data {
  SymptomAssessmentTemplates symptomAssessmentTemplates;

  Data({this.symptomAssessmentTemplates});

  Data.fromJson(Map<String, dynamic> json) {
    symptomAssessmentTemplates = json['SymptomAssessmentTemplates'] != null
        ? SymptomAssessmentTemplates.fromJson(
            json['SymptomAssessmentTemplates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (symptomAssessmentTemplates != null) {
      data['SymptomAssessmentTemplates'] = symptomAssessmentTemplates.toJson();
    }
    return data;
  }
}

class SymptomAssessmentTemplates {
  int totalCount;
  int retrievedCount;
  int pageIndex;
  int itemsPerPage;
  String order;
  String orderedBy;
  List<Items> items;

  SymptomAssessmentTemplates(
      {this.totalCount,
      this.retrievedCount,
      this.pageIndex,
      this.itemsPerPage,
      this.order,
      this.orderedBy,
      this.items});

  SymptomAssessmentTemplates.fromJson(Map<String, dynamic> json) {
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
  String title;
  String description;
  List<String> tags;
  List<TemplateSymptomTypes> templateSymptomTypes;

  Items(
      {this.id,
      this.title,
      this.description,
      this.tags,
      this.templateSymptomTypes});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    description = json['Description'];
    tags = json['Tags'].cast<String>();
    if (json['TemplateSymptomTypes'] != null) {
      templateSymptomTypes = [];
      json['TemplateSymptomTypes'].forEach((v) {
        templateSymptomTypes.add(TemplateSymptomTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Title'] = title;
    data['Description'] = description;
    data['Tags'] = tags;
    if (templateSymptomTypes != null) {
      data['TemplateSymptomTypes'] =
          templateSymptomTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TemplateSymptomTypes {
  int index;
  String symptomTypeId;
  String symptom;
  String description;

  TemplateSymptomTypes(
      {this.index, this.symptomTypeId, this.symptom, this.description});

  TemplateSymptomTypes.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    symptomTypeId = json['SymptomTypeId'];
    symptom = json['Symptom'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['SymptomTypeId'] = symptomTypeId;
    data['Symptom'] = symptom;
    data['Description'] = description;
    return data;
  }
}

class Client {
  String clientName;
  String clientCode;

  Client({this.clientName, this.clientCode});

  Client.fromJson(Map<String, dynamic> json) {
    clientName = json['ClientName'];
    clientCode = json['ClientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientName'] = clientName;
    data['ClientCode'] = clientCode;
    return data;
  }
}

class User {
  String userId;
  String displayName;
  String phone;
  String email;
  String userName;
  int currentRoleId;
  int iat;
  int exp;

  User(
      {this.userId,
      this.displayName,
      this.phone,
      this.email,
      this.userName,
      this.currentRoleId,
      this.iat,
      this.exp});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    displayName = json['DisplayName'];
    phone = json['Phone'];
    email = json['Email'];
    userName = json['UserName'];
    currentRoleId = json['CurrentRoleId'];
    iat = json['iat'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['DisplayName'] = displayName;
    data['Phone'] = phone;
    data['Email'] = email;
    data['UserName'] = userName;
    data['CurrentRoleId'] = currentRoleId;
    data['iat'] = iat;
    data['exp'] = exp;
    return data;
  }
}
