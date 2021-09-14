import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class StartAssesmentResponse {
  String status;
  String message;
  Data data;

  StartAssesmentResponse({this.status, this.message, this.data});

  StartAssesmentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

@JsonSerializable(nullable: true)
class Data {
  Assessmment assessmment;

  Data({this.assessmment});

  Data.fromJson(Map<String, dynamic> json) {
    assessmment = json['assessmment'] != null
        ? new Assessmment.fromJson(json['assessmment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmment != null) {
      data['assessmment'] = this.assessmment.toJson();
    }
    return data;
  }
}

@JsonSerializable(nullable: true)
class Assessmment {
  String qnAId;
  String taskId;
  String assessmentTitle;
  String assessmentDate;
  int carePlanId;
  Question question;
  bool isBiometric;
  String biometricName;
  String biometricMeasureUnit;

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
    question = json['Question'] != null
        ? new Question.fromJson(json['Question'])
        : null;
    isBiometric = json['IsBiometric'];
    biometricName = json['BiometricName'];
    biometricMeasureUnit = json['BiometricMeasureUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QnAId'] = this.qnAId;
    data['TaskId'] = this.taskId;
    data['AssessmentTitle'] = this.assessmentTitle;
    data['AssessmentDate'] = this.assessmentDate;
    data['CarePlanId'] = this.carePlanId;
    if (this.question != null) {
      data['Question'] = this.question.toJson();
    }
    data['IsBiometric'] = this.isBiometric;
    data['BiometricName'] = this.biometricName;
    data['BiometricMeasureUnit'] = this.biometricMeasureUnit;
    return data;
  }
}

@JsonSerializable(nullable: true)
class Question {
  int index;
  bool isLastQuestion;
  String questionText;
  String questionType;
  List<String> answerOptions;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['IsLastQuestion'] = this.isLastQuestion;
    data['QuestionText'] = this.questionText;
    data['QuestionType'] = this.questionType;
    data['AnswerOptions'] = this.answerOptions;
    return data;
  }
}

class Answer {
  int index;
  String text;

  Answer(this.index, this.text);
}
