import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthenticationView'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0), // Equivalent to Tailwind's px-20
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Equivalent to Tailwind's pt-20
            // Logo on top
            Image.asset(
              'assets/icon/splash.png', // Replace with your logo asset path
              height: 100,
            ),
            const SizedBox(height: 20), // Adds spacing below the logo

            // Text Widget
            const Text(
              'Cari rekomendasi trip, rencanakan sesuai dengan keinginan anda',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20), // Spacing

            // Rounded TextField for Username
            SizedBox(
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Rounded TextField for Password
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Sign In Button
            SizedBox(
              width: double.infinity, // Ensure the button is the same width
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.PROFILE);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Google Sign In Button
            SizedBox(
              width: double.infinity, // Align width with other buttons
              child: SignInButtonBuilder(
                backgroundColor: Colors.white, // Background color
                onPressed: () {
                  // sign in email
                },
                text: 'Sign in menggunakan email',
                textColor: Colors.black,
                icon: Icons.email,
                iconColor: Colors.black, // You can change icon color if needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0, // Same padding as other buttons
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: SignInButton(Buttons.google,
                  text: 'Sign in menggunakan Google',
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
