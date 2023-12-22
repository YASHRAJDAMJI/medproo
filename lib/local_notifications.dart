import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // on tap on any notification
  static void onNotificationTap(
      NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // initialize the local notifications
  static Future init() async {
    print("step2");
    // initialise the plugin. app_icon needs to be added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future showPeriodicNotifications({
    required String morningTitle,
    required String morningBody,
    required String eveningTitle,
    required String eveningBody,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    var detroit = tz.getLocation('India');
    final tz.TZDateTime now = tz.TZDateTime.now(detroit);

    tz.TZDateTime scheduledDateMorning =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 7, 0);
    if (now.isAfter(scheduledDateMorning)) {
      scheduledDateMorning = scheduledDateMorning.add(Duration(days: 1));
    }

    tz.TZDateTime scheduledDateEvening =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    if (now.isAfter(scheduledDateEvening)) {
      scheduledDateEvening = scheduledDateEvening.add(Duration(days: 1));
    }

    final Duration morningDifference = scheduledDateEvening.difference(scheduledDateMorning);
    final tz.TZDateTime scheduledDateAfternoon = scheduledDateMorning.add(morningDifference);

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      morningTitle,
      morningBody,
      scheduledDateMorning,
      notificationDetails,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      eveningTitle,
      eveningBody,
      scheduledDateAfternoon,
      notificationDetails,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      eveningTitle,
      eveningBody,
      scheduledDateEvening,
      notificationDetails,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }



  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}