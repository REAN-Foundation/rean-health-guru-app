class GetMyAssesmentIdResponse {
  String status;
  String message;
  Data data;

  GetMyAssesmentIdResponse({this.status, this.message, this.data});

  GetMyAssesmentIdResponse.fromJson(Map<String, dynamic> json) {
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
  Assessment assessment;

  Data({this.assessment});

  Data.fromJson(Map<String, dynamic> json) {
    assessment = json['assessment'] != null
        ? Assessment.fromJson(json['assessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessment != null) {
      data['assessment'] = assessment.toJson();
    }
    return data;
  }
}

class Assessment {
  String id;
  String patientUserId;
  String title;
  String assessmentTemplateId;
  String assessmentDate;
  String overallStatus;
  List<String> symptomsRecorded;

  Assessment(
      {this.id,
      this.patientUserId,
      this.title,
      this.assessmentTemplateId,
      this.assessmentDate,
      this.overallStatus,
      this.symptomsRecorded});

  Assessment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientUserId = json['PatientUserId'];
    title = json['Title'];
    assessmentTemplateId = json['AssessmentTemplateId'];
    assessmentDate = json['AssessmentDate'];
    overallStatus = json['OverallStatus'];
    /*if (json['SymptomsRecorded'] != null) {
      symptomsRecorded = new List<Null>();
      json['SymptomsRecorded'].forEach((v) {
        symptomsRecorded.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PatientUserId'] = patientUserId;
    data['Title'] = title;
    data['AssessmentTemplateId'] = assessmentTemplateId;
    data['AssessmentDate'] = assessmentDate;
    data['OverallStatus'] = overallStatus;
    /*if (this.symptomsRecorded != null) {
      data['SymptomsRecorded'] =
          this.symptomsRecorded.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
