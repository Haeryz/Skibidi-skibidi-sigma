import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/connection_controller.dart';

class ConnectionView extends GetView<ConnectionController> {
  const ConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectionView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          return controller.isConnected.value
              ? const Text(
                  'Connected to Internet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              : const Text(
                  'No Internet Connection',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
        }),
      ),
    );
  }
}
