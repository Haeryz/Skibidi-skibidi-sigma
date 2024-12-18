// ignore_for_file: library_private_types_in_public_api

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
      controller.setLooping(true); // Set the video to loop
      controller.play(); // Start playing the video automatically
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable scroll
                  shrinkWrap: true, // Limit the height of the grid view
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0, // Square aspect ratio for each cell
                  ),
                  itemCount: review['mediaUrls'].length > 9
                      ? 9
                      : review['mediaUrls'].length, // Limit to 9 items
                  itemBuilder: (context, index) {
                    final mediaUrl = review['mediaUrls'][index];
                    if (mediaUrl.contains('.mp4')) {
                      // Video Section
                      return FutureBuilder(
                        future: _initializeVideoController(mediaUrl),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            final controller = _videoControllers[mediaUrl]!;
                            return GestureDetector(
                              onTap: () {
                                // Navigate to FullScreenVideoPage on tap
                                Get.to(
                                  FullScreenVideoPage(videoUrl: mediaUrl),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else if (mediaUrl.contains('.jpg') ||
                        mediaUrl.contains('.png') ||
                        mediaUrl.contains('.jpeg')) {
                      // Image Section
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          mediaUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      // Fallback if media is neither image nor video
                      return Center(
                        child: Text('Unsupported media type: $mediaUrl'),
                      );
                    }
                  },
                ),
              ),
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

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({required this.videoUrl});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back(); // Close the full-screen video page
          },
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
