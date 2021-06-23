import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';
class TaskOfScheduleBloc extends Bloc<TaskOfScheduleEvent, TaskOfScheduleState> {
  TaskOfScheduleBloc() : super(TaskOfScheduleInitial());
  List<TaskOfSchedule> list = [];
  @override
  Stream<TaskOfScheduleState> mapEventToState(
    TaskOfScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTaskOfScheduleEvent:
        yield LoadingTaskOfSchedule();
        list = await ScheduleDatabase.getTaskOfScheduleData(
            event.props[0],event.props[1],);
        if (list.isNotEmpty) {
          yield LoadedTaskOfSchedule(list);
        } else
          yield LoadErrorTaskOfSchedule('Chưa có lịch giảng cụ thể');
        break;
      default:
    }
  }

}
