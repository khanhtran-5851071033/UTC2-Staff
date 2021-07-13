import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_staff/screens/profile_screen/history_attend/detail_history.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class HistoryAttend extends StatefulWidget {
  final Teacher teacher;

  const HistoryAttend({Key key, this.teacher}) : super(key: key);
  @override
  _HistoryAttendState createState() => _HistoryAttendState();
}

class _HistoryAttendState extends State<HistoryAttend> {
  ScheduleBloc scheduleBloc = new ScheduleBloc();
  List<TaskOfSchedule> listTaskOfSche = [];
  @override
  void initState() {
    scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
    scheduleBloc.add(GetSchedulePageEvent(widget.teacher.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lịch sử điểm danh',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is LoadedSchedulePage) {
              listTaskOfSche = state.listLich;
            }
          },
          builder: (context, state) {
            return BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
                if (state is LoadingSchedule)
                  return Container(
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.lightBlue,
                      size: size.width * 0.06,
                    )),
                  );
                else if (state is LoadedSchedulePage) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      scheduleBloc.add(GetSchedulePageEvent(widget.teacher.id));
                    },
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: state.listMon.length,
                          itemBuilder: (context, index) {
                            return Item(
                              schedule: state.listMon[index],
                              teacher: widget.teacher,
                              listTask: listTaskOfSche
                                  .where((element) =>
                                      element.idSchedule ==
                                      state.listMon[index].idSchedule)
                                  .toList(),
                            );
                          }),
                    ),
                  );
                } else if (state is LoadErrorSchedule) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.lightBlue,
                      size: size.width * 0.06,
                    )),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Schedule schedule;
  final Teacher teacher;
  final List<TaskOfSchedule> listTask;

  const Item({Key key, this.schedule, this.teacher, this.listTask})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.all(size.width * 0.03),
      padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorApp.blue.withOpacity(0.03),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 5), // changes position of shadow
          ),
        ],
        border: Border.all(color: Colors.lightBlue.withOpacity(.1), width: .5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
              leading: Container(
                padding: EdgeInsets.all(4),
                child: CircleAvatar(
                  backgroundColor: ColorApp.lightGrey,
                  backgroundImage: CachedNetworkImageProvider(teacher.avatar),
                ),
              ),
              title: Text(schedule.titleSchedule),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID :' + schedule.idSchedule),
                  Row(
                    children: [
                      Text('Ghi chú :' + schedule.note),
                    ],
                  )
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailHistory(
                                teacher: teacher,
                                listTask: listTask,
                                schedule: schedule,
                              )));
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              )),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 3,
                backgroundColor: ColorApp.black,
              ),
              Text('  Thời gian :'),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orangeAccent.withOpacity(.02)),
                  child: Text(
                    formatTimeSche(schedule.timeStart),
                    style: TextStyle(color: Colors.orangeAccent),
                  )),
              Text('  ->  '),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orangeAccent.withOpacity(.02)),
                  child: Text(formatTimeSche(schedule.timeEnd),
                      style: TextStyle(color: Colors.orangeAccent))),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Divider(
            height: 15,
            thickness: 1,
            color: ColorApp.lightGrey,
          ),
          Column(
            children: List.generate(
              listTask.length,
              (index) => Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: ColorApp.black,
                    ),
                    Text('  Buổi ' +
                        (index + 1).toString() +
                        ' : ' +
                        'Thứ ' +
                        listTask[index].note.toString() +
                        ' - ' 'Phòng ' +
                        listTask[index].idRoom.toString()),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
