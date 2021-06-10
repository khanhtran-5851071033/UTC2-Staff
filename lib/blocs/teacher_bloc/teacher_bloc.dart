import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  TeacherBloc() : super(TeacherInitial());

  @override
  Stream<TeacherState> mapEventToState(
    TeacherEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTeacher:
        yield TeacherLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userEmail = prefs.getString('userEmail');
      
        Teacher teacher = await TeacherDatabase.getTeacherData(userEmail);
       
        if (teacher != null) {
          yield TeacherLoaded(teacher);
        } else {
          yield TeacherError();
        }
        break;
      default:
    }
  }
}
