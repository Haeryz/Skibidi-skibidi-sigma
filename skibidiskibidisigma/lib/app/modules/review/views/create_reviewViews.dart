import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/controllers/profile_controller.dart';
import 'package:skibidiskibidisigma/app/modules/review/controllers/review_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateReviewView extends StatelessWidget {
  final ReviewController reviewController = Get.find<ReviewController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Mewing fanum tax',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap this in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Section

            Row(
              children: [
                Obx(() => CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          profileController.profileImage.value != null
                              ? FileImage(profileController.profileImage.value!)
                              : profileController.profileImageUrl.value != null
                                  ? NetworkImage(
                                      profileController.profileImageUrl.value!)
                                  : const AssetImage(
                                          'assets/icon/pfp_placeholder.png')
                                      as ImageProvider,
                    )),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Furina Lover', // Replace with dynamic user name if needed
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Posting publicly across Google',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Star Rating Section
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      reviewController.updateStars(index + 1);
                    },
                    child: AnimatedScale(
                      scale: reviewController.selectedStars.value > index
                          ? 1.2
                          : 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: Icon(
                        reviewController.selectedStars.value > index
                            ? Icons.star
                            : Icons.star_border,
                        color: reviewController.selectedStars.value > index
                            ? Colors.amber
                            : Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                }),
              );
            }),

            const SizedBox(height: 20),

            TextField(
              onChanged: (title) {
                reviewController.updateReviewTitle(title);
              },
              decoration: InputDecoration(
                hintText: 'Enter review title',
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Review Text Field
            TextField(
              maxLines: 3,
              onChanged: (text) {
                reviewController.updateReviewText(text);
              },
              decoration: InputDecoration(
                hintText: 'Share details of your own experience at this place',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Media Picker Section
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    reviewController.pickMedia(true); // Pick photo
                  },
                  icon: const Icon(Icons.add_photo_alternate,
                      color: Colors.black),
                  label: const Text("Add photo",
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 60),
                OutlinedButton.icon(
                  onPressed: () {
                    reviewController.pickMedia(false); // Pick video
                  },
                  icon: const Icon(Icons.video_library, color: Colors.black),
                  label: const Text("Add video",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),

            // Image Preview Section (3x3 Grid)
Obx(() {
  if (reviewController.mediaFiles.isNotEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 items in a row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: reviewController.mediaFiles.length,
        itemBuilder: (context, index) {
          final file = reviewController.mediaFiles[index];
          final isVideo = file.path.endsWith('.mp4');

          return FutureBuilder<Uint8List?>(
            future: isVideo
                ? VideoThumbnail.thumbnailData(
                    video: file.path,
                    imageFormat: ImageFormat.JPEG,
                    maxWidth: 128, // specify thumbnail width
                    quality: 75,
                  )
                : Future.value(null),
            builder: (context, snapshot) {
              final thumbnail = snapshot.data;

              return Stack(
                children: [
                  // Thumbnail or Image Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: isVideo
                        ? (thumbnail != null
                            ? Image.memory(
                                thumbnail,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ))
                        : Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                  // Remove Button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        reviewController.mediaFiles.removeAt(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  } else {
    return Container(); // Empty container if no media is selected
  }
}),

            // Post Button
            OutlinedButton.icon(
              onPressed: () {
                reviewController.postReview();
              },
              label: const Text(
                'Post',
                style: TextStyle(color: Colors.black),
              ),
              icon: const Icon(
                Icons.mode_edit_outline_outlined,
                color: Colors.black,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
