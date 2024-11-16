import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class Clickedreview extends StatefulWidget {
  @override
  State<Clickedreview> createState() => _ClickedreviewState();
}

class _ClickedreviewState extends State<Clickedreview> {
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void dispose() {
    // Dispose of all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideoController(String url) async {
    if (!_videoControllers.containsKey(url)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      _videoControllers[url] = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Media Section
            if (review['mediaUrls'] != null &&
                (review['mediaUrls'] as List).isNotEmpty)
              ...List.generate(review['mediaUrls'].length, (index) {
                final mediaUrl = review['mediaUrls'][index];

                // Debugging output for mediaUrl
                print('Media URL: $mediaUrl');

                if (mediaUrl.contains('.mp4')) {
                  // Video Section
                  return FutureBuilder(
                    future: _initializeVideoController(mediaUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final controller = _videoControllers[mediaUrl]!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: Stack(
                              children: [
                                VideoPlayer(controller),
                                Center(
                                  child: IconButton(
                                    icon: Icon(
                                      controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        controller.value.isPlaying
                                            ? controller.pause()
                                            : controller.play();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                } else if (mediaUrl.contains('.jpg') ||
                    mediaUrl.contains('.png') ||
                    mediaUrl.contains('.jpeg')) {
                  // Image Section (only process images)
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
                } else {
                  // Fallback if media is neither image nor video
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Unsupported media type: $mediaUrl'),
                  );
                }
              }),
            // Review Title
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
            // Rating Section
            Row(
              children: List.generate(review['stars'], (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 16),
            // Review Text
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
