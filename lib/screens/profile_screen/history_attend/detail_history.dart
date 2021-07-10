import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_staff/blocs/attend_teacher_bloc/attend_teacher_bloc.dart';
import 'package:utc2_staff/blocs/attend_teacher_bloc/attend_teacher_event.dart';
import 'package:utc2_staff/blocs/attend_teacher_bloc/attend_teacher_state.dart';
import 'package:utc2_staff/service/excel/excel_api.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class DetailHistory extends StatefulWidget {
  final Schedule schedule;
  final Teacher teacher;
  final List<TaskOfSchedule> listTask;

  const DetailHistory({Key key, this.schedule, this.teacher, this.listTask})
      : super(key: key);

  @override
  _DetailHistoryState createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  AttendTeacherBloc attendTeacherBloc = new AttendTeacherBloc();
  List<TaskAttend> list = [];
  @override
  void initState() {
    attendTeacherBloc = BlocProvider.of<AttendTeacherBloc>(context);
    attendTeacherBloc.add(GetAttendTeacherEvent(
        idSchedule: widget.schedule.idSchedule,
        idTeacher: widget.teacher.id,
        idTaskOfSchedule: widget.listTask));
    super.initState();
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showBottomSheet(BuildContext context, Size size,
      TaskOfSchedule taskOfSchedule, TaskAttend task, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (_, controller) {
                return Container(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: ColorApp.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(3),
                            topRight: const Radius.circular(3),
                          ),
                        ),
                        height: 3,
                        width: 50,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            'Thông tin điểm danh',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        height: 15,
                      ),
                      Container(
                        height: 200,
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ColorApp.blue.withOpacity(0.09),
                              spreadRadius: 1.5,
                              blurRadius: 3,
                              offset:
                                  Offset(-2, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          // border:
                          //     Border.all(color: ColorApp.lightGrey)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                        color: Colors.orangeAccent
                                            .withOpacity(.1)),
                                    child: Text(
                                      formatTimeTask(taskOfSchedule.timeStart),
                                      style:
                                          TextStyle(color: Colors.orangeAccent),
                                    )),
                                Text('  ->  '),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.orangeAccent
                                            .withOpacity(.1)),
                                    child: Text(
                                        formatTimeTask(taskOfSchedule.timeEnd),
                                        style: TextStyle(
                                            color: Colors.orangeAccent))),
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: ColorApp.black,
                                ),
                                Text('  Có mặt lúc : '),
                                task.dateAttend != null
                                    ? Text(formatTimeTask(task.dateAttend) +
                                        " - " +
                                        formatTimeSche1(task.dateAttend))
                                    : Container(),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 3,
                                      backgroundColor: ColorApp.black,
                                    ),
                                    Text('  Vị trí : '),
                                  ],
                                ),
                                task.dateAttend != null
                                    ? Expanded(child: Text(task.address))
                                    : Container(),
                              ],
                            ),
                            Row(children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: ColorApp.black,
                              ),
                              Text('  Tọa độ : '),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      _launchInWebViewWithJavaScript(
                                          'https://www.google.com/maps/place/${task.location}');
                                    },
                                    child: Text(
                                      task.location != null
                                          ? task.location
                                          : '',
                                      style: TextStyle(color: Colors.lightBlue),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                    )),
                              ),
                            ]),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 3,
                                      backgroundColor: ColorApp.black,
                                    ),
                                    Text('  Trạng thái : '),
                                  ],
                                ),
                                task.status != null
                                    ? Expanded(child: Text(task.status))
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
          ),
        );
      },
    );
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
          widget.schedule.titleSchedule,
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              // final excelFile = await ExcelTestApi.generate(
              //     widget.teacher,
              //     widget.classUtc,
              //     listStudent,
              //     widget.listPostQuiz,
              //     widget.listQuiz,
              //     widget.listTest);
              // ExcelApi.openFile(excelFile);
            },
            icon: Image.asset(
              'assets/icons/excel.png',
              width: 20,
            ),
            label: Text('In'),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              color: Colors.lightBlue,
              child: Row(
                children: [
                  textHeader('   Buổi '),
                  SizedBox(
                    width: 10,
                  ),
                  textHeader('STT'),
                  SizedBox(
                    width: 30,
                  ),
                  textHeader('Ngày'),
                  Spacer(),
                  textHeader('Trạng thái         '),
                ],
              ),
            ),
            Column(
              children: List.generate(
                  widget.listTask.length,
                  (index) => Container(
                        height: (size.height -
                                AppBar().preferredSize.height * 2.8) /
                            widget.listTask.length,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 10, color: ColorApp.lightGrey))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              child: textHeader(' Thứ ' +
                                  widget.listTask[index].note.toString() +
                                  '   '),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: BlocListener<AttendTeacherBloc,
                                    AttendTeacherState>(
                              listener: (context, state) {
                                if (state is LoadedAttendTeacher) {
                                  list = state.list;
                                  print(list.length);
                                }
                              },
                              child: BlocBuilder<AttendTeacherBloc,
                                  AttendTeacherState>(
                                builder: (context, state) {
                                  if (state is LoadingAttendTeacher)
                                    return Container(
                                      child: Center(
                                          child: SpinKitThreeBounce(
                                        color: Colors.lightBlue,
                                        size: size.width * 0.06,
                                      )),
                                    );
                                  else if (state is LoadedAttendTeacher) {
                                    return ListView.builder(
                                        itemCount: list
                                            .where((element) =>
                                                element.idTaskOfSchedule ==
                                                widget.listTask[index].idTask)
                                            .toList()
                                            .length,
                                        itemBuilder: (context, i) {
                                          var item = list
                                              .where((element) =>
                                                  element.idTaskOfSchedule ==
                                                  widget.listTask[index].idTask)
                                              .toList()[i];
                                          return Container(
                                            margin: EdgeInsets.only(top: 4),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom:
                                                        BorderSide(width: .1))),
                                            child: Row(
                                              children: [
                                                Text((i + 1).toString()),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    item.id,
                                                    style: TextStyle(
                                                        color: formatTimeSche1(
                                                                    item.id) ==
                                                                formatTimeSche(
                                                                    DateTime.now()
                                                                        .toString())
                                                            ? Colors.lightBlue
                                                            : ColorApp.black),
                                                  ),
                                                )),
                                                // Spacer(),
                                                TextButton.icon(
                                                    onPressed: () {
                                                      _showBottomSheet(
                                                          context,
                                                          size,
                                                          widget
                                                              .listTask[index],
                                                          item,
                                                          widget.teacher);
                                                    },
                                                    icon: Icon(
                                                      item.status ==
                                                              'Thành công'
                                                          ? Icons.check
                                                          : Icons.close,
                                                      size: 17,
                                                      color: item.status ==
                                                              'Thành công'
                                                          ? Colors.lightGreen
                                                          : ColorApp.red,
                                                    ),
                                                    label: Container(
                                                      padding: EdgeInsets.only(
                                                          right: 8),
                                                      child: Text(' Chi tiết'),
                                                    ))
                                              ],
                                            ),
                                          );
                                        });
                                  } else if (state is LoadErrorAttendTeacher) {
                                    return Center(
                                      child: Text(
                                        state.error,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
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
                              ),
                            ))
                          ],
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

Widget textHeader(String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    color: Colors.lightBlue,
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    ),
  );
}
