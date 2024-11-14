import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reels_controller.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReelsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ReelsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
