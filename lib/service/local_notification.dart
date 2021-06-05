import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyLocalNotification {
  static Future<void> scheduleWeeklyMondayTenAMNotification(
      FlutterLocalNotificationsPlugin notifications,
      int wd,
      int sh,
      int sm,
      int eh,
      int em,
      String tenMon,
      String room,
      int maMon,
      int maLich) async {
    String sem = em == 0 ? '00' : '$em';
    await notifications.zonedSchedule(
        int.parse('$maMon$maLich'),
        'Đến giờ học môn $tenMon - $room',
        '$sh:$sm - $eh:$sem',
        nextInstanceOfWeekDayTime(sh, sm, wd),
        NotificationDetails(
          android: AndroidNotificationDetails(
              '$tenMon-$maLich', '$tenMon-$maLich', '$tenMon-$maLich'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    print(timeZoneName);
  }

  static tz.TZDateTime nextInstanceOfTime(int h, int m) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(scheduledDate);
    return scheduledDate;
  }

  static tz.TZDateTime nextInstanceOfWeekDayTime(int h, int m, int wd) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(h, m);
    while (scheduledDate.weekday != wd) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> showNotification(
      FlutterLocalNotificationsPlugin notifications,
      String title,
      String body) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableLights: true,
      largeIcon: FilePathAndroidBitmap('assets/images/logoUTC.jpg'),
      styleInformation: BigTextStyleInformation(''),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> showNotificationEvent(
      FlutterLocalNotificationsPlugin notifications,
      String idChannel,
      String chanelName,
      String chanelDescription,
      String title,
      String body) async {
    int insistentFlag = 4;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(idChannel, chanelName, chanelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            enableLights: true,
            styleInformation: BigTextStyleInformation(''),
            additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> cancelNotification(
      FlutterLocalNotificationsPlugin notifications) async {
    await notifications.cancel(0);
  }
}
