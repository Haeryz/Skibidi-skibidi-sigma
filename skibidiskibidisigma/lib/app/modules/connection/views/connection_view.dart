import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/connection_controller.dart';

class ConnectionView extends GetView<ConnectionController> {
  const ConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Status'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          return controller.isConnected.value
              ? const Text(
                  'Connected to Internet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Internet Connection',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.retryConnection(),
                      child: const Text('Retry'),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
