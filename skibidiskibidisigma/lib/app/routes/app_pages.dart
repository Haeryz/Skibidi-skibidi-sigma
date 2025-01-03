import 'package:get/get.dart';

import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/Trip/bindings/trip_binding.dart';
import '../modules/Trip/views/trip_view.dart';
import '../modules/akun/bindings/akun_binding.dart';
import '../modules/akun/views/akun_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/plan/bindings/plan_binding.dart';
import '../modules/plan/views/plan_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/splash_screen/views/splash_view.dart';
import '../modules/wikipedia/bindings/home_binding.dart';
import '../modules/wikipedia/views/wikipedia_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreenView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.WIKIPEDIA,
      page: () => const WikipediaView(),
      binding: wikipediaBinding(),
    ),
    GetPage(
      name: _Paths.AKUN,
      page: () => const akunView(),
      binding: akunBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.PLAN,
      page: () => PlanView(),
      binding: PlanBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => ReviewView(),
      binding: ReviewBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => const ConnectionView(),
      binding: ConnectionBinding(),
    ),
  ];
}
