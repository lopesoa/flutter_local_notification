import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;




class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    
    //Quando aplicativo estiver fechado
    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }
    
    final AndroidInitializationSettings android =
        AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payLoad) async {
        onNotifications.add(payLoad);
      },
    );

    if(initScheduled){
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payLoad,
      );

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          await tz.TZDateTime.from(scheduleDate, tz.UTC),
          await _notificationDetails(),
          payload: payLoad,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  static Future showScheduledNotificationDay({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDaily(Time(22, 42, 0)),
          await _notificationDetails(),
          payload: payLoad,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time);
  
  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second
    );
    return scheduleDate.isBefore(now) ? scheduleDate.add(Duration(days: 1)) : scheduleDate;
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static void cancelAllnotifications()=> _notifications.cancelAll();

}
