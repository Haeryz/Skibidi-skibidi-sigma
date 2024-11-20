import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/navbar/views/navbar_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skibidiskibidisigma/app/modules/review/views/clickedReview.dart';
import 'package:skibidiskibidisigma/app/modules/review/views/create_reviewViews.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  ReviewView({super.key});

  final ReviewController reviewController = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ulasan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return Skeletonizer(
                  enabled: reviewController.isLoading.value,
                  child: reviewController.reviews.isEmpty
                      ? const Center(
                          child: Text("No reviews available."),
                        )
                      : ListView.builder(
                          itemCount: reviewController.reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviewController.reviews[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 10,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => Clickedreview(),
                                    arguments: review,
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image placeholder with Skeleton
                                      Skeletonizer(
                                        enabled:
                                            reviewController.isLoading.value,
                                        child: (review['mediaUrls'] != null &&
                                                (review['mediaUrls'] as List)
                                                    .isNotEmpty)
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                ),
                                                child: Image.network(
                                                  review['mediaUrls'][0],
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      color: Colors.grey[300],
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      color: Colors.grey,
                                                      child: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(
                                                height: 200,
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image),
                                              ),
                                      ),
                                      // Title placeholder with Skeleton
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Skeletonizer(
                                          enabled:
                                              reviewController.isLoading.value,
                                          child: Text(
                                            review['title'] ?? "Untitled",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarView(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              Get.to(CreateReviewView());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[100],
              shadowColor: Colors.black,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            child: const Icon(
              Icons.add_location_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
