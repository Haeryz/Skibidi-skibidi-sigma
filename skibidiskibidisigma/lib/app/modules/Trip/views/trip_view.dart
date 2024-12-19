import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/Trip/controllers/trip_controller.dart';

class TripView extends StatelessWidget {
  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Trip', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.tripNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Trip',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                controller.completeTrip();
                // Kembali ke PlanView
                Get.back(); // atau gunakan Get.off(() => PlanView()) jika ingin menghapus halaman ini dari stack
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}
