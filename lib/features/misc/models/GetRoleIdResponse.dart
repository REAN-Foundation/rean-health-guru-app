class GetRoleIdResponse {
  String status;
  String message;
  int httpCode;
  Data data;
  Client client;
  String context;
  List<String> clientIps;
  String aPIVersion;

  GetRoleIdResponse(
      {this.status,
      this.message,
      this.httpCode,
      this.data,
      this.client,
      this.context,
      this.clientIps,
      this.aPIVersion});

  GetRoleIdResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    httpCode = json['HttpCode'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    client = json['Client'] != null ? Client.fromJson(json['Client']) : null;
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
    data['Context'] = context;
    data['ClientIps'] = clientIps;
    data['APIVersion'] = aPIVersion;
    return data;
  }
}

class Data {
  List<PersonRoleTypes> personRoleTypes;

  Data({this.personRoleTypes});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['PersonRoleTypes'] != null) {
      personRoleTypes = <PersonRoleTypes>[];
      json['PersonRoleTypes'].forEach((v) {
        personRoleTypes.add(PersonRoleTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (personRoleTypes != null) {
      data['PersonRoleTypes'] = personRoleTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PersonRoleTypes {
  int id;
  String roleName;

  PersonRoleTypes({this.id, this.roleName});

  PersonRoleTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['RoleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['RoleName'] = roleName;
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
