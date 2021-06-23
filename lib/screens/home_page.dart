import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_bloc.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class HomePage extends StatefulWidget {
  final String idTeacher;

  const HomePage({Key key, this.idTeacher}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  final ValueNotifier<int> _pageNotifier = new ValueNotifier<int>(0);
  List subTask = [
    {'title': 'Báo Cáo', 'isComplete': true},
    {'title': 'Khảo sát ý kiến', 'isComplete': false},
    {'title': 'Tổng kết', 'isComplete': true},
    {'title': 'Trình bày', 'isComplete': false}
  ];
  List user = [
    'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://cdn.pixabay.com/photo/2014/04/03/10/32/user-310807_960_720.png'
  ];
  final _scrollController = ScrollController();
  ScheduleBloc scheduleBloc = new ScheduleBloc();
  TaskOfScheduleBloc taskBloc = new TaskOfScheduleBloc();
  int lenght;
  @override
  void initState() {
    scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
    taskBloc = BlocProvider.of<TaskOfScheduleBloc>(context);
    scheduleBloc.add(GetScheduleEvent(widget.idTeacher));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          stops: [
            0.02,
            0.1,
            0.3,
            0.5,
            0.8,
            0.9,
          ],
          colors: [
            ColorApp.lightGrey,
            ColorApp.lightBlue,
            ColorApp.mediumBlue,
            ColorApp.lightBlue,
            ColorApp.lightBlue,
            ColorApp.mediumBlue,
          ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            taskToday(size, pageController, _pageNotifier),
            Expanded(
              child: taskThisTime(size),
            )
          ],
        ),
      ),
    );
  }

  Widget taskThisTime(Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Công việc hiện tại'),
              Text(
                'All(1)',
                style: TextStyle(color: ColorApp.blue),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(left: size.width * 0.01),
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.03),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tham gia họp báo',
                      style: TextStyle(
                          color: ColorApp.mediumBlue,
                          fontSize: size.width * 0.05,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Now, 07:00 -11:30',
                            style: TextStyle(
                              color: ColorApp.blue,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorApp.lightBlue.withOpacity(.1)),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: ColorApp.lightBlue,
                                  size: 16,
                                ),
                                Text(
                                  'C1',
                                  style: TextStyle(
                                    color: ColorApp.blue,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorApp.lightBlue.withOpacity(.1)),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorApp.grey,
                    ),
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        radius: Radius.circular(10),
                        thickness: 2,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: subTask.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Checkbox(
                                value: subTask[i]['isComplete'],
                                activeColor: ColorApp.mediumBlue,
                                checkColor: Colors.white,
                                shape: CircleBorder(),
                                onChanged: (value) {
                                  setState(() {
                                    subTask[i]['isComplete'] = value;
                                  });
                                },
                              ),
                              title: Text(subTask[i]['title'].toString()),
                            );
                          },
                        ),
                      ),
                    ),
                    // FlatButton.icon(
                    //   height: 10,
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.add,
                    //     color: ColorApp.blue,
                    //   ),
                    //   label: Text(
                    //     "Thêm mô tả",
                    //     style: TextStyle(color: ColorApp.blue),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(parseDate);
  }

  Widget taskToday(Size size, PageController pageController,
      ValueNotifier<int> _pageNotifier) {
    return Container(
      // color: ColorApp.mediumBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Text(
              'Công việc hôm nay',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: size.width,
                height: size.width / 2.2,
                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is LoadingSchedule)
                      return Container(
                        child: Center(
                            child: SpinKitThreeBounce(
                          color: Colors.lightBlue,
                          size: size.width * 0.06,
                        )),
                      );
                    else if (state is LoadedSchedule) {
                      lenght = state.list.length;

                      return PageView(
                        physics: BouncingScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _pageNotifier.value = index;
                            taskBloc.add(GetTaskOfScheduleEvent(
                                widget.idTeacher,
                                state.list[index].idSchedule));
                            print(state.list[index].idSchedule);
                          });
                        },
                        children: List.generate(state.list.length, (index) {
                         
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        color: Colors.primaries[Random()
                                            .nextInt(Colors.primaries.length)],
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.03),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    5), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.list[index].titleSchedule,
                                                style: TextStyle(
                                                    color: ColorApp.mediumBlue,
                                                    fontSize:
                                                        size.width * 0.045,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                            BlocBuilder<TaskOfScheduleBloc,
                              TaskOfScheduleState>(
                            builder: (context, stateTask) {
                              if (state is LoadingTaskOfSchedule)
                                return Container(
                                  child: Center(
                                      child: SpinKitThreeBounce(
                                    color: Colors.lightBlue,
                                    size: size.width * 0.06,
                                  )),
                                );
                              else if (stateTask is LoadedTaskOfSchedule) {
                                                  return Column(
                                                    children: List.generate(
                                                      stateTask.list.length,
                                                      (index1) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Text(
                                                              formatTime(stateTask
                                                                      .list[
                                                                          index1]
                                                                      .timeStart) +
                                                                  ' - ' +
                                                                  formatTime(stateTask
                                                                      .list[
                                                                          index1]
                                                                      .timeEnd),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .orangeAccent
                                                                    .withOpacity(
                                                                        .1)),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.place,
                                                                  color: ColorApp
                                                                      .lightBlue,
                                                                  size: 16,
                                                                ),
                                                                Text(
                                                                  stateTask
                                                                      .list[
                                                                          index1]
                                                                      .idRoom,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        ColorApp
                                                                            .blue,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: ColorApp
                                                                    .lightBlue
                                                                    .withOpacity(
                                                                        .1)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );} else if (stateTask is LoadErrorTaskOfSchedule) {
                                return Center(
                                  child: Text(
                                    stateTask.error,
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
                                              // Spacer(),
                                            
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }
                      ,)
                       
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
                ),
              )
            ],
          ),
          Center(
            child: DotsIndicator(
              dotsCount: lenght ?? 2,
              mainAxisAlignment: MainAxisAlignment.center,
              position: _pageNotifier.value.toDouble(),
              decorator: DotsDecorator(
                color: Colors.white, // Inactive color
                activeColor: ColorApp.lightBlue,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
