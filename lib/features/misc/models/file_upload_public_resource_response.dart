class FileUploadPublicResourceResponse {
  String? status;
  String? message;
  int? httpCode;
  Data? data;

  FileUploadPublicResourceResponse(
      {this.status, this.message, this.httpCode, this.data});

  FileUploadPublicResourceResponse.fromJson(Map<String, dynamic> json) {
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
  List<FileResources>? fileResources;

  Data({this.fileResources});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['FileResources'] != null) {
      fileResources = [];
      json['FileResources'].forEach((v) {
        fileResources!.add(FileResources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fileResources != null) {
      data['FileResources'] = fileResources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FileResources {
  String? id;
  String? fileName;
  String? url;
  String? ownerUserId;
  String? uploadedByUserId;
  bool? isPublicResource;
  String? mimeType;
  List<Versions>? versions;
  Versions? defaultVersion;

  FileResources(
      {this.id,
      this.fileName,
      this.url,
      this.ownerUserId,
      this.uploadedByUserId,
      this.isPublicResource,
      this.mimeType,
      this.versions,
      this.defaultVersion});

  FileResources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['FileName'];
    url = json['Url'];
    ownerUserId = json['OwnerUserId'];
    uploadedByUserId = json['UploadedByUserId'];
    isPublicResource = json['IsPublicResource'];
    mimeType = json['MimeType'];
    if (json['Versions'] != null) {
      versions = [];
      json['Versions'].forEach((v) {
        versions!.add(Versions.fromJson(v));
      });
    }
    defaultVersion = json['DefaultVersion'] != null
        ? Versions.fromJson(json['DefaultVersion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['FileName'] = fileName;
    data['Url'] = url;
    data['OwnerUserId'] = ownerUserId;
    data['UploadedByUserId'] = uploadedByUserId;
    data['IsPublicResource'] = isPublicResource;
    data['MimeType'] = mimeType;
    if (versions != null) {
      data['Versions'] = versions!.map((v) => v.toJson()).toList();
    }
    if (defaultVersion != null) {
      data['DefaultVersion'] = defaultVersion!.toJson();
    }
    return data;
  }
}

class Versions {
  String? versionId;
  String? resourceId;
  String? version;
  String? fileName;
  String? mimeType;
  String? originalName;
  int? size;
  String? storageKey;
  String? url;
  String? sourceFilePath;

  Versions(
      {this.versionId,
      this.resourceId,
      this.version,
      this.fileName,
      this.mimeType,
      this.originalName,
      this.size,
      this.storageKey,
      this.url,
      this.sourceFilePath});

  Versions.fromJson(Map<String, dynamic> json) {
    versionId = json['VersionId'];
    resourceId = json['ResourceId'];
    version = json['Version'];
    fileName = json['FileName'];
    mimeType = json['MimeType'];
    originalName = json['OriginalName'];
    size = json['Size'];
    storageKey = json['StorageKey'];
    url = json['Url'];
    sourceFilePath = json['SourceFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VersionId'] = versionId;
    data['ResourceId'] = resourceId;
    data['Version'] = version;
    data['FileName'] = fileName;
    data['MimeType'] = mimeType;
    data['OriginalName'] = originalName;
    data['Size'] = size;
    data['StorageKey'] = storageKey;
    data['Url'] = url;
    data['SourceFilePath'] = sourceFilePath;
    return data;
  }
}
