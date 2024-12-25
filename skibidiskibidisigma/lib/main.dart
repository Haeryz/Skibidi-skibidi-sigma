// File: /lib/main.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/controllers/profile_controller.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:skibidiskibidisigma/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:skibidiskibidisigma/app/modules/plan/controllers/plan_controller.dart';
import 'package:skibidiskibidisigma/app/modules/review/controllers/review_controller.dart';
import 'package:skibidiskibidisigma/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/search/controllers/search_controller.dart' as local;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase only if it hasn't been initialized yet
  
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 11,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'Background Notification',
      body: message.notification?.body ?? 'This is a notification from terminated state.',
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final PlanController controller = Get.put(PlanController());
    controller.checkTripArrivalNotifications();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase only if it hasn't been initialized yet
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate();

  await GetStorage.init();

  // Initialize WorkManager for background tasks
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Initialize Firebase Messaging for background message handling
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register controllers after Firebase initialization
  Get.put(AuthenticationController());
  Get.lazyPut<local.SearchController>(() => local.SearchController());
  Get.put(PlanController());
  Get.put(NavbarController());
  Get.put(ReviewController());
  Get.put(ProfileController());

  // Initialize Gemini API with the key from .env
  final String apigeminiKey = dotenv.env['GEMINI_API_KEY']!;
  Gemini.init(apiKey: apigeminiKey);

  // Background notification setup
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.blue,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
      NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Notification channel for scheduled reminders',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
    ],
  );

  // Register the background notification task
  final PlanController planController = Get.find<PlanController>();
  planController.registerBackgroundNotification();

  // Run the app
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
  
}