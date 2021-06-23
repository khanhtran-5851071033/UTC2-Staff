import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

abstract class TaskOfScheduleState extends Equatable {
  const TaskOfScheduleState();

  @override
  List<Object> get props => [];
}

class TaskOfScheduleInitial extends TaskOfScheduleState {}

class LoadingTaskOfSchedule extends TaskOfScheduleState {}

class LoadedTaskOfSchedule extends TaskOfScheduleState {
  final List<TaskOfSchedule> list;
  LoadedTaskOfSchedule(this.list);
}

class LoadErrorTaskOfSchedule extends TaskOfScheduleState {
  final String error;
  LoadErrorTaskOfSchedule(this.error);
}
