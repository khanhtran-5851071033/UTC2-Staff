import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial());
  List<Schedule> list = [];
  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetScheduleEvent:
        print(event.props[0].toString() + 'id------------');
        yield LoadingSchedule();
        list = await ScheduleDatabase.getScheduleData(
          event.props[0],
        );
        if (list.isNotEmpty) {
          yield LoadedSchedule(list);
        } else
          yield LoadErrorSchedule('Chưa có lịch giảng');
        break;
      default:
    }
  }
}
