part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH; // Add SPLASH route
  static const HOME = _Paths.HOME;
  static const SEARCH = _Paths.SEARCH;
  static const AUTHENTICATION = _Paths.AUTHENTICATION;
  static const PROFILE = _Paths.PROFILE;
  static const PLAN = _Paths.PLAN;
  static const WIKIPEDIA = _Paths.WIKIPEDIA;
  static const AKUN = _Paths.AKUN;
  static const TRIP = _Paths.TRIP;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const NAVBAR = _Paths.NAVBAR;
  static const REELS = _Paths.REELS;
  static const REVIEW = _Paths.REVIEW;
  static const CONNECTION = _Paths.CONNECTION;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const SEARCH = '/search';
  static const AUTHENTICATION = '/authentication';
  static const PROFILE = '/profile';
  static const PLAN = '/plan';
  static const WIKIPEDIA = '/wikipedia';
  static const AKUN = '/akun';
  static const TRIP = '/trip';
  static const NOTIFICATION = '/notification';
  static const NAVBAR = '/navbar';
  static const REELS = '/reels';
  static const REVIEW = '/review';
  static const CONNECTION = '/connection';
}
