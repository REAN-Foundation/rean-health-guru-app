/// Status : "success"
/// Data : {"AssessmentId":"093dcdb4-ec1e-4d5a-a3e1-45f9621fcc54","Score":{"PhysicalLimitation_KCCQ_PL_score":62.5,"SymptomFrequency_KCCQ_SF_score":0,"QualityOfLife_KCCQ_QL_score":0,"SocialLimitation_KCCQ_SL_score":16.666666666666668,"ClinicalSummaryScore":31.25,"OverallSummaryScore":19.791666666666668}}

class AssessmentScore {
  AssessmentScore({
      String? status, 
      Data? data,}){
    _status = status;
    _data = data;
}

  AssessmentScore.fromJson(dynamic json) {
    _status = json['Status'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }
  String? _status;
  Data? _data;

  String? get status => _status;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }

}

/// AssessmentId : "093dcdb4-ec1e-4d5a-a3e1-45f9621fcc54"
/// Score : {"PhysicalLimitation_KCCQ_PL_score":62.5,"SymptomFrequency_KCCQ_SF_score":0,"QualityOfLife_KCCQ_QL_score":0,"SocialLimitation_KCCQ_SL_score":16.666666666666668,"ClinicalSummaryScore":31.25,"OverallSummaryScore":19.791666666666668}

class Data {
  Data({
      String? assessmentId, 
      Score? score,
      String? reportURL}){
    _assessmentId = assessmentId;
    _score = score;
    _reportURL = reportURL;
}

  Data.fromJson(dynamic json) {
    _assessmentId = json['AssessmentId'];
    _score = json['Score'] != null ? Score.fromJson(json['Score']) : null;
    _reportURL = json['ReportUrl'];
  }
  String? _assessmentId;
  Score? _score;
  String? _reportURL;

  String? get assessmentId => _assessmentId;
  Score? get score => _score;
  String? get reportURL => _reportURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AssessmentId'] = _assessmentId;
    if (_score != null) {
      map['Score'] = _score?.toJson();
    }
    map['ReportUrl'] = _reportURL;
    return map;
  }

}

/// PhysicalLimitation_KCCQ_PL_score : 62.5
/// SymptomFrequency_KCCQ_SF_score : 0
/// QualityOfLife_KCCQ_QL_score : 0
/// SocialLimitation_KCCQ_SL_score : 16.666666666666668
/// ClinicalSummaryScore : 31.25
/// OverallSummaryScore : 19.791666666666668

class Score {
  Score({
      dynamic physicalLimitationKCCQPLScore,
      dynamic symptomFrequencyKCCQSFScore,
      dynamic qualityOfLifeKCCQQLScore,
      dynamic socialLimitationKCCQSLScore,
      dynamic clinicalSummaryScore,
      dynamic overallSummaryScore,}){
    _physicalLimitationKCCQPLScore = physicalLimitationKCCQPLScore;
    _symptomFrequencyKCCQSFScore = symptomFrequencyKCCQSFScore;
    _qualityOfLifeKCCQQLScore = qualityOfLifeKCCQQLScore;
    _socialLimitationKCCQSLScore = socialLimitationKCCQSLScore;
    _clinicalSummaryScore = clinicalSummaryScore;
    _overallSummaryScore = overallSummaryScore;
}

  Score.fromJson(dynamic json) {
    _physicalLimitationKCCQPLScore = json['PhysicalLimitation_KCCQ_PL_score'];
    _symptomFrequencyKCCQSFScore = json['SymptomFrequency_KCCQ_SF_score'];
    _qualityOfLifeKCCQQLScore = json['QualityOfLife_KCCQ_QL_score'];
    _socialLimitationKCCQSLScore = json['SocialLimitation_KCCQ_SL_score'];
    _clinicalSummaryScore = json['ClinicalSummaryScore'];
    _overallSummaryScore = json['OverallSummaryScore'];
  }
  dynamic _physicalLimitationKCCQPLScore;
  dynamic _symptomFrequencyKCCQSFScore;
  dynamic _qualityOfLifeKCCQQLScore;
  dynamic _socialLimitationKCCQSLScore;
  dynamic _clinicalSummaryScore;
  dynamic _overallSummaryScore;

  dynamic get physicalLimitationKCCQPLScore => _physicalLimitationKCCQPLScore;
  dynamic get symptomFrequencyKCCQSFScore => _symptomFrequencyKCCQSFScore;
  dynamic get qualityOfLifeKCCQQLScore => _qualityOfLifeKCCQQLScore;
  dynamic get socialLimitationKCCQSLScore => _socialLimitationKCCQSLScore;
  dynamic get clinicalSummaryScore => _clinicalSummaryScore;
  dynamic get overallSummaryScore => _overallSummaryScore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PhysicalLimitation_KCCQ_PL_score'] = _physicalLimitationKCCQPLScore;
    map['SymptomFrequency_KCCQ_SF_score'] = _symptomFrequencyKCCQSFScore;
    map['QualityOfLife_KCCQ_QL_score'] = _qualityOfLifeKCCQQLScore;
    map['SocialLimitation_KCCQ_SL_score'] = _socialLimitationKCCQSLScore;
    map['ClinicalSummaryScore'] = _clinicalSummaryScore;
    map['OverallSummaryScore'] = _overallSummaryScore;
    return map;
  }

}