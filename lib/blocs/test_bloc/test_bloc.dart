import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/test_bloc/test_event.dart';
import 'package:utc2_staff/blocs/test_bloc/test_state.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/test_student_database.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInitial());
  List<StudentTest> list = [];
  List<Post> listPost = [];
  @override
  Stream<TestState> mapEventToState(
    TestEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTestEvent:
        yield LoadingTest();
        listPost = event.props[1];
        for (int i = 0; i < listPost.length; i++) {
          var item = await StudentTestDatabase.getStudentsTest(
              event.props[0], listPost[i].id);
          list = list + item;
        }
        if (list.isNotEmpty) {
          yield LoadedTest(list);
        } else
          yield LoadErrorTest('Chưa có bài');
        break;
      default:
    }
  }
}
