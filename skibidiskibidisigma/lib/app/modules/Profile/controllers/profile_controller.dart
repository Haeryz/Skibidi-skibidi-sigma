import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var profileImage = Rx<File?>(null); 
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    // Show a modal bottom sheet to select between camera and gallery
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

    // Proceed to pick the image from the selected source
    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    }
  }
}
