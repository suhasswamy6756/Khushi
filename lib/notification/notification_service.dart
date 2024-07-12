import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Notify {
  static Future<void> initializeNotification() async {
    try {
      await AwesomeNotifications().initialize(
        null, // Use default icon
        [
          NotificationChannel(
            channelKey: 'flutter_schedule_channel',
            channelName: 'Greetings',
            channelDescription:
                'Daily greetings.',
            importance: NotificationImportance.Max,
            defaultPrivacy: NotificationPrivacy.Public,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            defaultColor: Colors.transparent,
            locked: true,
            enableVibration: true,
            playSound: true,
          ),
        ],
      );
      print("Notification channel initialized successfully.");
    } catch (e) {
      print("Error initializing notification channel: $e");
    }
  }

  static Future<void> scheduleDailyNotifications() async {
    try {
      String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();

      // Cancel existing notifications before scheduling new ones
      await AwesomeNotifications().cancelAllSchedules();

      await _scheduleNotification('Good Morning!',
          'Start your day with new fitness goals', 9, localTimeZone, 1001); // 8:00 AM
      await _scheduleNotification('Good Afternoon!',
          'Walk more earn rewards!', 13, localTimeZone, 1002); // 1:00 PM
      await _scheduleNotification('Good Evening!', 'Earn rewards at cafes, restaurants, movie theaters, apparel stores, and more.', 17,
          localTimeZone, 1003); // 5:00 PM
      await _scheduleNotification(
          'Good Night!',
          'Keep walking',
          21,
          localTimeZone,
          1004); // 9:00 PM

      print("Daily notifications scheduled successfully.");
    } catch (e) {
      print("Error scheduling daily notifications: $e");
    }
  }

  static Future<void> _scheduleNotification(String title, String body, int hour,
      String localTimeZone, int notificationId) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'flutter_schedule_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigText,
          locked: false,
          wakeUpScreen: true,
          autoDismissible: true,

          fullScreenIntent: true,
          backgroundColor: Colors.transparent,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: 0,
          second: 0,
          millisecond: 0,
          timeZone: localTimeZone,
          repeats: true,
          // Ensures the notification repeats daily
          preciseAlarm: true,
          // Ensure precise alarm
          allowWhileIdle: true, // Allow notification while the device is idle
        ),
        /*actionButtons: [
          NotificationActionButton(
            key: "close",
            label: "Close Reminder",
            autoDismissible: true,
          ),
        ],*/
      );
      print("Notification scheduled: $title at $hour:00");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  // Generate a unique ID for each notification
  static int _generateUniqueId() {
    Random random = Random();
    return random.nextInt(1000000) + 1;
  }
}
