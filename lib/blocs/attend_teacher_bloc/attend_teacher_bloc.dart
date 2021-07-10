import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/attend_teacher_bloc/attend_teacher_event.dart';
import 'package:utc2_staff/blocs/attend_teacher_bloc/attend_teacher_state.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

class AttendTeacherBloc extends Bloc<AttendTeacherEvent, AttendTeacherState> {
  AttendTeacherBloc() : super(AttendTeacherInitial());
  List<TaskAttend> list = [];
  List<TaskOfSchedule> listTaskOf = [];
  @override
  Stream<AttendTeacherState> mapEventToState(
    AttendTeacherEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetAttendTeacherEvent:
        yield AttendTeacherInitial();
        yield LoadingAttendTeacher();
        list.clear();
        listTaskOf = event.props[2];

        for (int i = 0; i < listTaskOf.length; i++) {
          var item = await ScheduleDatabase.getTaskAttendData(
              event.props[0], event.props[1], listTaskOf[i].idTask);
          list = list + item;
        }

        if (list.isNotEmpty) {
          yield LoadedAttendTeacher(list);
        } else
          yield LoadErrorAttendTeacher('Chưa có điểm danh');
        break;
      default:
    }
  }
}
