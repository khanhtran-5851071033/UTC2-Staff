import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

abstract class AttendTeacherState extends Equatable {
  const AttendTeacherState();

  @override
  List<Object> get props => [];
}

class AttendTeacherInitial extends AttendTeacherState {}

class LoadingAttendTeacher extends AttendTeacherState {}

class LoadedAttendTeacher extends AttendTeacherState {
  final List<TaskAttend> list;
  LoadedAttendTeacher(this.list);
}

class LoadErrorAttendTeacher extends AttendTeacherState {
  final String error;
  LoadErrorAttendTeacher(this.error);
}
