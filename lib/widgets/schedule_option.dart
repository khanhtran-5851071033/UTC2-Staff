import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utc2_staff/service/firestore/schedule_teacher.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/local_notification.dart';
import 'package:utc2_staff/utils/color_random.dart';

import 'package:utc2_staff/utils/utils.dart';

class OpitonScheduleMonth extends StatefulWidget {
  final List<Schedule> listMon;
  final List<TaskOfSchedule> listLich;

  const OpitonScheduleMonth({Key key, this.listMon, this.listLich})
      : super(key: key);
  @override
  _OpitonScheduleState createState() => _OpitonScheduleState();
}

class _OpitonScheduleState extends State<OpitonScheduleMonth>
    with AutomaticKeepAliveClientMixin {
  final notifications = FlutterLocalNotificationsPlugin();
  final teacherDatabase = TeacherDatabase();
  @override
  void initState() {
    super.initState();
    // MyLocalNotification.configureLocalTimeZone();
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
    notifications.cancelAll();
    _getDataSource();
  }

  Future onSelectNotification(String payload) async {
    print(payload);
    // Get.to(DetailClassScreen());
  }

  List<Meeting> meetings;
  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];

    int wd, sh, sm, eh, em;
    int maMon, maLich;
    String room, tenMon;

    scheduleNoti() {
      MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
          notifications, wd, sh, sm, eh, em, tenMon, room, maMon, maLich);
    }

    final DateTime today = DateTime.now();

    for (int i = 0; i < widget.listMon.length; i++) {
      var idTeacher = widget.listMon[i].idTeacher;

      DateTime endDate = DateTime.parse(widget.listMon[i].timeEnd);
      DateTime startDate = DateTime.parse(widget.listMon[i].timeStart);

      //Neu mon hoc chua ket thuc
      if (endDate.difference(today).inDays >= 0) {
        ///Chay for widget.listLich
        for (int j = 0; j < widget.listLich.length; j++) {
          DateTime date = startDate;

          ///Bien tam cua StartDate

          ///startDate to EndDate
          for (int d = 0; d < endDate.difference(startDate).inDays; d++) {
            date = date.add(Duration(days: 1));

            wd = widget.listLich[j].note - 1;
            //Kiem tra Week day va id Mon hoc
            if (date.weekday == wd &&
                widget.listLich[j].idSchedule == widget.listMon[i].idSchedule) {
              ///Timmmmmme
              sh = DateTime.parse(widget.listLich[j].timeStart).hour;
              sm = DateTime.parse(widget.listLich[j].timeStart).minute;
              eh = DateTime.parse(widget.listLich[j].timeEnd).hour;
              em = DateTime.parse(widget.listLich[j].timeEnd).minute;

              //Mon
              tenMon = widget.listMon[i].titleSchedule;
              maMon = int.parse(widget.listMon[i].idSchedule);
              maLich = int.parse(widget.listLich[j].idTask);
              room = widget.listLich[j].idRoom;

              DateTime startTime =
                  DateTime(date.year, date.month, date.day, sh, sm);

              DateTime endTime =
                  DateTime(date.year, date.month, date.day, eh, em);

              meetings.add(Meeting(tenMon + '\n\n' + room, startTime, endTime,
                  ColorRandom.colors[maMon][0], false));
              teacherDatabase.createTeacherAttend(
                idTeacher, maMon, maLich, DateFormat("yyyy-MM-dd").format(date)
              );
              if (date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year) {
                if (sh > today.hour) {
                  scheduleNoti();
                } else if (sh == today.hour) {
                  if (sm > today.minute) {
                    scheduleNoti();
                  }
                }
              } else {
                scheduleNoti();
              }
            }
          }
        }
      }
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(meetings),
        allowedViews: <CalendarView>[
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.workWeek,
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineWorkWeek,
          CalendarView.timelineMonth
        ],
        resourceViewSettings: ResourceViewSettings(
            displayNameTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.redAccent,
                fontStyle: FontStyle.italic)),

        allowViewNavigation: true,
        showDatePickerButton: true,
        showNavigationArrow: true,
        headerHeight: 50,
        todayHighlightColor: ColorApp.blue,
        appointmentTextStyle: TextStyle(fontSize: 15),

        // scheduleViewMonthHeaderBuilder: (BuildContext buildercontext,ScheduleView),
        monthViewSettings: MonthViewSettings(
            dayFormat: 'EEE',
            showTrailingAndLeadingDates: true,
            showAgenda: true,
            agendaStyle: AgendaStyle(
              appointmentTextStyle:
                  TextStyle(fontSize: 15, color: Colors.white),
            ),
            monthCellStyle: MonthCellStyle(
                leadingDatesTextStyle: TextStyle(color: ColorApp.red)),
            agendaItemHeight: 100,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ColorApp.red, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
