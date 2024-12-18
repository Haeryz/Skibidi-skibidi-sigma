import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null);
  var profileImageUrl = Rx<String?>(null); // Add this line
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProfileImageUrl(); // Fetch the profile image URL on initialization
  }

  Future<void> fetchProfileImageUrl() async {
    final user = _auth.currentUser;
    if (user != null && user.photoURL != null) {
      profileImageUrl.value = user.photoURL; // Set the image URL
    }
  }

  Future<void> pickImage() async {
    final source = await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Get.back(result: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Get.back(result: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        try {
          profileImage.value = File(pickedFile.path);
          await uploadProfileImage(); // Call upload function after selecting image
          Get.snackbar('Success', 'Image selected');
        } catch (e) {
          Get.snackbar('Error', 'Error : $e', backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'No image selected', backgroundColor: Colors.red);
      }
    }
  }

  Future<void> uploadProfileImage() async {
    if (profileImage.value != null) {
      try {
        // Get current user
        final User? user = _auth.currentUser;
        if (user == null) throw 'User not logged in';

        // Set the path in Firebase Storage
        String filePath = 'profileImages/${user.uid}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);

        // Upload image to Firebase Storage
        await storageRef.putFile(profileImage.value!);

        // Retrieve the download URL
        String downloadUrl = await storageRef.getDownloadURL();

        // Update user profile with image URL
        await user.updatePhotoURL(downloadUrl);
        profileImageUrl.value =
            downloadUrl; // Set the image URL in the controller
        Get.snackbar('Success', 'Profile picture updated successfully');
      } catch (error) {
        Get.snackbar('Error', 'Failed to upload profile picture: $error');
      }
    } else {
      Get.snackbar('Error', 'No image selected to upload');
    }
  }
}
