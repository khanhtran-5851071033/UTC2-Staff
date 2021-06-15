import 'package:cloud_firestore/cloud_firestore.dart';

class QuizDatabase {
  Future<void> createQuiz(
      Map<String, String> dataQuiz, String idTeacher, String idQuiz) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .set(dataQuiz);
  }

  Future<void> createQuestion(Map<String, String> dataQuiz, String idTeacher,
      String idQuiz, String idQuestion) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .doc(idQuestion)
        .set(dataQuiz);
  }

  Future<void> deleteQuiz(String idTeacher, String idQuiz) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .delete();
  }

  Future<void> deleteQuestion(
      String idTeacher, String idQuiz, String idQuestion) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .doc(idQuestion)
        .delete();
  }

  static getQuizData(String idTeacher) async {
    List<Quiz> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .get();
    list = data.docs.map((e) => Quiz(e)).toList();
    return list;
  }

  static getQuestionData(String idTeacher, String idQuiz) async {
    List<Quiz> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .get();
    list = data.docs.map((e) => Quiz(e)).toList();
    return list;
  }
}

class Quiz {
  String idQuiz, idTeacher, titleQuiz, timePlay, dateCreate;
  Quiz(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idQuiz = json['id'];
    this.idTeacher = json['idTeacher'];
    this.titleQuiz = json['titleQuiz'];
    this.timePlay = json['timePlay'];
    this.dateCreate = json['dateCreate'];
  }
}

class Question {
  String idQuiz, idQuestion, question, answerCorrect, answer2, answer3, answer4;
  Question(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idQuiz = json['id'];
    this.idQuestion = json['idQuestion'];
    this.question = json['question'];
    this.answerCorrect = json['answerCorrect'];
    this.answer2 = json['answer2'];
    this.answer3 = json['answer3'];
    this.answer4 = json['answer4'];
  }
}
