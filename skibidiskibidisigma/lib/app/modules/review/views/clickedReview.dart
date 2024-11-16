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
            
          ],
        ),
      ),
    );
  }
}
