import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class ReviewController extends GetxController {
  // Reactive variable for selected stars
  final RxInt selectedStars = 0.obs;
  final RxString reviewText = ''.obs;
  final RxString reviewTitle = ''.obs;
  final RxList<File> mediaFiles = <File>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxMap<File, VideoPlayerController> videoControllers =
      <File, VideoPlayerController>{}.obs;

  void fetchReviews() async {
    try {
      final querySnapshot = await firestore.collection('reviews').get();
      reviews.value = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch reviews: $e',
          backgroundColor: Colors.red);
    }
  }

  Future<void> initializeVideoController(File videoFile) async {
    if (!videoControllers.containsKey(videoFile)) {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      videoControllers[videoFile] = controller;
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
      pickedFiles = await picker.pickMultiImage();
      // ignore: unnecessary_null_comparison
      if (pickedFiles != null) {
        if (pickedFiles.length + mediaFiles.length <= 9) {
          for (var file in pickedFiles) {
            mediaFiles.add(File(file.path));
          }
        } else {
          Get.snackbar('Limit Reached', 'You can only add up to 9 items.');
        }
      }
    } else {
      XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null && mediaFiles.length < 9) {
        final videoFile = File(pickedFile.path);
        mediaFiles.add(videoFile);
        await initializeVideoController(videoFile);
      } else {
        Get.snackbar('Limit Reached', 'You can only add up to 9 items.');
      }
    }
  }

Future<List<String>> _uploadMedia() async {
  List<String> mediaUrls = [];
  List<File> imageFiles = [];
  List<File> videoFiles = [];

  // Separate image and video files based on MIME type
  for (var file in mediaFiles) {
    final mimeType = lookupMimeType(file.path);

    // Check if the file is an image
    if (mimeType != null && mimeType.startsWith('image/')) {
      imageFiles.add(file);
    }
    // Check if the file is a video
    else if (mimeType != null && mimeType.startsWith('video/')) {
      videoFiles.add(file);
    }
  }

  // Upload image files
  for (var file in imageFiles) {
    final String fileName = file.path.split('/').last;
    final Reference storageRef = firebaseStorage.ref().child('reviews/images/$fileName');

    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;

    final String downloadUrl = await snapshot.ref.getDownloadURL();
    mediaUrls.add(downloadUrl);
  }

  // Upload video files
  for (var file in videoFiles) {
    final String fileName = file.path.split('/').last;
    final Reference storageRef = firebaseStorage.ref().child('reviews/videos/$fileName');

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
