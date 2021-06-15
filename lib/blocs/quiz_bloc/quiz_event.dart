import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class GetQuizEvent extends QuizEvent {
  final String idTeacher;

  GetQuizEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}
