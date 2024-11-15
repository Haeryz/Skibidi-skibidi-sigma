import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skibidiskibidisigma/app/modules/review/controllers/review_controller.dart';

class CreateReviewView extends StatelessWidget {
  final ReviewController reviewController = Get.find<ReviewController>();
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
            Get.back(); // Use GetX to navigate back
          },
        ),
        title: const Text(
          'Mewing fanum tax',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                      'assets/profile_image.png'), // Replace with actual profile image path
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Furina Lover',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Posting publicly across Google',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      reviewController
                          .updateStars(index + 1); // Update stars in controller
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(5, (index) {
            //     return const Icon(
            //       Icons.star_border,
            //       color: Colors.grey,
            //       size: 40,
            //     );
            //   }),
            // ),
            const SizedBox(height: 20),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share details of your own experience at this place',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.black), // Normal state border color
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.black), // Focused state border color
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.add_photo_alternate,
                color: Colors.black,
              ),
              label: const Text(
                "Add photos",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(child: Container()),
            OutlinedButton.icon(
              onPressed: () {},
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
