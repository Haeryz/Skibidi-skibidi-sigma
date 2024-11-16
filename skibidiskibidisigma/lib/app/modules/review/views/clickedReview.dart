import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Clickedreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the selected review from the arguments passed via Get.to()
    final Map<String, dynamic> review =
        Get.arguments ?? {}; // Default empty map if no arguments

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying media (image/video) if available
            if (review['mediaUrls'] != null &&
                (review['mediaUrls'] as List).isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  review['mediaUrls']
                      [0], // Display the first media (image or video)
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            // Review Title
            Text(
              review['title'] ?? "No Title",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            // Review Stars (assuming the stars are a number 1-5)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < (review['stars'] ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
            const SizedBox(height: 10),
            // Review Text
            Text(
              review['text'] ?? "No Review Text",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Optional: Displaying all media (if there are multiple images or videos)
            if (review['mediaUrls'] != null &&
                (review['mediaUrls'] as List).length > 1)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review['mediaUrls'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review['mediaUrls'][index],
                          fit: BoxFit.cover,
                          width: 150,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
