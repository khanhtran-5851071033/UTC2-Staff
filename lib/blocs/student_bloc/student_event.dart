part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class GetListStudentEvent extends StudentEvent {}

class FilterListStudentEvent extends StudentEvent {
  final String khoa, lop, heDaoTao;

  FilterListStudentEvent( this.khoa, this.lop, this.heDaoTao);
  @override
  List<Object> get props => [this.khoa, this.lop, this.heDaoTao];
}