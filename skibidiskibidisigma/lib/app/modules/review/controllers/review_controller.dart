import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class ReviewController extends GetxController {
  // Reactive variable for selected stars
  final RxInt selectedStars = 0.obs;
  final RxString reviewText = ''.obs;
  final RxString reviewTitle = ''.obs;
  final RxList<File> mediaFiles = <File>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  void fetchReviews() async {
    try {
      final querySnapshot = await firestore.collection('reviews').get();
      reviews.value = querySnapshot.docs
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch reviews: $e',
          backgroundColor: Colors.red);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  // Method to update the selected stars
  void updateStars(int stars) {
    selectedStars.value = stars;
  }

  void updateReviewTitle(String title) {
    reviewTitle.value = title;
  }

  void updateReviewText(String text) {
    reviewText.value = text;
  }

  Future<void> pickMedia(bool isPhoto) async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles;

    if (isPhoto) {
      // Picking multiple images if isPhoto is true
      pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.length +
                  mediaFiles
                      .where((file) =>
                          file.path.endsWith('.jpg') ||
                          file.path.endsWith('.png'))
                      .length <=
              9) {
        // Adding the selected images to mediaFiles if total doesn't exceed 9
        for (var file in pickedFiles) {
          mediaFiles.add(File(file.path));
        }
      } else {
        Get.snackbar('Limit Reached', 'You can only add up to 9 photos.');
      }
    } else {
      // Picking a single video if isPhoto is false
      XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null &&
          mediaFiles.where((file) => file.path.endsWith('.mp4')).length < 9) {
        mediaFiles.add(File(pickedFile.path));
      } else {
        Get.snackbar('Limit Reached', 'You can only add up to 9 videos.');
      }
    }

    // Ensure the total count of images and videos is not exceeding 9 for each type
    if (mediaFiles
            .where((file) =>
                file.path.endsWith('.jpg') || file.path.endsWith('.png'))
            .length >
        9) {
      mediaFiles.removeWhere(
          (file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'));
      Get.snackbar('Limit Reached', 'You can only add up to 9 photos.');
    }
    if (mediaFiles.where((file) => file.path.endsWith('.mp4')).length > 9) {
      mediaFiles.removeWhere((file) => file.path.endsWith('.mp4'));
      Get.snackbar('Limit Reached', 'You can only add up to 9 videos.');
    }
  }

  Future<List<String>> _uploadMedia() async {
    List<String> mediaUrls = [];

    for (var file in mediaFiles) {
      final String fileName = file.path.split('/').last;
      final Reference storageRef =
          firebaseStorage.ref().child('reviews/$fileName');

      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      mediaUrls.add(downloadUrl);
    }

    return mediaUrls;
  }

  Future<void> postReview() async {
    try {
      if (selectedStars.value == 0) {
        throw 'Please select a star rating.';
      }
      if (reviewTitle.isEmpty) {
        throw 'Please enter a review title.';
      }
      if (reviewText.isEmpty) {
        throw 'Please enter review text.';
      }

      final List<String> mediaUrls = await _uploadMedia();

      await firestore.collection('reviews').add({
        'stars': selectedStars.value,
        'title': reviewTitle.value,
        'text': reviewText.value,
        'mediaUrls': mediaUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      selectedStars.value = 0;
      reviewTitle.value = '';
      reviewText.value = '';
      mediaUrls.clear();
      mediaFiles.clear();

      fetchReviews();

      Get.snackbar('Success', 'Review anda telah diterima sistem',
          backgroundColor: Colors.green);

      Get.toNamed(Routes.REVIEW);
    } catch (e) {
      Get.snackbar('Error : ', e.toString(), backgroundColor: Colors.red);
    }
  }
}
