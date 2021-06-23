import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class LoadingSchedule extends ScheduleState {}

class LoadedSchedule extends ScheduleState {
  final List<Schedule> list;
  LoadedSchedule(this.list);
}

class LoadErrorSchedule extends ScheduleState {
  final String error;
  LoadErrorSchedule(this.error);
}
