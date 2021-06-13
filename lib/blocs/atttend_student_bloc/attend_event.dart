

import 'package:equatable/equatable.dart';

abstract class AttendStudentEvent extends Equatable {
  const AttendStudentEvent();

  @override
  List<Object> get props => [];
}
class GetListStudentOfClassOfAttendEvent extends AttendStudentEvent {
  final String idClass, isPost;

  GetListStudentOfClassOfAttendEvent(this.idClass, this.isPost);
  @override
  List<Object> get props => [idClass, isPost];
}


