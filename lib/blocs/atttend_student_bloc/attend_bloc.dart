import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_event.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_state.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';

class AttendStudentBloc extends Bloc<AttendStudentEvent, AttendStudentState> {
  AttendStudentBloc() : super(AttendInitial());
  List<StudentAttend> list = [];
  List<StudentOff> listStudentOff = [];
  List<Student> listStudent = [];
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
        listStudentOff =
            await StudentDatabase.getListStudentsOfClass(event.props[0]);
        List attend = [];
        if (list != null) {
          listStudent = await StudentDatabase.getListStudentsData();
          List<Student> newLit = [];
          Student a;
          for (var e in listStudentOff) {
            a = listStudent.where((i) => i.id == e.id).toList().first;
            newLit.add(a);
          }
          for (var student in listStudentOff) {
            for (int i = 0; i < list.length; i++) {
              if (list[i].id == student.id) {
                attend.add(list[i].status);
                break;
              }
            }
            attend.add('Chưa điểm danh');
          }
          print(attend);
          yield LoadedAttend(list, attend, newLit, event.props[1]);
        } else
          yield LoadErrorAttend('Bạn vắng mặt');
        break;
      default:
    }
  }
}
