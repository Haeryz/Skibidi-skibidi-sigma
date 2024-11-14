import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxBool isLoading = false.obs;

  final count = 0.obs;
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);

      // Only navigate on successful registration
      Get.offNamed(Routes.AUTHENTICATION);
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void increment() => count.value++;
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Sukses', 'Login sukses', backgroundColor: Colors.green);
      Get.toNamed(Routes.PROFILE);
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if user canceled the sign-in flow
      if (googleUser == null) {
        isLoading.value = false; // Reset loading state if canceled
        return null; // Return early to avoid further processing
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e', backgroundColor: Colors.red);
      isLoading.value = false; // Ensure loading state is reset on error
      return null; // Return null to indicate failure
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Sign out from Firebase (common for all users)
      await _auth.signOut();

      // Check if user is signed in with Google, if so, sign them out
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Navigate to authentication route after logging out
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
}
