import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService sharedInstance = NotificationService._();

  final _localNotification = FlutterLocalNotificationsPlugin();

  final _isInitialize = false;

  bool get _isInitialized => _isInitialize;

  // initialize the notification
  Future<void> initNotification() async {
    tz.initializeTimeZones();
    final String timeZoneName =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    if (_isInitialized == true) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await _localNotification.initialize(initSettings);
  }

  // set the details of the notification
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "daily_channel_id",
        "daily_reminder",
        channelDescription: "daily reminder notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // show the notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay selectedTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final notificationTime =
        scheduledTime.isBefore(now)
            ? scheduledTime.add(Duration(days: 1))
            : scheduledTime;

    await _localNotification.zonedSchedule(
      id,
      title,
      body,
      notificationTime,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint("Scheduling notification at: ${scheduledTime.toLocal()}");
  }

  // get the schedule notification list
  Future<List<PendingNotificationRequest>> getScheduleNotificationList() async {
    List<PendingNotificationRequest> pendingNotificationRequest =
        await _localNotification.pendingNotificationRequests();
    return pendingNotificationRequest;
  }

  // cancel all push notification
  Future<void> cancelAllPushNotification() async {
    await _localNotification.cancelAll();
  }

  // cancel specific push notification
  Future<void> cancelPushNotification(int id) async {
    await _localNotification.cancel(id);
  }

}
