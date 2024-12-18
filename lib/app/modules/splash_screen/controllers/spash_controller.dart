import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class SplashController extends GetxController {
  Future<String> determineNextRoute() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to home
      return Routes.HOME;
    } else {
      // User is not logged in, navigate to authentication
      return Routes.AUTHENTICATION;
    }
  }
}
