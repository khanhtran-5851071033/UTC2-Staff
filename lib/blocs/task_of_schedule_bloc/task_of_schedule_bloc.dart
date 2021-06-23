import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

class TaskOfScheduleBloc
    extends Bloc<TaskOfScheduleEvent, TaskOfScheduleState> {
  TaskOfScheduleBloc() : super(TaskOfScheduleInitial());
  List<TaskOfSchedule> todayList = [];
  @override
  Stream<TaskOfScheduleState> mapEventToState(
    TaskOfScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTaskOfScheduleEvent:
        yield LoadingTaskOfSchedule();
        List<TaskOfSchedule> list =
            await ScheduleDatabase.getTaskOfScheduleData(
          event.props[0],
          event.props[1],
        );
        for (var task in list) {
          if (task.timeStart != '') {
            DateTime timeStart =
                DateFormat("yyyy-MM-dd HH:mm:ss").parse(task.timeStart);
            DateTime now = DateTime.now();
            if (timeStart.day == now.day &&
                timeStart.month == now.month &&
                timeStart.year == now.year) {
              todayList.add(task);
            }
          }
        }
        if (todayList.isNotEmpty) {
          yield LoadedTaskOfSchedule(todayList);
        } else
          yield LoadErrorTaskOfSchedule('Chưa có lịch giảng cụ thể');
        break;
      default:
    }
  }
}
