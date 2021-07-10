import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

abstract class AttendTeacherEvent extends Equatable {
  const AttendTeacherEvent();

  @override
  List<Object> get props => [];
}

class GetAttendTeacherEvent extends AttendTeacherEvent {
  final String idTeacher;
  final String idSchedule;
  final List<TaskOfSchedule> idTaskOfSchedule;

  GetAttendTeacherEvent({this.idTaskOfSchedule, this.idTeacher, this.idSchedule});
  @override
  List<Object> get props => [idTeacher, idSchedule,idTaskOfSchedule];
}
