import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_event.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_state.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';

class AttendStudentBloc extends Bloc<AttendStudentEvent, AttendStudentState> {
  AttendStudentBloc() : super(AttendInitial());
  List<StudentAttend> list;
  @override
  Stream<AttendStudentState> mapEventToState(
    AttendStudentEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetListStudentOfClassOfAttendEvent:
        yield LoadingAttend();
        list = await StudentDatabase.getStudentsOfClassOfAttend(
          event.props[0],
          event.props[1],
        );
        if (list != null)
          yield LoadedAttend(list);
        else
          yield LoadErrorAttend('Bạn vắng mặt');
        break;
      default:
    }
  }
}
