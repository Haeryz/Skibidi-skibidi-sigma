// File 1: /lib/app/modules/home/controllers/home_controller.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _notificationShown = false; // Flag to prevent duplicate notifications

  void showGreetingNotification() {
    if (!_notificationShown) {
      _notificationShown = true; // Set flag to true to prevent showing again
      String greeting = getGreeting();
      String title = '$greeting !';
      String body = 'Selamat datang di aplikasi kami.';

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 100, // Unique ID for this notification
          channelKey: 'basic_channel',
          title: title,
          body: body,
        ),
      );
    }
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  void terminatedNotification() {
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null && !_notificationShown) {
        _notificationShown = true; // Set flag to prevent duplicate
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 11,
            channelKey: 'basic_channel',
            title: message.notification?.title ?? 'Terminated State Notification',
            body: message.notification?.body ?? 'Triggered on app launch.',
          ),
        );
      }
    });
  }
}