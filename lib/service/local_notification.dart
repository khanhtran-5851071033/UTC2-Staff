import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:utc2_staff/utils/utils.dart';

class MyLocalNotification {
  static Future<void> scheduleWeeklyMondayTenAMNotification(
      FlutterLocalNotificationsPlugin notifications, int h, int m) async {
    const int insistentFlag = 4;
    await notifications.zonedSchedule(
        m,
        'Trí Tuệ Nhân Tạo $m',
        '7:00 - 11:45 AM $m',
        nextInstanceOfWeekDayTime(h, m),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'weekly notification channel $m',
              'weekly notification channel name $m',
              'weekly notificationdescription $m',
              additionalFlags: Int32List.fromList(<int>[insistentFlag])),
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
    return scheduledDate;
  }

  static tz.TZDateTime nextInstanceOfWeekDayTime(int h, int m) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(h, m);
    while (scheduledDate.weekday != DateTime.thursday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(scheduledDate);
    return scheduledDate;
  }

  static Future<void> showNotification(
      FlutterLocalNotificationsPlugin notifications,
      String title,
      String body) async {
    int insistentFlag = 4;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
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
