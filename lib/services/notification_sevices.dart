import 'package:flutter/cupertino.dart';
import 'package:flutter_booktickets_app/models/task.dart';
import 'package:flutter_booktickets_app/ui_screen/notified_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    // tz.initializeTimeZones();
    _configureLocalTimezone();
    print("notification init");

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload)
      async {
        if (payload != null) {
          debugPrint("notification payload: $payload");
        } else {
          debugPrint("Notification Done");
        }
        Get.to(() => const NotifiedPage(label: "payload"));},
    );
    print('response: ${flutterLocalNotificationsPlugin.initialize}');
    print('Task: $onDidReceiveLocalNotification');
  }

  static Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static requestNotificationPermission() {
    print("requestNotificationPermission init");
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showNotification(
      {required String? title, required String? body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id', 'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      // playSound: true,
      showWhen: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: 'Default_Sound');
  }

  static Future<void> scheduleNotification(
      int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      await _convertTime(hour, minutes), // _convertTime 앞에 await 추가
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|${task.note}|",
    );
  }

  static Future<tz.TZDateTime> _convertTime(int hour, int minutes) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (payload != null) {
      debugPrint("notification payload: $payload");
    } else {
      debugPrint("Notification Done");
    }
    Get.to(() => NotifiedPage(label: payload));
    print("onDidReceiveLocalNotification payload : $payload");
  }



  // static Future<void> onReceiveNotificationResponse(String? payload) async {
  //   if (payload != null) {
  //     debugPrint("notification payload: $payload");
  //   } else {
  //     debugPrint("Notification Done");
  //   }
  //   Get.to(() => NotifiedPage(label: payload));
  // }
}


