

import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';

abstract class AttendStudentState extends Equatable {
  const AttendStudentState();

  @override
  List<Object> get props => [];
}

class AttendInitial extends AttendStudentState {}

class LoadingAttend extends AttendStudentState {}

class LoadedAttend extends AttendStudentState {
  final List<StudentAttend> list;

  LoadedAttend(this.list);
}

class LoadErrorAttend extends AttendStudentState {
  final String error;

  LoadErrorAttend(this.error);
}
