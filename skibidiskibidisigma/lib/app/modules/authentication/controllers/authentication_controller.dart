import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginState(); // Check login state when the controller is initialized
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _saveLoginState(); // Save login state after successful registration
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);

      // Navigate to profile
      Get.offNamed(Routes.PROFILE);
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveLoginState(); // Save login state after successful login
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
      Get.toNamed(Routes.PROFILE);
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isLoading.value = true; // Set loading state
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false; // Reset loading state if canceled
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential; // Return the UserCredential on success
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e', backgroundColor: Colors.red);
      return null; // Return null on failure
    } finally {
      isLoading.value = false; // Ensure loading state is reset
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _clearLoginState(); // Clear login state on logout

      // Navigate to authentication route
      Get.offAllNamed(Routes.AUTHENTICATION);
      Get.snackbar('Logged Out', 'You have successfully logged out',
          backgroundColor: Colors.green);
    } catch (error) {
      Get.snackbar('Error', 'Failed to log out: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && _auth.currentUser != null) {
      // Navigate to the home or profile screen if the user is still logged in
      Get.offNamed(Routes.HOME);
    } else {
      // Navigate to the authentication screen
      Get.offNamed(Routes.AUTHENTICATION);
    }
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
  }
}
