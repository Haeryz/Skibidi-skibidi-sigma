import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/splash_screen/controllers/spash_controller.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class SplashScreenView extends StatelessWidget {
  SplashScreenView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    // Trigger the navigation logic
    controller.determineNextRoute().then((route) {
      Get.offAllNamed(route); // Navigate to the resolved route
    });

    // Return the splash screen UI
    return Scaffold(
      body: Center(
        child: Image.asset('assets/icon/splash.png'),
      ),
    );
  }
}
