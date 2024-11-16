import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Clickedreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the review data passed from the previous screen
    final review = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Image or Video Section (If exists)
            if (review['mediaUrls'] != null &&
                (review['mediaUrls'] as List).isNotEmpty)
              ...List.generate(review['mediaUrls'].length, (index) {
                var mediaUrl = review['mediaUrls'][index];
                // Check if the media is an image or video
                if (mediaUrl.endsWith('.mp4')) {
                  // If it's a video, display a thumbnail (for example)
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9, // Adjust the aspect ratio
                        child: Container(
                          color: Colors.black26, // Video thumbnail background
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // If it's an image, display it
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        mediaUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              }),
            // Review Title Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                review['title'] ?? "Untitled",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            // Review Rating Section
            Row(
              children: List.generate(review['stars'], (index) {
                return Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 16),
            // Review Text Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                review['text'] ?? "No review text available.",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
