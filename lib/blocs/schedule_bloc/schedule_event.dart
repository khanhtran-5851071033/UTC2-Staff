import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}


class GetSchedulePageEvent extends ScheduleEvent {
  final String idTeacher;

  GetSchedulePageEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}