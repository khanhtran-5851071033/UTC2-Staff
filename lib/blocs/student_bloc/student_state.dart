part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class LoadingStudentState extends StudentState {}

class LoadedStudentState extends StudentState {
  final List<Student> listStudent;

  LoadedStudentState(this.listStudent);
}

class LoadErrorStudentState extends StudentState {}
