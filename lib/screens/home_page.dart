import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utc2_staff/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_bloc.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_staff/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_staff/blocs/today_task_bloc/today_task_bloc.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/geo_service.dart';
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

  TodayTaskBloc scheduleBloc;
  TaskOfScheduleBloc taskBloc;
  final teacherDatabase = TeacherDatabase();
  int lenght;
  @override
  void initState() {
    scheduleBloc = BlocProvider.of<TodayTaskBloc>(context);
    taskBloc = BlocProvider.of<TaskOfScheduleBloc>(context);
    scheduleBloc.add(GetTodayTaskEvent(widget.idTeacher));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
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
    );
  }

  GeoService geoService = GeoService();
  Future<Position> getLocation() async {
    var currentPosition = await geoService.getCurrentLocation();
    return currentPosition;
  }

  Position location;
  Geocoding geocoding;
  List<Address> results = [];
  String scheduleName = '';

  Widget taskThisTime(Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: ColorApp.lightGrey.withOpacity(.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Công việc hiện tại', style: TextStyle(color: Colors.white)),
              Text(
                'All(1)',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: size.width,
              // padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10)),
              child: BlocConsumer<TaskOfScheduleBloc, TaskOfScheduleState>(
                  listener: (context, state) async {
                if (state is LoadedTaskOfSchedule) {
                  await teacherDatabase
                      .getScheduleById(
                          widget.idTeacher, state.nowList[0].idSchedule)
                      .then((value) {
                    setState(() {
                      scheduleName = value.titleSchedule;
                    });
                  });
                }
              }, builder: (context, state) {
                if (state is LoadingTaskOfSchedule)
                  return Container(
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.lightBlue,
                      size: size.width * 0.06,
                    )),
                  );
                else if (state is LoadedTaskOfSchedule) {
                  if (state.nowList.isEmpty) {
                    return Center(
                      child: Text(
                        'Hiện tại chưa có công việc nào',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    );
                  } else
                    return Scrollbar(
                      radius: Radius.circular(5),
                      child: ListView.builder(
                        itemCount: state.nowList.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      scheduleName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: ColorApp.mediumBlue,
                                          fontSize: 17,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer()
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Now, ' +
                                            DateTime.parse(state
                                                    .nowList[index].timeStart)
                                                .hour
                                                .toString() +
                                            ':' +
                                            DateTime.parse(state
                                                    .nowList[index].timeStart)
                                                .minute
                                                .toString() +
                                            ' - ' +
                                            DateTime.parse(state
                                                    .nowList[index].timeEnd)
                                                .hour
                                                .toString() +
                                            ':' +
                                            DateTime.parse(state
                                                    .nowList[index].timeEnd)
                                                .minute
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.orange,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.orange.withOpacity(.1)),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: ColorApp.lightBlue
                                                .withOpacity(.1)),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        var s = await Permission.locationAlways
                                            .request();
                                        print(s);
                                        location = await getLocation();
                                        try {
                                          var geocoding = Geocoder.local;
                                          var longitude = location.longitude;
                                          var latitude = location.latitude;
                                          var results1 = await geocoding
                                              .findAddressesFromCoordinates(
                                                  new Coordinates(
                                                      latitude, longitude));
                                          results = results1;
                                          print(results1[0].addressLine);
                                        } catch (e) {
                                          print("Error occured: ");
                                        }
                                        teacherDatabase.attend(
                                            widget.idTeacher,
                                            state.nowList[index].idSchedule,
                                            state.nowList[index].idTask,
                                            DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now()),
                                            location.latitude.toString() +
                                                ',' +
                                                location.longitude.toString(),
                                            results[0].addressLine);
                                        Fluttertoast.showToast(
                                            msg: "Đã điểm danh",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                ColorApp.mediumBlue,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                      icon: Icon(
                                          Icons.library_add_check_outlined,
                                          color: ColorApp.blue,
                                          size: 18),
                                      label: Text(
                                        "Điểm danh",
                                        style: TextStyle(color: ColorApp.blue),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Divider(
                                  color: ColorApp.grey,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                } else
                  return SizedBox();
              }),
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
                child: BlocConsumer<TodayTaskBloc, TodayTaskState>(
                  listener: (context, state) {
                    if (state is LoadedTodayTask) {
                      lenght = state.list.length;
                      taskBloc.add(GetTaskOfScheduleEvent(
                          widget.idTeacher, state.list[0].idSchedule));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingSchedule)
                      return Container(
                        child: Center(
                            child: SpinKitThreeBounce(
                          color: Colors.lightBlue,
                          size: 30,
                        )),
                      );
                    else if (state is LoadedTodayTask) {
                      lenght = state.list.length;

                      return lenght == 0
                          ? Container()
                          : PageView(
                              physics: BouncingScrollPhysics(),
                              controller: pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _pageNotifier.value = index;
                                });
                                taskBloc.add(GetTaskOfScheduleEvent(
                                    widget.idTeacher,
                                    state.list[index].idSchedule));
                              },
                              children: List.generate(
                                state.list.length,
                                (index) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          color: Colors.primaries[Random()
                                              .nextInt(
                                                  Colors.primaries.length)],
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
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
                                                  state.list[index]
                                                      .titleSchedule,
                                                  style: TextStyle(
                                                      color:
                                                          ColorApp.mediumBlue,
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
                                                  builder:
                                                      (context, stateTask) {
                                                    if (state
                                                        is LoadingTaskOfSchedule)
                                                      return Container(
                                                          // child: Center(
                                                          //     child:
                                                          //         SpinKitThreeBounce(
                                                          //   color: Colors
                                                          //       .lightBlue,
                                                          //   size: size.width *
                                                          //       0.06,
                                                          // )),
                                                          );
                                                    else if (stateTask
                                                        is LoadedTaskOfSchedule) {
                                                      return Column(
                                                        children: List.generate(
                                                          stateTask.list.length,
                                                          (index1) => Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text('Thứ ' +
                                                                        (stateTask.list[index1].note)
                                                                            .toString()),
                                                                    Text(stateTask
                                                                        .list[
                                                                            index1]
                                                                        .titleTask),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      formatTime(stateTask
                                                                              .list[
                                                                                  index1]
                                                                              .timeStart) +
                                                                          ' - ' +
                                                                          formatTime(stateTask
                                                                              .list[index1]
                                                                              .timeEnd),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Colors
                                                                            .orangeAccent
                                                                            .withOpacity(.1)),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .place,
                                                                          color:
                                                                              ColorApp.lightBlue,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        Text(
                                                                          stateTask
                                                                              .list[index1]
                                                                              .idRoom,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorApp.blue,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: ColorApp
                                                                            .lightBlue
                                                                            .withOpacity(.1)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else if (stateTask
                                                        is LoadErrorTaskOfSchedule) {
                                                      return Center(
                                                        child: Text(
                                                          stateTask.error,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text('Thứ '),
                                                                  // Text(
                                                                  //     '          '),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Text(
                                                                    '                      ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .orangeAccent
                                                                          .withOpacity(
                                                                              .1)),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .place,
                                                                        color: ColorApp
                                                                            .lightBlue,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      Text(
                                                                        '          ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              ColorApp.blue,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: ColorApp
                                                                          .lightBlue
                                                                          .withOpacity(
                                                                              .1)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ));
                    } else if (state is TodayTaskError) {
                      return Center(
                        child: Text(
                          state.error,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: Center(
                            child: SpinKitThreeBounce(
                          color: Colors.lightBlue,
                          size: 30,
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
              dotsCount: lenght ?? 1,
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
