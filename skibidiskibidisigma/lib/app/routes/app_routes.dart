part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH; // Add SPLASH route
  static const HOME = _Paths.HOME;
  static const SEARCH = _Paths.SEARCH;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const SEARCH = '/search';
}
