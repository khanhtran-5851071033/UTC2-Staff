import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_event.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_state.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial());
  List<Quiz> list = [];
  @override
  Stream<QuizState> mapEventToState(
    QuizEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetQuizEvent:
        yield LoadingQuiz();
        list = await QuizDatabase.getQuizData(
            event.props[0],);
        if (list.isNotEmpty) {
          yield LoadedQuiz(sapXepGiamDan(list));
        } else
          yield LoadErrorQuiz('Chưa có bài tập nào');
        break;
      default:
    }
  }

  List<Quiz> sapXepGiamDan(List<Quiz> list) {
    list.sort((a, b) => a.dateCreate.compareTo(b.dateCreate));
    return list.reversed.toList();
  }
}
