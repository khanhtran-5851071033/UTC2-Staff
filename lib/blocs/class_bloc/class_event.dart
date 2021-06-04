part of 'class_bloc.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

class GetClassEvent extends ClassEvent {
  final String teacherID;
  GetClassEvent({
   this.teacherID,
  });
   @override
  List<Object> get props => [teacherID];
}
