import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  //Update the _firebaseMessagingBackgroundHandler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (!_notificationShown) {
      // Prevent duplicate notification
      _notificationShown = true;
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 11,
          channelKey: 'basic_channel',
          title: message.notification?.title ?? 'Background Notification',
          body: message.notification?.body ?? 'This is from terminated state.',
        ),
      );
    }
  }
}
