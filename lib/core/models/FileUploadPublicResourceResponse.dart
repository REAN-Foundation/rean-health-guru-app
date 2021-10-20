class FileUploadPublicResourceResponse {
  String status;
  String message;
  int httpCode;
  Data data;

  FileUploadPublicResourceResponse(
      {this.status, this.message, this.httpCode, this.data});

  FileUploadPublicResourceResponse.fromJson(Map<String, dynamic> json) {
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
  List<FileResources> fileResources;

  Data({this.fileResources});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['FileResources'] != null) {
      fileResources = new List<FileResources>();
      json['FileResources'].forEach((v) {
        fileResources.add(new FileResources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fileResources != null) {
      data['FileResources'] =
          this.fileResources.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FileResources {
  String id;
  String fileName;
  String url;
  String ownerUserId;
  String uploadedByUserId;
  bool isPublicResource;
  String mimeType;
  List<Versions> versions;
  Versions defaultVersion;

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
      versions = new List<Versions>();
      json['Versions'].forEach((v) {
        versions.add(new Versions.fromJson(v));
      });
    }
    defaultVersion = json['DefaultVersion'] != null
        ? new Versions.fromJson(json['DefaultVersion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['FileName'] = this.fileName;
    data['Url'] = this.url;
    data['OwnerUserId'] = this.ownerUserId;
    data['UploadedByUserId'] = this.uploadedByUserId;
    data['IsPublicResource'] = this.isPublicResource;
    data['MimeType'] = this.mimeType;
    if (this.versions != null) {
      data['Versions'] = this.versions.map((v) => v.toJson()).toList();
    }
    if (this.defaultVersion != null) {
      data['DefaultVersion'] = this.defaultVersion.toJson();
    }
    return data;
  }
}

class Versions {
  String versionId;
  String resourceId;
  String version;
  String fileName;
  String mimeType;
  String originalName;
  int size;
  String storageKey;
  String url;
  String sourceFilePath;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VersionId'] = this.versionId;
    data['ResourceId'] = this.resourceId;
    data['Version'] = this.version;
    data['FileName'] = this.fileName;
    data['MimeType'] = this.mimeType;
    data['OriginalName'] = this.originalName;
    data['Size'] = this.size;
    data['StorageKey'] = this.storageKey;
    data['Url'] = this.url;
    data['SourceFilePath'] = this.sourceFilePath;
    return data;
  }
}
