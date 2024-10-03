import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/search/bindings/search_binding.dart';
import 'package:skibidiskibidisigma/app/modules/Plan/bindings/plan_binding.dart';
import 'package:skibidiskibidisigma/app/modules/Plan/views/plan_view.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/bindings/profile_binding.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/views/profile_view.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/bindings/authentication_binding.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/views/authentication_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash_screen/views/splash_view.dart';
import '../modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreenView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      ),
      GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => const AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PLAN,
      page: () => const PlanView(),
      binding: PlanBinding(),

    ),
  ];
}
