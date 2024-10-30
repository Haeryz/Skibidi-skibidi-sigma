import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import 'registerView.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  AuthenticationView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication View'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/icon/splash.png', // Replace with your logo asset path
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Cari rekomendasi trip, rencanakan sesuai dengan keinginan anda',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),

            // Email TextField
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password TextField
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _passwordController,
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
            const SizedBox(height: 20),

            // Sign In Button with Obx to observe loading state
            // Inside Obx() in your AuthenticationView
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          // Validate email and password before calling loginUser
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Email and password cannot be empty.',
                              backgroundColor: Colors.red,
                            );
                          } else {
                            // If both fields are filled, proceed to login
                            controller.loginUser(
                              _emailController.text,
                              _passwordController.text,
                            );
                            Get.toNamed(Routes.PROFILE);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Registration Button
            SizedBox(
              width: double.infinity,
              child: SignInButtonBuilder(
                backgroundColor: Colors.white,
                onPressed: () {
                  Get.to(RegisterPage());
                },
                text: 'Registrasi',
                textColor: Colors.black,
                icon: Icons.email,
                iconColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Google Sign-In Button
            SizedBox(
              width: double.infinity,
              child: SignInButton(
                Buttons.google,
                text: 'Sign in menggunakan google',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                onPressed: () async {
                  if (!controller.isLoading.value) {
                    controller.isLoading.value =
                        true; // Set loading state to true
                    var userCredential = await controller.signInWithGoogle();

                    if (userCredential != null) {
                      Get.snackbar('Sukses', 'Login Google sukses',
                          backgroundColor: Colors.green);
                      Get.toNamed(
                          Routes.PROFILE); // Navigate to profile on success
                    } else {
                      Get.snackbar('Error', 'Login Google gagal',
                          backgroundColor: Colors.red);
                    }

                    controller.isLoading.value = false; // Reset loading state
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
