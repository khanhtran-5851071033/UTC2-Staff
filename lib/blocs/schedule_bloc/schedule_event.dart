import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class GetScheduleEvent extends ScheduleEvent {
  final String idTeacher;

  GetScheduleEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}
class GetSchedulePageEvent extends ScheduleEvent {
  final String idTeacher;

  GetSchedulePageEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}