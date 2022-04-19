class StartAssesmentResponse {
  String? status;
  String? message;
  Data? data;

  StartAssesmentResponse({this.status, this.message, this.data});

  StartAssesmentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Assessmment? assessmment;

  Data({this.assessmment});

  Data.fromJson(Map<String, dynamic> json) {
    assessmment = json['assessmment'] != null
        ? Assessmment.fromJson(json['assessmment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assessmment != null) {
      data['assessmment'] = assessmment!.toJson();
    }
    return data;
  }
}

class Assessmment {
  String? qnAId;
  String? taskId;
  String? assessmentTitle;
  String? assessmentDate;
  int? carePlanId;
  Question? question;
  bool? isBiometric;
  String? biometricName;
  String? biometricMeasureUnit;

  Assessmment(
      {this.qnAId,
      this.taskId,
      this.assessmentTitle,
      this.assessmentDate,
      this.carePlanId,
      this.question,
      this.isBiometric,
      this.biometricName,
      this.biometricMeasureUnit});

  Assessmment.fromJson(Map<String, dynamic> json) {
    qnAId = json['QnAId'];
    taskId = json['TaskId'];
    assessmentTitle = json['AssessmentTitle'];
    assessmentDate = json['AssessmentDate'];
    carePlanId = json['CarePlanId'];
    question = json['Question'] != null ? Question.fromJson(json['Question']) : null;
    isBiometric = json['IsBiometric'];
    biometricName = json['BiometricName'];
    biometricMeasureUnit = json['BiometricMeasureUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QnAId'] = qnAId;
    data['TaskId'] = taskId;
    data['AssessmentTitle'] = assessmentTitle;
    data['AssessmentDate'] = assessmentDate;
    data['CarePlanId'] = carePlanId;
    if (question != null) {
      data['Question'] = question!.toJson();
    }
    data['IsBiometric'] = isBiometric;
    data['BiometricName'] = biometricName;
    data['BiometricMeasureUnit'] = biometricMeasureUnit;
    return data;
  }
}

class Question {
  int? index;
  bool? isLastQuestion;
  String? questionText;
  String? questionType;
  List<String>? answerOptions;

  Question(
      {this.index,
      this.isLastQuestion,
      this.questionText,
      this.questionType,
      this.answerOptions});

  Question.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    isLastQuestion = json['IsLastQuestion'];
    questionText = json['QuestionText'];
    questionType = json['QuestionType'];
    answerOptions = json['AnswerOptions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Index'] = index;
    data['IsLastQuestion'] = isLastQuestion;
    data['QuestionText'] = questionText;
    data['QuestionType'] = questionType;
    data['AnswerOptions'] = answerOptions;
    return data;
  }
}

class Answer {
  int index;
  String text;

  Answer(this.index, this.text);
}
