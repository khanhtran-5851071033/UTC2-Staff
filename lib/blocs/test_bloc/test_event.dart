import 'package:equatable/equatable.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class GetTestEvent extends TestEvent {
  final String idClass;
  final List<Post> listPost;

  GetTestEvent(this.idClass, this.listPost);
  @override
  List<Object> get props => [idClass,listPost];
}
