import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_bloc.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_event.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_state.dart';
import 'package:utc2_staff/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_staff/screens/classroom/report/info_atten.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class ReportAttendenClass extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final List<Post> listPost;

  ReportAttendenClass({this.teacher, this.classUtc, this.listPost});
  @override
  _ReportAttendenClassState createState() => _ReportAttendenClassState();
}

class _ReportAttendenClassState extends State<ReportAttendenClass> {
  Widget textHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget textRow(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.clip,
      style: TextStyle(color: ColorApp.black),
    );
  }

  Widget headerTable() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 3, child: textHeader('Điểm danh')),
          Expanded(flex: 4, child: textHeader('Họ và tên')),
          Expanded(flex: 3, child: textHeader('Mã sinh viên')),
          Expanded(flex: 2, child: textHeader('Lớp')),
        ],
      ),
    );
  }

  Widget rowTable(
    int stt,
    Student student,
    bool isCheck,
  ) {
    bool isShow = false;
    if (attenden == 'Tất cả')
      isShow = true;
    else if (attenden == 'Có mặt' && isCheck)
      isShow = true;
    else if (attenden == 'Vắng' && !isCheck)
      isShow = true;
    else
      isShow = false;
    return isShow
        ? Container(
            color: stt.isEven
                ? ColorApp.lightGrey.withOpacity(.2)
                : Colors.blue.withOpacity(.08),
            margin: EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 3,
                    child: TextButton.icon(
                      onPressed: () {
                        _showBottomSheet(context, widget.classUtc,
                            widget.teacher, widget.listPost, student);
                      },
                      label: Text('Chi tiết'),
                      icon: Icon(
                        isCheck ? Icons.check : Icons.close,
                        size: 15,
                        color: isCheck ? Colors.lightGreen : ColorApp.red,
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: textRow(stt.toString() + '. ' + student.name)),
                Expanded(flex: 3, child: textRow(student.id)),
                Expanded(flex: 2, child: textRow(student.lop)),
              ],
            ),
          )
        : Container();
  }

  _showBottomSheet(BuildContext context, Class _class, Teacher teacher,
      List<Post> listPost, Student student) {
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
              initialChildSize: 0.6,
              minChildSize: 0.2,
              maxChildSize: 0.95,
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
                            'Chi tiết điểm danh',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        height: 5,
                      ),
                      Expanded(
                          child: InfoAteen(widget.teacher, widget.classUtc,
                              controller, student, listPost, time))
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

  // List<String> timeAtten;
  StudentBloc studentBloc = new StudentBloc();
  Post time;
  String attenden = 'Tất cả';
  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat("HH:mm - dd/MM/yyyy").format(parseDate);
  }

  AttendStudentBloc attendStudentBloc = new AttendStudentBloc();
  @override
  void initState() {
    studentBloc = BlocProvider.of<StudentBloc>(context);
    studentBloc.add(GetListStudentOfClassEvent(widget.classUtc.id));
    if (widget.listPost != null) {
      time = widget.listPost[0];
      // timeAtten = widget.listPost.map((e) => formatTime(e.timeAtten)).toList();
    }
    // if (timeAtten.length == widget.listPost.length) time = timeAtten.first;
    attendStudentBloc = BlocProvider.of<AttendStudentBloc>(context);
    print(time.id);
    attendStudentBloc
        .add(GetListStudentOfClassOfAttendEvent(widget.classUtc.id, time.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: ColorApp.lightGrey,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.black,
          ),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xem trước',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {},
            icon: Image.asset(
              'assets/icons/pdf.png',
              width: 20,
            ),
            label: Text('In báo cáo'),
          ),
        ],
      ),
      body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Filter(
                    title: 'Đợt',
                    value: time,
                    item: widget.listPost,
                    function: (val) {
                      setState(() {
                        time = val;
                      });
                      attendStudentBloc.add(GetListStudentOfClassOfAttendEvent(
                          widget.classUtc.id, time.id));
                    },
                  ),
                  Filter1(
                    title: 'Lọc',
                    value: attenden,
                    item: [
                      'Tất cả',
                      'Có mặt',
                      'Vắng',
                    ],
                    function: (val) {
                      setState(() {
                        attenden = val;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          height: size.height,
                          width: size.width * 1.2,
                          child: Column(
                            children: [
                              headerTable(),
                              SizedBox(
                                height: 5,
                              ),
                              BlocConsumer<AttendStudentBloc,
                                  AttendStudentState>(
                                listener: (context, state) {
                                  if (state is LoadedAttend) {
                                    for (var p in widget.listPost) {
                                      if (p.id == state.idPost) {
                                        setState(() {
                                          time = p;
                                        });
                                        break;
                                      }
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  if (state is AttendInitial) {
                                    return SpinKitChasingDots(
                                      color: ColorApp.lightBlue,
                                    );
                                  } else if (state is LoadingAttend) {
                                    return SpinKitChasingDots(
                                      color: ColorApp.lightBlue,
                                    );
                                  } else if (state is LoadedAttend) {
                                    return Container(
                                        height: size.height * 2 / 3,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: 2))),
                                        child: ListView.builder(
                                            itemCount: state.listStudent.length,
                                            itemBuilder: (context, index) {
                                              return rowTable(
                                                  (index + 1),
                                                  state.listStudent[index],
                                                  state.attend[index] ==
                                                          'Thành công'
                                                      ? true
                                                      : false);
                                            }));
                                  } else if (state is LoadErrorAttend) {
                                    return Center(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        state.error,
                                        style: TextStyle(
                                            fontSize: 20, color: ColorApp.red),
                                      ),
                                    ));
                                  } else
                                    return Container();
                                },
                              ),
                            ],
                          ),
                        );
                      }))
            ],
          )),
    );
  }
}

class Filter extends StatelessWidget {
  final String title;
  final Post value;
  final List<Post> item;
  final Function function;

  Filter({this.title, this.value, this.item, this.function});
  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat("HH:mm - dd/MM/yyyy").format(parseDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(title + ':   '),
          DropdownButton<Post>(
            value: value,
            items: item.map((Post value) {
              return new DropdownMenuItem<Post>(
                value: value,
                child: new Text(
                  formatTime(value.timeAtten),
                  style: TextStyle(color: ColorApp.mediumBlue),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              function(newValue);
            },
          )
        ],
      ),
    );
  }
}

class Filter1 extends StatelessWidget {
  final String title;
  final String value;
  final List<String> item;
  final Function function;

  Filter1({this.title, this.value, this.item, this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(title + ':   '),
          DropdownButton<String>(
            value: value,
            items: item.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      value == 'Tất cả'
                          ? null
                          : value == 'Có mặt'
                              ? Icons.check
                              : Icons.close,
                      size: 15,
                      color: value == 'Tất cả'
                          ? null
                          : value == 'Có mặt'
                              ? Colors.lightGreen
                              : ColorApp.red,
                    ),
                    new Text(
                      value,
                      style: TextStyle(color: ColorApp.mediumBlue),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              function(newValue);
            },
          )
        ],
      ),
    );
  }
}
