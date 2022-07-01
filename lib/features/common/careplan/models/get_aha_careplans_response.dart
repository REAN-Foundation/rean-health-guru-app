class GetAHACarePlansResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  GetAHACarePlansResponse(
      {this.status, this.message, this.httpCode, this.data});

  GetAHACarePlansResponse.fromJson(Map<String, dynamic> json) {
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
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<AvailablePlans>? availablePlans;

  Data({this.availablePlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['AvailablePlans'] != null) {
      availablePlans = <AvailablePlans>[];
      json['AvailablePlans'].forEach((v) {
        availablePlans!.add(AvailablePlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (availablePlans != null) {
      data['AvailablePlans'] = availablePlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailablePlans {
  String? provider;
  String? name;
  String? code;
  String? displayName;
  int? defaultDurationDays;

  AvailablePlans(
      {this.provider,
      this.name,
      this.code,
      this.displayName,
      this.defaultDurationDays});

  AvailablePlans.fromJson(Map<String, dynamic> json) {
    provider = json['Provider'];
    name = json['Name'];
    code = json['Code'];
    displayName = json['DisplayName'];
    defaultDurationDays = json['DefaultDurationDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Provider'] = provider;
    data['Name'] = name;
    data['Code'] = code;
    data['DisplayName'] = displayName;
    data['DefaultDurationDays'] = defaultDurationDays;
    return data;
  }
}
