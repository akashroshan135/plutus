import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plutus/main.dart';

import 'package:plutus/routes/individual/transUpcoming.dart';

// *  Notification Packages
// ! timezone latest_all.dart is used as latest.dart doesn't work on emulator
// TODO use latest.dart in export builds
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
      macOS: null,
    );
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  Future setNotification(transaction) async {
    final androidDetails = new AndroidNotificationDetails(
      '1',
      'Plutus',
      'Upcoming Transactions',
      importance: Importance.max,
    );
    final notificationDetails =
        new NotificationDetails(android: androidDetails);

    final mainText = 'Pending Transaction';
    final subText = 'Tags: ' +
        transaction.tags +
        ', Amount: \₹' +
        transaction.amount.toString();
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(transaction.selectedDate, tz.local);
    // final tz.TZDateTime scheduledDate =
    //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      transaction.id,
      mainText,
      subText,
      scheduledDate,
      notificationDetails,
      payload: transaction.id.toString(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future selectNotification(String payload) async {
    MyApp.navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => TransactionUpcomingScreen(
          transactionId: payload,
        ),
      ),
    );
  }

  Future cancelNotification(upcoming) async {
    await flutterLocalNotificationsPlugin.cancel(upcoming.id);
  }
}
