import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/navbar/views/navbar_view.dart';
import 'package:skibidiskibidisigma/app/modules/review/views/create_reviewViews.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});
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
          padding: const EdgeInsets.symmetric(
              horizontal: 8), // Apply 8px padding to left and right
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40), // This can be removed or modified if needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Belum ada review',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19)),
                      Row(
                        children: [
                          const Text('Anda belum menulis ulasan, ayo '),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.AUTHENTICATION);
                            },
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8), // Adjust padding as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {}, child: const Text('tulis ulasan')),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlinedButton(
                          onPressed: () {}, child: const Text('Upload foto ')),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Mulai tulis ulasan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 15, // 15 TextFields
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Ulasan ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavbarView(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(
              16.0), // Add some padding for better positioning
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Get.to(CreateReviewView()); // This should work fine
              },
              child: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding:
                    const EdgeInsets.all(20), // Adjust the size of the button
              ),
            ),
          ),
        ));
  }
}
