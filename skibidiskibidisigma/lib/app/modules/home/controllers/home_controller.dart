import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
      if (message != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 11, // Use a unique ID
            channelKey: 'basic_channel',
            title:
                message.notification?.title ?? 'Terminated State Notification',
            body: message.notification?.body ??
                'This is triggered on app launch from terminated state.',
          ),
        );
      }
    });
  }
}
