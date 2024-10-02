import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/views/authentication_view.dart';
import '../../home/views/home_view.dart'; 

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000, 
      splash: Image.asset('assets/icon/splash.png'), 
      nextScreen: const AuthenticationView(), 
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.blue,
    );
  }
}
