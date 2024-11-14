// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // @override
  // void onInit() {
  //   super.onInit();
  //   initPushNotification();
  // }

  // Future<void> initPushNotification() async {
  //   // Request permission for notifications
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   print('User granted permission: ${settings.authorizationStatus}');

  //   // Get FCM token
  //   String? token = await _firebaseMessaging.getToken();
  //   print('FCM Token: $token');

  //   // Handle messages when the app is terminated
  //   FirebaseMessaging.instance.getInitialMessage().then((message) {
  //     if (message != null) {
  //       print(
  //           "Message when the app is terminated: ${message.notification?.title}");
  //     }
  //   });

  //   // Handle messages when the app is in the background
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }

  // // Background message handler
  // static Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   print('Message received in background: ${message.notification?.title}');
  // }
}
