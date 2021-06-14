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
  final List attend;
  final List<Student> listStudent;
  final String idPost;
  LoadedAttend(this.list, this.attend, this.listStudent,this.idPost);
}

class LoadErrorAttend extends AttendStudentState {
  final String error;

  LoadErrorAttend(this.error);
}
