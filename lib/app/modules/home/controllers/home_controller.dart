import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
class HomeController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _notificationShown = false; // Add this to your HomeController

  void showNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Hello, Flutter!',
        body: 'This is a background notification test.',
      ),
    );
  }

  void terminatedNotification() {
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null && !_notificationShown) {
        _notificationShown = true; // Set flag to prevent duplicate
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 11,
            channelKey: 'basic_channel',
            title:
                message.notification?.title ?? 'Terminated State Notification',
            body: message.notification?.body ?? 'Triggered on app launch.',
          ),
        );
      }
    });
  }
}
