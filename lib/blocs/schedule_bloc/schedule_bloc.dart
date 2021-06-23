import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial());
  List<Schedule> todayList = [];
  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetScheduleEvent:
        print(event.props[0].toString() + 'id------------');
        yield LoadingSchedule();
        List<Schedule> list = await ScheduleDatabase.getScheduleData(
          event.props[0],
        );
        for (var task in list) {
          DateTime timeStart =
              DateFormat("yyyy-MM-dd HH:mm:ss").parse(task.timeStart);
          DateTime timeEnd =
              DateFormat("yyyy-MM-dd HH:mm:ss").parse(task.timeEnd);
          DateTime now = DateTime.now();
          if (now.difference(timeStart).inDays >= 0 &&
              timeEnd.difference(now).inDays >= 0) {
            todayList.add(task);
          }
        }
        // print(todayList.length);
        if (todayList.length > 0) {
          yield LoadedSchedule(todayList);
        } else
          yield LoadErrorSchedule('Chưa có lịch giảng');
        break;
      default:
    }
  }
}
