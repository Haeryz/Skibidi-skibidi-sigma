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
  var isLoading = true.obs; // Track loading state

void fetchReviews() async {
  try {
    isLoading.value = true;  // Set loading to true while fetching data
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews') 
        .orderBy('timestamp', descending: true) // Order by timestamp descending
        .get();

    reviews.value = querySnapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // Add document ID if needed
            })
        .toList();
  } catch (e) {
    Get.snackbar("Error", "Failed to fetch reviews: $e");
  } finally {
    isLoading.value = false;  // Set loading to false after data is fetched
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

  Future<void> pickMedia(bool isPhoto, {bool fromCamera = false}) async {
    final ImagePicker picker = ImagePicker();
    if (isPhoto) {
      if (fromCamera) {
        // Capture a single image from the camera
        final XFile? capturedImage =
            await picker.pickImage(source: ImageSource.camera);
        if (capturedImage != null) {
          mediaFiles.add(File(capturedImage.path));
        }
      } else {
        // Select multiple images from the gallery
        final List<XFile> selectedImages = await picker.pickMultiImage();
        if (selectedImages.length + mediaFiles.length <= 9) {
          for (var image in selectedImages) {
            mediaFiles.add(File(image.path));
          }
        } else {
          Get.snackbar('Limit Reached', 'You can only add up to 9 items.');
        }
            }
    } else {
      if (fromCamera) {
        // Capture a single video from the camera
        final XFile? capturedVideo =
            await picker.pickVideo(source: ImageSource.camera);
        if (capturedVideo != null && mediaFiles.length < 9) {
          final videoFile = File(capturedVideo.path);
          mediaFiles.add(videoFile);
          await initializeVideoController(videoFile);
        }
      } else {
        // Select multiple videos by looping through the picker
        while (mediaFiles.length < 9) {
          final XFile? selectedVideo =
              await picker.pickVideo(source: ImageSource.gallery);
          if (selectedVideo != null) {
            final videoFile = File(selectedVideo.path);
            mediaFiles.add(videoFile);
            await initializeVideoController(videoFile);
          } else {
            break; // Exit if no video is selected
          }
        }
      }
    }
  }

  void showMediaPicker(bool isPhoto) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(Get.context!).size.height * 0.4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Pick from Camera'),
                  onTap: () {
                    Get.back(); // Close bottom sheet
                    pickMedia(isPhoto, fromCamera: true); // Pick from camera
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Pick from Gallery'),
                  onTap: () {
                    Get.back(); // Close bottom sheet
                    pickMedia(isPhoto, fromCamera: false); // Pick from gallery
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
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
      final Reference storageRef =
          firebaseStorage.ref().child('reviews/images/$fileName');

      final UploadTask uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      mediaUrls.add(downloadUrl);
    }

    // Upload video files
    for (var file in videoFiles) {
      final String fileName = file.path.split('/').last;
      final Reference storageRef =
          firebaseStorage.ref().child('reviews/videos/$fileName');

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
