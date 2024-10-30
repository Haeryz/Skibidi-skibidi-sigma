import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:skibidiskibidisigma/firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/search/controllers/search_controller.dart'
    as local; // Import SearchController
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10, // You may want to generate unique IDs
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'Background Notification',
      body: message.notification?.body ??
          'This is a notification from terminated state.',
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("FCM Registration Token: $token");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register controllers after Firebase initialization
  Get.put(AuthenticationController());
  Get.lazyPut<local.SearchController>(() => local.SearchController());
  final String apigeminiKey = dotenv.env['GEMINI_API_KEY']!;
  Gemini.init(apiKey: apigeminiKey);
  //background notification
  AwesomeNotifications().initialize(
    null, // icon for notifications (use app icon or any asset)
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
